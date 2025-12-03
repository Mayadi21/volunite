import 'package:flutter/material.dart';
// Asumsikan ini adalah path yang benar ke file color_pallete Anda
import 'package:volunite/color_pallete.dart';
// Asumsikan ini adalah path yang benar ke NotifikasiItem di file notification.dart
import 'notification.dart';

class DetailNotifikasiPage extends StatelessWidget {
  final NotifikasiItem item;
  const DetailNotifikasiPage({super.key, required this.item});

  // Fungsi untuk mendapatkan warna ikon yang sesuai
  Color _getIconColor(Color bgColor) {
    // Sesuaikan logika warna ikon berdasarkan warna latar belakang spesifik
    if (bgColor == Colors.orange.shade200) {
      return Colors.orange.shade800;
    }
    // Warna default untuk ikon adalah putih
    return Colors.white;
  }

  // Fungsi untuk mendapatkan teks aksi yang sesuai berdasarkan kategori
  String _getActionText(String category) {
    switch (category) {
      case 'kegiatan':
        return 'Lihat Pendaftar';
      case 'pemberitahuan':
        return 'Lihat Event';
      case 'rewards':
        return 'Lihat Rewards';
      default:
        return 'Kembali';
    }
  }

  // Fungsi yang dipanggil saat tombol aksi ditekan
  void _handleAction(BuildContext context, String category) {
    // Anda bisa mengganti ini dengan navigasi aktual ke halaman yang sesuai
    String actionMessage = '';
    switch (category) {
      case 'kegiatan':
        actionMessage = 'Mengarahkan ke Halaman Pendaftar Event...';
        // TODO: Ganti dengan Navigator.push ke halaman detail pendaftar
        break;
      case 'pemberitahuan':
        actionMessage = 'Mengarahkan ke Halaman Detail Event...';
        // TODO: Ganti dengan Navigator.push ke halaman detail event
        break;
      case 'rewards':
        actionMessage = 'Mengarahkan ke Halaman Rewards Organizer...';
        // TODO: Ganti dengan Navigator.push ke halaman rewards
        break;
      default:
        Navigator.of(context).pop();
        return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(actionMessage)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // AppBar dengan Gradient seperti NotifikasiPage
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [kBlueGray, kSkyBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ICON & TITLE
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: item.iconBgColor,
                    child: Icon(
                      item.icon,
                      color: _getIconColor(item.iconBgColor),
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.time,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              // ISI NOTIFIKASI
              Text(
                item.subtitle,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              // BUTTON AKSI
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSkyBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => _handleAction(context, item.category),
                    child: Text(
                      _getActionText(item.category),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
