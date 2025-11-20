import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/color_pallete.dart';

class EditOrganizerProfilePage extends StatefulWidget {
  const EditOrganizerProfilePage({super.key});

  @override
  State<EditOrganizerProfilePage> createState() =>
      _EditOrganizerProfilePageState();
}

class _EditOrganizerProfilePageState extends State<EditOrganizerProfilePage> {
  File? _imageFile;
  final primaryDark = kDarkBlueGray;

  // Controllers disesuaikan untuk kebutuhan Organizer (Organisasi)
  late TextEditingController _namaOrganisasiController;
  late TextEditingController _kategoriController;
  late TextEditingController _deskripsiController;
  late TextEditingController _emailController;
  late TextEditingController _teleponController;
  late TextEditingController _websiteController;
  late TextEditingController _alamatController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi data dummy Organizer (KMB-USU)
    _namaOrganisasiController = TextEditingController(text: 'KMB-USU');
    _kategoriController = TextEditingController(text: 'Sosial & Pendidikan');
    _deskripsiController = TextEditingController(
      text:
          'Komunitas Mahasiswa Buddhis Universitas Sumatera Utara yang bergerak di bidang sosial dan keagamaan.',
    );
    _emailController = TextEditingController(text: 'kmb.usu@univ.ac.id');
    _teleponController = TextEditingController(text: '081234567890');
    _websiteController = TextEditingController(text: 'www.kmbusu.org');
    _alamatController = TextEditingController(
      text: 'Jl. Universitas No. 9, Padang Bulan, Medan',
    );
  }

  @override
  void dispose() {
    _namaOrganisasiController.dispose();
    _kategoriController.dispose();
    _deskripsiController.dispose();
    _emailController.dispose();
    _teleponController.dispose();
    _websiteController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  // --- FUNGSI IMAGE PICKER (Sama dengan Volunteer) ---
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
    }
  }

  @override
  Widget build(BuildContext context) {
    const pageBackgroundColor = kBackground;

    return Scaffold(
      backgroundColor: pageBackgroundColor,
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
          'Edit Profil Organisasi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // --- FOTO PROFIL ORGANISASI ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: kLightGray,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : const NetworkImage(
                                'https://ui-avatars.com/api/?name=KMB+USU&background=random',
                              )
                              as ImageProvider,
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
              _buildSectionHeader('Identitas Organisasi'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nama Organisasi',
                controller: _namaOrganisasiController,
              ),
              const SizedBox(height: 16),
              // Mengganti Jenis Kelamin menjadi Kategori
              _buildTextField(
                label: 'Kategori Organisasi',
                controller: _kategoriController,
                readOnly: true,
                onTap: () {
                  /* Logic Dropdown Kategori */
                },
              ),
              const SizedBox(height: 16),
              // Field Deskripsi (Multiline)
              _buildTextField(
                label: 'Deskripsi Singkat',
                controller: _deskripsiController,
                maxLines: 3, // Supaya bisa nulis panjang
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('Kontak & Media Sosial'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Email Resmi',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Nomor Telepon / WhatsApp',
                controller: _teleponController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Website / Link Bio',
                controller: _websiteController,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 32),

              _buildSectionHeader('Lokasi'),
              const SizedBox(height: 16),
              _buildTextField(
                label: 'Alamat Lengkap',
                controller: _alamatController,
                maxLines: 2,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Logic Simpan Data Organizer
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kSkyBlue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(double.infinity, 50),
            elevation: 8,
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
          style: const TextStyle(
            color: kDarkBlueGray,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
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
    int maxLines = 1, // Tambahan untuk deskripsi/alamat
  }) {
    Widget field = TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: kDarkBlueGray,
      ),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        suffixIcon: readOnly
            ? const Icon(Icons.arrow_forward_ios, size: 14, color: kBlueGray)
            : null,
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
          Text(
            label,
            style: const TextStyle(
              color: kBlueGray,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          field,
        ],
      ),
    );
  }
}
