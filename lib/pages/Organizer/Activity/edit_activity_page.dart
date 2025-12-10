// lib/pages/Organizer/Activity/edit_activity_page.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kategori_model.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kategori_service.dart';
import 'package:volunite/services/kegiatan_service.dart';

class EditActivityPage extends StatefulWidget {
  final Kegiatan kegiatan; // Data yang mau diedit
  const EditActivityPage({super.key, required this.kegiatan});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Controllers
  late TextEditingController _judulCtrl;
  late TextEditingController _deskripsiCtrl;
  late TextEditingController _lokasiCtrl;
  late TextEditingController _syaratCtrl;
  late TextEditingController _kuotaCtrl;

  DateTime? _tglMulai;
  DateTime? _tglSelesai;
  XFile? _newImage; // Jika user ganti gambar
  
  List<Kategori> _kategoriList = [];
  List<int> _selectedKategoriIds = [];

  @override
  void initState() {
    super.initState();
    // 1. Isi form dengan data lama
    _judulCtrl = TextEditingController(text: widget.kegiatan.judul);
    _deskripsiCtrl = TextEditingController(text: widget.kegiatan.deskripsi);
    _lokasiCtrl = TextEditingController(text: widget.kegiatan.lokasi);
    _syaratCtrl = TextEditingController(text: widget.kegiatan.syaratKetentuan);
    _kuotaCtrl = TextEditingController(text: widget.kegiatan.kuota.toString());
    _tglMulai = widget.kegiatan.tanggalMulai;
    _tglSelesai = widget.kegiatan.tanggalBerakhir;
    
    // Ambil ID kategori lama
    _selectedKategoriIds = widget.kegiatan.kategori.map((e) => e.id).toList();

    _loadKategori();
  }

  Future<void> _loadKategori() async {
    try {
      final data = await KategoriService.fetchKategori();
      setState(() => _kategoriList = data);
    } catch (e) { print(e); }
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _newImage = file);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    
    final success = await KegiatanService.updateKegiatan(
      id: widget.kegiatan.id,
      judul: _judulCtrl.text,
      deskripsi: _deskripsiCtrl.text,
      lokasi: _lokasiCtrl.text,
      syaratKetentuan: _syaratCtrl.text,
      kuota: _kuotaCtrl.text,
      tanggalMulai: dateFormat.format(_tglMulai!),
      tanggalBerakhir: dateFormat.format(_tglSelesai!),
      kategoriIds: _selectedKategoriIds,
      imageFile: _newImage, // Bisa null
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Berhasil diupdate!")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update.")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Kegiatan"), backgroundColor: kSkyBlue, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar (Preview Lama atau Baru)
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180, width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _newImage != null
                        ? (kIsWeb ? Image.network(_newImage!.path, fit: BoxFit.cover) : Image.file(File(_newImage!.path), fit: BoxFit.cover))
                        : (widget.kegiatan.thumbnail != null 
                            ? Image.network(widget.kegiatan.thumbnail!, fit: BoxFit.cover)
                            : const Icon(Icons.add_a_photo, color: Colors.grey)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              _field("Judul", _judulCtrl),
              _field("Deskripsi", _deskripsiCtrl, maxLines: 3),
              _field("Lokasi", _lokasiCtrl),
              _field("Kuota", _kuotaCtrl, isNumber: true),
              const SizedBox(height: 20),
              
              // Kategori
              const Text("Kategori:", style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _kategoriList.map((k) {
                  final isSel = _selectedKategoriIds.contains(k.id);
                  return FilterChip(
                    label: Text(k.namaKategori),
                    selected: isSel,
                    onSelected: (val) => setState(() => val ? _selectedKategoriIds.add(k.id) : _selectedKategoriIds.remove(k.id)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: kSkyBlue),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1, bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: (v) => v!.isEmpty ? "Wajib isi" : null,
      ),
    );
  }
}