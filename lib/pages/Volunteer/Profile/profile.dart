// lib/pages/profile/profile_page.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'edit_profile.dart';
import 'package:volunite/color_pallete.dart'; // Impor color palette

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final primaryDark = kDarkBlueGray;
  File? _imageFile;

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
      if (status.isDenied && Platform.isAndroid) {
        status = await Permission.storage.request();
      }
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 25, bottom: 15),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Apakah kamu yakin ingin keluar dari akun?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // --- TOMBOL TIDAK (Diedit) ---
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Background Putih
                          foregroundColor:
                              kBlueGray, // Warna efek sentuhan & text otomatis menyesuaikan
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          // Menambahkan Border (Garis Tepi)
                          side: const BorderSide(color: kBlueGray, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Tidak',
                          // Hapus properti color di sini atau ubah jadi kBlueGray
                          // agar tidak tertimpa warna putih (jika sebelumnya putih)
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    // -----------------------------
                    const SizedBox(width: 15),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[700],
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Keluar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // --- AKHIR DARI FUNGSI HELPER ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
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
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          // Tombol Edit Profile
          _buildActionButton(
            icon: Icons.edit,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              // Area Profil Gambar & Nama
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: kLightGray,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.person,
                            size: 70,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: kSkyBlue,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () => _showImageSourceDialog(context),
                        child: const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'MAS GIB RAN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlueGray,
                ),
              ),
              const SizedBox(height: 20),

              // Kartu Pengalaman (DIUBAH)
              _buildExperienceCardModern(),

              const SizedBox(height: 16),

              // Row Statistik (DIUBAH)
              _buildStatsRowModern(),

              const SizedBox(height: 24),

              // Bagian Pencapaian Sertifikat (DIUBAH)
              _buildAchievementSectionModern(
                title: 'Pencapaian Sertifikat',
                items: [
                  _buildCertificateItem('28 Okt 24', 'Pandawara', kBlueGray),
                  _buildCertificateItem('30 Okt 24', 'KMB-USU', kSkyBlue),
                  _buildCertificateItem('1 Nov 24', 'Cisco', kDarkBlueGray),
                ],
              ),

              const SizedBox(height: 24),

              // Bagian Pencapaian Relawan
              _buildAchievementSectionModern(
                title: 'Pencapaian Relawan',
                items: [
                  _buildVolunteerItem(
                    'Penjaga\nHijau',
                    Icons.eco,
                    Colors.green[700]!,
                  ),
                  _buildVolunteerItem(
                    'Juara\nKomunitas',
                    Icons.emoji_events,
                    kSkyBlue,
                  ),
                  _buildVolunteerItem(
                    'Perintis\nPerubahan',
                    Icons.star,
                    Colors.orange[700]!,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Tombol Keluar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showLogoutDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Sedikit lebih bulat
                    ),
                    elevation: 0, // Mengurangi elevasi agar tidak kaku
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // WIDGET BARU (Gaya Modern)
  // ---------------------------------------------------------------------------

  Widget _buildActionButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: kDarkBlueGray, size: 20),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCardBase({required Widget child, required double widthFactor}) {
    return Container(
      width: widthFactor > 0 ? widthFactor : null, // Hanya jika widthFactor > 0
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kLightGray,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          // Efek Shadow/Neumorphic yang lebih lembut
          BoxShadow(
            color: kBlueGray.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: kBlueGray.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildExperienceCardModern() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [kSkyBlue, kBlueGray], // Gradient sesuai referensi
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Total Volunteer XP',
                style: TextStyle(
                  color: Colors.white, // Diubah jadi putih agar terbaca
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Icon(
                Icons.trending_up,
                color: Colors.white, // Icon diubah jadi putih
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            '18,000 XP',
            style: TextStyle(
              color: Colors.white, // Diubah jadi putih tebal
              fontSize: 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 18000 / 54000,
              // Background bar jadi putih transparan
              backgroundColor: Colors.white24,
              // Isi bar jadi putih solid
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 6),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '18,000/54,000 to Level Up',
              style: TextStyle(
                color: Colors.white, // Diubah jadi putih transparan
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRowModern() {
    return Row(
      children: [
        Expanded(
          child: _buildCardBase(
            widthFactor: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '72',
                  style: TextStyle(
                    color: kDarkBlueGray,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kegiatan Sukarela',
                  style: TextStyle(color: kBlueGray, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCardBase(
            widthFactor: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '#3',
                  style: TextStyle(
                    color: kDarkBlueGray,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Peringkat Global',
                  style: TextStyle(color: kBlueGray, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementSectionModern({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlueGray,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: kSkyBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
            separatorBuilder: (context, index) => const SizedBox(width: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildCertificateItem(String date, String title, Color color) {
    return _buildCardBase(
      widthFactor: 120,
      child: Column(
        children: [
          Container(
            height: 80,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.file_copy, size: 40, color: color),
          ),
          const SizedBox(height: 8),
          Text(date, style: const TextStyle(fontSize: 11, color: kBlueGray)),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: kDarkBlueGray,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerItem(String label, IconData icon, Color color) {
    return SizedBox(
      width: 100,
      child: Column(
        children: [
          // Diubah menjadi base card untuk efek neumorphic soft
          _buildCardBase(
            widthFactor: 80,
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: kDarkBlueGray,
            ),
          ),
        ],
      ),
    );
  }
}
