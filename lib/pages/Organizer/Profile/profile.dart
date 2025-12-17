import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/pages/Shared/edit_profile.dart'; 
import 'package:volunite/services/profile_service.dart'; 
import 'package:volunite/services/general_profile_service.dart';

class OrganizerProfilePage extends StatefulWidget {
  const OrganizerProfilePage({super.key});

  @override
  State<OrganizerProfilePage> createState() => _OrganizerProfilePageState();
}

class _OrganizerProfilePageState extends State<OrganizerProfilePage> {
  final Color primaryDark = kDarkBlueGray;
  static const Color primaryAction = kSkyBlue;
  static const Color logoutColor = Color(0xFFD32F2F);

  late Future<Map<String, dynamic>> _futureStats;
  
  String _imgSignature = DateTime.now().toString(); 

  @override
  void initState() {
    super.initState();
    _refreshData();
    GeneralProfileService.shouldRefresh.addListener(_refreshData);
  }

  @override
  void dispose() {
    GeneralProfileService.shouldRefresh.removeListener(_refreshData);
    super.dispose();
  }

  void _refreshData() {
    if (mounted) {
      setState(() {
        _futureStats = ProfileService.fetchOrganizerStats();
        _imgSignature = DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"), 
        content: const Text("Keluar dari akun?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () { 
              Navigator.pop(ctx); 
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginPage()), (r) => false); 
            }, 
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red), 
            child: const Text("Keluar", style: TextStyle(color: Colors.white))
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureStats,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: kSkyBlue));
            if (snapshot.hasError) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text("Error: ${snapshot.error}"), ElevatedButton(onPressed: _refreshData, child: const Text("Retry"))]));

            final data = snapshot.data!;
            final user = data['user'];
            final stats = data['stats'];

            final String nama = user['nama'] ?? 'Organizer';
            final String? foto = user['path_profil'];
            
            final String totalRelawan = stats['total_relawan'].toString();
            final String attendanceRate = "${stats['attendance_rate']}%";
            final String kegTotal = stats['kegiatan_total'].toString();
            final String kegAktif = stats['kegiatan_aktif'].toString();
            final String kegSelesai = stats['kegiatan_selesai'].toString();

            return RefreshIndicator(
              onRefresh: () async => _refreshData(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: primaryAction, shape: BoxShape.circle, boxShadow: [BoxShadow(color: primaryAction.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]),
                            child: IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                              },
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),

                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: primaryAction.withOpacity(0.5), width: 3)),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: kLightGray,
                              backgroundImage: foto != null 
                                  ? NetworkImage("$foto?v=$_imgSignature") 
                                  : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(nama, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: kDarkBlueGray), textAlign: TextAlign.center),
                          const Text('Penyelenggara Kegiatan', style: TextStyle(fontSize: 12, color: kBlueGray)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      _buildMetricCard(icon: Icons.group, label: 'Total Relawan', value: totalRelawan, color: primaryDark),
                      const SizedBox(height: 12),
                      _buildMetricCard(icon: Icons.check_circle_outline, label: 'Tingkat Kehadiran', value: attendanceRate, color: primaryAction),

                      const SizedBox(height: 30),

                      _buildAchievementSection(
                        title: 'Statistik Kegiatan',
                        items: [
                          _buildStatItem(kegTotal, 'Total'),
                          _buildStatItem(kegAktif, 'Aktif'),
                          _buildStatItem(kegSelesai, 'Selesai'),
                        ],
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _showLogoutDialog(context),
                          style: ElevatedButton.styleFrom(backgroundColor: logoutColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          child: const Text('Keluar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMetricCard({required IconData icon, required String label, required String value, required Color color}) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.15), blurRadius: 10, offset: const Offset(0, 5))]), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 28, color: color)), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: kBlueGray, fontSize: 13)), const SizedBox(height: 4), Text(value, style: const TextStyle(color: kDarkBlueGray, fontSize: 24, fontWeight: FontWeight.w900))])]));
  }

  Widget _buildAchievementSection({required String title, required List<Widget> items}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)), const SizedBox(height: 12), Row(children: [for (int i = 0; i < items.length; i++) ...[Expanded(child: items[i]), if (i < items.length - 1) const SizedBox(width: 12)]])]);
  }

  Widget _buildStatItem(String value, String label) {
    return Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: primaryDark.withOpacity(0.1)), boxShadow: [BoxShadow(color: kLightGray, blurRadius: 4, offset: const Offset(0, 2))]), child: Column(children: [Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryAction)), const SizedBox(height: 4), Text(label, style: const TextStyle(fontSize: 12, color: kBlueGray), textAlign: TextAlign.center)]));
  }
}