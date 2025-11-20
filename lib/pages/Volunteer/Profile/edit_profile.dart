// lib/pages/Volunteer/Profile/edit_profile.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/color_pallete.dart'; // Impor color palette

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _imageFile;
  // Gunakan kDarkBlueGray sebagai warna utama (primaryDark)
  final primaryDark = kDarkBlueGray;

  // Controllers untuk setiap field
  late TextEditingController _namaController;
  late TextEditingController _jenisKelaminController;
  late TextEditingController _tglLahirController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _domisiliController;
  late TextEditingController _pendidikanController;
  late TextEditingController _keahlianController;
  late TextEditingController _minatController;
  late TextEditingController _ketersediaanController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data dari gambar
    _namaController = TextEditingController(text: 'Go Youn Jung');
    _jenisKelaminController = TextEditingController(text: 'Perempuan');
    _tglLahirController = TextEditingController(text: '22-04-1996');
    _emailController = TextEditingController(text: 'goyounjung@naver.com');
    _teleponController = TextEditingController(text: '081234567890');
    _domisiliController = TextEditingController(text: 'Medan');
    _pendidikanController = TextEditingController(text: 'Sarjana (S1)');
    _keahlianController = TextEditingController(text: 'Desain Grafis');
    _minatController = TextEditingController(text: 'Pendidikan');
    _ketersediaanController = TextEditingController(text: 'Akhir Pekan');
  }

  @override
  void dispose() {
    // Selalu dispose controller Anda
    _namaController.dispose();
    _jenisKelaminController.dispose();
    _tglLahirController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _domisiliController.dispose();
    _pendidikanController.dispose();
    _keahlianController.dispose();
    _minatController.dispose();
    _ketersediaanController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // ⬇ FUNGSI IMAGE PICKER ⬇
  // ------------------------------------------------------------------

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
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } else if (status.isPermanentlyDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Izin diperlukan untuk mengakses fitur ini.'),
            action: SnackBarAction(
              label: 'Buka Pengaturan',
              onPressed: openAppSettings,
            ),
          ),
        );
      }
    } else if (status.isDenied) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin ditolak oleh pengguna.')),
        );
      }
    }
  }

  // ------------------------------------------------------------------
  // ⬆ BATAS AKHIR FUNGSI IMAGE PICKER ⬆
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Gunakan kBackground dari Color Palette
    const pageBackgroundColor = kBackground;

    return Scaffold(
      backgroundColor: pageBackgroundColor,

      // --- APPBAR ---
      appBar: AppBar(
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
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      // --- BODY ---
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- FOTO PROFIL ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    // Gunakan kLightGray untuk placeholder/background avatar
                    backgroundColor: kLightGray,
                    // Tampilkan gambar yang ada atau gambar baru
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        // TODO: Ganti ini dengan gambar profil user yang ada
                        : const NetworkImage(
                                'https://i.mydramalist.com/r6R0z_5f.jpg',
                              )
                              as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryDark, // kDarkBlueGray
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: InkWell(
                        onTap: () => _showImageSourceDialog(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // --- FORMULIR ---
              _buildSectionHeader('Informasi Pribadi'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nama Lengkap',
                controller: _namaController,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    // TODO: Ganti ini dengan DropdownButton
                    child: _buildTextField(
                      label: 'Jenis Kelamin',
                      controller: _jenisKelaminController,
                      readOnly: true,
                      onTap: () {
                        /* Tampilkan dialog/dropdown jenis kelamin */
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    // TODO: Ganti ini dengan Date Picker
                    child: _buildTextField(
                      label: 'Tanggal lahir',
                      controller: _tglLahirController,
                      readOnly: true,
                      onTap: () {
                        /* Tampilkan date picker */
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildTextField(label: 'Email', controller: _emailController),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nomor Telepon',
                controller: _teleponController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // TODO: Ganti ini dengan Dropdown/Pilihan Lokasi
              _buildTextField(
                label: 'Domisili',
                controller: _domisiliController,
                readOnly: true,
                onTap: () {
                  /* Tampilkan pilihan domisili */
                },
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('Pendidikan dan Pengalaman'),
              const SizedBox(height: 16),
              // TODO: Ganti ini dengan Dropdown
              _buildTextField(
                label: 'Pendidikan terakhir',
                controller: _pendidikanController,
                readOnly: true,
                onTap: () {
                  /* Tampilkan pilihan pendidikan */
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Keahlian Khusus',
                controller: _keahlianController,
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('Preferensi dan Ketersediaan'),
              const SizedBox(height: 16),
              // TODO: Ganti ini dengan Pilihan Chip/Dropdown
              _buildTextField(
                label: 'Minat/Kategori Volunteer',
                controller: _minatController,
                readOnly: true,
                onTap: () {
                  /* Tampilkan pilihan minat */
                },
              ),
              const SizedBox(height: 16),
              // TODO: Ganti ini dengan Pilihan Chip/Dropdown
              _buildTextField(
                label: 'Ketersediaan Waktu',
                controller: _ketersediaanController,
                readOnly: true,
                onTap: () {
                  /* Tampilkan pilihan waktu */
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // --- TOMBOL SIMPAN (Pinned di bawah) ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Tambahkan logika untuk menyimpan data
            // (Contoh: kirim _namaController.text ke server)
            Navigator.of(context).pop(); // Kembali setelah simpan
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kSkyBlue, // kDarkBlueGray
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 50), // Lebar penuh
            elevation: 8, // Tambahkan sedikit bayangan
          ),
          child: const Text(
            'Simpan Perubahan',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET: Judul Section ---
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        // Gunakan kSoftBlue untuk background header (opsional)
        color: kSoftBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            // Gunakan kDarkBlueGray atau kBlueGray untuk warna teks
            color: kDarkBlueGray,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGET: Card Input Field ---
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
    VoidCallback? onTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // Jika readOnly, gunakan InkWell agar bisa diklik. Jika tidak, fokuskan pada TextFormField.
    Widget field = TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType, // Tambahkan keyboardType
      style: TextStyle(
        fontWeight: FontWeight.w600, // Sedikit kurang tebal dari sebelumnya
        fontSize: 16,
        color: kDarkBlueGray, // Warna teks input
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        // Tambahkan ikon panah jika readOnly (untuk Dropdown/Picker)
        suffixIcon: readOnly
            ? Icon(Icons.arrow_forward_ios, size: 14, color: kBlueGray)
            : null,
      ),
      onTap: readOnly ? onTap : null, // Hanya panggil onTap jika readOnly
    );

    // Jika readOnly, bungkus dengan InkWell untuk efek visual klik
    if (readOnly && onTap != null) {
      field = InkWell(
        onTap: onTap,
        child: IgnorePointer(
          // Abaikan pointer pada TextFormField di dalamnya
          child: field,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white, // Background putih untuk field
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kLightGray,
          width: 1,
        ), // Tambahkan border halus
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.1), // Bayangan dari kBlueGray
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: kBlueGray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ), // Warna label dari palette
          ),
          const SizedBox(height: 4),
          field,
        ],
      ),
    );
  }
}
