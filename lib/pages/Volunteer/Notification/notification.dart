// lib/pages/Volunteer/Notification/notification.dart
import 'package:flutter/material.dart';
import 'detail_notification.dart'; 
import 'package:volunite/color_pallete.dart'; // Impor color palette

// KELAS YANG DAPAT DIMUTASI (Mutable)
class NotifikasiItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  bool isUnread; // ✅ DIUBAH: Hapus 'final' agar nilainya dapat dimodifikasi
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notifikasi Demo',
      theme: ThemeData(
        // Tema utama tidak terlalu memengaruhi karena AppBar menggunakan flexibleSpace
        primaryColor: kDarkBlueGray,
        appBarTheme: const AppBarTheme(backgroundColor: kDarkBlueGray),
        fontFamily: 'Inter',
      ),
      home: const NotifikasiPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// HALAMAN UTAMA NOTIFIKASI
class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  int _selectedTabIndex = 0;

  // --- DATA NOTIFIKASI (DIUBAH MENJADI NON-FINAL) ---
  List<NotifikasiItem> _allNotifications = [
    // ✅ DIUBAH: Hapus 'final'
    NotifikasiItem(
      id: '1',
      title: 'Kegiatan "Baksos" Selesai!',
      subtitle: 'Sertifikatmu telah ditambahkan ke achievement, yuk li...',
      time: '13:25',
      icon: Icons.group_work,
      iconBgColor: kDarkBlueGray,
      isUnread: true,
      category: 'kegiatan',
    ),
    NotifikasiItem(
      id: '2',
      title: 'Voluntree Versi 2.1 Hadir!',
      subtitle: 'Beberapa penyesuaian dapat Anda lihat di sini, sepert...',
      time: '11 Nov 2024',
      icon: Icons.info_outline,
      iconBgColor: kSoftBlue,
      isUnread: false,
      category: 'pemberitahuan',
    ),
    NotifikasiItem(
      id: '3',
      title: 'Promo Pengguna Baru',
      subtitle: 'Untuk pengguna baru, kamu mendapatkan promo 10...',
      time: '07 Nov 2024',
      icon: Icons.percent,
      iconBgColor: kBlueGray,
      isUnread: false,
      category: 'rewards',
    ),
    NotifikasiItem(
      id: '4',
      title: 'Rewards Spesial Untukmu',
      subtitle: 'Klaim voucher diskon 50% khusus untukmu!',
      time: '06 Nov 2024',
      icon: Icons.star_outline,
      iconBgColor: kSkyBlue,
      isUnread: true,
      category: 'rewards',
    ),
  ];

  List<NotifikasiItem> get _filteredNotifications {
    if (_selectedTabIndex == 1) {
      return _allNotifications
          .where((item) => item.category == 'rewards')
          .toList();
    } else if (_selectedTabIndex == 2) {
      return _allNotifications
          .where((item) => item.category == 'pemberitahuan')
          .toList();
    }
    return _allNotifications;
  }

  bool get _hasUnreadRewards => _allNotifications.any(
    (item) => item.category == 'rewards' && item.isUnread,
  );
  bool get _hasUnreadAll => _allNotifications.any((item) => item.isUnread);

  @override
  Widget build(BuildContext context) {
    // const Color primaryColor = kDarkBlueGray; // Tidak terlalu terpakai karena AppBar pakai gradient

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        // ✅ Perubahan AppBar untuk Gradient
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                kBlueGray,
                kSkyBlue,
              ], // Gradient dari BlueGray ke SkyBlue
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // ✅ Perubahan: Kembali ke halaman sebelumnya
            Navigator.pop(context);
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
          _buildTabBar(
            kDarkBlueGray,
          ), // Menggunakan kDarkBlueGray untuk warna teks tab tidak aktif
          _buildNotificationList(),
        ],
      ),
    );
  }

  // WIDGET UNTUK TAB BAR
  Widget _buildTabBar(Color primaryColor) {
    return Container(
      color: kBackground,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          _buildTabItem(
            label: 'Semua',
            index: 0,
            hasNotification: _hasUnreadAll,
          ),
          const SizedBox(width: 10),
          _buildTabItem(
            label: 'Rewards',
            index: 1,
            hasNotification: _hasUnreadRewards,
          ),
          const SizedBox(width: 10),
          _buildTabItem(
            label: 'Pemberitahuan',
            index: 2,
            hasNotification: false,
          ),
        ],
      ),
    );
  }

  // WIDGET UNTUK SATU BUAH TAB
  Widget _buildTabItem({
    required String label,
    required int index,
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              // ✅ Perubahan: Menggunakan kSkyBlue untuk tab terpilih
              color: isSelected ? kSkyBlue : kLightGray,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : kDarkBlueGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
    final notifications = _filteredNotifications;

    if (notifications.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Tidak ada notifikasi.')),
      );
    }

    return Expanded(
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final item = notifications[index];
            return _buildNotificationItem(item);
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 1,
              thickness: 1,
              color: kLightGray,
              indent: 80,
              endIndent: 16,
            );
          },
        ),
      ),
    );
  }

  // WIDGET UNTUK SATU ITEM NOTIFIKASI
  Widget _buildNotificationItem(NotifikasiItem item) {
    Color iconColor = (item.iconBgColor == kSoftBlue)
        ? kDarkBlueGray
        : Colors.white;

    return ListTile(
      // ✅ Perubahan: Latar belakang item unread
      tileColor: item.isUnread ? kLightGray : Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: item.iconBgColor,
            child: Icon(item.icon, color: iconColor, size: 24),
          ),
          if (item.isUnread)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: kDarkBlueGray,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        style: const TextStyle(color: kBlueGray, fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        item.time,
        style: const TextStyle(color: kBlueGray, fontSize: 12),
      ),
      onTap: () {
        print('Notifikasi diklik: ${item.title}');

        // ✅ Perubahan: Set isUnread menjadi false saat diklik
        if (item.isUnread) {
          setState(() {
            item.isUnread = false; // Mengubah status notifikasi
          });
        }

        // Logika navigasi ke detail page (hanya untuk ID '1')
        if (item.id == '1') {
          // Asumsi DetailNotifikasiPage ada dan berfungsi
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
