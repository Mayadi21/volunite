import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Organizer/Activity/activity_card.dart';
import 'package:volunite/pages/Organizer/Activity/create_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/edit_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_list_page.dart';
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

  Future<void> _handleUpdateStatus(int id, String status, String title, String content) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Kembali")),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: status == 'finished' ? Colors.green : Colors.orange
            ),
            child: Text(status == 'finished' ? "Ya, Selesai" : "Ya, Batalkan"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await KegiatanService.updateStatusKegiatan(id, status);
      
      if (success) {
        if (mounted) {
          String msg = status == 'finished' ? "Kegiatan selesai!" : "Kegiatan dibatalkan.";
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
        }
        _refreshData(); 
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal mengupdate status"), backgroundColor: Colors.red));
      }
    }
  }

  void _showManageOptions(BuildContext context, Kegiatan item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        String status = item.status.toLowerCase();
        
        // Cek Status
        bool isWaiting = status == 'waiting';
        bool isActive = ['scheduled', 'on progress'].contains(status); 
        bool isDone = ['finished', 'cancelled', 'rejected'].contains(status); 

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              
              ListTile(
                leading: const Icon(Icons.visibility_rounded, color: kBlueGray),
                title: const Text("Lihat Detail Lengkap"),
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrganizerDetailActivityPage(kegiatan: item)))
                      .then((val) { if (val == true) _refreshData(); });
                },
              ),

              if (!isDone)
                ListTile(
                  leading: const Icon(Icons.edit_rounded, color: kSkyBlue),
                  title: const Text("Edit Informasi"),
                  onTap: () async {
                    Navigator.pop(ctx);
                    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditActivityPage(kegiatan: item)));
                    if (result == true) _refreshData();
                  },
                ),
              
              const Divider(indent: 16, endIndent: 16),

              if (isActive) 
                ListTile(
                  leading: const Icon(Icons.check_circle_outline, color: Colors.green),
                  title: const Text("Selesaikan Kegiatan"),
                  subtitle: const Text("Tandai kegiatan telah berakhir"),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleUpdateStatus(
                      item.id, 
                      'finished', 
                      "Selesaikan Kegiatan?", 
                      "Apakah acara ini sudah terlaksana dengan baik? Status akan berubah menjadi 'Finished'."
                    );
                  },
                ),

              if (isWaiting)
                ListTile(
                  leading: const Icon(Icons.delete_forever_rounded, color: Colors.red),
                  title: const Text("Hapus Kegiatan"),
                  subtitle: const Text("Hanya bisa jika status Waiting"),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleDelete(item.id);
                  },
                )
              else if (!isDone) 
                ListTile(
                  leading: const Icon(Icons.cancel_presentation_rounded, color: Colors.orange),
                  title: const Text("Batalkan Kegiatan"),
                  subtitle: const Text("Pindahkan ke riwayat (Cancelled)"),
                  onTap: () {
                    Navigator.pop(ctx);
                    _handleUpdateStatus(
                      item.id, 
                      'cancelled', 
                      "Batalkan Kegiatan?", 
                      "Kegiatan akan dibatalkan dan tidak dapat dilanjutkan kembali."
                    );
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
        title: const Text('Manajemen Kegiatan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: kSkyBlue,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [Tab(text: "Aktif"), Tab(text: "Selesai")],
        ),
      ),
      body: FutureBuilder<List<Kegiatan>>(
        future: _futureKegiatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: kSkyBlue));
          if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Belum ada data", style: TextStyle(color: kBlueGray)));

          final all = snapshot.data!;
          
          final active = all.where((e) => ['Waiting', 'scheduled', 'on progress'].contains(e.status)).toList();
          final history = all.where((e) => ['Rejected', 'finished', 'cancelled'].contains(e.status)).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _ListContent(
                items: active, 
                onManage: (i) => _showManageOptions(context, i), 
                isHistory: false, 
                onRefresh: _refreshData
              ),
              _ListContent(
                items: history, 
                onManage: (i) => _showManageOptions(context, i), 
                isHistory: true, 
                onRefresh: _refreshData
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateActivityPage()));
          if (res == true) _refreshData();
        },
        backgroundColor: kSkyBlue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _ListContent extends StatelessWidget {
  final List<Kegiatan> items;
  final Function(Kegiatan) onManage;
  final bool isHistory;
  final VoidCallback onRefresh;

  const _ListContent({
    required this.items, 
    required this.onManage, 
    required this.isHistory,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(isHistory ? Icons.history : Icons.event_note, size: 60, color: kLightGray), 
            const SizedBox(height: 10), 
            Text(isHistory ? "Belum ada riwayat" : "Tidak ada kegiatan aktif", style: const TextStyle(color: kBlueGray))
          ]
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final item = items[i];
          return OrganizerActivityCard(
            item: item,
            isHistory: isHistory,
            onManage: () => onManage(item),
            onApplicants: () {
               Navigator.push(context, MaterialPageRoute(
                 builder: (_) => ApplicantListPage(
                   kegiatanId: item.id, 
                   statusKegiatan: item.status 
                 )
               ));
            },
          );
        },
      ),
    );
  }
}