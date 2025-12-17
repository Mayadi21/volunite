import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pencapaian_model.dart';
import 'package:volunite/models/volunteer_pencapaian_model.dart'; // Pastikan path model benar
import 'package:volunite/services/pencapaian_service.dart'; // Pastikan path service benar
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/pages/Volunteer/Profile/achievement_dialog.dart'; 
import 'package:volunite/pages/Volunteer/Profile/achievement_page.dart'; 
import 'package:volunite/pages/shared/edit_profile.dart';
import 'package:volunite/pages/Volunteer/Profile/leaderboard_page.dart'; 
import 'package:volunite/services/general_profile_service.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<VolunteerProfileData> _futureProfile;
  
  // Signature untuk bypass cache gambar
  String _imgSignature = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    _refresh();
    
    // [LISTENER] Dengarkan sinyal refresh dari GeneralProfileService
    // Agar saat user edit nama/foto, halaman ini otomatis update
    GeneralProfileService.shouldRefresh.addListener(_refresh);
  }

  @override
  void dispose() {
    GeneralProfileService.shouldRefresh.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {
        _futureProfile = VolunteerService.fetchProfile();
        // Update signature gambar
        _imgSignature = DateTime.now().millisecondsSinceEpoch.toString();
      });
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
            onPressed: () {
              // Navigasi ke Edit Profile (Shared)
              // Tidak perlu await karena sudah ada Listener
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfilePage()));
            },
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
            return Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Gagal memuat: ${snapshot.error}", textAlign: TextAlign.center),
                const SizedBox(height: 10),
                ElevatedButton(onPressed: _refresh, child: const Text("Coba Lagi"))
              ],
            ));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  // 1. HEADER PROFIL
                  _buildProfileHeader(data),
                  const SizedBox(height: 20),

                  // 2. CARD XP
                  _buildExperienceCardModern(data),
                  const SizedBox(height: 16),

                  // 3. STATS ROW (Termasuk Link ke Leaderboard)
                  _buildStatsRowModern(data),
                  const SizedBox(height: 24),

                  // 4. ACHIEVEMENT SECTION
                  _buildAchievementSectionModern(
                    title: 'Pencapaian Relawan',
                    items: data.achievements.map((ach) {
                      return _buildVolunteerItemHelper(
                        ach.nama, 
                        Icons.emoji_events_rounded, 
                        ach.isUnlocked ? Colors.orange : Colors.grey, 
                        ach.isUnlocked, 
                        ach
                      );
                    }).toList()
                  ),

                  const SizedBox(height: 30),
                  
                  // 5. LOGOUT BUTTON
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
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET KOMPONEN ---

  Widget _buildProfileHeader(VolunteerProfileData data) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: kLightGray,
          // Pasang Signature agar gambar refresh otomatis
          backgroundImage: data.pathProfil != null 
              ? NetworkImage("${data.pathProfil!}?v=$_imgSignature") 
              : null,
          child: data.pathProfil == null ? const Icon(Icons.person, size: 70, color: Colors.white) : null,
        ),
        const SizedBox(height: 12),
        Text(
          data.nama,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkBlueGray),
        ),
      ],
    );
  }

  Widget _buildExperienceCardModern(VolunteerProfileData data) {
    double progress = data.nextLevelTarget > 0 ? (data.currentLevelXp / data.nextLevelTarget) : 0.0;
    if(progress > 1.0) progress = 1.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [kSkyBlue, kBlueGray], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Volunteer XP', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
              Icon(Icons.trending_up, color: Colors.white, size: 18)
            ]
          ),
          const SizedBox(height: 10),
          Text('${data.totalXp} XP', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 8
            )
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${data.currentLevelXp}/${data.nextLevelTarget} to Next Level', style: const TextStyle(color: Colors.white, fontSize: 12))
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRowModern(VolunteerProfileData data) {
    return Row(
      children: [
        // CARD 1: Kegiatan Diikuti
        Expanded(
          child: _buildCardBase(
            widthFactor: 0, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text('${data.activityCount}', style: const TextStyle(color: kDarkBlueGray, fontSize: 36, fontWeight: FontWeight.w900)), 
                const SizedBox(height: 4), 
                const Text('Kegiatan Diikuti', style: TextStyle(color: kBlueGray, fontSize: 13))
              ]
            )
          )
        ),
        
        const SizedBox(width: 16),
        
        // CARD 2: Peringkat Global (KLIK -> LEADERBOARD)
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage()));
            },
            child: _buildCardBase(
              widthFactor: 0, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Tampilkan Ranking Asli dari Backend
                      Text(
                        '#${data.globalRank}', 
                        style: const TextStyle(color: kSkyBlue, fontSize: 36, fontWeight: FontWeight.w900)
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 14, color: kBlueGray)
                    ],
                  ),
                  const SizedBox(height: 4), 
                  const Text('Peringkat Global', style: TextStyle(color: kBlueGray, fontSize: 13))
                ]
              )
            ),
          )
        ),
      ],
    );
  }

  Widget _buildAchievementSectionModern({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
              TextButton(
                onPressed: () {
                  // Navigasi ke Halaman Semua Achievement (Jika ada)
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => AllAchievementsPage(achievements: ...)));
                },
                child: const Text("Lihat Semua", style: TextStyle(color: kSkyBlue, fontWeight: FontWeight.bold))
              )
            ]
          )
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: items.isEmpty 
            ? const Center(child: Text("Belum ada pencapaian", style: TextStyle(color: Colors.grey)))
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return items[index];
                },
              ),
        ),
      ],
    );
  }

  Widget _buildVolunteerItemHelper(String label, IconData icon, Color color, bool isUnlocked, Pencapaian item) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (_) => AchievementDialog(item: item));
      },
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.5,
        child: SizedBox(
          width: 100,
          child: Column(
            children: [
              _buildCardBase(
                widthFactor: 80, 
                child: item.thumbnail != null 
                    ? Image.network(item.thumbnail!, width: 40, height: 40, fit: BoxFit.cover)
                    : Icon(icon, size: 40, color: color)
              ),
              const SizedBox(height: 8),
              Text(
                label, 
                textAlign: TextAlign.center, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isUnlocked ? kDarkBlueGray : Colors.grey), 
                maxLines: 2, 
                overflow: TextOverflow.ellipsis
              ),
              if(!isUnlocked) 
                const Padding(padding: EdgeInsets.only(top: 4), child: Icon(Icons.lock, size: 14, color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardBase({required double widthFactor, required Widget child}) {
    return Container(
      width: widthFactor > 0 ? widthFactor : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 4))]
      ),
      child: Center(child: child),
    );
  }
}