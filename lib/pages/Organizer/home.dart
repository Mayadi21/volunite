import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/models/user_model.dart';
import 'package:volunite/pages/Organizer/Activity/activities_page.dart';
import 'package:volunite/pages/Organizer/Activity/activity_card.dart';
import 'package:volunite/pages/Organizer/Activity/create_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_list_page.dart'; 
import 'package:volunite/pages/shared/notification.dart';
import 'package:volunite/services/kegiatan_service.dart';

class OrganizerHomeTab extends StatefulWidget {
  const OrganizerHomeTab({super.key});

  @override
  State<OrganizerHomeTab> createState() => _OrganizerHomeTabState();
}

class _OrganizerHomeTabState extends State<OrganizerHomeTab> {
  bool _isLoading = true;
  User? _user;
  Map<String, dynamic>? _stats;
  List<Kegiatan> _recentKegiatan = [];
  List<Pendaftaran> _pendingApplicants = [];

  @override
  void initState() {
    super.initState();
    _loadDashboard();
    
    KegiatanService.shouldRefresh.addListener(_loadDashboard);
  }

  @override
  void dispose() {
    KegiatanService.shouldRefresh.removeListener(_loadDashboard);
    super.dispose();
  }

  Future<void> _loadDashboard() async {
    try {
      final data = await KegiatanService.fetchDashboard();
      if (mounted) {
        setState(() {
          _user = User.fromJson(data['user']);
          _stats = data['stats'];
          _recentKegiatan = (data['kegiatan'] as List).map((e) => Kegiatan.fromJson(e)).toList();
          _pendingApplicants = (data['pelamar_pending'] as List).map((e) => Pendaftaran.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading dashboard: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: kSkyBlue))
        : RefreshIndicator(
            onRefresh: _loadDashboard,
            color: kSkyBlue,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  _buildMetricsGrid(),
                  const SizedBox(height: 24),

                  _buildCreateButton(context),
                  const SizedBox(height: 30),

                  _buildSectionTitle(
                    "Kegiatan Mendatang", 
                    "Lihat Semua", 
                    onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (_) => const OrganizerActivitiesPage()));
                    }
                  ),
                  const SizedBox(height: 16),
                  _buildHorizontalActivityList(),

                  const SizedBox(height: 30),

                  const Text(
                    "Menunggu Verifikasi Anda", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)
                  ),
                  const SizedBox(height: 12),
                  
                  _buildPendingApplicantsList(),
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final String nama = _user?.nama ?? 'Organizer';
    final String? foto = _user?.pathProfil;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                ),
                child: CircleAvatar(
                  radius: 26,
                  backgroundColor: kLightGray,
                  backgroundImage: foto != null 
                    ? NetworkImage(foto) 
                    : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Halo, $nama 👋", maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                    const Text("Kelola kegiatanmu hari ini", style: TextStyle(fontSize: 13, color: kBlueGray)),
                  ],
                ),
              ),
            ],
          ),
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
            Positioned(right: 12, top: 12, child: CircleAvatar(radius: 4, backgroundColor: Colors.red)) 
          ],
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    final aktif = _stats?['aktif'] ?? 0;
    final waiting = _stats?['waiting'] ?? 0;
    final selesai = _stats?['selesai'] ?? 0;
    final pendaftar = _stats?['pendaftar'] ?? 0;

    final items = [
      _MetricItem(icon: Icons.event_available, label: "Aktif", value: "$aktif", color: kSkyBlue),
      _MetricItem(icon: Icons.access_time_filled, label: "Menunggu", value: "$waiting", color: Colors.orange),
      _MetricItem(icon: Icons.history, label: "Selesai", value: "$selesai", color: kBlueGray),
      _MetricItem(icon: Icons.group, label: "Partisipan", value: "$pendaftar", color: Colors.green),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.4,
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

  Widget _buildCreateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateActivityPage()));
          if (res == true) _loadDashboard();
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
    if (_recentKegiatan.isEmpty) {
      return _buildEmptyState("Belum ada kegiatan");
    }

    return SizedBox(
      height: 295,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: _recentKegiatan.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final item = _recentKegiatan[index];
          return SizedBox(
            width: 260,
            child: OrganizerActivityCard(
              item: item, 
              onManage: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => OrganizerDetailActivityPage(kegiatan: item)))
                        .then((val) { if (val == true) _loadDashboard(); });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPendingApplicantsList() {
    if (_pendingApplicants.isEmpty) {
      return _buildEmptyState("Tidak ada pelamar baru");
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _pendingApplicants.length,
      itemBuilder: (context, index) {
        final pendaftar = _pendingApplicants[index];
        final user = pendaftar.user;
        final kegiatan = pendaftar.kegiatan;

        return GestureDetector(
          onTap: () {
            if (kegiatan != null) {
               Navigator.push(context, MaterialPageRoute(builder: (_) => ApplicantListPage(kegiatanId: kegiatan.id)));
            }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kLightGray)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20, 
                  backgroundColor: kLightGray,
                  backgroundImage: user?.pathProfil != null ? NetworkImage(user!.pathProfil!) : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.nama ?? 'Volunteer', style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                      Text(
                        "Mendaftar di: ${kegiatan?.judul ?? 'Kegiatan'}", 
                        style: const TextStyle(fontSize: 11, color: kBlueGray), 
                        maxLines: 1, 
                        overflow: TextOverflow.ellipsis
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Text("Menunggu", style: TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String msg) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kLightGray)),
      child: Center(
        child: Text(msg, style: const TextStyle(color: kBlueGray)),
      ),
    );
  }
}

class _MetricItem {
  final IconData icon; final String label; final String value; final Color color;
  const _MetricItem({required this.icon, required this.label, required this.value, required this.color});
}