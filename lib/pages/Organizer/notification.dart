import 'package:flutter/material.dart';
import 'package:volunite/pages/Organizer/navbar.dart';

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

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  int _selectedTabIndex = 0; // 0: Semua, 1: Rewards, 2: Pemberitahuan

  final List<NotifikasiItem> _allNotifications = [
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
          .where((i) => i.category == 'pemberitahuan')
          .toList();
    }
    return _allNotifications;
  }

  bool get _hasUnreadRewards =>
      _allNotifications.any((i) => i.category == 'rewards' && i.isUnread);
  bool get _hasUnreadAll => _allNotifications.any((i) => i.isUnread);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005271);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final popped = await Navigator.maybePop(context);
            if (!popped) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OrganizerLandingPage()),
              );
            }
          },
        ),
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [_buildTabBar(primaryColor), _buildNotificationList()],
      ),
    );
  }

  Widget _buildTabBar(Color primaryColor) {
    return Container(
      color: Colors.white,
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
            hasNotification: false,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String label,
    required int index,
    required Color primaryColor,
    bool hasNotification = false,
  }) {
    final bool isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
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

  Widget _buildNotificationList() {
    final notifications = _filteredNotifications;
    if (notifications.isEmpty) {
      return const Expanded(
        child: Center(child: Text('Tidak ada notifikasi.')),
      );
    }

    return Expanded(
      child: ListView.separated(
        itemCount: notifications.length,
        itemBuilder: (context, index) =>
            _buildNotificationItem(notifications[index]),
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[200],
          indent: 80,
          endIndent: 16,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotifikasiItem item) {
    return ListTile(
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
            child: Icon(
              item.icon,
              color: item.iconBgColor == Colors.orange.shade200
                  ? Colors.orange.shade800
                  : Colors.white,
              size: 24,
            ),
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
        // Contoh aksi: buka detail notifikasi
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

class DetailNotifikasiPage extends StatelessWidget {
  final NotifikasiItem item;
  const DetailNotifikasiPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF005271);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final popped = await Navigator.maybePop(context);
            if (!popped) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const OrganizerLandingPage()),
              );
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: item.iconBgColor,
                  child: Icon(item.icon, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item.time,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 16),
            Text(item.subtitle, style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }
}
