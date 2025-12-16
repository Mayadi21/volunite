import 'package:flutter/material.dart';
import 'dart:io'; 
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart'; 
import 'package:volunite/color_pallete.dart'; 
import 'package:volunite/models/user_model.dart'; 
import 'package:volunite/services/general_profile_service.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool _isLoading = true;
  User? _user;
  
  XFile? _newImageFile;
  
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _genderCtrl = TextEditingController();
  final _tglLahirCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _domisiliCtrl = TextEditingController();

  final _passOldCtrl = TextEditingController();
  final _passNewCtrl = TextEditingController();
  final _passConfirmCtrl = TextEditingController();
  final _passFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _namaCtrl.dispose(); _emailCtrl.dispose(); _genderCtrl.dispose();
    _tglLahirCtrl.dispose(); _phoneCtrl.dispose(); _domisiliCtrl.dispose();
    _passOldCtrl.dispose(); _passNewCtrl.dispose(); _passConfirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final data = await GeneralProfileService.fetchMyProfile();
      if (mounted) {
        setState(() {
          _user = data['user'] as User;
          final detail = data['detail'] as DetailUser;

          _namaCtrl.text = _user?.nama ?? '';
          _emailCtrl.text = _user?.email ?? '';
          _genderCtrl.text = detail.jenisKelamin ?? '';
          _phoneCtrl.text = detail.noTelepon ?? '';
          _domisiliCtrl.text = detail.domisili ?? '';
          
          if (detail.tanggalLahir != null) {
            try {
              final date = DateTime.parse(detail.tanggalLahir!);
              _tglLahirCtrl.text = DateFormat('dd-MM-yyyy').format(date);
            } catch (_) {
              _tglLahirCtrl.text = detail.tanggalLahir!;
            }
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error load profile: $e");
      if(mounted) Navigator.pop(context);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;
    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }

    if (status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }

    if (status.isGranted || status.isLimited) {
      try {
        final picked = await ImagePicker().pickImage(
          source: source, 
          imageQuality: 70, 
        );
        
        if (picked != null) {
          setState(() {
            _newImageFile = picked;
          });
        }
      } catch (e) {
        debugPrint("Error picking image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mengambil gambar"))
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context, 
      builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(leading: const Icon(Icons.camera), title: const Text("Kamera"), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
        ListTile(leading: const Icon(Icons.photo), title: const Text("Galeri"), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
      ])
    );
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    String? tglLahirBackend;
    if (_tglLahirCtrl.text.isNotEmpty) {
      try {
        final date = DateFormat('dd-MM-yyyy').parse(_tglLahirCtrl.text);
        tglLahirBackend = DateFormat('yyyy-MM-dd').format(date);
      } catch (_) {}
    }

    try {
      final success = await GeneralProfileService.updateProfile(
        nama: _namaCtrl.text,
        jenisKelamin: _genderCtrl.text,
        noTelepon: _phoneCtrl.text,
        domisili: _domisiliCtrl.text,
        tanggalLahir: tglLahirBackend,
        fotoProfil: _newImageFile,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!"), backgroundColor: Colors.green)
        );
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal update: $e"), backgroundColor: Colors.red)
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_passFormKey.currentState!.validate()) return;
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Memproses...")));

    try {
      await GeneralProfileService.changePassword(
        currentPassword: _passOldCtrl.text,
        newPassword: _passNewCtrl.text,
        newPasswordConfirmation: _passConfirmCtrl.text,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Kata sandi berhasil diubah!"), backgroundColor: Colors.green)
        );
        _passOldCtrl.clear(); _passNewCtrl.clear(); _passConfirmCtrl.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e"), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(title: const Text("Edit Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), backgroundColor: kSkyBlue, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: _showImageSourceDialog, 
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 50, 
                    backgroundColor: kLightGray,
                    backgroundImage: _newImageFile != null 
                        ? FileImage(File(_newImageFile!.path)) 
                        : (_user?.pathProfil != null ? NetworkImage(_user!.pathProfil!) : null) as ImageProvider?,
                    child: (_newImageFile == null && _user?.pathProfil == null) ? const Icon(Icons.person, size: 50, color: Colors.grey) : null,
                  ),
                  const CircleAvatar(radius: 16, backgroundColor: kSkyBlue, child: Icon(Icons.camera_alt, size: 16, color: Colors.white))
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            _buildTextField("Nama Lengkap", _namaCtrl),
            const SizedBox(height: 16),
            _buildTextField("Email", _emailCtrl, readOnly: true),
            const SizedBox(height: 16),
            _buildTextField("Nomor Telepon", _phoneCtrl, type: TextInputType.phone),
            const SizedBox(height: 16),
            _buildTextField("Domisili", _domisiliCtrl),
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: () {
                showModalBottomSheet(context: context, builder: (_) => Column(mainAxisSize: MainAxisSize.min, children: ['Laki-Laki', 'Perempuan'].map((e) => ListTile(title: Text(e), onTap: () { setState(() => _genderCtrl.text = e); Navigator.pop(context); })).toList()));
              },
              child: AbsorbPointer(child: _buildTextField("Jenis Kelamin", _genderCtrl, suffix: Icons.arrow_drop_down)),
            ),
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now(), builder: (context, child) => Theme(data: Theme.of(context).copyWith(colorScheme: const ColorScheme.light(primary: kSkyBlue)), child: child!));
                if (picked != null) setState(() => _tglLahirCtrl.text = DateFormat('dd-MM-yyyy').format(picked));
              },
              child: AbsorbPointer(child: _buildTextField("Tanggal Lahir", _tglLahirCtrl, suffix: Icons.calendar_today)),
            ),

            const SizedBox(height: 30),
            
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Keamanan Akun", style: TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray)),
              subtitle: const Text("Ubah kata sandi akun anda"),
              trailing: TextButton(onPressed: _showPasswordDialog, child: const Text("Ubah", style: TextStyle(color: kSkyBlue))),
            ),

            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(backgroundColor: kSkyBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text("SIMPAN PERUBAHAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPasswordDialog() {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text("Ubah Password"),
      content: Form(
        key: _passFormKey,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          TextFormField(controller: _passOldCtrl, decoration: const InputDecoration(labelText: "Password Lama"), obscureText: true, validator: (v) => v!.isEmpty ? "Isi password lama" : null),
          TextFormField(controller: _passNewCtrl, decoration: const InputDecoration(labelText: "Password Baru"), obscureText: true, validator: (v) => v!.length < 8 ? "Min 8 karakter" : null),
          TextFormField(controller: _passConfirmCtrl, decoration: const InputDecoration(labelText: "Konfirmasi Password"), obscureText: true, validator: (v) => v != _passNewCtrl.text ? "Password tidak sama" : null),
        ]),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
        ElevatedButton(onPressed: _changePassword, child: const Text("Simpan"))
      ],
    ));
  }

  Widget _buildTextField(String label, TextEditingController ctrl, {bool readOnly = false, TextInputType type = TextInputType.text, IconData? suffix}) {
    return TextField(
      controller: ctrl, readOnly: readOnly, keyboardType: type,
      decoration: InputDecoration(
        labelText: label, filled: true, fillColor: Colors.white,
        suffixIcon: suffix != null ? Icon(suffix, color: kBlueGray) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: kLightGray)),
      ),
    );
  }
}