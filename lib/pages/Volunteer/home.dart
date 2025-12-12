// lib/pages/Volunteer/home.dart
import 'package:flutter/material.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Volunteer/Notification/notification.dart';
import 'package:volunite/pages/Volunteer/Category/categories_page.dart';
import 'package:volunite/pages/Volunteer/Category/category_activities_page.dart';
import 'package:volunite/color_pallete.dart';

// Import model dan service Anda
import 'package:volunite/models/kegiatan_model.dart'; 
import 'package:volunite/services/kegiatan_service.dart'; 
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/models/user_model.dart'; // Pastikan model ini punya pathProfil

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  User? currentUser;
  bool isLoadingUser = true;
  late Future<List<Kegiatan>> _kegiatanFuture;

  @override
  void initState() {
    super.initState();
    loadUser();
    _kegiatanFuture = KegiatanService.fetchKegiatan();
  }
  
  void loadUser() async {
    final user = await AuthService().getCurrentUser();

    setState(() {
      currentUser = user;
      isLoadingUser = false;
    });
  }

  // 🔥 FUNGSI PEMBANTU UNTUK MENAMPILKAN GAMBAR PROFIL
  Widget _buildProfileImage(String path) {
    // Ukuran yang sesuai dengan radius 24 * 2
    const double size = 48.0; 
    
    // Periksa apakah path adalah URL jaringan (http/https)
    final bool isNetworkImage = path.startsWith("http") || path.startsWith("https");
    
    // Jika path adalah asset, pastikan path lengkapnya benar.
    // Asumsi: Path database 'images/profile/...' mengacu pada folder 'assets/images/profile/...'
    final String finalPath = path.startsWith('assets/') ? path : 'assets/$path';
    
    return ClipOval(
      child: isNetworkImage
          ? Image.network(
              path,
              width: size,
              height: size,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: size,
                  height: size,
                  color: Colors.grey.shade200,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                // Placeholder jika URL gagal dimuat
                return Container(
                  width: size,
                  height: size,
                  color: kSoftBlue,
                  child: const Icon(Icons.person, size: 30, color: kDarkBlueGray),
                );
              },
            )
          : Image.asset(
              finalPath, // Gunakan path asset yang sudah dikoreksi
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder jika asset lokal tidak ditemukan
                return Container(
                  width: size,
                  height: size,
                  color: kSoftBlue,
                  child: const Icon(Icons.person, size: 30, color: kDarkBlueGray),
                );
              },
            ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    // Tentukan path profil yang akan digunakan, jika null gunakan placeholder asset
    final String profilePath = currentUser?.pathProfil ?? 'assets/images/profile_placeholder.jpeg';


    return Container(
      color: kBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 🔥 MODIFIKASI CIRCLE AVATAR UNTUK MEMANGGIL GAMBAR DINAMIS
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: kSoftBlue, // Background saat loading
                      child: isLoadingUser
                          ? const Center(child: CircularProgressIndicator(strokeWidth: 2))
                          : _buildProfileImage(profilePath),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, Selamat Datang 👋",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        Text(
                          isLoadingUser 
                          ? "Memuat..."
                          : currentUser?.nama ?? 'User',
                          style: TextStyle(fontSize: 14, color: kBlueGray),
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: kSoftBlue,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: kDarkBlueGray,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔍 Search Bar (Tidak Berubah)
            TextField(
              decoration: InputDecoration(
                hintText: "Cari kegiatan relawan...",
                hintStyle: const TextStyle(color: kBlueGray),
                prefixIcon: const Icon(Icons.search, color: kBlueGray),
                filled: true,
                fillColor: kSoftBlue.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kSkyBlue, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🧭 Kategori (Tidak Berubah)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori Pilihan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat semua',
                    style: TextStyle(
                      color: kBlueGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // LIST KATEGORI (Tidak Berubah)
            SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  categoryItem(context, Icons.nature, "Lingkungan", primary),
                  categoryItem(context, Icons.school, "Pendidikan", primary),
                  categoryItem(
                    context,
                    Icons.health_and_safety,
                    "Kesehatan",
                    primary,
                  ),
                  categoryItem(context, Icons.people, "Sosial", primary),
                  categoryItem(context, Icons.palette, "Seni", primary),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 💎 Exp Card (Tidak Berubah)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [kSkyBlue, kBlueGray],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlueGray.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your Voluntree Exp",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "18,000",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.8,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your Coins: 10,000",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 📢 JUDUL KEGIATAN
            const Text(
              "Daftar Sekarang",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kDarkBlueGray,
              ),
            ),

            const SizedBox(height: 15),

            // ✅ BAGIAN PENTING: FutureBuilder untuk memuat dan memfilter kegiatan
            SizedBox(
              height:245,
              child: FutureBuilder<List<Kegiatan>>(
                future: _kegiatanFuture,
                builder: (context, snapshot) {
                  // State Loading
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // State Error
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                            'Gagal memuat data. Periksa koneksi atau baseUrl Anda. Error: ${snapshot.error}'));
                  }

                  // State Data Tersedia
                  if (snapshot.hasData) {
                    // ** FILTER DATA DI SINI **
                    final List<Kegiatan> allKegiatan = snapshot.data!;
                    final List<Kegiatan> scheduledKegiatan = allKegiatan
                        .where((k) => k.status.toLowerCase() == 'scheduled')
                        .toList();

                    // State Data Kosong Setelah Filter
                    if (scheduledKegiatan.isEmpty) {
                      return const Center(
                        child: Text('Tidak ada kegiatan yang dijadwalkan saat ini.'),
                      );
                    }

                    // Tampilkan data yang sudah difilter
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: scheduledKegiatan.length,
                      itemBuilder: (context, index) {
                        final kegiatan = scheduledKegiatan[index];
                        // Menggunakan eventCard yang sudah Anda buat, 
                        // tetapi dengan data dinamis
                        return eventCard(
                          context,
                          // Jika thumbnail null, gunakan placeholder
                          kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg', 
                          kegiatan.judul,
                          // Format tanggal sesuai kebutuhan
                          _formatDate(kegiatan.tanggalMulai), 
                          _formatTimeRange(
                            kegiatan.tanggalMulai, 
                            kegiatan.tanggalBerakhir
                          ),
                          primary,
                          kegiatan, // Kirim objek kegiatan untuk DetailPage
                        );
                      },
                    );
                  }

                  // Fallback
                  return const Center(child: Text('Tidak ada data kegiatan.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Utility Functions (ditambahkan untuk memformat tanggal) ---

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tanggal N/A';
    const dayNames = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const monthNames = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    
    // Perbaikan indexing untuk dayNames: DateTime.weekday mengembalikan 1 (Senin) hingga 7 (Minggu)
    // List dayNames dimulai dari Minggu (index 0)
    final int weekdayIndex = date.weekday % 7; 
    final dayName = dayNames[weekdayIndex];
    
    final day = date.day;
    final month = monthNames[date.month];
    final year = date.year;

    return '$dayName, $day $month $year';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return 'Waktu N/A';

    final startTime = '${start.hour.toString().padLeft(2, '0')}.${start.minute.toString().padLeft(2, '0')} WIB';
    
    if (end != null) {
      final endTime = '${end.hour.toString().padLeft(2, '0')}.${end.minute.toString().padLeft(2, '0')} WIB';
      return '$startTime - $endTime';
    }
    
    return startTime;
  }
  
  // --- Static Widgets (dipertahankan) ---

  // 🔹 Kategori item (Tidak Berubah)
  static Widget categoryItem(
      BuildContext context, IconData icon, String title, Color primary) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman list kegiatan berdasarkan kategori
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryActivitiesPage(categoryName: title),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(
          right: 15,
          top: 5,
          bottom: 5,
        ), // Margin disesuaikan untuk shadow
        child: Column(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kSoftBlue, kSkyBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: kBlueGray.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 26, color: kDarkBlueGray),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: kDarkBlueGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 Event card (DIUBAH untuk menerima objek Kegiatan dan handle gambar Network/Asset)
  static Widget eventCard(
    BuildContext context,
    String image,
    String title,
    String date,
    String time,
    Color primary,
    Kegiatan kegiatan,
  ) {
    final bool isUrl = image.startsWith("http");
    const double imageHeight = 130.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailActivitiesPage(
              kegiatan: kegiatan,
              title: title,
              date: date,
              time: time,
              imagePath: image,
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kBlueGray.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: isUrl
                  ? Image.network(
                      image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          height: imageHeight,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: imageHeight,
                          color: Colors.grey,
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    )
                  : Image.asset(
                      image,
                      height: imageHeight,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: imageHeight,
                          color: Colors.grey,
                          child: const Icon(Icons.error, size: 40),
                        );
                      },
                    ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15)
                  .copyWith(top: 10, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kegiatan.status,
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: kBlueGray),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          date,
                          style: const TextStyle(
                              color: kBlueGray, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: kBlueGray),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style:
                            const TextStyle(color: kBlueGray, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}