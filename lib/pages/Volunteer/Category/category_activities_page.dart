// lib/pages/Volunteer/Category/category_activities_page.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';

// -----------------------------------------------------------------------------
// 1. MODEL DATA
// -----------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// 2. HALAMAN UTAMA (CATEGORY PAGE)
// -----------------------------------------------------------------------------
class CategoryActivitiesPage extends StatelessWidget {
  final String categoryName;

  CategoryActivitiesPage({super.key, required this.categoryName});

  final List<Activity> _dummyActivities = [
    Activity(
      title: "Pintar Bersama - KMB USU",
      date: DateTime.now().add(const Duration(days: 2)),
      start: const TimeOfDay(hour: 12, minute: 0),
      end: const TimeOfDay(hour: 17, minute: 0),
      bannerUrl: "assets/images/event1.jpg",
      status: ActivityStatus.upcoming,
    ),
    Activity(
      title: "Aksi Bersih Pantai Cermin",
      date: DateTime.now().add(const Duration(days: 5)),
      start: const TimeOfDay(hour: 9, minute: 0),
      end: const TimeOfDay(hour: 12, minute: 0),
      bannerUrl: "assets/images/event2.jpg",
      status: ActivityStatus.upcoming,
    ),
    Activity(
      title: "Workshop Digital Marketing",
      date: DateTime.now().subtract(const Duration(days: 5)),
      start: const TimeOfDay(hour: 10, minute: 0),
      end: const TimeOfDay(hour: 15, minute: 0),
      bannerUrl: "assets/images/event1.jpg",
      status: ActivityStatus.finished,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        // 1. Background color dibuat transparan agar gradient terlihat
        backgroundColor: Colors.transparent,
        elevation: 0,

        // 2. Menggunakan flexibleSpace untuk Gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // 3. Icon Back diubah jadi Putih agar terlihat jelas
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

        // 4. Judul diubah jadi Putih
        title: Text(
          categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _dummyActivities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) {
          final activity = _dummyActivities[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailActivitiesPage(
                    title: activity.title,
                    date:
                        "${activity.date.day}/${activity.date.month}/${activity.date.year}",
                    time:
                        "${activity.start.hour}:${activity.start.minute.toString().padLeft(2, '0')}",
                    imagePath: activity.bannerUrl,
                  ),
                ),
              );
            },
            child: ActivityCard(activity: activity),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. WIDGET CARD
// -----------------------------------------------------------------------------
class ActivityCard extends StatelessWidget {
  final Activity activity;
  const ActivityCard({super.key, required this.activity});

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
    return '${hari[d.weekday % 7]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              activity.bannerUrl,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 15,
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
                _InfoRow(
                  icon: Icons.calendar_today,
                  text: _formatDate(activity.date),
                ),
                const SizedBox(height: 4),
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

class _FinishedChip extends StatelessWidget {
  const _FinishedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1FF),
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
