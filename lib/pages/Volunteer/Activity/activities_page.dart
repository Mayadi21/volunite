import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kegiatan_service.dart';
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/models/user_model.dart';
import 'package:volunite/pages/Volunteer/Activity/activity_card.dart';

// 🔥 REVISI ENUM: Menambahkan 'notRegistered' kembali, menghapus 'registered'
enum RegisterFilter { all, notRegistered, accepted, pending, rejected }

// =============================================================================
// MAIN PAGE
// =============================================================================
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0; // 0 = Mendatang, 1 = Riwayat

  User? currentUser;
  bool loading = true;

  List<Kegiatan> upcomingActivities = [];
  List<Kegiatan> historyActivities = [];

  // 🔍 SEARCH & FILTER
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  RegisterFilter _registerFilter = RegisterFilter.all;

  // Map untuk menyimpan status pendaftaran {kegiatanId: Status String}
  final Map<int, String> _registrationStatuses = {};
  final PendaftaranService _pendaftaranService = PendaftaranService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _searchController.addListener(_onSearchChanged);
    _loadAll();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  // =============================================================================
  // DATA LOADING & HANDLERS
  // =============================================================================
  Future<void> _loadAll() async {
    final auth = AuthService();
    currentUser = await auth.getCurrentUser();
    
    final kegiatan = await KegiatanService.fetchKegiatan();
    _registrationStatuses.clear();

    if (currentUser != null) {
      for (final k in kegiatan) {
        final status = await _pendaftaranService.getRegistrationStatus(k.id); 
        
        if (status != 'Memuat' && !status.contains('Kesalahan')) {
          _registrationStatuses[k.id] = status;
        }
      }
    }

    upcomingActivities = kegiatan
        .where((k) =>
            k.status.toLowerCase() == 'scheduled' ||
            k.status.toLowerCase() == 'upcoming')
        .toList();

    historyActivities = kegiatan
        .where((k) =>
            k.status.toLowerCase() == 'finished' ||
            k.status.toLowerCase() == 'cancelled')
        .toList();

    if (mounted) {
      setState(() => loading = false);
    }
  }

  void _onSearchChanged() {
    setState(() {
      _searchText = _searchController.text.toLowerCase();
    });
  }

  void _handleTabSelection() {
    // Reset search dan filter saat beralih ke tab Riwayat atau sebaliknya
    if (_currentIndex == 0 && _tabController.index == 1) {
      _searchController.clear();
      _registerFilter = RegisterFilter.all;
    }
    
    setState(() => _currentIndex = _tabController.index);
  }

  // =============================================================================
  // 🔥 FILTER LOGIC (REVISI untuk notRegistered)
  // =============================================================================
  List<Kegiatan> _applyFilters(List<Kegiatan> list, {required bool isHistoryTab}) {
    if (isHistoryTab) {
      return list; 
    }

    return list.where((k) {
      // 1. Filter Search (Judul/Deskripsi)
      final matchSearch = k.judul.toLowerCase().contains(_searchText) ||
          (k.deskripsi ?? '').toLowerCase().contains(_searchText);
      
      if (!matchSearch) return false;

      // Ambil status pendaftaran (fallback ke 'Belum Mendaftar' jika tidak ada di Map)
      final status = _registrationStatuses[k.id] ?? 'Belum Mendaftar';

      final matchRegister = switch (_registerFilter) {
        RegisterFilter.all => true,
        
        // 🔥 Filter: Belum Daftar (Belum Mendaftar ATAU Kuota Penuh)
        RegisterFilter.notRegistered => status == 'Belum Mendaftar' || status == 'Kuota Penuh',
        
        // Filter status spesifik
        RegisterFilter.accepted => status == 'Diterima',
        RegisterFilter.pending => status == 'Mengajukan',
        RegisterFilter.rejected => status == 'Ditolak',
      };

      return matchRegister;
    }).toList();
  }

  // =============================================================================
  // UI BUILDERS
  // =============================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        shadowColor: Colors.transparent, 
        
        flexibleSpace: Container( 
          decoration: const BoxDecoration(
              gradient: LinearGradient(
              colors: [kSkyBlue, kBlueGray],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        
        title: const Text(
          'Kegiatan',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        
        // Pinned TabBar dan Search/Filter
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(_currentIndex == 0 ? 100 : 56), 
          child: Column(
            children: [
              _buildTabBar(), 
              if (_currentIndex == 0) _buildSearchAndFilterMinimal(),
            ],
          ),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                // Tab Mendatang
                ActivityList(
                  activities: _applyFilters(upcomingActivities, isHistoryTab: false),
                  registrationStatuses: _registrationStatuses, 
                ),
                // Tab Riwayat
                ActivityList(
                  activities: _applyFilters(historyActivities, isHistoryTab: true),
                  registrationStatuses: _registrationStatuses, 
                ),
              ],
            ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), 
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5), 
        ),
        child: TabBar(
          controller: _tabController,
          
          indicator: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(24),
          ),
          
          indicatorSize: TabBarIndicatorSize.tab, 
          
          labelColor: kDarkBlueGray, 
          unselectedLabelColor: Colors.white, 
          
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14, 
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          
          tabs: const [
            Tab(text: 'Mendatang'),
            Tab(text: 'Riwayat'),
          ],
        ),
      ),
    );
  }

  // 🔥 WIDGET SEARCH & FILTER MINIMALIS (REVISI DROP DOWN)
  Widget _buildSearchAndFilterMinimal() {
    return Padding(
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
          
          // Dropdown Filter Minimalis
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
                    // 🔥 Menambahkan "Belum Daftar"
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

// =============================================================================
// LIST
// =============================================================================
class ActivityList extends StatelessWidget {
  final List<Kegiatan> activities;
  final Map<int, String> registrationStatuses;

  const ActivityList({
    super.key, 
    required this.activities,
    required this.registrationStatuses,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada kegiatan.',
          style: TextStyle(color: kBlueGray),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final kegiatan = activities[index];
        final status = registrationStatuses[kegiatan.id]; 
        
        return ActivityCard(
          kegiatan: kegiatan,
          initialRegistrationStatus: status, 
        );
      },
    );
  }
}