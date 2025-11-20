// lib/pages/kategori/detail_category.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
// Impor model kategori dari halaman kategori
import 'categories_page.dart';
// Impor ActivityCard dan Activity dari halaman kegiatan
import 'package:volunite/pages/Volunteer/Activity/activity_card.dart';

class DetailCategoryPage extends StatelessWidget {
  final ActivityCategory category;

  const DetailCategoryPage({super.key, required this.category});

  // Data Dummy Kegiatan yang sesuai dengan kategori ini
  // (Dalam proyek nyata, ini akan diambil dari API)
  List<Activity> get _dummyActivities {
    return [
          Activity(
            title: 'Bakti Sosial Mengajar Anak Jalanan',
            date: DateTime(2025, 1, 15),
            start: const TimeOfDay(hour: 14, minute: 0),
            end: const TimeOfDay(hour: 16, minute: 0),
            bannerUrl: 'assets/images/event2.jpg',
            status: ActivityStatus.upcoming,
          ),
          Activity(
            title: 'Donasi Buku & Alat Tulis ke Panti Asuhan',
            date: DateTime(2025, 2, 5),
            start: const TimeOfDay(hour: 10, minute: 0),
            end: const TimeOfDay(hour: 12, minute: 0),
            bannerUrl: 'assets/images/event1.jpg',
            status: ActivityStatus.upcoming,
          ),
          Activity(
            title: 'Membaca Bersama untuk Anak Kurang Mampu',
            date: DateTime(2024, 11, 10),
            start: const TimeOfDay(hour: 9, minute: 0),
            end: const TimeOfDay(hour: 11, minute: 0),
            bannerUrl: 'assets/images/event2.jpg',
            status: ActivityStatus.finished,
          ),
        ]
        // Filter dummy data agar sesuai dengan nama kategori yang dikirim
        // Di sini saya mengembalikan semua, karena data dummy statis
        .where((activity) => category.name == 'Pendidikan' ? true : false)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activities = _dummyActivities;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kSkyBlue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Kegiatan ${category.name}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kategori (Opsional: deskripsi/filter)
          _buildCategoryHeader(),

          // Daftar Kegiatan
          Expanded(
            child: activities.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada kegiatan untuk kategori ini.',
                      style: TextStyle(color: kBlueGray),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: activities.length,
                    itemBuilder: (context, index) {
                      return ActivityCard(activity: activities[index]);
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 14),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kLightGray, width: 1)),
      ),
      child: Row(
        children: [
          Icon(category.icon, size: 28, color: category.color),
          const SizedBox(width: 12),
          Text(
            'Kumpulan kegiatan di bidang ${category.name}.',
            style: const TextStyle(
              fontSize: 14,
              color: kDarkBlueGray,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
