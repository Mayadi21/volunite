import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/pages/Admin/data/mock_data.dart';
import 'admin_activity_detail.dart'; // Halaman Detail/ACC

class ActivityPendingList extends StatefulWidget {
  const ActivityPendingList({super.key});

  @override
  State<ActivityPendingList> createState() => _ActivityPendingListState();
}

class _ActivityPendingListState extends State<ActivityPendingList> {
  // Kita ubah jadi stateful agar list bisa di-refresh
  late List<Activity> pendingActivities;

  @override
  void initState() {
    super.initState();
    _filterPending();
  }

  void _filterPending() {
    // Ambil data terbaru dari mock_data
    pendingActivities =
        mockActivities.where((a) => a.status == 'Pending').toList();
  }

  // Fungsi untuk refresh list setelah ACC
  void _refreshList() {
    setState(() {
      _filterPending();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (pendingActivities.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text('Tidak ada kegiatan \nyang menunggu persetujuan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: pendingActivities.length,
      itemBuilder: (context, index) {
        final activity = pendingActivities[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.2),
              child:
                  const Icon(Icons.hourglass_top_rounded, color: Colors.orange),
            ),
            title: Text(activity.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(activity.organizerName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke Halaman ACC
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminActivityDetailPage(
                    activity: activity,
                  ),
                ),
              ).then((_) => _refreshList()); // Refresh list saat kembali
            },
          ),
        );
      },
    );
  }
}