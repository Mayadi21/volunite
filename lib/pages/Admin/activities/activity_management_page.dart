// lib/pages/Admin/activities/activity_management_page.dart
import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'activity_all_list.dart'; // File baru
import 'activity_pending_list.dart'; // File baru

class ActivityManagementPage extends StatelessWidget {
  const ActivityManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TabController untuk 2 halaman: "Pending" dan "Semua"
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0, // Sembunyikan AppBar utama, kita hanya butuh TabBar
          bottom: const TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            tabs: [
              Tab(icon: Icon(Icons.hourglass_top_rounded), text: 'Pending'),
              Tab(icon: Icon(Icons.checklist_rounded), text: 'Semua Kegiatan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ActivityPendingList(), // <-- Halaman ACC Kegiatan
            ActivityAllList(), // <-- Halaman manajemen (list semua)
          ],
        ),
      ),
    );
  }
}