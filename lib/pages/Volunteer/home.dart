import 'package:flutter/material.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/shared/notification.dart';
import 'package:volunite/pages/Volunteer/Category/categories_page.dart';
import 'package:volunite/pages/Volunteer/Category/category_activities_page.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/models/kegiatan_model.dart'; 
import 'package:volunite/services/kegiatan_service.dart'; 
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/models/user_model.dart';
import 'package:volunite/services/notifikasi_service.dart'; 
import 'package:volunite/models/pencapaian_model.dart'; 
import 'package:volunite/models/volunteer_pencapaian_model.dart'; 
import 'package:volunite/services/pencapaian_service.dart'; 
import 'package:volunite/services/general_profile_service.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  User? currentUser;
  bool isLoadingUser = true;
  late Future<List<Kegiatan>> _kegiatanFuture;
  late Future<VolunteerProfileData> _futureProfile; 
  bool _hasNewNotification = false; 
  List<Kegiatan> _allKegiatan = []; 
  String _searchText = ''; 
  final TextEditingController _searchController = TextEditingController();
  
  String _imgSignature = DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    loadUser(); 
    _refreshProfile();
    _kegiatanFuture = _fetchAndStoreKegiatan();
    _searchController.addListener(_onSearchChanged);
    _checkNewNotifications();
    
    GeneralProfileService.shouldRefresh.addListener(_onGlobalRefresh);
  }

  @override
  void dispose() {
    GeneralProfileService.shouldRefresh.removeListener(_onGlobalRefresh);
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onGlobalRefresh() {
    if (mounted) {
      _updateUserData(); 
      _refreshProfile(); 
      setState(() {
        _imgSignature = DateTime.now().millisecondsSinceEpoch.toString();
      });
    }
  }

  void _refreshProfile() {
    setState(() {
      _futureProfile = VolunteerService.fetchProfile();
    });
  }

  // Fungsi khusus untuk mengambil data user terbaru dari API (Bukan dari cache lokal Auth)
  Future<void> _updateUserData() async {
    try {
      final freshData = await GeneralProfileService.fetchMyProfile();
      if (mounted) {
        setState(() {
          currentUser = freshData['user'] as User; 
        });
      }
    } catch(e) {
      debugPrint("Gagal refresh user di home: $e");
    }
  }

  Future<void> loadUser() async {
    // Load awal, bisa dari cache local dulu biar cepat
    final user = await AuthService().getCurrentUser();
    if (mounted) {
      setState(() {
        currentUser = user;
        isLoadingUser = false;
      });
      // Panggil update juga untuk memastikan data sinkron dgn server
      _updateUserData(); 
    }
  }
  
  // --- Fungsi Utility Lainnya (Tidak Berubah) ---
  Future<void> _checkNewNotifications() async { try { final unreadCount = await NotifikasiService.countUnread(); if (mounted) setState(() => _hasNewNotification = unreadCount > 0); } catch (e) { debugPrint('Error check notification: $e'); } }
  Future<void> _markNotificationsAsRead() async { try { final notifications = await NotifikasiService.fetchNotifikasi(); for (final notif in notifications) { if (!notif.isRead) { await NotifikasiService.markAsRead(notif.id); notif.isRead = true; } } if (mounted) setState(() => _hasNewNotification = false); } catch (e) { debugPrint('Error mark notifications read: $e'); } }
  Future<List<Kegiatan>> _fetchAndStoreKegiatan() async { final kegiatanList = await KegiatanService.fetchKegiatan(); if (mounted) setState(() => _allKegiatan = kegiatanList); return kegiatanList; }
  void _onSearchChanged() { setState(() => _searchText = _searchController.text); }
  List<Kegiatan> _getFilteredKegiatan(List<Kegiatan> allKegiatan) { final List<Kegiatan> scheduledKegiatan = allKegiatan.where((k) => k.status.toLowerCase() == 'scheduled').toList(); if (_searchText.isEmpty) return scheduledKegiatan; final query = _searchText.toLowerCase(); return scheduledKegiatan.where((k) { final titleMatch = k.judul.toLowerCase().contains(query); final descriptionMatch = (k.deskripsi ?? '').toLowerCase().contains(query); final categoryMatch = k.kategori.any((cat) => cat.namaKategori.toLowerCase().contains(query)); return titleMatch || descriptionMatch || categoryMatch; }).toList(); }
  
  // [LOGIC 4] Update _buildProfileImage untuk mendukung signature
  Widget _buildProfileImage(String path) {
    const double size = 48.0; 
    final bool isNetworkImage = path.startsWith("http") || path.startsWith("https");
    final String finalPath = path.startsWith('assets/') ? path : 'assets/$path';
    
    // Tambahkan signature ke URL
    final String urlWithSignature = isNetworkImage ? "$path?v=$_imgSignature" : path;
    
    return ClipOval(
      child: isNetworkImage
          ? Image.network(
              urlWithSignature,
              width: size, height: size, fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(width: size, height: size, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator(strokeWidth: 2)));
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(width: size, height: size, color: kSoftBlue, child: const Icon(Icons.person, size: 30, color: kDarkBlueGray));
              },
            )
          : Image.asset(
              finalPath, 
              width: size, height: size, fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(width: size, height: size, color: kSoftBlue, child: const Icon(Icons.person, size: 30, color: kDarkBlueGray));
              },
            ),
    );
  }

  // XP Card
  Widget _buildSimpleXPCard(VolunteerProfileData data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [kSkyBlue, kBlueGray], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total Volunteer XP', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)), const SizedBox(height: 8), Text('${data.totalXp} XP', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900))]), Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.star_rounded, color: Colors.white, size: 32))]),
    );
  }

  // Utility Date Formatter
  String _formatDate(DateTime? date) { if (date == null) return 'Tanggal N/A'; const dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu']; const monthNames = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember']; final int weekdayIndex = date.weekday % 7; return '${dayNames[weekdayIndex]}, ${date.day} ${monthNames[date.month]} ${date.year}'; }
  String _formatTimeRange(DateTime? start, DateTime? end) { if (start == null) return 'Waktu N/A'; final startTime = '${start.hour.toString().padLeft(2, '0')}.${start.minute.toString().padLeft(2, '0')} WIB'; if (end != null) { final endTime = '${end.hour.toString().padLeft(2, '0')}.${end.minute.toString().padLeft(2, '0')} WIB'; return '$startTime - $endTime'; } return startTime; }
  
  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final String profilePath = currentUser?.pathProfil ?? 'assets/images/profile_placeholder.jpeg';

    return Container(
      color: kBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: kSoftBlue,
                      child: isLoadingUser
                          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                          : _buildProfileImage(profilePath), // Panggil builder baru
                    ),
                    const SizedBox(width: 10),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text("Hi, Selamat Datang 👋", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                        // Nama akan berubah otomatis
                        Text(isLoadingUser ? "Memuat..." : currentUser?.nama ?? 'User', style: const TextStyle(fontSize: 14, color: kBlueGray)),
                      ]),
                  ]),
                Stack(children: [CircleAvatar(radius: 20, backgroundColor: kSoftBlue, child: IconButton(icon: const Icon(Icons.notifications_outlined, size: 20, color: kDarkBlueGray), onPressed: () { _markNotificationsAsRead(); Navigator.push(context, MaterialPageRoute(builder: (context) => const NotifikasiPage())); })), if (_hasNewNotification) Positioned(right: 5, top: 5, child: Container(padding: const EdgeInsets.all(2), decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(6), border: Border.all(color: Colors.white, width: 1)), constraints: const BoxConstraints(minWidth: 8, minHeight: 8)))]),
              ]),

            const SizedBox(height: 25),
            // Search Bar
            TextField(controller: _searchController, decoration: InputDecoration(hintText: "Cari kegiatan relawan...", hintStyle: const TextStyle(color: kBlueGray), prefixIcon: const Icon(Icons.search, color: kBlueGray), filled: true, fillColor: kSoftBlue.withOpacity(0.5), contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15), border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kSkyBlue, width: 1.2)))),
            const SizedBox(height: 25),
            // Kategori
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Kategori Pilihan', style: TextStyle(fontWeight: FontWeight.bold)), InkWell(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoriesPage())); }, child: const Text('Lihat semua', style: TextStyle(color: kBlueGray, fontWeight: FontWeight.w600)))]),
            const SizedBox(height: 15),
            SizedBox(height: 95, child: ListView(scrollDirection: Axis.horizontal, children: [categoryItem(context, Icons.nature, "Lingkungan", primary), categoryItem(context, Icons.school, "Pendidikan", primary), categoryItem(context, Icons.health_and_safety, "Kesehatan", primary), categoryItem(context, Icons.people, "Sosial", primary), categoryItem(context, Icons.palette, "Seni", primary)])),
            const SizedBox(height: 25),
            // XP Card
            FutureBuilder<VolunteerProfileData>(future: _futureProfile, builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.waiting) return Container(width: double.infinity, height: 90, padding: const EdgeInsets.all(24), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [kSkyBlue, kBlueGray], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 6))]), child: const Center(child: CircularProgressIndicator(color: Colors.white))); if (snapshot.hasData) return _buildSimpleXPCard(snapshot.data!); return const SizedBox.shrink(); }),
            const SizedBox(height: 30),
            const Text("Daftar Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
            const SizedBox(height: 15),
            // List Kegiatan
            SizedBox(height: 245, child: FutureBuilder<List<Kegiatan>>(future: _kegiatanFuture, builder: (context, snapshot) { if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator()); if (snapshot.hasData) { final all = snapshot.data!; final filtered = _getFilteredKegiatan(all); if (filtered.isEmpty) return const Center(child: Text('Tidak ada kegiatan.')); return ListView.builder(scrollDirection: Axis.horizontal, itemCount: filtered.length, itemBuilder: (context, index) { final k = filtered[index]; return eventCard(context, k.thumbnail ?? 'assets/images/event_placeholder.jpg', k.judul, _formatDate(k.tanggalMulai), _formatTimeRange(k.tanggalMulai, k.tanggalBerakhir), primary, k); }); } return const Center(child: Text('Tidak ada data kegiatan.')); })),
          ],
        ),
      ),
    );
  }
  
  // (Static helper widgets categoryItem, eventCard tetap sama seperti file Anda sebelumnya)
  static Widget categoryItem(BuildContext context, IconData icon, String title, Color primary) { return GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryActivitiesPage(categoryName: title))); }, child: Container(width: 80, margin: const EdgeInsets.only(right: 15, top: 5, bottom: 5), child: Column(children: [Container(height: 55, width: 55, decoration: BoxDecoration(gradient: const LinearGradient(colors: [kSoftBlue, kSkyBlue], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))]), child: Icon(icon, size: 26, color: kDarkBlueGray)), const SizedBox(height: 8), Text(title, style: const TextStyle(fontSize: 12, color: kDarkBlueGray), textAlign: TextAlign.center)]))); }
  static Widget eventCard(BuildContext context, String image, String title, String date, String time, Color primary, Kegiatan kegiatan) { final bool isUrl = image.startsWith("http"); const double imageHeight = 130.0; String displayStatus = kegiatan.status.isNotEmpty ? '${kegiatan.status[0].toUpperCase()}${kegiatan.status.substring(1).toLowerCase()}' : 'Status N/A'; return GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => DetailActivitiesPage(kegiatan: kegiatan, title: title, date: date, time: time, imagePath: image))); }, child: Container(width: 280, margin: const EdgeInsets.only(right: 15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.18), blurRadius: 10, offset: const Offset(0, 6))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(20)), child: isUrl ? Image.network(image, height: imageHeight, width: double.infinity, fit: BoxFit.cover, loadingBuilder: (context, child, progress) { if (progress == null) return child; return Container(height: imageHeight, color: Colors.grey.shade200, child: const Center(child: CircularProgressIndicator(strokeWidth: 2))); }, errorBuilder: (context, error, stackTrace) { return Container(height: imageHeight, color: Colors.grey, child: const Icon(Icons.broken_image, size: 40)); }) : Image.asset(image, height: imageHeight, width: double.infinity, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) { return Container(height: imageHeight, color: Colors.grey, child: const Icon(Icons.error, size: 40)); })), Padding(padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10, bottom: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: primary.withOpacity(0.2), borderRadius: BorderRadius.circular(12)), child: Text(displayStatus, style: TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.bold))), const SizedBox(height: 6), Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkBlueGray)), const SizedBox(height: 6), Row(children: [const Icon(Icons.calendar_today, size: 14, color: kBlueGray), const SizedBox(width: 5), Expanded(child: Text(date, style: const TextStyle(color: kBlueGray, fontSize: 12), overflow: TextOverflow.ellipsis))]), const SizedBox(height: 2), Row(children: [const Icon(Icons.access_time, size: 14, color: kBlueGray), const SizedBox(width: 5), Text(time, style: const TextStyle(color: kBlueGray, fontSize: 12))])]))]))); }
}