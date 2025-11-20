import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
// Pastikan import ini sesuai dengan lokasi file card Anda
import 'package:volunite/pages/Organizer/Activity/activity_card.dart';

class OrganizerActivitiesPage extends StatefulWidget {
  const OrganizerActivitiesPage({super.key});

  @override
  State<OrganizerActivitiesPage> createState() =>
      _OrganizerActivitiesPageState();
}

class _OrganizerActivitiesPageState extends State<OrganizerActivitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Data Dummy
  final List<OrganizerActivityItem> _items = [
    OrganizerActivityItem(
      title: 'Pintar Bersama - KMB USU',
      banner: 'assets/images/event1.jpg',
      start: DateTime(2025, 11, 15, 12, 0),
      end: DateTime(2025, 11, 15, 17, 0),
      location: 'USU - Ruang B.204',
      registered: 46,
      quota: 60,
    ),
    OrganizerActivityItem(
      title: 'Aksi Bersih Pantai',
      banner: 'assets/images/event2.jpg',
      start: DateTime(2025, 11, 16, 9, 0),
      end: DateTime(2025, 11, 16, 12, 0),
      location: 'Pantai Cermin',
      registered: 82,
      quota: 120,
    ),
    OrganizerActivityItem(
      title: 'Donor Darah',
      banner: 'assets/images/event2.jpg',
      start: DateTime(2025, 10, 5, 9, 0),
      end: DateTime(2025, 10, 5, 13, 0),
      location: 'Aula Fakultas',
      registered: 120,
      quota: 120,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    // Logika filter data
    final upcoming = _items.where((e) => e.end.isAfter(now)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final history = _items.where((e) => e.end.isBefore(now)).toList()
      ..sort((a, b) => b.start.compareTo(a.start));

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor:
            Colors.transparent, // Transparan agar gradient terlihat
        // === BAGIAN GRADIENT (Sama persis Volunteer) ===
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue], // Warna gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        title: const Text(
          'Kegiatan Penyelenggara',
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),

        // actions: [], // DIHAPUS: Tidak ada icon notifikasi
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                splashFactory: NoSplash.splashFactory,
                tabs: [
                  _CustomTabButton(
                    label: 'Mendatang',
                    icon: Icons.calendar_month,
                    isActive: _currentIndex == 0,
                  ),
                  _CustomTabButton(
                    label: 'Riwayat',
                    icon: Icons.history,
                    isActive: _currentIndex == 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ActivityTabContent(
            items: upcoming,
            isHistory: false,
            onManage: (item) => _openManage(context, item.title),
            onApplicants: () {},
            emptyTitle: "Belum ada kegiatan mendatang",
            emptySubtitle: "Buat kegiatan baru agar relawan bisa mendaftar.",
          ),
          _ActivityTabContent(
            items: history,
            isHistory: true,
            onManage: (item) => _openManage(context, item.title),
            onApplicants: () {},
            emptyTitle: "Riwayat kosong",
            emptySubtitle:
                "Kegiatan yang sudah selesai akan ditampilkan di sini.",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke halaman buat kegiatan
        },
        icon: const Icon(Icons.add),
        label: const Text("Buat Kegiatan"),
        backgroundColor: kSkyBlue,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _openManage(BuildContext context, String title) {
    // Navigasi ke halaman kelola
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Kelola $title")));
  }
}

// --- WIDGET PENDUKUNG HALAMAN INI ---

class _ActivityTabContent extends StatelessWidget {
  final List<OrganizerActivityItem> items;
  final bool isHistory;
  final Function(OrganizerActivityItem) onManage;
  final VoidCallback onApplicants;
  final String emptyTitle;
  final String emptySubtitle;

  const _ActivityTabContent({
    required this.items,
    required this.isHistory,
    required this.onManage,
    required this.onApplicants,
    required this.emptyTitle,
    required this.emptySubtitle,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.event_busy, size: 56, color: kBlueGray),
              const SizedBox(height: 12),
              Text(
                emptyTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kDarkBlueGray,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                emptySubtitle,
                style: const TextStyle(color: kBlueGray),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const _SearchField();

        final item = items[index - 1];
        // Memanggil Card yang sudah dipisah
        return OrganizerActivityCard(
          item: item,
          isHistory: isHistory,
          onManage: () => onManage(item),
          onApplicants: onApplicants,
        );
      },
      separatorBuilder: (context, index) {
        if (index == 0) return const SizedBox(height: 16);
        return const SizedBox(height: 14);
      },
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari kegiatan di sini...',
        hintStyle: const TextStyle(color: kBlueGray),
        prefixIcon: const Icon(Icons.search, color: kBlueGray),
        filled: true,
        fillColor: kSoftBlue.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: kSkyBlue, width: 1.2),
        ),
      ),
    );
  }
}

class _CustomTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  const _CustomTabButton({
    required this.label,
    required this.icon,
    required this.isActive,
  });
  @override
  Widget build(BuildContext context) {
    const Color activeColor = kDarkBlueGray;
    final Color inactiveColor = Colors.white.withOpacity(0.85);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Tab(
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? activeColor : inactiveColor,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isActive ? activeColor : inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
