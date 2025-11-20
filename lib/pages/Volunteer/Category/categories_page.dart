// lib/pages/Volunteer/Category/categories_page.dart

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Volunteer/Category/detail_category.dart'; // Pastikan impor halaman detail

// Model Sederhana untuk Data Kategori (Tetap Sama)
class ActivityCategory {
  final String name;
  final IconData icon;
  final Color color;

  const ActivityCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // Daftar Dummy Kategori (Tetap Sama)
  final List<ActivityCategory> categories = const [
    ActivityCategory(
      name: 'Pendidikan',
      icon: FontAwesomeIcons.bookOpen,
      color: Color(0xFF4CAF50),
    ),
    ActivityCategory(
      name: 'Lingkungan',
      icon: FontAwesomeIcons.leaf,
      color: Color(0xFF2196F3),
    ),
    ActivityCategory(
      name: 'Kesehatan',
      icon: FontAwesomeIcons.heartPulse,
      color: Color(0xFFF44336),
    ),
    ActivityCategory(
      name: 'Sosial',
      icon: FontAwesomeIcons.handsHoldingChild,
      color: Color(0xFFFF9800),
    ),
    ActivityCategory(
      name: 'Budaya',
      icon: FontAwesomeIcons.palette,
      color: Color(0xFF9C27B0),
    ),
    ActivityCategory(
      name: 'Teknologi',
      icon: FontAwesomeIcons.laptopCode,
      color: Color(0xFF00BCD4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Kategori Kegiatan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            // KIRIM DATA KATEGORI ke _CategoryCard
            return _CategoryCard(category: category);
          },
        ),
      ),
    );
  }
}

// Widget untuk Tampilan Kartu Kategori
class _CategoryCard extends StatelessWidget {
  final ActivityCategory category;

  // Hapus parameter index dari konstruktor
  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // PERBAIKAN: Semua kartu sekarang memiliki aksi navigasi yang sama
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailCategoryPage(category: category),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: kBlueGray.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Kategori
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(category.icon, size: 24, color: category.color),
            ),
            const SizedBox(height: 12),
            // Nama Kategori
            Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kDarkBlueGray,
              ),
            ),
            const SizedBox(height: 4),
            // Teks Tambahan
            Text(
              'Lihat daftar kegiatan', // Teks statis untuk semua kartu
              style: TextStyle(
                fontSize: 12,
                color: kSkyBlue, // Warna cerah agar menarik
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
