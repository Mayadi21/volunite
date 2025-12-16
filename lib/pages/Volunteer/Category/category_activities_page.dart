import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';

// Model & Service
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kegiatan_service.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/services/auth/auth_service.dart'; 

// 🔥 DEFINISIKAN ENUM FILTER
enum RegisterFilter { all, notRegistered, accepted, pending, rejected }

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

  // 🔍 SEARCH & FILTER STATE
  List<Kegiatan> _allKegiatan = [];
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();
  // 🔥 STATE FILTER BARU
  RegisterFilter _registerFilter = RegisterFilter.all;

  // 🔥 STATE BARU: Map untuk menyimpan status pendaftaran {kegiatanId: Status String}
  final Map<int, String> _registrationStatuses = {}; 
  final PendaftaranService _pendaftaranService = PendaftaranService();

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
    final user = await AuthService().getCurrentUser(); 

    _registrationStatuses.clear();
    if (user != null) {
      for (final k in kegiatan) {
          final status = await _pendaftaranService.getRegistrationStatus(k.id);
          if (status != 'Memuat' && !status.contains('Kesalahan')) {
              _registrationStatuses[k.id] = status;
          }
      }
    }


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

  // 🔥 REVISI: MENAMBAHKAN LOGIKA FILTER STATUS
  List<Kegiatan> _getFilteredKegiatan() {
    // 1️⃣ Filter kategori
    final byCategory = _allKegiatan.where((k) {
      // Pastikan kegiatan sedang berlangsung/mendatang (Tidak menampilkan Riwayat)
      final isUpcoming = k.status.toLowerCase() == 'scheduled' ||
                         k.status.toLowerCase() == 'upcoming';

      final matchCategory = k.kategori.any(
        (cat) =>
            cat.namaKategori.toLowerCase() ==
            widget.categoryName.toLowerCase(),
      );
      
      return isUpcoming && matchCategory;
    }).toList();


    return byCategory.where((k) {
      // 2️⃣ Filter Search
      final titleMatch = k.judul.toLowerCase().contains(_searchText);
      final descMatch =
          (k.deskripsi ?? '').toLowerCase().contains(_searchText);
      final categoryMatch = k.kategori.any(
        (cat) => cat.namaKategori.toLowerCase().contains(_searchText),
      );
      
      final matchSearch = titleMatch || descMatch || categoryMatch;
      if (!matchSearch) return false;
      
      // 3️⃣ Filter Status Pendaftaran
      final status = _registrationStatuses[k.id] ?? 'Belum Mendaftar';
      
      final matchRegister = switch (_registerFilter) {
        RegisterFilter.all => true,
        
        // Filter: Belum Daftar (Belum Mendaftar ATAU Kuota Penuh)
        RegisterFilter.notRegistered => status == 'Belum Mendaftar' || status == 'Kuota Penuh',
        
        // Filter status spesifik
        RegisterFilter.accepted => status == 'Diterima',
        RegisterFilter.pending => status == 'Mengajukan',
        RegisterFilter.rejected => status == 'Ditolak',
      };

      return matchRegister;
    }).toList();
  }

  // --------------------------------------------------------------------------
  // FORMAT TANGGAL & WAKTU (tetap sama)
  // --------------------------------------------------------------------------

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal N/A';

    const days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
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
    final searchAndFilterRow = _buildSearchAndFilterRow();

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
        // 🔥 Tambahkan search dan filter di bottom AppBar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70), 
          child: searchAndFilterRow,
        ),
      ),
      body: Column(
        children: [
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
                      _searchText.isEmpty && _registerFilter == RegisterFilter.all
                          ? 'Tidak ada kegiatan di kategori ini.'
                          : 'Tidak ada hasil yang cocok dengan filter.',
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
                    final status = _registrationStatuses[kegiatan.id]; 

                    return GestureDetector(
                      onTap: () async {
                        final bool? needsRefresh = await Navigator.push<bool>(
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
                        
                        if (needsRefresh == true && mounted) {
                           setState(() {
                             _kegiatanFuture = _fetchAndStoreKegiatan();
                           });
                        }
                      },
                      child: KegiatanCard(
                        kegiatan: kegiatan,
                        date: _formatDate(kegiatan.tanggalMulai),
                        timeRange: _formatTimeRange(
                          kegiatan.tanggalMulai,
                          kegiatan.tanggalBerakhir,
                        ),
                        registrationStatus: status, 
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
  
  // 🔥 WIDGET BARU: ROW SEARCH & FILTER
  Widget _buildSearchAndFilterRow() {
    return Container(
      color: Colors.transparent, // Agar terlihat menyatu dengan AppBar gradient
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: kDarkBlueGray, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Cari kegiatan...',
                hintStyle: const TextStyle(color: kBlueGray, fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 20, color: kBlueGray),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), 
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: kSkyBlue, width: 1.2),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Dropdown Filter Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.transparent),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<RegisterFilter>(
                value: _registerFilter,
                icon: const Icon(Icons.filter_list, color: kBlueGray),
                style: const TextStyle(color: kDarkBlueGray, fontSize: 13),
                dropdownColor: Colors.white,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _registerFilter = val);
                  }
                },
                items: const [
                  DropdownMenuItem(
                    value: RegisterFilter.all,
                    child: Text('Semua', style: TextStyle(color: kDarkBlueGray)),
                  ),
                  DropdownMenuItem(
                    value: RegisterFilter.notRegistered,
                    child: Text('Belum Daftar', style: TextStyle(color: kDarkBlueGray)),
                  ),
                  DropdownMenuItem(
                    value: RegisterFilter.accepted,
                    child: Text('Diterima', style: TextStyle(color: kDarkBlueGray)),
                  ),
                  DropdownMenuItem(
                    value: RegisterFilter.pending,
                    child: Text('Mengajukan', style: TextStyle(color: kDarkBlueGray)),
                  ),
                  DropdownMenuItem(
                    value: RegisterFilter.rejected,
                    child: Text('Ditolak', style: TextStyle(color: kDarkBlueGray)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// 2. KARTU KEGIATAN (REVISI STATELESS -> STATEFUL UNTUK MENERIMA STATUS)
//    (Hanya disertakan agar file ini lengkap, asumsikan _RegistrationStatusChip ada)
// ============================================================================
class KegiatanCard extends StatefulWidget {
  final Kegiatan kegiatan;
  final String date;
  final String timeRange;
  final String? registrationStatus; 

  const KegiatanCard({
    super.key,
    required this.kegiatan,
    required this.date,
    required this.timeRange,
    this.registrationStatus, 
  });

  @override
  State<KegiatanCard> createState() => _KegiatanCardState();
}

class _KegiatanCardState extends State<KegiatanCard> {

  // Asumsi: Kita harus mendefinisikan _RegistrationStatusChip, _FinishedChip, _InfoRow
  // di file ini atau memastikan mereka diimpor. Karena mereka tidak didefinisikan 
  // di file ini, saya sertakan dummy class untuk kompilasi, namun Anda harus 
  // memasukkan definisi yang sebenarnya (yang sama dengan activity_card.dart) 
  // di bagian akhir file category_activities_page.dart Anda.

  bool get isFinished =>
      widget.kegiatan.status.toLowerCase() == 'completed' ||
      widget.kegiatan.status.toLowerCase() == 'finished';

  bool get showRegistrationChip {
    final status = widget.registrationStatus;
    return status == 'Diterima' || status == 'Mengajukan' || status == 'Ditolak' || status == 'Kuota Penuh';
  }

  @override
  Widget build(BuildContext context) {
    final image = widget.kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg';
    final isUrl = image.startsWith('http');

    // Asumsi: Pengecekan kuota di card ini tidak menggunakan state real-time 
    // seperti di activity_card, melainkan hanya status yang dikirimkan.
    Widget statusWidget = showRegistrationChip 
      ? _RegistrationStatusChip(status: widget.registrationStatus!) 
      : const SizedBox.shrink();


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
                      errorBuilder: (context, error, stackTrace) {
                            return Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 40, color: kBlueGray),
                            );
                        },
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
                        widget.kegiatan.judul,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kDarkBlueGray,
                        ),
                      ),
                    ),
                    
                    statusWidget,
                       
                    if (isFinished) const _FinishedChip(),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(icon: Icons.calendar_today, text: widget.date),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: widget.timeRange),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================================
// 3. KOMPONEN PENDUKUNG (Ditambahkan di sini agar file kompilasi)
// PASTIKAN ANDA MENGGANTI INI DENGAN DEFINISI ASLI DARI FILE ANDA
// ============================================================================

class _RegistrationStatusChip extends StatelessWidget {
  final String status;
  const _RegistrationStatusChip({required this.status});
  @override Widget build(BuildContext context) { 
        Color color; Color bgColor; IconData icon; String label;
        switch (status) {
            case 'Diterima': color = Colors.green[700]!; bgColor = Colors.green[50]!; icon = Icons.check_circle; label = 'Diterima'; break;
            case 'Mengajukan': color = Colors.orange[700]!; bgColor = Colors.orange[50]!; icon = Icons.pending_actions; label = 'Mengajukan'; break;
            case 'Ditolak': color = Colors.red[700]!; bgColor = Colors.red[50]!; icon = Icons.cancel; label = 'Ditolak'; break;
            case 'Kuota Penuh': color = kDarkBlueGray; bgColor = Colors.grey[300]!; icon = Icons.block; label = 'Penuh'; break;
            default: return const SizedBox.shrink();
        }
        return Container(
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
            child: Row(mainAxisSize: MainAxisSize.min, children: [Icon(icon, size: 12, color: color), const SizedBox(width: 4), Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color))]),
        );
    }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
  @override Widget build(BuildContext context) {
    return Row(children: [Icon(icon, size: 14, color: kBlueGray), const SizedBox(width: 6), Text(text, style: const TextStyle(fontSize: 12, color: kBlueGray))]);
    }
}

class _FinishedChip extends StatelessWidget {
  const _FinishedChip();
  @override Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 6),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFE3F1FF), borderRadius: BorderRadius.circular(12)),
        child: const Row(
            mainAxisSize: MainAxisSize.min, 
            children: [
                Icon(Icons.check_circle, size: 12, color: kDarkBlueGray),
                SizedBox(width: 4),
                Text('Selesai', style: TextStyle(color: kDarkBlueGray, fontSize: 11, fontWeight: FontWeight.w600)),
            ]
        ),
    );
  }
}
