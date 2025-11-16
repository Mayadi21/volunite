import 'package:flutter/material.dart';
import 'dashboard_widgets.dart'; // Import widget terpisah

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Selamat Datang, Admin!',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Grid Statistik
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: const [
            StatCard(
                title: 'Total Volunteer',
                value: '1,280',
                icon: Icons.group,
                color: Colors.blue),
            StatCard(
                title: 'Organisasi',
                value: '76',
                icon: Icons.business,
                color: Colors.green),
            StatCard(
                title: 'Event Aktif',
                value: '32',
                icon: Icons.event,
                color: Colors.orange),
            StatCard(
                title: 'Laporan Baru',
                value: '4',
                icon: Icons.file_copy,
                color: Colors.red),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Aktivitas Terkini',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const ActivityCard(
          icon: Icons.person_add,
          title: 'Volunteer baru Budi Santoso mendaftar.',
          time: '2 menit lalu',
          color: Colors.green,
        ),
        const ActivityCard(
          icon: Icons.event,
          title: 'Yayasan Peduli Anak menambahkan event baru.',
          time: '1 jam lalu',
          color: Colors.blue,
        ),
      ],
    );
  }
}