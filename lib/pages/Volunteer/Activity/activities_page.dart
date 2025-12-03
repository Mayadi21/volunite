// lib/pages/kegiatan/activities_page.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kegiatan_service.dart';
import 'package:volunite/pages/Volunteer/Activity/activity_card.dart'; // Impor ActivityCard dan Activity

// =============================================================================
// MAIN PAGE - ActivitiesPage
// =============================================================================
class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({super.key});

  @override
  State<ActivitiesPage> createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  // Data Dummy Kegiatan
  List<Kegiatan> kegiatanList = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    fetchData();
  }

  void fetchData() async{
    try {
      kegiatanList = await KegiatanService.fetchKegiatan();
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      loading = false;
    });
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
        // Memisahkan data berdasarkan status
    final upcomingActivities = kegiatanList
        .where((a) => a.status == "upcoming")
        .toList();

    final historyActivities = kegiatanList
        .where((a) => a.status == "finished")
        .toList();


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
                indicatorColor:
                    Colors.transparent, // Hilangkan indicator default
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
                  CustomTabButton(
                    label: 'Mendatang',
                    icon: Icons.calendar_month,
                    isActive: _currentIndex == 0,
                  ),
                  CustomTabButton(
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
      body: loading
    ? const Center(child: CircularProgressIndicator())
    : TabBarView(
        controller: _tabController,
        children: [
          ActivityList(activities: upcomingActivities),
          ActivityList(activities: historyActivities),
        ],
      ),
    );
  }
}

// =============================================================================
// WIDGET KUSTOM UNTUK BUTTON TAB
// =============================================================================
class CustomTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;

  const CustomTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = kDarkBlueGray;
    final Color inactiveColor = Colors.white.withOpacity(0.85);

    // Padding agar indicator Box (latar putih/biru) tidak menempel sempurna
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Tab(
        child: Container(
          decoration: BoxDecoration(
            // Warna latar hanya muncul saat tab aktif
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            // Tidak perlu boxShadow lagi karena container TabBar sudah memiliki latar
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

// -----------------------------------------------------------------------------
// TAB CONTENT - ACTIVITY LIST
// -----------------------------------------------------------------------------
// class _ActivityList extends StatelessWidget {
//   final List<Activity> activities;

//   const _ActivityList({required this.activities});

//   @override
//   Widget build(BuildContext context) {
//     if (activities.isEmpty) {
//       return const Center(
//         child: Text(
//           'Tidak ada kegiatan saat ini.',
//           style: TextStyle(color: kBlueGray),
//         ),
//       );
//     }

//     return ListView.separated(
//       padding: const EdgeInsets.all(16),
//       itemCount: activities.length + 1, // +1 untuk SearchField
//       itemBuilder: (context, index) {
//         if (index == 0) {
//           return const _SearchField();
//         }
//         final activity = activities[index - 1];
//         return ActivityCard(activity: activity);
//       },
//       separatorBuilder: (context, index) {
//         if (index == 0) {
//           return const SizedBox(height: 16);
//         }
//         return const SizedBox(height: 14);
//       },
//     );
//   }
// }

class ActivityList extends StatelessWidget {
  final List<Kegiatan> activities;

  const ActivityList({required this.activities});

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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return const _SearchField();

        final item = activities[index - 1];

        return ActivityCard(
          activity: Activity(
            title: item.judul,
            date: item.tanggalMulai ?? DateTime.now(),
            bannerUrl: item.thumbnail ?? "assets/images/event1.jpg",
            start: const TimeOfDay(hour: 0, minute: 0),
            end: const TimeOfDay(hour: 0, minute: 0),
            status: item.status == "upcoming"
                ? ActivityStatus.upcoming
                : ActivityStatus.finished,
          ),
        );
      },
    );
  }
}


// -----------------------------------------------------------------------------
// SEARCH FIELD COMPONENT
// -----------------------------------------------------------------------------
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
