import 'package:flutter/material.dart';

class DetailNotifikasiPage extends StatelessWidget {
  const DetailNotifikasiPage({super.key});

  // Warna utama yang sama dengan halaman notifikasi
  static const Color primaryColor = Color(0xFF005271);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // 1. Konten yang bisa di-scroll
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Header ---
                    _buildHeader(),
                    const SizedBox(height: 32),

                    // --- Grid Rewards ---
                    _buildRewardsGrid(),
                    const SizedBox(height: 32),

                    // --- Teks Deskripsi ---
                    _buildDescriptionText(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // 2. Tombol Klaim (Menempel di Bawah)
          _buildClaimButton(context),
        ],
      ),
    );
  }

  // Widget untuk Header (Ikon, Judul, Tanggal)
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ikon
        CircleAvatar(
          radius: 24,
          // Gunakan ikon yang sama dari list notifikasi
          backgroundColor: Colors.blue.shade700,
          child: const Icon(Icons.group_work, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        // Teks Judul dan Tanggal
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kegiatan “Baksos” Selesai!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '4 Desember 2024 13.25.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk Grid 3 Hadiah
  Widget _buildRewardsGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildRewardItem(
          imagePath: 'assets/images/certificate.png', // <-- Perlu asset
          line1: 'Sertifikat',
          line2: 'Pandawara',
        ),
        _buildRewardItem(
          imagePath: 'assets/images/coins.png', // <-- Perlu asset
          line1: '5.000',
          line2: 'Koin',
        ),
        _buildRewardItem(
          imagePath: 'assets/images/exp.png', // <-- Perlu asset
          line1: '5.000',
          line2: 'EXP',
        ),
      ],
    );
  }

  // Widget untuk satu item hadiah (Gambar + Teks)
  Widget _buildRewardItem({
    required String imagePath,
    required String line1,
    required String line2,
  }) {
    // Ukuran gambar dan font
    const double imageSize = 90;
    const double fontHeight = 1.3;

    return Expanded(
      child: Column(
        children: [
          // Gambar 3D (Ganti dengan placeholder jika belum ada)
          Image.asset(
            imagePath,
            height: imageSize,
            width: imageSize,
            // Error handling jika gambar tidak ditemukan
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: imageSize,
                width: imageSize,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
              );
            },
          ),
          const SizedBox(height: 12),
          // Teks
          Text(
            line1,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: fontHeight,
            ),
          ),
          Text(
            line2,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              height: fontHeight,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk Teks Deskripsi
  Widget _buildDescriptionText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selamat!! kamu baru saja mendapatkan sertifikat. Ikut kegiatan lainnya dan dapatkan lebih banyak sertifikat.',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sertifikatmu akan ditambahkan ke bagian achievement, yuk lihat pencapaianmu kali ini. Sertifikat Pandawara ini bersifat resmi langsung dari CEO perusahaan Pandawara.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Klik button di bawah ini untuk pergi ke laman yang dibeli.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // Widget untuk Tombol Klaim di Bawah
  Widget _buildClaimButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32), // Padding bawah
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Sesuai gambar
          ),
        ),
        onPressed: () {
          // Aksi tombol klaim, panggil bottom sheet
          _showClaimSuccessSheet(context);
        },
        child: const Text(
          'Klaim',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  // METHOD BARU UNTUK MENAMPILKAN POP-UP
  void _showClaimSuccessSheet(BuildContext context) {
    // Warna tombol dari gambar (sama dengan primaryColor)
    const Color buttonColor = Color(0xFF005271);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Padding(
          // Padding untuk seluruh konten sheet
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Agar tinggi sheet pas konten
            children: [
              // 1. "Drag Handle"
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // 2. Teks Judul
              const Text(
                'Berhasil di klaim!!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),

              // 3. Teks Subjudul
              Text(
                '(Hadiah telah ditambahkan ke akunmu)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Teks Deskripsi
              Text(
                'Kamu bisa cek sertifikat dan jumlah koinmu di halaman poin.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // 5. Tombol
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor, // Warna dari gambar
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30), // Sangat bulat
                    ),
                  ),
                  onPressed: () {
                    // 1. Tutup bottom sheet
                    Navigator.of(sheetContext).pop();
                    // 2. Tutup halaman Detail Notifikasi
                    Navigator.of(context).pop();

                    // TODO: Tambahkan navigasi ke Halaman Poin di sini jika perlu
                    // cth: Navigator.pushNamed(context, '/halamanPoin');
                  },
                  child: const Text(
                    'Lihat Halaman Poin',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}