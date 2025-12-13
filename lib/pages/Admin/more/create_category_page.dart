import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'kategori_service.dart';
import 'dart:io';

class CreateCategoryPage extends StatefulWidget {
  const CreateCategoryPage({super.key});

  @override
  State<CreateCategoryPage> createState() => _CreateCategoryPageState();
}

class _CreateCategoryPageState extends State<CreateCategoryPage> {
  final _service = KategoriService();
  final _formKey = GlobalKey<FormState>();

  final _namaC = TextEditingController();
  final _descC = TextEditingController();

  XFile? _selectedImage;
  bool _isLoading = false;

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
      await _service.createKategori(
        nama: _namaC.text.trim(),
        deskripsi: _descC.text.trim(),
        thumbnail: _selectedImage,
      );

      Navigator.pop(context, true); // kembali + trigger refresh
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menambahkan kategori: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kategori')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // === THUMBNAIL PICKER ===
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
                      : Container(
                          height: 160,
                          width: double.infinity,
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
                      : const Text('Simpan Kategori'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
