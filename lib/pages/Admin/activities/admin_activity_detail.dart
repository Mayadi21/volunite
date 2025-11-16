import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';

class AdminActivityDetailPage extends StatefulWidget {
  final Activity activity;
  const AdminActivityDetailPage({super.key, required this.activity});

  @override
  State<AdminActivityDetailPage> createState() =>
      _AdminActivityDetailPageState();
}

class _AdminActivityDetailPageState extends State<AdminActivityDetailPage> {
  late Activity _activity;

  @override
  void initState() {
    super.initState();
    _activity = widget.activity;
  }

  void _approveActivity() {
    // Di aplikasi nyata, ini akan memanggil API PATCH/PUT
    // Di sini kita ubah data di mock_data
    setState(() {
      _activity.status = 'Disetujui';
    });
    _showFeedbackAndPop('Kegiatan telah disetujui.');
  }

  void _rejectActivity() {
    // Di aplikasi nyata, ini akan memanggil API PATCH/PUT
    setState(() {
      _activity.status = 'Ditolak';
    });
    _showFeedbackAndPop('Kegiatan telah ditolak.');
  }

  void _showFeedbackAndPop(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // 1. AppBar dengan Gambar (Mirip halaman detail volunteer)
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                _activity.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              background: Image.asset(
                _activity.imageAsset,
                fit: BoxFit.cover,
                // Tambahkan overlay gelap agar judul terbaca
                color: Colors.black.withOpacity(0.4),
                colorBlendMode: BlendMode.darken,
                // Error handling jika aset tidak ditemukan
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, color: Colors.white)
                    ),
                  );
                },
              ),
            ),
          ),
          // 2. Isi Konten
          SliverList(
            delegate: SliverChildListDelegate([
              // Info Penyelenggara
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.business)),
                title: Text(_activity.organizerName),
                subtitle: const Text('Penyelenggara'),
              ),
              // Info Waktu
              ListTile(
                leading:
                    const Icon(Icons.calendar_today, color: primaryColor),
                title: Text(_activity.date),
                subtitle: Text(_activity.time),
              ),
              // Info Lokasi
              ListTile(
                leading: const Icon(Icons.location_on, color: primaryColor),
                title: Text(_activity.location),
                subtitle: const Text('Lokasi'),
              ),
              // Deskripsi
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Kegiatan',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _activity.description,
                      style: const TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100), // Beri ruang untuk tombol
            ]),
          ),
        ],
      ),
      // 3. Tombol Aksi (ACC/Tolak)
      // Hanya tampilkan jika status masih Pending
      bottomSheet: _activity.status == 'Pending'
          ? Container(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 24.0), // Beri padding bawah
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close_rounded),
                      label: const Text('Tolak'),
                      onPressed: _rejectActivity,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      label: const Text('Setujui'),
                      onPressed: _approveActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}