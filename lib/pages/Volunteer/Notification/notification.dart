import 'package:flutter/material.dart';
import 'detail_notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifikasi Demo',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
      home: NotifikasiPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotifikasiItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  final bool isUnread;
  final String category; // 'rewards', 'pemberitahuan', 'kegiatan'

  NotifikasiItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconBgColor,
    this.isUnread = false,
    required this.category,
  });
}

// HALAMAN UTAMA NOTIFIKASI
class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  // Mengelola tab yang sedang aktif
  int _selectedTabIndex = 0; // 0: Semua, 1: Rewards, 2: Pemberitahuan

  final List<NotifikasiItem> _allNotifications = [
    NotifikasiItem(
      id: '1',
      title: 'Kegiatan "Baksos" Selesai!',
      subtitle: 'Sertifikatmu telah ditambahkan ke achievement, yuk li...',
      time: '13:25',
      icon: Icons.group_work, // Ikon yang mirip
      iconBgColor: Colors.blue.shade700,
      isUnread: true, // Ada titik merah di ikon
      category: 'kegiatan',
    ),
    NotifikasiItem(
      id: '2',
      title: 'Voluntree Versi 2.1 Hadir!',
      subtitle: 'Beberapa penyesuaian dapat Anda lihat di sini, sepert...',
      time: '11 Nov 2024',
      icon: Icons.info_outline,
      iconBgColor: Colors.blue.shade100,
      isUnread: false,
      category: 'pemberitahuan',
    ),
    NotifikasiItem(
      id: '3',
      title: 'Promo Pengguna Baru',
      subtitle: 'Untuk pengguna baru, kamu mendapatkan promo 10...',
      time: '07 Nov 2024',
      icon: Icons.percent,
      iconBgColor: Colors.yellow.shade700,
      isUnread: false,
      category: 'rewards',
    ),
    // Tambahan data untuk demo filter
    NotifikasiItem(
      id: '4',
      title: 'Rewards Spesial Untukmu',
      subtitle: 'Klaim voucher diskon 50% khusus untukmu!',
      time: '06 Nov 2024',
      icon: Icons.star_outline,
      iconBgColor: Colors.red.shade400,
      isUnread: true, // Ada titik merah di tab Rewards
      category: 'rewards',
    ),
  ];

  // Helper untuk memfilter daftar berdasarkan tab
  List<NotifikasiItem> get _filteredNotifications {
    if (_selectedTabIndex == 1) {
      // Tab 'Rewards'
      return _allNotifications
          .where((item) => item.category == 'rewards')
          .toList();
    } else if (_selectedTabIndex == 2) {
      // Tab 'Pemberitahuan'
      return _allNotifications
          .where((item) => item.category == 'pemberitahuan')
          .toList();
    }
    // Tab 'Semua' (index 0)
    return _allNotifications;
  }

  // Helper untuk cek apakah ada notifikasi belum dibaca di kategori
  bool get _hasUnreadRewards => _allNotifications.any(
    (item) => item.category == 'rewards' && item.isUnread,
  );
  bool get _hasUnreadAll => _allNotifications.any((item) => item.isUnread);

  @override
  Widget build(BuildContext context) {
    // Warna utama dari AppBar di screenshot
    const Color primaryColor = Color(0xFF005271);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Aksi tombol kembali, contoh:
            // Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Bagian Tab Filter
          _buildTabBar(primaryColor),

          // 2. Bagian Daftar Notifikasi
          _buildNotificationList(),
        ],
      ),
    );
  }

  // WIDGET UNTUK TAB BAR
  Widget _buildTabBar(Color primaryColor) {
    return Container(
      color: Colors.white, // Latar belakang putih di belakang tab
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildTabItem(
            label: 'Semua',
            index: 0,
            primaryColor: primaryColor,
            hasNotification: _hasUnreadAll,
          ),
          const SizedBox(width: 10),
          _buildTabItem(
            label: 'Rewards',
            index: 1,
            primaryColor: primaryColor,
            hasNotification: _hasUnreadRewards,
          ),
          const SizedBox(width: 10),
          _buildTabItem(
            label: 'Pemberitahuan',
            index: 2,
            primaryColor: primaryColor,
            hasNotification: false, // Asumsi tidak ada notif di sini
          ),
        ],
      ),
    );
  }

  // WIDGET UNTUK SATU BUAH TAB
  Widget _buildTabItem({
    required String label,
    required int index,
    required Color primaryColor,
    bool hasNotification = false,
  }) {
    final bool isSelected = _selectedTabIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Badan Tombol Tab
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Titik Notifikasi Merah
          if (hasNotification)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // WIDGET UNTUK DAFTAR NOTIFIKASI
  Widget _buildNotificationList() {
    // Menggunakan data yang sudah difilter
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Tidak ada notifikasi.')),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return _buildNotificationItem(item);
        },
        // Garis pemisah antar item
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[200],
            indent: 80, // Pemisah mulai dari setelah ikon
            endIndent: 16,
          );
        },
      ),
    );
  }

  // WIDGET UNTUK SATU ITEM NOTIFIKASI
  Widget _buildNotificationItem(NotifikasiItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          // Ikon Latar Belakang
          CircleAvatar(
            radius: 24,
            backgroundColor: item.iconBgColor,
            child: Icon(
              item.icon,
              color: item.iconBgColor == Colors.blue.shade100
                  ? Colors
                        .blue
                        .shade800 // Warna ikon khusus untuk info
                  : Colors.white,
              size: 24,
            ),
          ),
          // Titik "Unread" (Belum Dibaca)
          if (item.isUnread)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red, // Warna titik merah di "Baksos"
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        item.title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        item.subtitle,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        item.time,
        style: TextStyle(color: Colors.grey[500], fontSize: 12),
      ),
      onTap: () {
        // Aksi ketika item notifikasi diklik
        print('Notifikasi diklik: ${item.title}');
        // Di sini Anda bisa mengubah status isUnread menjadi false
        if (item.id == '1') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DetailNotifikasiPage(),
          ),
        );
      }
      },
    );
  }
}
