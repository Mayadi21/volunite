// lib/pages/Organizer/Activity/detail_activities_page.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart'; // Asumsikan impor ini ada di file utama Anda


const kPrimaryColor = kSkyBlue; // Ditetapkan sebagai warna utama

class OrganizerDetailActivityPage extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String imagePath;

  const OrganizerDetailActivityPage({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  @override
  State<OrganizerDetailActivityPage> createState() =>
      _OrganizerDetailActivityPageState();
}

class _OrganizerDetailActivityPageState
    extends State<OrganizerDetailActivityPage> {
  bool _isDescriptionExpanded = false;

  final String fullDescription =
      'Kegiatan volunteer yang mengajak Anda untuk berbagi ilmu dan inspirasi kepada anak-anak yang membutuhkan. Melalui acara ini, Anda dapat berkontribusi dalam memberikan pendidikan dan pengalaman belajar yang menyenangkan. Mari bersama-sama menciptakan perubahan positif dan memberikan dampak nyata bagi generasi muda.';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // final primary = Theme.of(context).colorScheme.primary; // Diganti
    final primary = kPrimaryColor; // Gunakan warna utama dari palet

    return Scaffold(
      backgroundColor: kBackground, // Menggunakan warna latar belakang dari palet
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar Gambar
              SliverAppBar(
                expandedHeight: screenHeight * 0.35,
                pinned: true,
                backgroundColor: primary, // Menggunakan kPrimaryColor
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kDarkBlueGray.withOpacity(0.3), // Warna yang lebih gelap
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  // --- Tombol Edit ---
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kDarkBlueGray.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Edit Kegiatan',
                        onPressed: () {
                          // TODO: Navigasi ke halaman Edit Kegiatan
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kDarkBlueGray.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Image.asset(widget.imagePath, fit: BoxFit.cover),
                ),
              ),

              // 2. Header Konten yang Pinned
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyPinnedHeaderDelegate(
                  title: widget.title,
                  date: widget.date,
                  time: widget.time,
                ),
              ),

              // 3. Konten yang Bisa Scroll
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white, // Konten tetap putih untuk kontras
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ).copyWith(top: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Statistik Pendaftar (Khusus Organizer) ---
                        _buildOrganizerStatsCard(primary),
                        const SizedBox(height: 24),

                        _buildLocationCard(),
                        const SizedBox(height: 24),

                        const Divider(
                          color: kLightGray, // Menggunakan kLightGray
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 24),

                        // --- Deskripsi ---
                        const Text(
                          'Deskripsi Kegiatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray, // Warna teks gelap
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fullDescription,
                          maxLines: _isDescriptionExpanded ? null : 4,
                          overflow: _isDescriptionExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: kDarkBlueGray.withOpacity(0.8), // Warna teks abu-abu
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          child: Text(
                            _isDescriptionExpanded
                                ? 'Lihat Lebih Sedikit'
                                : 'Lihat Lebih Banyak',
                            style: TextStyle(
                              color: primary, // Warna Primary
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Syarat dan Ketentuan ---
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: const Text(
                              'Syarat dan Ketentuan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkBlueGray,
                              ),
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(
                              top: 8,
                              bottom: 16,
                            ),
                            children: [
                              _buildRequirementItem(
                                'Mahasiswa/i semester 3,5,7',
                              ),
                              _buildRequirementItem(
                                'Memiliki pengalaman organisasi',
                              ),
                              _buildRequirementItem(
                                'Mampu bekerja dalam sebuah tim',
                              ),
                              _buildRequirementItem('Kreatif'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // --- Dokumen Pendukung ---
                        const Text(
                          'Dokumen Pendukung',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildDocumentCard(),

                        // Padding bawah ekstra agar konten tidak tertutup bottom bar
                        SizedBox(height: bottomPadding + 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar Melayang (Versi Organizer)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(primary),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KHUSUS ORGANIZER: Statistik Pendaftar ---
  Widget _buildOrganizerStatsCard(Color primary) {
    int current = 46;
    int quota = 60;
    double progress = current / quota;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSoftBlue.withOpacity(0.3), // Menggunakan kSoftBlue
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSoftBlue), // Menggunakan kSoftBlue
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Status Pendaftaran",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: kDarkBlueGray), // Warna teks gelap
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green, // Tetap hijau untuk "Aktif"
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Aktif",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$current Pendaftar",
                style: TextStyle(
                  color: primary, // Warna Primary
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                "Kuota: $quota",
                style: TextStyle(color: kDarkBlueGray.withOpacity(0.7), fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: kSoftBlue, // Latar belakang progress bar
              color: primary, // Warna Primary
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "12 pelamar belum diverifikasi",
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange, // Tetap orange untuk peringatan
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kLightGray.withOpacity(0.5), // Menggunakan kLightGray
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sekretariat KMB-USU',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: kDarkBlueGray),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jalan Brigjend Katamso Dalam No.62. A U R, Kec. Medan Maimun, Kota Medan',
                    style: TextStyle(
                        fontSize: 12, color: kDarkBlueGray.withOpacity(0.7)),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map, size: 16),
                    label: const Text('Lihat Peta'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: kDarkBlueGray,
                      elevation: 0,
                      side: BorderSide(color: kLightGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- BOTTOM BAR KHUSUS ORGANIZER ---
  Widget _buildBottomBar(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ).copyWith(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          // Tombol Sekunder: Tutup/Pause
          Expanded(
            flex: 1,
            child: OutlinedButton(
              onPressed: () {
                // Logic Tutup Pendaftaran
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Tutup',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Primer: Lihat Pelamar
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {
                // Navigasi ke List Pelamar
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary, // Warna Primary
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Lihat Pelamar (12)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: kDarkBlueGray,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard() {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kLightGray.withOpacity(0.5), // Menggunakan kLightGray
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kLightGray, width: 1),
        ),
        child: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: kDarkBlueGray.withOpacity(0.8), size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dokumen Pedoman Volunteer.pdf',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kDarkBlueGray),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Klik untuk preview',
                    style: TextStyle(
                        fontSize: 12, color: kDarkBlueGray.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.visibility_outlined, color: kDarkBlueGray),
          ],
        ),
      ),
    );
  }
}

// --- DELEGATE HEADER (Menggunakan kBlueGray dan kDarkBlueGray) ---
class _MyPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String date;
  final String time;

  final double _minHeight = 150; // Sedikit disesuaikan
  final double _maxHeight = 150;

  _MyPinnedHeaderDelegate({
    required this.title,
    required this.date,
    required this.time,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // final primary = Theme.of(context).colorScheme.primary; // Diganti
    final primary = kPrimaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkBlueGray),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTag(context, 'Pendidikan', Icons.school_outlined),
                const SizedBox(width: 8),
                _buildTag(context, 'Sosial', Icons.people_outline),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoRow(Icons.calendar_today_outlined, date),
                const Spacer(),
                _buildInfoRow(Icons.access_time_outlined, time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, IconData icon) {
    // final primary = Theme.of(context).colorScheme.primary; // Diganti
    final primary = kPrimaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kDarkBlueGray.withOpacity(0.7), size: 16),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14, color: kDarkBlueGray)),
      ],
    );
  }

  @override
  double get maxExtent => _maxHeight;

  @override
  double get minExtent => _minHeight;

  @override
  bool shouldRebuild(covariant _MyPinnedHeaderDelegate oldDelegate) {
    return title != oldDelegate.title ||
        date != oldDelegate.date ||
        time != oldDelegate.time;
  }
}