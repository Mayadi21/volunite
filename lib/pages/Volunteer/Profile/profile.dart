import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pencapaian_model.dart';
import 'package:volunite/models/volunteer_pencapaian_model.dart';
import 'package:volunite/services/pencapaian_service.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/pages/Volunteer/Profile/achievement_dialog.dart'; // Import Halaman Lihat Semua
import 'package:volunite/pages/Volunteer/Profile/achievement_page.dart'; // Import Dialog
import 'edit_profile.dart'; 
// Asumsi import ini ada dan benar sesuai path project Anda

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<VolunteerProfileData> _futureProfile;
  File? _imageFile; // Digunakan untuk preview gambar lokal saat pick, jika fitur upload masih diinginkan

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  // Fungsi untuk memuat ulang data profil dari server
  void _refresh() {
    setState(() {
      _futureProfile = VolunteerService.fetchProfile();
    });
  }

  // Fungsi navigasi ke EditProfilePage dan memanggil _refresh() setelah kembali
  void _navigateToEditProfile() async {
    // Menunggu hingga halaman EditProfilePage di-pop (ditutup)
    await Navigator.push(
      context, 
      MaterialPageRoute(builder: (_) => const EditProfilePage())
    );
    
    // Setelah kembali, muat ulang data untuk menampilkan perubahan nama/foto terbaru
    _refresh(); 
  }

  // --- FUNGSI HELPER ---
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: const Icon(Icons.photo_camera), title: const Text('Kamera'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.camera); }),
            ListTile(leading: const Icon(Icons.photo_library), title: const Text('Galeri'), onTap: () { Navigator.pop(context); _pickImage(ImageSource.gallery); }),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    var status = source == ImageSource.camera ? await Permission.camera.request() : await Permission.photos.request();
    if (status.isGranted) {
      final picked = await ImagePicker().pickImage(source: source);
      if (picked != null) {
        setState(() => _imageFile = File(picked.path));
        // Catatan: Di sini harus ada logika untuk mengunggah foto ke server 
        // dan kemudian memanggil _refresh() jika berhasil.
      }
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Keluar"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Keluar", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
  // ---------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [kBlueGray, kSkyBlue]))),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            // Memicu navigasi dan refresh data
            onPressed: _navigateToEditProfile,
          )
        ],
      ),
      body: FutureBuilder<VolunteerProfileData>(
        future: _futureProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kSkyBlue));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat profil: ${snapshot.error}", textAlign: TextAlign.center));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              children: [
                // 1. Header Profil (Sudah direvisi)
                _buildProfileHeader(data),
                const SizedBox(height: 24),

                // 2. XP Card (Tanpa Leveling)
                _buildSimpleXPCard(data),
                const SizedBox(height: 16),

                // 3. Stats Row
                _buildStatsRow(data),
                const SizedBox(height: 24),

                // 4. Achievement Section
                _buildAchievementSection(context, data.achievements),

                const SizedBox(height: 30),
                
                // 5. Logout
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Keluar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(VolunteerProfileData data) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: kLightGray,
              // Tampilkan foto lokal jika ada, jika tidak, ambil dari network
              backgroundImage: _imageFile != null 
                  ? FileImage(_imageFile!) 
                  : (data.pathProfil != null ? NetworkImage(data.pathProfil!) : null) as ImageProvider?,
              child: (_imageFile == null && data.pathProfil == null) 
                  ? const Icon(Icons.person, size: 70, color: Colors.white) 
                  : null,
            ),
            // BLOK KODE LOGO KAMERA DIHAPUS DARI SINI
          ],
        ),
        const SizedBox(height: 12),
        // Nama diambil dari data.nama (yang sudah diperbarui via _refresh)
        Text(
          data.nama,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkBlueGray),
        ),
      ],
    );
  }

  // XP CARD YANG DISEDERHANAKAN (HANYA TOTAL)
  Widget _buildSimpleXPCard(VolunteerProfileData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [kSkyBlue, kBlueGray], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Volunteer XP',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                '${data.totalXp} XP',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.star_rounded, color: Colors.white, size: 32),
          )
        ],
      ),
    );
  }

  Widget _buildStatsRow(VolunteerProfileData data) {
    return Row(
      children: [
        _buildStatCard('${data.activityCount}', 'Kegiatan Sukarela'),
        const SizedBox(width: 16),
        _buildStatCard('#-', 'Peringkat Global'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.5), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: const TextStyle(color: kDarkBlueGray, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: kBlueGray, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementSection(BuildContext context, List<Pencapaian> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Pencapaian Relawan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
              TextButton(
                onPressed: () {
                  // Navigasi ke Halaman "Lihat Semua"
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AllAchievementsPage(achievements: items)));
                },
                child: const Text("Lihat Semua", style: TextStyle(color: kSkyBlue, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Horizontal List (Preview 5 item pertama saja)
        SizedBox(
          height: 140,
          child: items.isEmpty 
            ? const Center(child: Text("Belum ada pencapaian", style: TextStyle(color: Colors.grey)))
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                // Tampilkan maksimal 5 di preview
                itemCount: items.length > 5 ? 5 : items.length, 
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _buildAchievementItem(context, items[index]);
                },
              ),
        ),
      ],
    );
  }

  Widget _buildAchievementItem(BuildContext context, Pencapaian item) {
    final bool isUnlocked = item.isUnlocked;
    final Color iconColor = isUnlocked ? Colors.orange : Colors.grey;
    final double opacity = isUnlocked ? 1.0 : 0.5;
    
    return GestureDetector(
      onTap: () {
        // Tampilkan Pop-up Detail
        showDialog(context: context, builder: (_) => AchievementDialog(item: item));
      },
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: 100,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: isUnlocked 
                ? [BoxShadow(color: kBlueGray.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 4))] 
                : null,
            border: Border.all(color: kLightGray),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item.thumbnail != null 
                  ? Image.network(item.thumbnail!, width: 40, height: 40, fit: BoxFit.cover)
                  : Icon(Icons.emoji_events_rounded, size: 40, color: iconColor),
              
              const SizedBox(height: 8),
              
              Text(
                item.nama,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kDarkBlueGray),
              ),

              if (!isUnlocked) ...[
                const SizedBox(height: 4),
                const Icon(Icons.lock, size: 14, color: Colors.grey),
              ]
            ],
          ),
        ),
      ),
    );
  }
}