import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/models/user_model.dart';

import 'activity_category_page.dart';
import 'achievements_page.dart';

class MorePage extends StatelessWidget {
  const MorePage({super.key});

  Future<void> _showLogoutConfirmation(
    BuildContext context,
    AuthService authService,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah kamu yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await authService.logout();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<User?>(
        future: authService.getCurrentUser(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          return ListView(
            children: [
              // ===== HEADER ADMIN =====
              Container(
                padding: const EdgeInsets.all(24),
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

                    // === NAMA ADMIN DINAMIS ===
                    Text(
                      user?.nama ?? 'Admin',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== MENU UTAMA =====
              _buildMenuSection(
                title: 'Menu Utama',
                children: [
                  _buildMenuTile(
                    icon: Icons.category_rounded,
                    title: 'Manajemen Kategori Kegiatan',
                    subtitle: 'Atur kategori kegiatan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ActivityCategoryPage(),
                        ),
                      );
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
                          builder: (_) => const AchievementsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),

              // ===== AKUN =====
              _buildMenuSection(
                title: 'Akun',
                children: [
                  _buildMenuTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    color: Colors.red,
                    onTap: () {
                      _showLogoutConfirmation(context, authService);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  // ===== MENU SECTION =====
  Widget _buildMenuSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  // ===== MENU TILE =====
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: onTap != null
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
      onTap: onTap,
    );
  }
}
