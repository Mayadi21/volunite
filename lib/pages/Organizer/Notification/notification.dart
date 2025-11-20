// lib/pages/Organizer/Notification/notification.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'detail_notification.dart';


// --- KELAS MODEL DATA ---
class NotifikasiItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  bool isUnread; // ✅ DIUBAH: Dibuat mutable (non-final)
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

// --- HALAMAN UTAMA NOTIFIKASI ---
class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  int _selectedTabIndex = 0; // 0: Semua, 1: Rewards, 2: Pemberitahuan

  // ✅ DIUBAH: Dibuat non-final agar isUnread dapat dimodifikasi
  List<NotifikasiItem> _allNotifications = [
    NotifikasiItem(
      id: '1',
      title: 'Pendaftaran Volunteer Baru',
      subtitle: 'Ada pendaftar baru pada kegiatan "Baksos Desa"',
      time: '09:30',
      icon: Icons.person_add,
      iconBgColor: Colors.green.shade700,
      isUnread: true,
      category: 'kegiatan',
    ),
    NotifikasiItem(
      id: '2',
      title: 'Permintaan Verifikasi Event',
      subtitle: 'Event "Donor Darah" menunggu verifikasi Anda',
      time: '11 Nov 2025',
      icon: Icons.pending_actions,
      iconBgColor: Colors.orange.shade200,
      isUnread: false,
      category: 'pemberitahuan',
    ),
    NotifikasiItem(
      id: '3',
      title: 'Reward untuk Penyelenggara',
      subtitle: 'Dapatkan badge khusus setelah 5 event sukses',
      time: '05 Nov 2025',
      icon: Icons.emoji_events_outlined,
      iconBgColor: Colors.yellow.shade700,
      isUnread: false,
      category: 'rewards',
    ),
  ];

  List<NotifikasiItem> get _filteredNotifications {
    if (_selectedTabIndex == 1) {
      return _allNotifications.where((i) => i.category == 'rewards').toList();
    } else if (_selectedTabIndex == 2) {
      return _allNotifications
          .where(
            (i) => i.category == 'pemberitahuan' || i.category == 'kegiatan',
          )
          .toList();
    }
    return _allNotifications;
  }

  bool get _hasUnreadRewards =>
      _allNotifications.any((i) => i.category == 'rewards' && i.isUnread);
  bool get _hasUnreadAll => _allNotifications.any((i) => i.isUnread);

  @override
  Widget build(BuildContext context) {
    // const Color primaryColor = Color(0xFF005271); // Warna Organizer lama
    const Color primaryColor = kSkyBlue; // Gunakan warna dari palet

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
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
            // Logika kembali ke OrganizerLandingPage
            Navigator.pop(context);
            // Anda mungkin perlu menyesuaikan navigasi ini berdasarkan struktur project Anda
            // final popped = await Navigator.maybePop(context);
            // if (!popped) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (_) => const OrganizerLandingPage()),
            //   );
            // }
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
        children: [_buildTabBar(primaryColor), _buildNotificationList()],
      ),
    );
  }

  // WIDGET UNTUK TAB BAR
  Widget _buildTabBar(Color primaryColor) {
    return Container(
      // ✅ DIUBAH: Background kBackground
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
            hasNotification: _allNotifications.any(
              (i) =>
                  (i.category == 'pemberitahuan' || i.category == 'kegiatan') &&
                  i.isUnread,
            ), // Tambahkan pengecekan unread untuk kategori lain
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
    // Ganti primaryColor dengan kDarkBlueGray untuk tab non-aktif
    final Color selectedColor = kSkyBlue;
    final Color unselectedBgColor = kLightGray;
    final Color unselectedTextColor = kDarkBlueGray;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              // ✅ DIUBAH: Warna mengikuti Volunteer
              color: isSelected ? selectedColor : unselectedBgColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                // ✅ DIUBAH: Warna teks mengikuti Volunteer
                color: isSelected ? Colors.white : unselectedTextColor,
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
      // ✅ DIUBAH: Background Colors.white untuk ListView
      child: Container(
        color: Colors.white,
        child: ListView.separated(
          itemCount: notifications.length,
          itemBuilder: (context, index) =>
              _buildNotificationItem(notifications[index]),
          separatorBuilder: (context, index) => const Divider(
            height: 1,
            thickness: 1,
            // ✅ DIUBAH: Warna Divider kLightGray
            color: kLightGray,
            indent: 80,
            endIndent: 16,
          ),
        ),
      ),
    );
  }

  // WIDGET UNTUK SATU ITEM NOTIFIKASI
  Widget _buildNotificationItem(NotifikasiItem item) {
    // Penyesuaian warna ikon agar sesuai dengan warna di item
    Color iconColor = (item.iconBgColor == Colors.orange.shade200)
        ? Colors.orange.shade800
        : Colors.white;

    return ListTile(
      // ✅ DIUBAH: Tambahkan tileColor untuk item unread
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
          // ✅ DIUBAH: Warna teks title
          color: kDarkBlueGray,
        ),
      ),
      subtitle: Text(
        item.subtitle,
        // ✅ DIUBAH: Warna teks subtitle
        style: const TextStyle(color: kBlueGray, fontSize: 13),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        item.time,
        // ✅ DIUBAH: Warna teks trailing
        style: const TextStyle(color: kBlueGray, fontSize: 12),
      ),
      onTap: () {
        // ✅ DIUBAH: Set isUnread menjadi false saat diklik
        if (item.isUnread) {
          setState(() {
            item.isUnread = false;
          });
        }

        // Navigasi ke detail notifikasi
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailNotifikasiPage(item: item),
          ),
        );
      },
    );
  }
}


