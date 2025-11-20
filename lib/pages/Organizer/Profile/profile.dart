// lib/pages/Organizer/Profile/profile.dart

import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/color_pallete.dart'; // Import Color Pallete
import 'edit_profile.dart';

class OrganizerProfilePage extends StatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  final Color primaryDark = kDarkBlueGray;
  static const Color primaryAction = kSkyBlue;
  static const Color logoutColor = Color(0xFFD32F2F); // Merah Standar Material

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
                  color: logoutColor,
                  size: 60,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Apakah kamu yakin ingin keluar dari akun?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkBlueGray,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryDark,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Tidak',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
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
                          backgroundColor: logoutColor,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .stretch, // Agar tombol dan achievement full width
              children: [
                // =================================================================
                // HEADER (Avatar & Edit Button)
                // =================================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: primaryAction, // kSkyBlue
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryAction.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EditOrganizerProfilePage(),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Avatar dan Nama
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryAction.withOpacity(0.5),
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: kLightGray,
                        child: Icon(
                          Icons.business,
                          size: 60,
                          color: primaryDark,
                        ), // Warna ikon disesuaikan
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'KMB-USU',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const Text(
                      'Penyelenggara Kegiatan',
                      style: TextStyle(fontSize: 12, color: kBlueGray),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // =================================================================
                // CARD METRIC UTAMA (Pengganti _buildStatsRow)
                // =================================================================
                _buildMetricCard(
                  icon: Icons.group,
                  label: 'Total Relawan',
                  value: '2,480',
                  color: primaryDark, // Warna kDarkBlueGray
                ),
                const SizedBox(height: 12),
                _buildMetricCard(
                  icon: Icons.check_circle_outline,
                  label: 'Tingkat Kehadiran',
                  value: '92%',
                  color: primaryAction, // Warna kSkyBlue
                ),

                const SizedBox(height: 30),

                // =================================================================
                // ACHIEVEMENT SECTIONS
                // =================================================================
                _buildAchievementSection(
                  title: 'Statistik Kegiatan',
                  items: [
                    _buildStatItem('12', 'Total'),
                    _buildStatItem('8', 'Aktif'),
                    _buildStatItem('4', 'Selesai'),
                  ],
                ),

                const SizedBox(height: 24),

                _buildAchievementSection(
                  title: 'Statistik Relawan',
                  items: [
                    _buildStatItem('248', 'Total\nPendaftar'),
                    _buildStatItem('4.8', 'Rating\nRata-rata'),
                  ],
                ),

                const SizedBox(height: 30),

                // Tombol Keluar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showLogoutDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: logoutColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget baru yang lebih menarik dari _buildStatsRow
  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color, // Warna aksen
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Ikon Aksen
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(width: 16),
          // Data
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: kBlueGray, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  color: kDarkBlueGray,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementSection({
    required String title,
    required List<Widget> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: kDarkBlueGray,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              Expanded(child: items[i]),
              if (i < items.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white, // Ganti background menjadi putih
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryDark.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: kLightGray,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color:
                  primaryAction, // Menggunakan kSkyBlue untuk menonjolkan nilai
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: kBlueGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
