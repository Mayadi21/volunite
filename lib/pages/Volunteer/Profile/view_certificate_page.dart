import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart'; 

class ViewCertificatePage extends StatelessWidget {
  final String certificateTitle;

  const ViewCertificatePage({super.key, required this.certificateTitle});

  // Fungsi untuk menampilkan Bottom Sheet notifikasi unduhan
  void _showDownloadSuccessDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return DownloadSuccessDialog();
      },
    );
  }

  // Simulasi proses unduhan
  Future<void> _handleDownload(BuildContext context) async {
    // Simulasi penundaan unduhan
    await Future.delayed(const Duration(seconds: 1)); 

    // Setelah selesai, tampilkan dialog
    if (context.mounted) {
      _showDownloadSuccessDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Latar belakang hitam untuk menonjolkan sertifikat
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Sertifikat',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // AppBar putih
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Colors.black), // Ikon unduh
            onPressed: () => _handleDownload(context), // Panggil fungsi unduh
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Placeholder Gambar Sertifikat Penuh
              Container(
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: AspectRatio(
                  aspectRatio: 1.414, // Rasio A4 (vertikal)
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Isi Sertifikat Anda (Contoh Teks)
                        const Text('Pandawara', style: TextStyle(fontSize: 18, color: Color(0xFF1E3A5F), fontWeight: FontWeight.bold)),
                        const Text('Certificate of Achievement', style: TextStyle(fontSize: 24, color: Color(0xFF4C709A))),
                        const SizedBox(height: 10),
                        Text(
                          'Jhon Shamith', 
                          style: TextStyle(
                            fontSize: 36, 
                            color: Color(0xFF1E3A5F), 
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'For successfully completing the volunteer activity.', 
                          style: TextStyle(fontSize: 14, color: Color(0xFF4C709A))
                        ),
                        const Text('Sept 30, 2024', style: TextStyle(fontSize: 14, color: Color(0xFF4C709A))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

// **WIDGET BOTTOM SHEET NOTIFIKASI UNDUH**
class DownloadSuccessDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Garis pegangan
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
          const SizedBox(height: 20),
          
          const Text(
            'Berhasil diunduh!!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kDarkBlueGray,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '(Sertifikat telah ditambahkan ke galeri)',
            style: TextStyle(
              fontSize: 14,
              color: kBlueGray,
            ),
          ),
          const SizedBox(height: 15),
          
          const Text(
            'Kamu bisa cek sertifikatmu di galeri perangkat.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: kDarkBlueGray,
            ),
          ),
          const SizedBox(height: 30),
          
          // Tombol Kembali
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Tutup bottom sheet
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kDarkBlueGray, // Warna biru tua
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Kembali',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10), // Tambahan padding bawah
        ],
      ),
    );
  }
}