import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Organizer/Activity/activity_card.dart';
import 'package:volunite/pages/Organizer/Activity/create_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/edit_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart'; // Import Detail Page
import 'package:volunite/services/kegiatan_service.dart';

class OrganizerActivitiesPage extends StatefulWidget {
  const OrganizerActivitiesPage({super.key});

  @override
  State<OrganizerActivitiesPage> createState() => _OrganizerActivitiesPageState();
}

class _OrganizerActivitiesPageState extends State<OrganizerActivitiesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _futureKegiatan = KegiatanService.fetchOrganizerKegiatan();
    });
  }

  // --- LOGIC HAPUS PERMANEN (HARD DELETE) ---
  Future<void> _handleDelete(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hapus Kegiatan?"),
        content: const Text("Kegiatan ini belum dipublikasikan/dihadiri. Data akan dihapus permanen."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await KegiatanService.deleteKegiatan(id);
      if (success) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kegiatan dihapus permanen.")));
        _refreshData();
      }
    }
  }

  // --- LOGIC BATALKAN (SOFT DELETE) ---
  Future<void> _handleCancel(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Batalkan Kegiatan?"),
        content: const Text("Status akan berubah menjadi 'Cancelled'. Data peserta tidak akan hilang."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Kembali")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text("Ya, Batalkan"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await KegiatanService.cancelKegiatan(id);
      if (success) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Kegiatan dibatalkan.")));
        _refreshData();
      }
    }
  }

  // --- MENU KELOLA ---
  void _showManageOptions(BuildContext context, Kegiatan item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        // Cek Status
        bool isWaiting = item.status.toLowerCase() == 'waiting';
        // bool isScheduled = item.status.toLowerCase() == 'scheduled';

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility, color: kBlueGray),
                title: const Text("Lihat Detail"),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrganizerDetailActivityPage(kegiatan: item)));
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: kSkyBlue),
                title: const Text("Edit Kegiatan"),
                onTap: () async {
                  Navigator.pop(ctx);
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditActivityPage(kegiatan: item)));
                  if (result == true) _refreshData();
                },
              ),
              const Divider(),
              
              // LOGIKA TOMBOL HAPUS vs BATAL
              if (isWaiting)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Hapus Permanen", style: TextStyle(color: Colors.red)),
                  subtitle: const Text("Hanya bisa dilakukan saat status Waiting", style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleDelete(item.id);
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.cancel, color: Colors.orange),
                  title: const Text("Batalkan Kegiatan", style: TextStyle(color: Colors.orange)),
                  subtitle: const Text("Pindahkan ke riwayat (Cancelled)", style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleCancel(item.id);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

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
        title: const Text('Manajemen Kegiatan', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(24)),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                indicator: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                labelColor: kDarkBlueGray,
                unselectedLabelColor: Colors.white.withOpacity(0.85),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                tabs: const [Tab(text: "Aktif"), Tab(text: "Selesai")],
              ),
            ),
          ),
        ),
      ),
      
      body: FutureBuilder<List<Kegiatan>>(
        future: _futureKegiatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada kegiatan."));

          final allItems = snapshot.data!;
          final now = DateTime.now();

          // FILTER LOGIC
          final activeItems = allItems.where((e) {
            final status = e.status.toLowerCase();
            // Masukkan Waiting, Scheduled, On Progress
            return status != 'finished' && status != 'cancelled' && status != 'rejected';
          }).toList()..sort((a, b) => (a.tanggalMulai ?? now).compareTo(b.tanggalMulai ?? now));

          final historyItems = allItems.where((e) {
            final status = e.status.toLowerCase();
            // Masukkan Finished, Cancelled, Rejected
            return status == 'finished' || status == 'cancelled' || status == 'rejected';
          }).toList()..sort((a, b) => (b.tanggalMulai ?? now).compareTo(a.tanggalMulai ?? now)); // Descending

          return TabBarView(
            controller: _tabController,
            children: [
              _ActivityTabContent(
                items: activeItems,
                isHistory: false,
                onManage: (item) => _showManageOptions(context, item),
                onRefresh: () async => _refreshData(),
                emptyText: "Tidak ada kegiatan aktif.",
              ),
              _ActivityTabContent(
                items: historyItems,
                isHistory: true,
                onManage: (item) => _showManageOptions(context, item), // Tetap bisa lihat detail/edit terbatas
                onRefresh: () async => _refreshData(),
                emptyText: "Belum ada riwayat kegiatan.",
              ),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateActivityPage()));
          if (result == true) _refreshData();
        },
        backgroundColor: kSkyBlue,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Buat Baru", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _ActivityTabContent extends StatelessWidget {
  final List<Kegiatan> items;
  final bool isHistory;
  final Function(Kegiatan) onManage;
  final Future<void> Function() onRefresh;
  final String emptyText;

  const _ActivityTabContent({
    required this.items,
    required this.isHistory,
    required this.onManage,
    required this.onRefresh,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return Center(child: Text(emptyText, style: const TextStyle(color: kBlueGray)));

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 14),
        itemBuilder: (ctx, i) => OrganizerActivityCard(
          item: items[i],
          isHistory: isHistory,
          onManage: () => onManage(items[i]),
          onApplicants: () {},
        ),
      ),
    );
  }
}