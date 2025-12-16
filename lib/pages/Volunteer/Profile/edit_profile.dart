// lib/pages/Volunteer/Profile/edit_profile.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/color_pallete.dart'; 
import 'package:volunite/models/user_model.dart'; 
import 'package:volunite/services/profile_service.dart'; // Impor Service
import 'package:intl/intl.dart'; 

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // File gambar yang baru dipilih (XFile untuk dikirim ke Service)
  XFile? _newImageFile; 
  final primaryDark = kDarkBlueGray;

  // State Data
  User? _user; 
  DetailUser? _detailUser;
  bool _isLoading = true;
  String? _errorMessage;

  // Controllers untuk field
  late TextEditingController _namaController;
  late TextEditingController _jenisKelaminController;
  late TextEditingController _tglLahirController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _domisiliController;
  

  @override
  void initState() {
    super.initState();
    
    // Inisialisasi controller
    _namaController = TextEditingController();
    _emailController = TextEditingController();
    _jenisKelaminController = TextEditingController();
    _teleponController = TextEditingController();
    _domisiliController = TextEditingController();
    _tglLahirController = TextEditingController();

    _fetchUserData(); 
  }
  
  @override
  void dispose() {
    _namaController.dispose();
    _jenisKelaminController.dispose();
    _tglLahirController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _domisiliController.dispose();
    super.dispose();
  }

  // ==========================================================
  // ⬇ FUNGSI PENGAMBILAN & PENGISIAN DATA DARI API ⬇
  // ==========================================================

  Future<void> _fetchUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
  
    try {
      final data = await ProfileService.fetchProfile();
  
      if (mounted) {
        final user = data['user'] as User;
        final detail = data['detail'] as DetailUser;

        setState(() {
          _user = user;
          _detailUser = detail;
          _isLoading = false;
        });
        
        _populateControllers(user, detail);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: ${e.toString()}';
        });
      }
    }
  }

  void _populateControllers(User user, DetailUser detail) {
    _namaController.text = user.nama;
    _emailController.text = user.email;
    
    _jenisKelaminController.text = detail.jenisKelamin ?? '';
    _teleponController.text = detail.noTelepon ?? '';
    _domisiliController.text = detail.domisili ?? '';
    
    // Format Tanggal Lahir (API: YYYY-MM-DD -> Tampilan: dd-MM-yyyy)
    if (detail.tanggalLahir != null && detail.tanggalLahir!.isNotEmpty) {
      try {
        final date = DateTime.parse(detail.tanggalLahir!);
        _tglLahirController.text = DateFormat('dd-MM-yyyy').format(date);
      } catch (_) {
        _tglLahirController.text = detail.tanggalLahir!; 
      }
    }
  }

  // ==========================================================
  // ⬇ FUNGSI INTERAKTIF (Date Picker & Jenis Kelamin) ⬇
  // ==========================================================

  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime(2000, 1, 1);
    if (_tglLahirController.text.isNotEmpty) {
      try {
        initialDate = DateFormat('dd-MM-yyyy').parse(_tglLahirController.text);
      } catch (_) {}
    }
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: kSkyBlue, onPrimary: Colors.white, onSurface: kDarkBlueGray),
            textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: kSkyBlue)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _tglLahirController.text = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  void _selectJenisKelamin(BuildContext context) {
    final List<String> options = ['Laki-Laki', 'Perempuan', 'Tidak Ingin Memberi Tahu'];
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Pilih Jenis Kelamin',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray),
                ),
              ),
              ...options.map((option) {
                return ListTile(
                  title: Text(option),
                  trailing: _jenisKelaminController.text == option ? Icon(Icons.check, color: kSkyBlue) : null,
                  onTap: () {
                    setState(() {
                      _jenisKelaminController.text = option;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
  
  // ==========================================================
  // ⬇ FUNGSI IMAGE PICKER ⬇
  // ==========================================================

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    PermissionStatus status;

    if (source == ImageSource.camera) {
      status = await Permission.camera.request();
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted) {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: source, imageQuality: 70); 

      if (pickedFile != null) {
        setState(() {
          _newImageFile = pickedFile; 
        });
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Izin ${source == ImageSource.camera ? "Kamera" : "Galeri"} diperlukan.'),
          action: status.isPermanentlyDenied 
            ? SnackBarAction(label: 'Buka Pengaturan', onPressed: openAppSettings)
            : null,
        ),
      );
    }
  }

  // ==========================================================
  // ⬇ FUNGSI SIMPAN DATA (Update) - DENGAN NOTIFIKASI BARU ⬇
  // ==========================================================

  void _saveData() async {
    if (_user == null) return; 

    // 1. Konversi Tanggal Lahir (dd-MM-yyyy -> YYYY-MM-DD)
    String? tglLahirUntukBackend;
    if (_tglLahirController.text.isNotEmpty) {
      try {
        final date = DateFormat('dd-MM-yyyy').parse(_tglLahirController.text);
        tglLahirUntukBackend = DateFormat('yyyy-MM-dd').format(date);
      } catch (_) {
        tglLahirUntukBackend = _tglLahirController.text;
      }
    }
  
    // Tampilkan dialog loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await ProfileService.updateProfile(
        nama: _namaController.text,
        jenisKelamin: _jenisKelaminController.text.isEmpty ? null : _jenisKelaminController.text,
        tanggalLahir: tglLahirUntukBackend,
        noTelepon: _teleponController.text.isEmpty ? null : _teleponController.text,
        domisili: _domisiliController.text.isEmpty ? null : _domisiliController.text,
        fotoProfil: _newImageFile, 
      );
  
      if (mounted) {
        // Tutup loading dialog
        Navigator.of(context).pop(); 
        
        // === REVISI NOTIFIKASI SUKSES ===
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  ' Profil berhasil diperbarui!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        
        // Kembali ke halaman sebelumnya
        Navigator.of(context).pop(); 
      }
    } catch (e) {
      print('Update Error: $e');
      if (mounted) {
        // Tutup loading dialog
        Navigator.of(context).pop(); 

        // === REVISI NOTIFIKASI GAGAL ===
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Gagal memperbarui: ${e.toString()}',
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageBackgroundColor = kBackground;

    // State: Loading atau Error
    if (_isLoading || _user == null) {
      return Scaffold(
        backgroundColor: pageBackgroundColor,
        appBar: _buildAppBar(),
        body: Center(
          child: _errorMessage != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _fetchUserData, child: const Text('Coba Lagi')),
                ],
              )
            : const CircularProgressIndicator(color: kSkyBlue),
        ),
      );
    }

    // State: Data Loaded
    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: _buildAppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: kLightGray,
                    backgroundImage: _newImageFile != null
                        ? FileImage(File(_newImageFile!.path)) 
                        : NetworkImage(
                            _user!.pathProfil ?? 'https://via.placeholder.com/150',
                          ) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryDark,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: InkWell(
                        onTap: () => _showImageSourceDialog(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(Icons.camera_alt, color: Colors.white, size: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('Informasi Pribadi'),
              const SizedBox(height: 16),
              _buildTextField(label: 'Nama Lengkap', controller: _namaController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Jenis Kelamin',
                      controller: _jenisKelaminController,
                      readOnly: true,
                      onTap: () => _selectJenisKelamin(context),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Tanggal lahir',
                      controller: _tglLahirController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email',
                controller: _emailController,
                readOnly: true,
                keyboardType: TextInputType.emailAddress,
                onTap: () {
                  print('Arahkan ke halaman Ubah Email');
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nomor Telepon',
                controller: _teleponController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Domisili',
                controller: _domisiliController,
                readOnly: false,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: kSkyBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            minimumSize: const Size(double.infinity, 50),
            elevation: 8,
          ),
          child: const Text(
            'Simpan Perubahan',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBlueGray, kSkyBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: const Text(
        'Edit Data Diri',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: kSoftBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: kDarkBlueGray, fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    Widget field = TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: kDarkBlueGray),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        suffixIcon: readOnly ? Icon(Icons.arrow_forward_ios, size: 14, color: kBlueGray) : null,
      ),
      onTap: readOnly ? onTap : null,
    );

    if (readOnly && onTap != null) {
      field = InkWell(
        onTap: onTap,
        child: IgnorePointer(child: field),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kLightGray, width: 1),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: kBlueGray, fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          field,
        ],
      ),
    );
  }
}
