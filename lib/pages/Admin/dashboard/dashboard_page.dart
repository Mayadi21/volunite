import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'dashboard_widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground, // Menggunakan warna background dari palet
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Header Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang,',
                  style: TextStyle(
                    fontSize: 16,
                    color: kBlueGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Admin Dashboard',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kDarkBlueGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Grid Statistik
            // Menggunakan childAspectRatio agar kartu tidak terlalu kotak (sedikit landscape)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: const [
                StatCard(
                  title: 'Total Volunteer',
                  value: '1,280',
                  icon: Icons.group_outlined,
                  color: kSkyBlue, // Menggunakan kSkyBlue
                ),
                StatCard(
                  title: 'Organisasi',
                  value: '76',
                  icon: Icons.business_outlined,
                  color: kDarkBlueGray, // Menggunakan kDarkBlueGray
                ),
                StatCard(
                  title: 'Event Aktif',
                  value: '32',
                  icon: Icons.event_available_outlined,
                  color: kBlueGray, // Menggunakan kBlueGray
                ),
                StatCard(
                  title: 'Laporan Baru',
                  value: '4',
                  icon: Icons.description_outlined,
                  color: kSkyBlue, // Mengulang kSkyBlue untuk aksen
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Section Header Aktivitas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Aktivitas Terkini',
                  style: TextStyle(
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
                      color: kBlueGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // List Aktivitas
            const ActivityCard(
              icon: Icons.person_add_alt_1,
              title: 'Volunteer baru Budi Santoso mendaftar.',
              time: '2 menit lalu',
            ),
            const ActivityCard(
              icon: Icons.event_note,
              title: 'Yayasan Peduli Anak menambahkan event baru.',
              time: '1 jam lalu',
            ),
            const ActivityCard(
              icon: Icons.check_circle_outline,
              title: 'Laporan kegiatan pantai bersih disetujui.',
              time: '3 jam lalu',
            ),
          ],
        ),
      ),
    );
  }
}
