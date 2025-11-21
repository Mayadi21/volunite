import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart'; 
import 'view_certificate_page.dart'; 

class CertificateDetailPage extends StatelessWidget {
  final String date;
  final String title;
  final String description;

  const CertificateDetailPage({
    super.key,
    required this.date,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Sertifikat',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
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
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Bagian Lingkungan/Kategori
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.eco, color: kSkyBlue),
                  const SizedBox(width: 8),
                  const Text(
                    'Lingkungan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlueGray,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Gambar Sertifikat (Placeholder)
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: kLightGray,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/images/certificate_icon.png',
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.assignment, size: 100, color: kBlueGray),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),

              // Tanggal dan Nama Organisasi
              Text(
                date,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlueGray,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kBlueGray,
                ),
              ),
              const SizedBox(height: 20),

              // Deskripsi Kegiatan
              const Text(
                'Deskripsi Kegiatan:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlueGray,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 14,
                  color: kDarkBlueGray,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Lihat Sertifikat (DIUBAH UNTUK NAVIGASI)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // **[LOGIKA NAVIGASI BARU]**
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewCertificatePage(
                          certificateTitle: title,
                          // Anda mungkin ingin meneruskan path/URL sertifikat asli di sini
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kSkyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lihat Sertifikat',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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