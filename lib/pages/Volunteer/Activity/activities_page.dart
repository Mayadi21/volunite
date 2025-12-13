import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kegiatan_service.dart';
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/models/user_model.dart';
import 'package:volunite/pages/Volunteer/Activity/activity_card.dart';

enum RegisterFilter { all, registered, notRegistered }

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
  String _searchText = ''; // Sudah lowercased di _onSearchChanged
  RegisterFilter _registerFilter = RegisterFilter.all;

  // 🏷️ REGISTERED IDS
  final Set<int> _registeredIds = {};

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

    for (final k in kegiatan) {
      // ASUMSI: Logika ini sudah benar untuk menandai pendaftaran
      final isRegistered =
          await PendaftaranService().isUserRegistered(k.id); 
      if (isRegistered) {
        _registeredIds.add(k.id);
      }
    }

    upcomingActivities = kegiatan
        .where((k) =>
            k.status.toLowerCase() == 'scheduled' ||
            k.status.toLowerCase() == 'upcoming')
        .toList();

    // Untuk tab Riwayat, kita asumsikan semua kegiatan 'finished' adalah riwayat.
    // Catatan: Jika riwayat harus difilter berdasarkan Pendaftaran, 
    // logika ini perlu disesuaikan dengan `_registeredIds`.
    historyActivities = kegiatan
        .where((k) =>
            k.status.toLowerCase() == 'finished' ||
            k.status.toLowerCase() == 'completed')
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
    // 🔥 Reset search dan filter saat beralih ke tab Riwayat atau sebaliknya
    if (_currentIndex == 0 && _tabController.index == 1) {
      // Dari Mendatang ke Riwayat: Reset search/filter jika diperlukan
      _searchController.clear();
      _registerFilter = RegisterFilter.all;
    }
    
    setState(() => _currentIndex = _tabController.index);
  }

  // =============================================================================
  // FILTER LOGIC
  // =============================================================================
  List<Kegiatan> _applyFilters(List<Kegiatan> list, {required bool isHistoryTab}) {
    // Riwayat tidak memiliki filter tambahan (hanya menampilkan historyActivities)
    if (isHistoryTab) {
      // Jika Riwayat harus difilter berdasarkan pendaftaran user:
      // return list.where((k) => _registeredIds.contains(k.id)).toList();
      // Saat ini, tidak ada filter search/pendaftaran di Riwayat
      return list; 
    }

    // Filter untuk tab Mendatang (Mendatang memiliki Search dan Register Filter)
    return list.where((k) {
      // 1. Filter Search (Judul/Deskripsi)
      final matchSearch = k.judul.toLowerCase().contains(_searchText) ||
          (k.deskripsi ?? '').toLowerCase().contains(_searchText);
      
      if (!matchSearch) return false;

      // 2. Filter Pendaftaran
      final isRegistered = _registeredIds.contains(k.id);

      final matchRegister = switch (_registerFilter) {
        RegisterFilter.all => true,
        RegisterFilter.registered => isRegistered,
        RegisterFilter.notRegistered => !isRegistered,
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Kegiatan',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        bottom: PreferredSize(
          // Tinggi AppBar disesuaikan: TabBar (40) + Search/Filter (45) + Padding
          preferredSize: Size.fromHeight(_currentIndex == 0 ? 100 : 56), 
          child: Column(
            children: [
              _buildTabBar(),
              // 🔥 Tampilkan Search & Filter hanya di tab Mendatang (index 0)
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
                ),
                // Tab Riwayat
                ActivityList(
                  activities: _applyFilters(historyActivities, isHistoryTab: true),
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
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: Colors.transparent,
          indicator: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          labelColor: kDarkBlueGray,
          unselectedLabelColor: Colors.white.withOpacity(0.85),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
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

  // 🔥 WIDGET SEARCH & FILTER MINIMALIS BARU
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
                  borderRadius: BorderRadius.circular(10), // Lebih minimalis
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
          
          // 🔥 Dropdown Filter Minimalis
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
                    value: RegisterFilter.registered,
                    child: Text('Terdaftar', style: TextStyle(color: kDarkBlueGray)),
                  ),
                  DropdownMenuItem(
                    value: RegisterFilter.notRegistered,
                    child: Text('Belum Terdaftar', style: TextStyle(color: kDarkBlueGray)),
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

  const ActivityList({super.key, required this.activities});

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
        return ActivityCard(kegiatan: activities[index]);
      },
    );
  }
}
