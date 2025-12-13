// lib/pages/Admin/activities/activity_all_list.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/services/core/api_client.dart';

class ActivityAllList extends StatefulWidget {
  const ActivityAllList({super.key});

  @override
  State<ActivityAllList> createState() => _ActivityAllListState();
}

class _ActivityAllListState extends State<ActivityAllList> {
  List<Activity> activities = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final res = await ApiClient.get(
        '/kegiatan',
      ); // sesuaikan jika endpoint berbeda
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final listJson = (data is Map && data['data'] != null)
            ? data['data']
            : data;
        activities = (listJson as List)
            .map((e) => Activity.fromJson(e as Map<String, dynamic>))
            .toList();
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

  Color _getStatusColor(String status) {
    final s = status.toLowerCase();
    if (s == 'waiting' || s == 'pending') return Colors.orange;
    if (s == 'scheduled' ||
        s == 'on progress' ||
        s == 'disetujui' ||
        s == 'approved')
      return Colors.green;
    if (s == 'finished') return Colors.blue;
    return Colors.red;
  }

  IconData _getStatusIcon(String status) {
    final s = status.toLowerCase();
    if (s == 'waiting' || s == 'pending') return Icons.hourglass_top_rounded;
    if (s == 'scheduled' ||
        s == 'on progress' ||
        s == 'disetujui' ||
        s == 'approved')
      return Icons.check_circle_rounded;
    if (s == 'finished') return Icons.flag_rounded;
    return Icons.cancel_rounded;
  }

  Future<void> _deleteActivity(Activity activity) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kegiatan'),
        content: Text('Anda yakin ingin menghapus "${activity.judul}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // lakukan panggilan API DELETE
    try {
      final res = await ApiClient.delete('/kegiatan/${activity.id}');
      if (res.statusCode == 200 || res.statusCode == 204) {
        setState(() {
          activities.removeWhere((a) => a.id == activity.id);
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Kegiatan dihapus')));
      } else {
        final body = res.body.isNotEmpty ? res.body : '(${res.statusCode})';
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menghapus $body')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _fetchAll,
              child: const Text('Coba lagi'),
            ),
          ],
        ),
      );
    }

    if (activities.isEmpty) {
      return const Center(child: Text('Belum ada kegiatan.'));
    }

    return RefreshIndicator(
      onRefresh: _fetchAll,
      child: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          final statusColor = _getStatusColor(activity.status);
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                child: Icon(
                  _getStatusIcon(activity.status),
                  color: statusColor,
                ),
              ),
              title: Text(
                activity.judul,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(activity.organizerName ?? '-'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteActivity(activity),
              ),
            ),
          );
        },
      ),
    );
  }
}
