import 'package:flutter/material.dart';

// Menggunakan nama ProfilePage agar sesuai dengan LandingPage.dart Anda
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // TIDAK ADA LAGI Scaffold di sini.
    // Langsung kembalikan kontennya, diawali dengan SafeArea.
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Tombol Edit di Kanan Atas ---
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    onPressed: () {},
                  ),
                ),
              ),

              // --- Foto Profil & Nama ---
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Go Youn Jung',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // --- Kartu Volunteer Exp ---
              _buildExperienceCard(),
              const SizedBox(height: 16),

              // --- Kartu Statistik (Kegiatan & Peringkat) ---
              _buildStatsRow(),
              const SizedBox(height: 24),

              // --- Bagian Pencapaian Sertifikat ---
              _buildAchievementSection(
                title: 'Pencapaian Sertifikat',
                items: [
                  _buildCertificateItem('28 Okt 24', 'Pandawara'),
                  _buildCertificateItem('30 Okt 24', 'KMB-USU'),
                  _buildCertificateItem('1 Nov 24', 'Cisco'),
                ],
              ),
              const SizedBox(height: 24),

              // --- Bagian Pencapaian Relawan ---
              _buildAchievementSection(
                title: 'Pencapaian Relawan',
                items: [
                  _buildVolunteerItem(
                      'Penjaga\nHijau', Icons.eco, Colors.green),
                  _buildVolunteerItem(
                      'Juara\nKomunitas', Icons.emoji_events, Colors.blue),
                  _buildVolunteerItem(
                      'Perintis\nPerubahan', Icons.star, Colors.orange),
                ],
              ),
              const SizedBox(height: 24),

              // --- Tombol Keluar ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Keluar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper untuk kartu Volunteer Exp
  Widget _buildExperienceCard() {
    const cardColor = Color(0xFF006064); // Dark Cyan

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Your Volunteer Exp',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '18,000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 18000 / 54000,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '18,000/54,000',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Widget helper untuk baris statistik
  Widget _buildStatsRow() {
    const cardColor = Color(0xFF006064); // Dark Cyan

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '72',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Kegiatan Sukarela',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '3',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('Peringkat Global',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Widget helper untuk section list horizontal (Sertifikat & Relawan)
  Widget _buildAchievementSection(
      {required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150, // Tinggi tetap untuk list horizontal
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) => items[index],
            separatorBuilder: (context, index) => const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }

  // Widget helper untuk item sertifikat
  Widget _buildCertificateItem(String date, String title) {
    return Container(
      width: 120,
      child: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            // Ikon dummy untuk sertifikat
            child: Icon(Icons.school, size: 50, color: Colors.blue[700]),
          ),
          const SizedBox(height: 8),
          Text(date, style: const TextStyle(fontSize: 12)),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget helper untuk item pencapaian relawan
  Widget _buildVolunteerItem(String label, IconData icon, Color color) {
    return Container(
      width: 100,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}