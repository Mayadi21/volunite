import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
// Import model dan service kategori Anda
import 'package:volunite/models/kategori_model.dart';
// Asumsi service kategori ada di path berikut:
import 'package:volunite/services/kategori_service.dart'; 

// Import halaman tujuan (asumsi DetailCategoryPage menerima Kategori atau nama)
import 'package:volunite/pages/Volunteer/Category/category_activities_page.dart'; 
// Asumsi 'detail_category.dart' adalah CategoryActivitiesPage (diberikan sebelumnya)
// Jika Anda memiliki DetailCategoryPage terpisah, sesuaikan impor di atas dan navigasi di bawah.


// 🔥 UBAH DARI StatelessWidget MENJADI StatefulWidget
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
    // 🔥 Memuat data kategori saat inisialisasi
    _kategoriFuture = KategoriService.fetchKategori();
  }
  
  // 🔥 FUNGSI PEMBANTU UNTUK MENGAMBIL IKON BERDASARKAN NAMA
  IconData _getIconForCategory(String categoryName) {
    // Anda bisa menentukan map ikon statis di sini 
    switch (categoryName.toLowerCase()) {
      case 'pendidikan':
        return Icons.school;
      case 'lingkungan':
        return Icons.nature;
      case 'kesehatan':
        return Icons.health_and_safety;
      case 'sosial':
        return Icons.people;
      case 'budaya':
        return Icons.palette;
      case 'teknologi':
        return Icons.laptop_mac; // Menggunakan Icons default Flutter
      default:
        return Icons.category;
    }
  }

  // 🔥 FUNGSI PEMBANTU UNTUK MENENTUKAN WARNA BERDASARKAN NAMA (Opsional)
  Color _getColorForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'pendidikan':
        return const Color(0xFF4CAF50);
      case 'lingkungan':
        return const Color(0xFF2196F3);
      case 'kesehatan':
        return const Color(0xFFF44336);
      case 'sosial':
        return const Color(0xFFFF9800);
      case 'budaya':
        return const Color(0xFF9C27B0);
      case 'teknologi':
        return const Color(0xFF00BCD4);
      default:
        return kSkyBlue; // Fallback
    }
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
      // 🔥 Mengganti GridView statis dengan FutureBuilder
      body: FutureBuilder<List<Kategori>>(
        future: _kategoriFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat kategori: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final categories = snapshot.data!;

            if (categories.isEmpty) {
              return const Center(child: Text('Tidak ada kategori yang tersedia saat ini.'));
            }

            return Padding(
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
                  
                  // 🔥 KIRIM DATA DARI MODEL KATEGORI BACKEND ke _CategoryCard
                  return _CategoryCard(
                    category: category,
                    icon: _getIconForCategory(category.namaKategori), // Ambil ikon statis
                    color: _getColorForCategory(category.namaKategori), // Ambil warna statis
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Tidak ada data.'));
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 3. WIDGET CARD (DIUBAH UNTUK MENGAMBIL MODEL KATEGORI)
// -----------------------------------------------------------------------------
class _CategoryCard extends StatelessWidget {
  // Sekarang menerima model Kategori dari backend, dan ikon/warna statis
  final Kategori category;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Logic untuk menentukan apakah thumbnail adalah URL atau Asset
    final String imagePath = category.thumbnail ?? 'assets/images/category_placeholder.png';
    final bool isUrl = imagePath.startsWith("http") || imagePath.startsWith("https");

    // Jika Anda ingin menggunakan thumbnail sebagai latar belakang kartu/ikon,
    // Anda bisa mengganti ikon dengan gambar di sini, tapi untuk saat ini
    // kita gunakan ikon dan warna yang sudah ditentukan.
    
    return InkWell(
      // Navigasi ke CategoryActivitiesPage, mengirim nama kategori
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Asumsi CategoryActivitiesPage menerima categoryName (String)
            builder: (context) => CategoryActivitiesPage(categoryName: category.namaKategori), 
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
                // Menggunakan warna yang didapat dari fungsi helper
                color: color.withOpacity(0.15), 
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color), // Menggunakan ikon yang didapat dari fungsi helper
            ),
            const SizedBox(height: 12),
            // Nama Kategori dari Database
            Text(
              category.namaKategori, // 🔥 Menggunakan namaKategori dari model
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: kDarkBlueGray,
              ),
            ),
            const SizedBox(height: 4),
            // Teks Tambahan
            Text(
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
}