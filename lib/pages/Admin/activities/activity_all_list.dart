import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/pages/Admin/data/mock_data.dart';

class ActivityAllList extends StatefulWidget {
  const ActivityAllList({super.key});

  @override
  State<ActivityAllList> createState() => _ActivityAllListState();
}

class _ActivityAllListState extends State<ActivityAllList> {
  void _deleteActivity(Activity activity) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Kegiatan'),
        content: Text('Anda yakin ingin menghapus ${activity.name}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                // Hapus dari list utama
                mockActivities.removeWhere((a) => a.id == activity.id);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Disetujui') return Colors.green;
    if (status == 'Pending') return Colors.orange;
    return Colors.red;
  }

  IconData _getStatusIcon(String status) {
    if (status == 'Disetujui') return Icons.check_circle_rounded;
    if (status == 'Pending') return Icons.hourglass_top_rounded;
    return Icons.cancel_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mockActivities.length,
      itemBuilder: (context, index) {
        final activity = mockActivities[index];
        final statusColor = _getStatusColor(activity.status);
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: statusColor.withOpacity(0.2),
              child: Icon(_getStatusIcon(activity.status), color: statusColor),
            ),
            title: Text(activity.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(activity.organizerName),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteActivity(activity),
            ),
          ),
        );
      },
    );
  }
}