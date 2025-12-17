import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kategori_model.dart';
import 'package:volunite/services/kategori_service.dart';
import 'package:volunite/pages/Volunteer/Category/category_activities_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  late Future<List<Kategori>> _kategoriFuture;

  @override
  void initState() {
    super.initState();
    _kategoriFuture = KategoriService.fetchKategori();
  }

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

      // ================= BODY =================
      body: FutureBuilder<List<Kategori>>(
        future: _kategoriFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal memuat kategori: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada kategori tersedia'),
            );
          }

          final categories = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return _CategoryCard(
                  category: categories[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ===================================================================
// CATEGORY CARD
// ===================================================================
class _CategoryCard extends StatelessWidget {
  final Kategori category;

  const _CategoryCard({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryActivitiesPage(
              categoryName: category.namaKategori,
            ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ================= ICON =================
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kSkyBlue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: _buildCategoryIcon(),
            ),
            const SizedBox(height: 12),

            // ================= TITLE =================
            Text(
              category.namaKategori,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kDarkBlueGray,
              ),
            ),
            const SizedBox(height: 4),

            // ================= SUBTITLE =================
            const Text(
              'Lihat daftar kegiatan',
              style: TextStyle(
                fontSize: 12,
                color: kSkyBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================================================================
  // ICON BUILDER (THUMBNAIL DARI DATABASE)
  // ===================================================================
  Widget _buildCategoryIcon() {
    final String? iconPath = category.thumbnail;

    if (iconPath == null || iconPath.isEmpty) {
      return const Icon(Icons.category, color: kSkyBlue);
    }

    // Jika URL
    if (iconPath.startsWith('http')) {
      return Image.network(
        iconPath,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.category, color: kSkyBlue),
      );
    }

    // Jika Asset
    return Image.asset(
      iconPath,
      fit: BoxFit.contain,
    );
  }
}
