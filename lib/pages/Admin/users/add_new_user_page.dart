import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
// --- TAMBAHKAN IMPORT INI ---
import 'package:volunite/pages/Admin/data/mock_data.dart';
// ------------------------------

class AddNewUserPage extends StatefulWidget {
  // ... (kode parameter opsional tidak berubah)
  final Volunteer? volunteerToEdit;
  final Organization? organizationToEdit;

  const AddNewUserPage({
    super.key,
    this.volunteerToEdit,
    this.organizationToEdit,
  });

  @override
  State<AddNewUserPage> createState() => _AddNewUserPageState();
}

class _AddNewUserPageState extends State<AddNewUserPage> {
  // ... (kode _formKey, _selectedRole, controllers, initState, dispose tidak berubah)
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'Volunteer';
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    // Cek apakah ini mode Edit atau Tambah
    if (widget.volunteerToEdit != null) {
      _isEditMode = true;
      _selectedRole = 'Volunteer';
      _nameController.text = widget.volunteerToEdit!.name;
      _emailController.text = widget.volunteerToEdit!.email;
    } else if (widget.organizationToEdit != null) {
      _isEditMode = true;
      _selectedRole = 'Organisasi';
      _nameController.text = widget.organizationToEdit!.name;
      _emailController.text = widget.organizationToEdit!.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  // --- PERBAIKI LOGIKA FUNGSI INI ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Logika untuk menyimpan user baru
      // Di aplikasi nyata, Anda akan memanggil API di sini

      // Contoh: Tambahkan ke list mock data jika bukan mode edit
      if (!_isEditMode) {
        if (_selectedRole == 'Volunteer') {
          final newId = (mockVolunteers.map((v) => v.id).reduce((a, b) => a > b ? a : b)) + 1;
          mockVolunteers.add(Volunteer(
            id: newId,
            name: _nameController.text,
            email: _emailController.text,
          ));
        } else if (_selectedRole == 'Organisasi') {
          final newId = (mockOrganizations.map((o) => o.id).reduce((a, b) => a > b ? a : b)) + 1;
          mockOrganizations.add(Organization(
            id: newId,
            name: _nameController.text,
            email: _emailController.text,
          ));
        }
        // TODO: Tambahkan logika untuk role Admin jika perlu
      }
      // TODO: Tambahkan logika untuk mode Edit

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                '${_isEditMode ? 'Memperbarui' : 'Menyimpan'} $_selectedRole: ${_nameController.text}'),
            backgroundColor: Colors.green),
      );

      // Kembali ke halaman list (dan kirim 'true' untuk refresh)
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (sisa kode build method tidak berubah)
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit User' : 'Tambah User Baru',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Lengkap',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Nama tidak boleh kosong'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => (value == null || !value.contains('@'))
                          ? 'Email tidak valid'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Sembunyikan field password jika mode edit
                    if (!_isEditMode)
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        obscureText: true,
                        validator: (value) => (value == null || value.length < 6)
                            ? 'Password minimal 6 karakter'
                            : null,
                      ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: _selectedRole,
                      decoration: const InputDecoration(
                        labelText: 'Role Pengguna',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shield_outlined),
                      ),
                      // Nonaktifkan ganti role jika mode edit
                      onChanged: _isEditMode
                          ? null
                          : (newValue) {
                              setState(() {
                                _selectedRole = newValue!;
                              });
                            },
                      items:
                          ['Volunteer', 'Organisasi', 'Admin'].map((String role) {
                        return DropdownMenuItem<String>(
                          value: role,
                          child: Text(role),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          // --- TOMBOL INI SEKARANG MENEMPEL DI BAWAH ---
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: _submitForm,
              icon: const Icon(Icons.save, color: Colors.white),
              label: Text(_isEditMode ? 'Simpan Perubahan' : 'Simpan User Baru'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50), // Buat tombol lebar
              ),
            ),
          ),
        ],
      ),
    );
  }
}