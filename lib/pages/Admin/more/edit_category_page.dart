import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'kategori_service.dart';

class EditCategoryPage extends StatefulWidget {
  final Kategori kategori;

  const EditCategoryPage({super.key, required this.kategori});

  @override
  State<EditCategoryPage> createState() => _EditCategoryPageState();
}

class _EditCategoryPageState extends State<EditCategoryPage> {
  final _service = KategoriService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _namaC;
  late TextEditingController _descC;

  XFile? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaC = TextEditingController(text: widget.kategori.namaKategori);
    _descC = TextEditingController(text: widget.kategori.deskripsi);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() => _selectedImage = image);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _service.updateKategori(
        id: widget.kategori.id,
        nama: _namaC.text.trim(),
        deskripsi: _descC.text.trim(),
        thumbnail: _selectedImage,
      );

      Navigator.pop(context, true); // sukses → kembali + refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memperbarui kategori: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaC.dispose();
    _descC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Kategori')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // === THUMBNAIL ===
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _selectedImage != null
                      ? Image.file(
                          File(_selectedImage!.path),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : widget.kategori.thumbnail != null
                      ? Image.network(
                          widget.kategori.thumbnail!,
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 160,
                          color: Colors.grey[300],
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 40),
                              SizedBox(height: 8),
                              Text('Pilih Thumbnail'),
                            ],
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // === NAMA ===
              TextFormField(
                controller: _namaC,
                decoration: const InputDecoration(
                  labelText: 'Nama Kategori',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),

              const SizedBox(height: 16),

              // === DESKRIPSI ===
              TextFormField(
                controller: _descC,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),

              // === BUTTON SIMPAN ===
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
