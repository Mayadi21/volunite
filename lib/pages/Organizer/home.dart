// lib/pages/Organizer/home.dart

import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Organizer/Activity/create_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Organizer/Activity/activity_card.dart'; // Gunakan Card yang sudah kita standarisasi
import 'package:volunite/pages/Organizer/Notification/notification.dart';
import 'package:volunite/services/kegiatan_service.dart';


class OrganizerHomeTab extends StatefulWidget {
  const OrganizerHomeTab({super.key});

  static const Color kPrimaryAction = kSkyBlue;

  @override
  State<OrganizerHomeTab> createState() => _OrganizerHomeTabState();
}

class _OrganizerHomeTabState extends State<OrganizerHomeTab> {
  late Future<List<Kegiatan>> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _futureKegiatan = KegiatanService.fetchOrganizerKegiatan();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      // Gunakan RefreshIndicator agar user bisa tarik layar untuk reload data
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =======================
              // 👋 Header
              // =======================
              _buildHeader(context),

              const SizedBox(height: 20),

              // =======================
              // 📊 Metrics (Statistik)
              // =======================
              const _MetricsGrid(primary: OrganizerHomeTab.kPrimaryAction),

              const SizedBox(height: 24),

              // =======================
              // ➕ Tombol Buat Kegiatan
              // =======================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateActivityPage()),
                    );
                    if (result == true) {
                      _refreshData(); // Refresh jika ada data baru
                    }
                  },
                  icon: const Icon(Icons.add, size: 22),
                  label: const Text("Buat Kegiatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OrganizerHomeTab.kPrimaryAction,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 3,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // =======================
              // 📅 Kegiatan Mendatang (Dari API)
              // =======================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Kegiatan Mendatang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                  Text("Lihat Semua", style: TextStyle(color: kBlueGray, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),

              // LIST HORIZONTAL DARI API
              SizedBox(
                height: 360, // Tinggi area card
                child: FutureBuilder<List<Kegiatan>>(
                  future: _futureKegiatan,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Gagal memuat data: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Ambil 5 kegiatan terbaru saja untuk dashboard
                    final items = snapshot.data!.take(5).toList();

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      separatorBuilder: (ctx, i) => const SizedBox(width: 15),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        // Kita bungkus Card dengan Container lebar fix agar rapi di horizontal scroll
                        return SizedBox(
                          width: 300,
                          child: OrganizerActivityCard(
                            item: item,
                            isHistory: false,
                            onManage: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OrganizerDetailActivityPage(kegiatan: item),
                                ),
                              ).then((val) {
                                if (val == true) _refreshData();
                              });
                            },
                            onApplicants: () {
                              // TODO: Navigasi ke list pelamar
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // =======================
              // 👥 Pelamar Terbaru (Dummy Dulu)
              // =======================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Pelamar Terbaru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                  Text("Lihat semua", style: TextStyle(color: kBlueGray, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 10),

              // Data Dummy Pelamar (Nanti diganti API)
              const _ApplicantTile(name: "Rina Marlina", event: "Pintar Bersama", submittedAt: "Baru saja"),
              const _ApplicantTile(name: "Andi Saputra", event: "Aksi Bersih Pantai", submittedAt: "10 menit lalu"),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER WIDGET
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Halo, Penyelenggara 👋", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                Text("Dashboard Kegiatanmu", style: TextStyle(fontSize: 14, color: kBlueGray)),
              ],
            ),
          ],
        ),
        CircleAvatar(
          radius: 22,
          backgroundColor: kSkyBlue,
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NotifikasiPage()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightGray),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.event_busy, size: 50, color: kBlueGray),
          SizedBox(height: 10),
          Text("Belum ada kegiatan", style: TextStyle(color: kDarkBlueGray, fontWeight: FontWeight.bold)),
          Text("Buat kegiatan pertamamu!", style: TextStyle(color: kBlueGray, fontSize: 12)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WIDGET METRICS GRID (Statik Dulu)
// ---------------------------------------------------------------------
class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    const items = [
      _MetricItem(icon: Icons.event_available, label: "Aktif", value: "4"),
      _MetricItem(icon: Icons.pending_actions, label: "Menunggu", value: "1"),
      _MetricItem(icon: Icons.group, label: "Pendaftar", value: "12"),
      _MetricItem(icon: Icons.star_rate, label: "Rating", value: "4.8"),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, i) => _MetricTile(
        icon: items[i].icon,
        label: items[i].label,
        value: items[i].value,
        primary: primary,
      ),
    );
  }
}

class _MetricItem {
  final IconData icon; final String label; final String value;
  const _MetricItem({required this.icon, required this.label, required this.value});
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.icon, required this.label, required this.value, required this.primary});
  final IconData icon; final String label; final String value; final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.8), blurRadius: 6, offset: const Offset(2, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: kBlueGray, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kDarkBlueGray)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WIDGET APPLICANT TILE (Tetap Sama)
// ---------------------------------------------------------------------
class _ApplicantTile extends StatelessWidget {
  const _ApplicantTile({required this.name, required this.event, required this.submittedAt});
  final String name; final String event; final String submittedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.8), blurRadius: 6, offset: const Offset(2, 2))],
      ),
      child: ListTile(
        leading: const CircleAvatar(backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg')),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600, color: kDarkBlueGray)),
        subtitle: Text("$event • $submittedAt", style: const TextStyle(color: kBlueGray)),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: kSkyBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          child: const Text("Detail", style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ),
    );
  }
}