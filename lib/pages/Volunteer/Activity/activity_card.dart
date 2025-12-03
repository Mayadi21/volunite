// lib/pages/kegiatan/activity_card.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart'; // Impor color palette

// Anda perlu mendefinisikan kBadgeBgFinished di color_pallete.dart, contoh:
// const Color kBadgeBgFinished = Color(0xFFE3F1FF); // soft blue

enum ActivityStatus { upcoming, finished }

class Activity {
  final String title;
  final DateTime date;
  final TimeOfDay start;
  final TimeOfDay end;
  // Ubah tipe data untuk mencocokkan penggunaan Image.asset
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

  // Helper untuk memformat tanggal
  String _formatDate(DateTime d) {
    const hari = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
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
    // Perbaikan indexing hari: d.weekday mengembalikan 1 (Senin) hingga 7 (Minggu).
    // Untuk list hari di atas (diawali Minggu di index 0), gunakan [d.weekday % 7].
    return '${hari[d.weekday % 7]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  // Helper untuk memformat waktu
  String _formatTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final isFinished = activity.status == ActivityStatus.finished;
    final timeRange =
        '${_formatTime(activity.start)} - ${_formatTime(activity.end)} WIB';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.network(
              activity.bannerUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Konten Detail
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title & Chip
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 15, // Disesuaikan sedikit lebih besar
                          fontWeight: FontWeight.w700,
                          color: kDarkBlueGray,
                        ),
                      ),
                    ),
                    if (isFinished) ...[
                      const SizedBox(width: 8),
                      const _FinishedChip(),
                    ],
                  ],
                ),
                const SizedBox(height: 8),

                // Info Tanggal
                _InfoRow(
                  icon: Icons.calendar_today,
                  text: _formatDate(activity.date),
                ),
                const SizedBox(height: 4),

                // Info Waktu
                _InfoRow(icon: Icons.access_time, text: timeRange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// KOMPONEN PEMBANTU
// -----------------------------------------------------------------------------

// Row icon + text
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: kBlueGray),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: kBlueGray)),
      ],
    );
  }
}

// Chip status selesai
class _FinishedChip extends StatelessWidget {
  const _FinishedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1FF), // soft blue (as kBadgeBgFinished)
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 12, color: kDarkBlueGray),
          SizedBox(width: 4),
          Text(
            'Selesai',
            style: TextStyle(
              color: kDarkBlueGray,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
