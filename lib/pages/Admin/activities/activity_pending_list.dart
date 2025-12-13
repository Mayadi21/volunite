// lib/pages/Admin/activities/activity_pending_list.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/services/core/api_client.dart';
import 'admin_activity_detail.dart';

class ActivityPendingList extends StatefulWidget {
  const ActivityPendingList({super.key});

  @override
  State<ActivityPendingList> createState() => _ActivityPendingListState();
}

class _ActivityPendingListState extends State<ActivityPendingList> {
  List<Activity> pendingActivities = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchPending();
  }

  Future<void> _fetchPending() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final res = await ApiClient.get('/kegiatan'); // sesuaikan path jika API beda
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        // Asumsi: data adalah array atau { data: [...] }
        final listJson = (data is Map && data['data'] != null) ? data['data'] : data;
        final all = (listJson as List).map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();

        // Filter status "Waiting" sebagai pending
        pendingActivities = all.where((a) => a.status.toLowerCase() == 'waiting').toList();
      } else {
        error = 'Gagal memuat data (${res.statusCode})';
      }
    } catch (e) {
      error = 'Terjadi error: $e';
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  // Dipanggil setelah kembali dari halaman detail (ACC)
  void _refreshList() => _fetchPending();

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _fetchPending, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

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

    return RefreshIndicator(
      onRefresh: _fetchPending,
      child: ListView.builder(
        itemCount: pendingActivities.length,
        itemBuilder: (context, index) {
          final activity = pendingActivities[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.withOpacity(0.2),
                child: const Icon(Icons.hourglass_top_rounded, color: Colors.orange),
              ),
              title: Text(activity.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(activity.organizerName ?? '-'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminActivityDetailPage(activity: activity),
                  ),
                ).then((_) => _refreshList());
              },
            ),
          );
        },
      ),
    );
  }
}
