// lib/pages/Admin/users/add_user_page.dart
import 'package:flutter/material.dart';
import 'user_service.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;

  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _tanggalCtrl = TextEditingController();
  final _noTelpCtrl = TextEditingController();
  final _domisiliCtrl = TextEditingController();

  String _selectedRole = 'Volunteer';
  String _selectedGender = 'Laki-Laki';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      await UserService.createUser(
        nama: _namaCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
        role: _selectedRole,
        tanggalLahir: _tanggalCtrl.text.trim(),
        jenisKelamin: _selectedGender,
        noTelepon: _noTelpCtrl.text.trim(),
        domisili: _domisiliCtrl.text.trim(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User berhasil ditambahkan')),
      );

      Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menambah user: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _tanggalCtrl.dispose();
    _noTelpCtrl.dispose();
    _domisiliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah User Baru')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _namaCtrl,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) => v!.isEmpty ? 'Nama wajib' : null,
              ),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Email wajib' : null,
              ),
              TextFormField(
                controller: _passwordCtrl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) => v!.length < 6 ? 'Min 6 karakter' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRole,
                items: const [
                  DropdownMenuItem(
                    value: 'Volunteer',
                    child: Text('Volunteer'),
                  ),
                  DropdownMenuItem(
                    value: 'Organizer',
                    child: Text('Organizer'),
                  ),
                  DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                ],
                onChanged: (v) => setState(() => _selectedRole = v!),
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _tanggalCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (YYYY-MM-DD)',
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-Laki',
                    child: Text('Laki-Laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                  DropdownMenuItem(
                    value: 'Tidak Ingin Memberi Tahu',
                    child: Text('Tidak Ingin Memberi Tahu'),
                  ),
                ],
                onChanged: (v) => setState(() => _selectedGender = v!),
                decoration: const InputDecoration(labelText: 'Jenis Kelamin'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noTelpCtrl,
                decoration: const InputDecoration(labelText: 'No. Telepon'),
              ),
              TextFormField(
                controller: _domisiliCtrl,
                decoration: const InputDecoration(labelText: 'Domisili'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const CircularProgressIndicator()
                    : const Text('Tambah User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
