import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'notifications_page.dart';
import 'achievements_page.dart';
import 'package:volunite/pages/Authentication/login.dart'; // Import halaman login

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan warna latar belakang abu-abu agar Card terlihat
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: [
          // --- HEADER PROFIL ADMIN ---
          Container(
            padding: const EdgeInsets.all(24.0),
            color: primaryColor,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white.withOpacity(0.9),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    size: 40,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin Volunite',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'admin@volunite.com',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- GRUP MENU 1 ---
          _buildMenuSection(
            context,
            title: 'Menu Utama',
            children: [
              _buildMenuTile(
                icon: Icons.notifications_active_rounded,
                title: 'Kirim Notifikasi',
                subtitle: 'Kirim notifikasi massal ke pengguna',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationsPage()));
                },
              ),
              _buildMenuTile(
                icon: FontAwesomeIcons.award,
                title: 'Manajemen Achievement',
                subtitle: 'Atur lencana dan pencapaian',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AchievementsPage()));
                },
              ),
            ],
          ),

          // --- GRUP MENU 2 ---
          _buildMenuSection(
            context,
            title: 'Akun',
            children: [
              _buildMenuTile(
                icon: Icons.logout,
                title: 'Logout',
                color: Colors.red,
                onTap: () {
                  // Logika logout: Kembali ke halaman Login
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) =>
                        false, // Hapus semua riwayat navigasi
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat grup menu
  Widget _buildMenuSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias, // Agar rapi
            margin: EdgeInsets.zero,
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk membuat item menu
  Widget _buildMenuTile(
      {required IconData icon,
      required String title,
      String? subtitle,
      VoidCallback? onTap,
      Color color = Colors.black87}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing:
          onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey) : null,
      onTap: onTap,
    );
  }
}