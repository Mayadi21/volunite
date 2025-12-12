// lib/pages/Admin/dashboard/dashboard_page.dart

import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'dashboard_widgets.dart';
import 'package:volunite/services/core/api_client.dart';
import 'dart:convert';
import 'package:volunite/pages/Admin/activities/activity_management_page.dart';

/// Model sederhana untuk activity (dideklarasikan di atas agar selalu dikenali)
class ActivityItem {
  final String title;
  final String timeAgo;

  ActivityItem({required this.title, required this.timeAgo});

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      title: json['judul'] ?? json['title'] ?? 'Tidak ada judul',
      timeAgo: json['time_ago'] ?? json['created_at'] ?? '',
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _loading = true;
  String? _error;

  // Statistik default (sementara)
  int totalVolunteer = 0;
  int organisasi = 0;
  int eventAktif = 0;
  int eventMenungguPersetujuan = 0;

  // Aktivitas terkini (maks 3)
  List<ActivityItem> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final statsResp = await ApiClient.get('/admin/dashboard-stats');
      if (statsResp.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(statsResp.body);
        setState(() {
          totalVolunteer = data['total_volunteer'] ?? 0;
          organisasi = data['organisasi'] ?? 0;
          eventAktif = data['event_aktif'] ?? 0;
          eventMenungguPersetujuan = data['event_menunggu_persetujuan'] ?? 0;
        });
      } else {
        throw Exception('Gagal ambil statistik (${statsResp.statusCode})');
      }

      final actResp = await ApiClient.get('/admin/activities/recent?limit=3');
      if (actResp.statusCode == 200) {
        final List<dynamic> list = jsonDecode(actResp.body);
        setState(() {
          activities = list.map((e) => ActivityItem.fromJson(e)).toList();
        });
      } else {
        // debug: print body
        // ignore: avoid_print
        print('ACT RESP BODY: ${actResp.body}');
        throw Exception('Gagal ambil aktivitas (${actResp.statusCode})');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Terjadi kesalahan: $_error'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchDashboardData,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Header
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

            // Grid Statistik (gunakan nilai dari API)
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                StatCard(
                  title: 'Total Volunteer',
                  value: totalVolunteer.toString(),
                  icon: Icons.group_outlined,
                  color: kSkyBlue,
                ),
                StatCard(
                  title: 'Organisasi',
                  value: organisasi.toString(),
                  icon: Icons.business_outlined,
                  color: kDarkBlueGray,
                ),
                StatCard(
                  title: 'Event Aktif',
                  value: eventAktif.toString(),
                  icon: Icons.event_available_outlined,
                  color: kBlueGray,
                ),
                StatCard(
                  title: 'Event Menunggu Persetujuan',
                  value: eventMenungguPersetujuan.toString(),
                  icon: Icons.pending_actions_outlined,
                  color: kSkyBlue,
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Aktivitas Terkini
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ActivityManagementPage(),
                      ),
                    );
                  },
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

            // Render activities (maks 3)
            ...activities.map(
              (a) => ActivityCard(
                icon: Icons.event_note,
                title: a.title,
                time: a.timeAgo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
