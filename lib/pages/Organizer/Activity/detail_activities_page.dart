import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Wajib untuk format tanggal
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart'; // Import Model
import 'package:volunite/pages/Organizer/Activity/edit_activity_page.dart';

const kPrimaryColor = kSkyBlue;

class OrganizerDetailActivityPage extends StatefulWidget {
  // Menerima Model Kegiatan Utuh
  final Kegiatan kegiatan; 

  const OrganizerDetailActivityPage({
    super.key,
    required this.kegiatan,
  });

  @override
  State<OrganizerDetailActivityPage> createState() => _OrganizerDetailActivityPageState();
}

class _OrganizerDetailActivityPageState extends State<OrganizerDetailActivityPage> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final primary = kPrimaryColor;
    
    // Parsing Data dari Model
    final item = widget.kegiatan;
    final start = item.tanggalMulai ?? DateTime.now();
    final end = item.tanggalBerakhir ?? DateTime.now();
    
    // Format Tanggal & Jam
    final dateStr = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(start); // Perlu locale id_ID di main.dart idealnya
    final timeStr = '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)} WIB';

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar Gambar
              SliverAppBar(
                expandedHeight: screenHeight * 0.35,
                pinned: true,
                backgroundColor: primary,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: kDarkBlueGray.withOpacity(0.3),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  // Tombol Edit
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: kDarkBlueGray.withOpacity(0.3),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        tooltip: 'Edit Kegiatan',
                        onPressed: () async {
                          // Navigasi ke Halaman Edit dengan membawa object kegiatan
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditActivityPage(kegiatan: item),
                            ),
                          );
                          
                          // Jika berhasil update (result == true), refresh halaman ini?
                          // Idealnya pakai setState atau reload data, tapi karena ini detail,
                          // biasanya user back dulu ke dashboard untuk refresh.
                          if (result == true) {
                            if (mounted) Navigator.pop(context, true); // Balik ke dashboard minta refresh
                          }
                        },
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: item.thumbnail != null
                      ? Image.network(item.thumbnail!, fit: BoxFit.cover)
                      : Container(color: Colors.grey, child: const Icon(Icons.image, size: 50, color: Colors.white)),
                ),
              ),

              // 2. Header Konten yang Pinned (Judul)
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyPinnedHeaderDelegate(
                  title: item.judul,
                  date: dateStr,
                  time: timeStr,
                  // Ambil kategori pertama dan kedua jika ada
                  tags: item.kategori.take(2).map((e) => e.namaKategori).toList(), 
                ),
              ),

              // 3. Konten Scrollable
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistik Pendaftar
                        _buildOrganizerStatsCard(primary, item.kuota ?? 0),
                        const SizedBox(height: 24),

                        // Lokasi
                        _buildLocationCard(item.lokasi ?? "Lokasi belum ditentukan"),
                        const SizedBox(height: 24),

                        const Divider(color: kLightGray, thickness: 1, height: 1),
                        const SizedBox(height: 24),

                        // Deskripsi
                        const Text('Deskripsi Kegiatan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                        const SizedBox(height: 8),
                        Text(
                          item.deskripsi ?? "Tidak ada deskripsi",
                          maxLines: _isDescriptionExpanded ? null : 4,
                          overflow: _isDescriptionExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, color: kDarkBlueGray.withOpacity(0.8), height: 1.5),
                        ),
                        InkWell(
                          onTap: () => setState(() => _isDescriptionExpanded = !_isDescriptionExpanded),
                          child: Text(
                            _isDescriptionExpanded ? 'Lihat Lebih Sedikit' : 'Lihat Lebih Banyak',
                            style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Syarat & Ketentuan
                        Theme(
                          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: const Text('Syarat dan Ketentuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: kDarkBlueGray)),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(top: 8, bottom: 16),
                            children: [
                              _buildRequirementItem(item.syaratKetentuan ?? "-"),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: bottomPadding + 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _buildBottomBar(primary),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS ---

  Widget _buildOrganizerStatsCard(Color primary, int quota) {
    // TODO: Nanti ambil data real pendaftar dari backend (relasi pendaftaran)
    int current = 0; 
    double progress = (quota > 0) ? current / quota : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSoftBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kSoftBlue),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status Pendaftaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkBlueGray)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(8)),
                child: const Text("Aktif", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$current Pendaftar", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Kuota: $quota", style: TextStyle(color: kDarkBlueGray.withOpacity(0.7), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: progress, minHeight: 10, backgroundColor: kSoftBlue, color: primary),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(String location) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: kLightGray.withOpacity(0.5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.location_on, size: 40, color: kSkyBlue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lokasi Pelaksanaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: kDarkBlueGray)),
                  const SizedBox(height: 4),
                  Text(location, style: TextStyle(fontSize: 12, color: kDarkBlueGray.withOpacity(0.7))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16).copyWith(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Lihat Pelamar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14, color: kDarkBlueGray, height: 1.4))),
        ],
      ),
    );
  }
}

// --- DELEGATE HEADER (Disesuaikan untuk menerima List String tags) ---
class _MyPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String date;
  final String time;
  final List<String> tags;

  final double _minHeight = 150;
  final double _maxHeight = 150;

  _MyPinnedHeaderDelegate({
    required this.title,
    required this.date,
    required this.time,
    required this.tags,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final primary = kPrimaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: kDarkBlueGray), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),
            Row(
              children: tags.map((tag) => Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildTag(context, tag),
              )).toList(),
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

  Widget _buildTag(BuildContext context, String label) {
    final primary = kPrimaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(color: primary, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kDarkBlueGray.withOpacity(0.7), size: 16),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: kDarkBlueGray)),
      ],
    );
  }

  @override
  double get maxExtent => _maxHeight;
  @override
  double get minExtent => _minHeight;
  @override
  bool shouldRebuild(covariant _MyPinnedHeaderDelegate oldDelegate) {
    return title != oldDelegate.title || date != oldDelegate.date;
  }
}