import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart'; // Pastikan path ini benar
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Organizer/Activity/create_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Organizer/Notification/notification.dart'; // Pastikan path benar
import 'package:volunite/services/kegiatan_service.dart';
import 'package:volunite/pages/Organizer/Activity/activity_card.dart'; // Import Card Baru

class OrganizerHomeTab extends StatefulWidget {
  const OrganizerHomeTab({super.key});

  @override
  State<OrganizerHomeTab> createState() => _OrganizerHomeTabState();
}

class _OrganizerHomeTabState extends State<OrganizerHomeTab> {
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _refreshData();
    KegiatanService.shouldRefresh.addListener(_refreshData);
  }

  @override
  void dispose() {
    KegiatanService.shouldRefresh.removeListener(_refreshData);
    super.dispose();
  }

  void _refreshData() {
     if (mounted) { 
        setState(() {
          _futureKegiatan = KegiatanService.fetchOrganizerKegiatan();
        });
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground, // Menggunakan background soft abu-abu
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        color: kSkyBlue,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header (Profil & Notifikasi)
              _buildHeader(context),
              const SizedBox(height: 24),

              // 2. Statistik (Grid 2x2)
              const _MetricsGrid(),
              const SizedBox(height: 24),

              // 3. Tombol Buat Kegiatan (Primary CTA)
              _buildCreateButton(context),
              const SizedBox(height: 30),

              // 4. Section: Kegiatan Mendatang (Horizontal Scroll)
              _buildSectionTitle("Kegiatan Mendatang", "Lihat Semua", onTap: () {}),
              const SizedBox(height: 16),
              
              _buildHorizontalActivityList(),

              const SizedBox(height: 30),

              // 5. Section: Pelamar Terbaru
              _buildSectionTitle("Pelamar Terbaru", "Lihat Semua", onTap: () {}),
              const SizedBox(height: 12),
              
              // Dummy Pelamar (Bisa diganti Logic Real nanti)
              const _ApplicantTile(name: "Rina Marlina", event: "Mengajar Anak Jalanan", time: "Baru saja"),
              const _ApplicantTile(name: "Budi Santoso", event: "Bersih Pantai", time: "5 menit lalu"),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDER METHODS ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: const CircleAvatar(
                radius: 26,
                backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg'), // Ganti dengan path user profil
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Halo, Penyelenggara 👋", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                Text("Kelola kegiatanmu hari ini", style: TextStyle(fontSize: 13, color: kBlueGray)),
              ],
            ),
          ],
        ),
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined, color: kDarkBlueGray),
                onPressed: () {
                   Navigator.push(context, MaterialPageRoute(builder: (_) => const NotifikasiPage()));
                },
              ),
            ),
            Positioned(right: 12, top: 12, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)) // Dot merah
          ],
        ),
      ],
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateActivityPage()));
          if (res == true) _refreshData();
        },
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("Buat Kegiatan Baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: kSkyBlue,
          elevation: 4,
          shadowColor: kSkyBlue.withOpacity(0.4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String actionText, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
        InkWell(
          onTap: onTap,
          child: Text(actionText, style: const TextStyle(color: kSkyBlue, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildHorizontalActivityList() {
    return SizedBox(
      height: 295, // Tinggi disesuaikan dengan konten card baru
      child: FutureBuilder<List<Kegiatan>>(
        future: _futureKegiatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kSkyBlue));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final items = snapshot.data!.take(5).toList();

          return ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none, // Biar shadow gak kepotong
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = items[index];
              
              // Disini kita Panggil Widget Reusable tadi
              return SizedBox(
                width: 260, // KITA ATUR LEBARNYA DISINI (KHUSUS HOME)
                child: OrganizerActivityCard(
                  item: item,
                  onManage: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (_) => OrganizerDetailActivityPage(kegiatan: item)
                    )).then((val) { if (val == true) _refreshData(); });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kLightGray)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.event_busy_rounded, size: 40, color: kLightGray),
          SizedBox(height: 8),
          Text("Belum ada kegiatan aktif", style: TextStyle(color: kBlueGray)),
        ],
      ),
    );
  }
}

// --- SUB-COMPONENTS (WIDGETS) ---

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    // Data Dummy (Nanti bisa diganti real data dari API Dashboard)
    const items = [
      _MetricItem(icon: Icons.event_available, label: "Aktif", value: "4", color: kSkyBlue),
      _MetricItem(icon: Icons.access_time_filled, label: "Menunggu", value: "1", color: Colors.orange),
      _MetricItem(icon: Icons.group, label: "Pendaftar", value: "12", color: Colors.green),
      _MetricItem(icon: Icons.star_rounded, label: "Rating", value: "4.8", color: Colors.amber),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4, // Lebar vs Tinggi kotak statistik
      ),
      itemBuilder: (context, i) {
        final item = items[i];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.5), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: item.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDarkBlueGray)),
                  Text(item.label, style: const TextStyle(fontSize: 12, color: kBlueGray)),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

class _MetricItem {
  final IconData icon; final String label; final String value; final Color color;
  const _MetricItem({required this.icon, required this.label, required this.value, required this.color});
}


class _ApplicantTile extends StatelessWidget {
  final String name; final String event; final String time;
  const _ApplicantTile({required this.name, required this.event, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kLightGray)),
      child: Row(
        children: [
          const CircleAvatar(radius: 20, backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg')),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                Text("Mendaftar di $event", style: const TextStyle(fontSize: 11, color: kBlueGray), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 10, color: kBlueGray)),
        ],
      ),
    );
  }
}