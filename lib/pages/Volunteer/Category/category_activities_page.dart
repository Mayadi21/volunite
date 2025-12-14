import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';

// Model & Service
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kegiatan_service.dart';


// ============================================================================
// 1. HALAMAN UTAMA
// ============================================================================
class CategoryActivitiesPage extends StatefulWidget {
  final String categoryName;

  const CategoryActivitiesPage({
    super.key,
    required this.categoryName,
  });

  @override
  State<CategoryActivitiesPage> createState() => _CategoryActivitiesPageState();
}

class _CategoryActivitiesPageState extends State<CategoryActivitiesPage> {
  late Future<List<Kegiatan>> _kegiatanFuture;

  // 🔍 SEARCH STATE
  List<Kegiatan> _allKegiatan = [];
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kegiatanFuture = _fetchAndStoreKegiatan();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // FETCH & SEARCH LOGIC
  // --------------------------------------------------------------------------

  Future<List<Kegiatan>> _fetchAndStoreKegiatan() async {
    final kegiatan = await KegiatanService.fetchKegiatan();
    if (mounted) {
      setState(() {
        _allKegiatan = kegiatan;
      });
    }
    return kegiatan;
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
    });
  }

  List<Kegiatan> _getFilteredKegiatan() {
    // 1️⃣ Filter kategori
    final byCategory = _allKegiatan.where((k) {
      return k.kategori.any(
        (cat) =>
            cat.namaKategori.toLowerCase() ==
            widget.categoryName.toLowerCase(),
      );
    }).toList();

    // 2️⃣ Jika search kosong
    if (_searchText.isEmpty) return byCategory;

    // 3️⃣ Filter search
    return byCategory.where((k) {
      final titleMatch = k.judul.toLowerCase().contains(_searchText);
      final descMatch =
          (k.deskripsi ?? '').toLowerCase().contains(_searchText);
      final categoryMatch = k.kategori.any(
        (cat) => cat.namaKategori.toLowerCase().contains(_searchText),
      );

      return titleMatch || descMatch || categoryMatch;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // FORMAT TANGGAL & WAKTU
  // --------------------------------------------------------------------------

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal N/A';

    const days = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu'
    ];
    const months = [
      '',
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
      'Desember'
    ];

    return '${days[date.weekday % 7]}, ${date.day} ${months[date.month]} ${date.year}';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return 'Waktu N/A';

    final startTime =
        '${start.hour.toString().padLeft(2, '0')}.${start.minute.toString().padLeft(2, '0')} WIB';

    if (end != null) {
      final endTime =
          '${end.hour.toString().padLeft(2, '0')}.${end.minute.toString().padLeft(2, '0')} WIB';
      return '$startTime - $endTime';
    }

    return startTime;
  }

  // --------------------------------------------------------------------------
  // UI
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
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
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: kSoftBlue.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 📋 LIST
          Expanded(
            child: FutureBuilder<List<Kegiatan>>(
              future: _kegiatanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final filtered = _getFilteredKegiatan();

                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      _searchText.isEmpty
                          ? 'Tidak ada kegiatan di kategori ini.'
                          : 'Tidak ada hasil untuk "$_searchText"',
                      style: const TextStyle(color: kBlueGray),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final kegiatan = filtered[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailActivitiesPage(
                              kegiatan: kegiatan,
                              title: kegiatan.judul,
                              date: _formatDate(kegiatan.tanggalMulai),
                              time: _formatTimeRange(
                                kegiatan.tanggalMulai,
                                kegiatan.tanggalBerakhir,
                              ),
                              imagePath: kegiatan.thumbnail ??
                                  'assets/images/event_placeholder.jpg',
                            ),
                          ),
                        );
                      },
                      child: KegiatanCard(
                        kegiatan: kegiatan,
                        date: _formatDate(kegiatan.tanggalMulai),
                        timeRange: _formatTimeRange(
                          kegiatan.tanggalMulai,
                          kegiatan.tanggalBerakhir,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// 2. KARTU KEGIATAN (WAJIB DI LUAR STATE)
// ============================================================================
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

  bool get isFinished =>
      kegiatan.status.toLowerCase() == 'completed' ||
      kegiatan.status.toLowerCase() == 'finished';

  @override
  Widget build(BuildContext context) {
    final image = kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg';
    final isUrl = image.startsWith('http');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(18)),
            child: isUrl
                ? Image.network(
                    image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                    if (isFinished) const _FinishedChip(),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today, text: date),
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


// ============================================================================
// 3. KOMPONEN PENDUKUNG
// ============================================================================
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
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: kBlueGray),
        ),
      ],
    );
  }
}

class _FinishedChip extends StatelessWidget {
  const _FinishedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle,
              size: 12, color: kDarkBlueGray),
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
