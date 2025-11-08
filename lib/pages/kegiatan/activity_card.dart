// lib/pages/kegiatan/activity_card.dart
import 'package:flutter/material.dart';

enum ActivityStatus { upcoming, finished }

class Activity {
  final String title;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  final String bannerUrl;
  final ActivityStatus status;

  Activity({
    required this.title,
    required this.date,
    required this.start,
    required this.end,
    required this.bannerUrl,
    required this.status,
  });
}

class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({super.key, required this.activity});

  String _formatDate(DateTime d) {
    const hari = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '${hari[d.weekday % 7]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')} WIB';

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF0C5E70);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Banner
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(activity.bannerUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 12),

          // Title
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              activity.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 8),

          // Date
          Row(
            children: [
              const Icon(Icons.event, size: 16),
              const SizedBox(width: 6),
              Text(_formatDate(activity.date)),
            ],
          ),
          const SizedBox(height: 6),

          // Time
          Row(
            children: [
              const Icon(Icons.access_time, size: 16),
              const SizedBox(width: 6),
              Text(
                '${_formatTime(activity.start)} - ${_formatTime(activity.end)}',
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Badge jika kegiatan selesai
          if (activity.status == ActivityStatus.finished)
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Sudah Selesai',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
