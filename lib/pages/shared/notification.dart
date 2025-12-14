import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/notifikasi_model.dart';
import 'package:volunite/services/notifikasi_service.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  late Future<List<NotifikasiModel>> _futureNotif;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _futureNotif = NotifikasiService.fetchNotifikasi();
    });
  }

  Future<void> _handleTap(NotifikasiModel item) async {
    showDialog(
      context: context,
      builder: (context) => _NotifikasiDialog(item: item),
    );
    if (!item.isRead) {
      setState(() {
        item.isRead = true;
      });
      try {
        await NotifikasiService.markAsRead(item.id);
      } catch (e) {
        debugPrint("Gagal update status read: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<NotifikasiModel>>(
        future: _futureNotif,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: kSkyBlue));
          }
          if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat: ${snapshot.error}", style: const TextStyle(color: kBlueGray)));
          }

          final allData = snapshot.data ?? [];

          final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
          
          final filteredData = allData.where((item) {
            final isRecent = item.createdAt.isAfter(sevenDaysAgo);
            final isUnread = !item.isRead;
            return isRecent || isUnread;
          }).toList();
          // ------------------------------------

          if (filteredData.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.notifications_none_rounded, size: 60, color: kLightGray),
                  SizedBox(height: 12),
                  Text("Tidak ada notifikasi baru", style: TextStyle(color: kBlueGray)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: filteredData.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: kLightGray),
            itemBuilder: (context, index) {
              return _NotifTile(
                item: filteredData[index],
                onTap: () => _handleTap(filteredData[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final NotifikasiModel item;
  final VoidCallback onTap;

  const _NotifTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.notifications;
    Color iconColor = kSkyBlue;

    if (item.judul.contains('Diterima') || item.judul.contains('Selamat')) {
      iconData = Icons.celebration;
      iconColor = Colors.green;
    } else if (item.judul.contains('Kehadiran') || item.judul.contains('Laporan')) {
      iconData = Icons.fact_check;
      iconColor = Colors.orange;
    } else if (item.judul.contains('Pendaftar')) {
      iconData = Icons.person_add;
      iconColor = kBlueGray;
    }

    return ListTile(
      tileColor: item.isRead ? Colors.white : kSkyBlue.withOpacity(0.05), 
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      onTap: onTap,
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(iconData, color: iconColor, size: 24),
          ),
          if (!item.isRead)
            Positioned(
              top: 0, right: 0,
              child: Container(
                width: 12, height: 12,
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
        item.judul,
        style: TextStyle(
          fontWeight: item.isRead ? FontWeight.normal : FontWeight.bold,
          fontSize: 15,
          color: kDarkBlueGray,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            item.subjudul,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: kBlueGray),
          ),
          const SizedBox(height: 6),
          Text(
            _formatTime(item.createdAt),
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return "Baru saja";
    if (diff.inMinutes < 60) return "${diff.inMinutes} menit lalu";
    if (diff.inHours < 24) return "${diff.inHours} jam lalu";
    if (diff.inDays < 7) return "${diff.inDays} hari lalu";
    return DateFormat('dd MMM yyyy').format(time);
  }
}

class _NotifikasiDialog extends StatelessWidget {
  final NotifikasiModel item;
  const _NotifikasiDialog({required this.item});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kSkyBlue.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.notifications_active, color: kSkyBlue, size: 40),
            ),
            const SizedBox(height: 16),
            
            Text(
              item.judul,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray),
            ),
            const SizedBox(height: 8),
            
            Text(
              DateFormat('EEEE, dd MMM yyyy • HH:mm', 'id_ID').format(item.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            
            Text(
              item.subjudul,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
            ),
            
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSkyBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("Tutup", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }
}