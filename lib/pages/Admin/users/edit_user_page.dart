// lib/pages/Admin/users/edit_user_page.dart
import 'package:flutter/material.dart';
import 'user_service.dart';

class EditUserPage extends StatefulWidget {
  final int userId;
  final String title; // "Edit Volunteer" atau "Edit Organisasi"

  const EditUserPage({super.key, required this.userId, required this.title});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  bool _loading = true;
  bool _submitting = false;
  Map<String, dynamic>? _userData;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _namaController;
  late TextEditingController _emailController;
  late TextEditingController _tanggalLahirController;
  late TextEditingController _noTelpController;
  late TextEditingController _domisiliController;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController();
    _emailController = TextEditingController();
    _tanggalLahirController = TextEditingController();
    _noTelpController = TextEditingController();
    _domisiliController = TextEditingController();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final data = await UserService.getUser(widget.userId);
      setState(() {
        _userData = data;
        _namaController.text = data['nama'] ?? '';
        _emailController.text = data['email'] ?? '';
        final detail = data['detail_user'] ?? data['detailUser'] ?? {};
        _tanggalLahirController.text = detail?['tanggal_lahir'] ?? '';
        _noTelpController.text = detail?['no_telepon'] ?? '';
        _domisiliController.text = detail?['domisili'] ?? '';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat user: $e')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _submitting = true;
    });

    final body = {
      'nama': _namaController.text.trim(),
      'email': _emailController.text.trim(),
      'tanggal_lahir': _tanggalLahirController.text.trim(),
      'no_telepon': _noTelpController.text.trim(),
      'domisili': _domisiliController.text.trim(),
      // jangan kirim password kosong; tambahkan bila ingin ubah
    };

    try {
      final updated = await UserService.updateUser(widget.userId, body);
      setState(() {
        _submitting = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('User berhasil diupdate')));
      Navigator.of(context).pop(true); // kembali ke list, mentrigger refresh
    } catch (e) {
      setState(() {
        _submitting = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(labelText: 'Nama'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Nama wajib diisi' : null,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Email wajib' : null,
                    ),
                    TextFormField(
                      controller: _tanggalLahirController,
                      decoration: const InputDecoration(
                        labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                      ),
                    ),
                    TextFormField(
                      controller: _noTelpController,
                      decoration: const InputDecoration(
                        labelText: 'No. Telepon',
                      ),
                    ),
                    TextFormField(
                      controller: _domisiliController,
                      decoration: const InputDecoration(labelText: 'Domisili'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitting ? null : _submit,
                      child: _submitting
                          ? const CircularProgressIndicator()
                          : const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _tanggalLahirController.dispose();
    _noTelpController.dispose();
    _domisiliController.dispose();
    super.dispose();
  }
}
