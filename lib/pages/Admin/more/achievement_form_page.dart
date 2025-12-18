import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'achievement_service.dart';

import 'kategori_service.dart';

class AchievementFormPage extends StatefulWidget {
  final PencapaianModel? initialData;

  const AchievementFormPage({super.key, this.initialData});

  @override
  State<AchievementFormPage> createState() => _AchievementFormPageState();
}

class _AchievementFormPageState extends State<AchievementFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _service = PencapaianService();
  final _kategoriService = KategoriService();
  final _picker = ImagePicker();

  // ================= CONTROLLERS =================
  late TextEditingController _namaCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _expCtrl;
  late TextEditingController _countKategoriCtrl;

  // ================= STATE =================
  XFile? _image;
  bool _isSaving = false;

  bool _expMode = false;
  bool _kategoriMode = false;

  List<KategoriSimple> _kategoriList = [];
  KategoriSimple? _selectedKategori;
  bool _loadingKategori = true;

  // ================= INIT =================
  @override
  void initState() {
    super.initState();

    _namaCtrl = TextEditingController(text: widget.initialData?.nama ?? '');
    _descCtrl = TextEditingController(
      text: widget.initialData?.description ?? '',
    );
    _expCtrl = TextEditingController(
      text: widget.initialData?.requiredExp?.toString() ?? '',
    );
    _countKategoriCtrl = TextEditingController(
      text: widget.initialData?.requiredCountKategori?.toString() ?? '',
    );

    _expCtrl.addListener(_syncMode);
    _countKategoriCtrl.addListener(_syncMode);

    _loadKategori();
    _syncMode();
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _descCtrl.dispose();
    _expCtrl.dispose();
    _countKategoriCtrl.dispose();
    super.dispose();
  }

  // ================= LOAD KATEGORI =================
  Future<void> _loadKategori() async {
    final data = await _kategoriService.getAllSimple();

    setState(() {
      _kategoriList = data;

      if (widget.initialData?.requiredKategori != null) {
        _selectedKategori = data.firstWhere(
          (k) => k.id == widget.initialData!.requiredKategori,
          orElse: () => data.isNotEmpty ? data.first : null as KategoriSimple,
        );
      }

      _loadingKategori = false;
      _syncMode();
    });
  }

  // ================= MODE LOGIC =================
  void _syncMode() {
    setState(() {
      _expMode = _expCtrl.text.isNotEmpty;
      _kategoriMode =
          _selectedKategori != null || _countKategoriCtrl.text.isNotEmpty;
    });
  }

  // ================= IMAGE =================
  Future<void> _pickImage() async {
    final img = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (img != null) setState(() => _image = img);
  }

  // ================= SUBMIT =================
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final fields = {
      'nama': _namaCtrl.text,
      'deskripsi': _descCtrl.text,
      'required_exp': _expMode ? _expCtrl.text : '',
      'required_kategori': _kategoriMode
          ? _selectedKategori?.id.toString() ?? ''
          : '',
      'required_count_kategori': _kategoriMode ? _countKategoriCtrl.text : '',
    };

    bool success;
    if (widget.initialData == null) {
      success = await _service.create(fields, _image);
    } else {
      success = await _service.update(widget.initialData!.id, fields, _image);
    }

    setState(() => _isSaving = false);

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data')));
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialData != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Achievement' : 'Tambah Achievement'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ========== IMAGE ==========
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _buildImage(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _textField(_namaCtrl, 'Nama Achievement'),
              const SizedBox(height: 12),
              _textField(_descCtrl, 'Deskripsi', maxLines: 3),

              const Divider(height: 32),

              // ========== EXP ==========
              _sectionTitle('Requirement EXP'),
              _numberField(_expCtrl, 'Required EXP', enabled: !_kategoriMode),

              const Divider(height: 32),

              // ========== KATEGORI ==========
              _sectionTitle('Requirement Kategori'),

              _loadingKategori
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<KategoriSimple>(
                      value: _selectedKategori,
                      items: _kategoriList
                          .map(
                            (k) => DropdownMenuItem(
                              value: k,
                              child: Text(k.namaKategori),
                            ),
                          )
                          .toList(),
                      onChanged: _expMode
                          ? null
                          : (val) {
                              setState(() {
                                _selectedKategori = val;
                                _syncMode();
                              });
                            },
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                      ),
                    ),

              const SizedBox(height: 12),

              _numberField(
                _countKategoriCtrl,
                'Jumlah Kategori',
                enabled: !_expMode,
              ),

              const SizedBox(height: 30),

              // ========== SUBMIT ==========
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= WIDGETS =================
  Widget _buildImage() {
    if (_image != null) {
      return kIsWeb
          ? Image.network(_image!.path, fit: BoxFit.cover)
          : Image.file(File(_image!.path), fit: BoxFit.cover);
    }

    if (widget.initialData?.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.initialData!.thumbnailUrl!,
        fit: BoxFit.cover,
      );
    }

    return const Icon(Icons.camera_alt, size: 40, color: Colors.grey);
  }

  Widget _textField(TextEditingController c, String label, {int maxLines = 1}) {
    return TextFormField(
      controller: c,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
    );
  }

  Widget _numberField(
    TextEditingController c,
    String label, {
    required bool enabled,
  }) {
    return TextFormField(
      controller: c,
      enabled: enabled,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
