import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';

// Import model dan service Anda
import 'package:volunite/models/kegiatan_model.dart'; 
import 'package:volunite/services/kegiatan_service.dart'; 

// -----------------------------------------------------------------------------
// 1. HALAMAN UTAMA (STATEFUL WIDGET)
// -----------------------------------------------------------------------------
class CategoryActivitiesPage extends StatefulWidget {
  final String categoryName;

  const CategoryActivitiesPage({super.key, required this.categoryName});

  @override
  State<CategoryActivitiesPage> createState() => _CategoryActivitiesPageState();
}

class _CategoryActivitiesPageState extends State<CategoryActivitiesPage> {
  // Future untuk menyimpan hasil pemanggilan API
  late Future<List<Kegiatan>> _kegiatanFuture;

  @override
  void initState() {
    super.initState();
    // Memuat semua data kegiatan saat widget dibuat
    _kegiatanFuture = KegiatanService.fetchKegiatan();
  }

  // --- Utility Functions untuk format tanggal/waktu (Disalin dari home.dart) ---

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal N/A';
    const dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const monthNames = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    // Penyesuaian indexing untuk dayNames: DateTime.weekday mengembalikan 1 (Senin) hingga 7 (Minggu)
    final int weekdayIndex = date.weekday % 7; 
    final dayName = dayNames[weekdayIndex];
    
    final day = date.day;
    final month = monthNames[date.month];
    final year = date.year;

    return '$dayName, $day $month $year';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return 'Waktu N/A';

    final startTime = '${start.hour.toString().padLeft(2, '0')}.${start.minute.toString().padLeft(2, '0')} WIB';
    
    if (end != null) {
      final endTime = '${end.hour.toString().padLeft(2, '0')}.${end.minute.toString().padLeft(2, '0')} WIB';
      return '$startTime - $endTime';
    }
    
    return startTime;
  }
  
  // -----------------------------------------------------------------------------
  // WIDGET UTAMA
  // -----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      // MENGGUNAKAN FUTUREBUILDER UNTUK MEMUAT DATA DARI BACKEND
      body: FutureBuilder<List<Kegiatan>>(
        future: _kegiatanFuture,
        builder: (context, snapshot) {
          // State Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // State Error
          if (snapshot.hasError) {
            return Center(
                child: Text('Gagal memuat data: ${snapshot.error}'));
          }

          // State Data Tersedia
          if (snapshot.hasData) {
            final allKegiatan = snapshot.data!;
            
            // LOGIKA FILTER BERDASARKAN categoryName (case-insensitive)
            // Asumsi properti model Kegiatan untuk kategori adalah 'kategori' (String)
            final List<Kegiatan> filteredKegiatan = allKegiatan
        .where((k) => k.kategori.any((kategoriItem) => 
            kategoriItem.namaKategori.toLowerCase() == widget.categoryName.toLowerCase())
        )
        .toList();

            // State Data Kosong Setelah Filter
            if (filteredKegiatan.isEmpty) {
              return Center(
                  child: Text(
                      'Tidak ada kegiatan yang ditemukan untuk kategori ${widget.categoryName}.'));
            }

            // Tampilkan data yang sudah difilter
            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: filteredKegiatan.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final kegiatan = filteredKegiatan[index];
                
                // Format tanggal dan waktu
                final formattedDate = _formatDate(kegiatan.tanggalMulai);
                final formattedTime = _formatTimeRange(kegiatan.tanggalMulai, kegiatan.tanggalBerakhir);

                return GestureDetector(
                  onTap: () {
                    // Navigasi ke DetailActivitiesPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailActivitiesPage(
                          kegiatan: kegiatan, // Kirim objek Kegiatan nyata
                          title: kegiatan.judul,
                          date: formattedDate,
                          time: formattedTime,
                          imagePath: kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg',
                        ),
                      ),
                    );
                  },
                  // Menggunakan Widget Card yang baru (KegiatanCard)
                  child: KegiatanCard(
                    kegiatan: kegiatan,
                    date: formattedDate,
                    timeRange: formattedTime,
                  ),
                );
              },
            );
          }

          // Fallback
          return const Center(child: Text('Tidak ada data kegiatan.'));
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// 2. WIDGET CARD BARU (KEGIATANCARD)
// Widget ini menampilkan data menggunakan model Kegiatan dari backend.
// -----------------------------------------------------------------------------
class KegiatanCard extends StatelessWidget {
  final Kegiatan kegiatan;
  final String date;
  final String timeRange;
  
  const KegiatanCard({
    super.key, 
    required this.kegiatan,
    required this.date,
    required this.timeRange,
  });

  // Logika untuk menentukan apakah kegiatan sudah selesai
  bool get isFinished => kegiatan.status.toLowerCase() == 'completed' || kegiatan.status.toLowerCase() == 'finished';

  @override
  Widget build(BuildContext context) {
    final image = kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg';
    // Cek apakah thumbnail berupa URL atau Asset
    final bool isUrl = image.startsWith("http"); 

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
            // Menampilkan gambar dari URL (Network) atau Asset
            child: isUrl 
              ? Image.network(
                  image,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.image_not_supported)),
                  ),
                )
              : Image.asset(
                  image,
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
                        kegiatan.judul,
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
                  text: date,
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
// 3. KOMPONEN PEMBANTU (Tidak diubah dari file sebelumnya)
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