import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart'; // Impor color palette

class DetailActivitiesPage extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String imagePath;

  const DetailActivitiesPage({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  @override
  State<DetailActivitiesPage> createState() => _DetailActivitiesPageState();
}

class _DetailActivitiesPageState extends State<DetailActivitiesPage> {
  bool _isDescriptionExpanded = false;

  final String fullDescription =
      'Kegiatan volunteer yang mengajak Anda untuk berbagi ilmu dan inspirasi kepada anak-anak yang membutuhkan. Melalui acara ini, Anda dapat berkontribusi dalam memberikan pendidikan dan pengalaman belajar yang menyenangkan. Mari bersama-sama menciptakan perubahan positif dan memberikan dampak nyata bagi generasi muda. Gabung sekarang dan jadilah bagian dari gerakan kebaikan ini!';

  // --- Form Report ---
  void _showReportForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    String? selectedComplaintType;

    final List<String> complaintOptions = [
      'Informasi Palsu (Hoax)',
      'Penipuan',
      'Ujaran Kebencian',
      'Konten Tidak Pantas',
      'Spam',
      'Lainnya',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: kBackground,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Laporkan Kegiatan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: kBlueGray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      "Jenis Keluhan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedComplaintType,
                      icon: const Icon(Icons.arrow_drop_down, color: kBlueGray),
                      decoration: InputDecoration(
                        hintText: 'Pilih jenis masalah',
                        hintStyle: const TextStyle(color: kBlueGray),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: kSoftBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: kSkyBlue,
                            width: 1.3,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: complaintOptions.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: kDarkBlueGray),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          selectedComplaintType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap pilih jenis keluhan';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text(
                      "Deskripsi Keluhan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Jelaskan detail masalah yang Anda temukan...',
                        hintStyle: const TextStyle(color: kBlueGray),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: kSkyBlue,
                            width: 1.3,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Laporan berhasil dikirim'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkBlueGray,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Kirim Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
                elevation: 0,
                backgroundColor: kBlueGray,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.35),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                actions: [
                  // Tombol Report
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.35),
                      child: IconButton(
                        icon: const Icon(
                          Icons.flag_outlined,
                          color: Colors.white,
                        ),
                        tooltip: 'Laporkan',
                        onPressed: () => _showReportForm(context),
                      ),
                    ),
                  ),
                  // Tombol Share
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.35),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(widget.imagePath, fit: BoxFit.cover),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.15),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Header Konten
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyPinnedHeaderDelegate(
                  title: widget.title,
                  date: widget.date,
                  time: widget.time,
                ),
              ),

              // 3. Konten Scroll
              SliverToBoxAdapter(
                child: Container(
                  color: kBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildLocationCard(),
                        const SizedBox(height: 24),
                        _buildParticipantsInfo(),
                        const SizedBox(height: 24),
                        const Divider(
                          color: Color(0x11000000),
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 24),

                        // Deskripsi
                        const Text(
                          'Deskripsi Kegiatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          fullDescription,
                          maxLines: _isDescriptionExpanded ? null : 4,
                          overflow: _isDescriptionExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kBlueGray,
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
                            style: const TextStyle(
                              color: kSkyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Syarat & Ketentuan
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
                              _buildRequirementItem(
                                'Mampu bekerja dibawah tekanan',
                              ),
                              _buildRequirementItem('Kreatif'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Dokumen Pendukung
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
                        const SizedBox(height: 24),

                        // Pihak Penyelenggara
                        const Text(
                          'Pihak Penyelenggara',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildOrganizersList(),

                        SizedBox(height: bottomPadding + 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  Widget _buildLocationCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      shadowColor: kBlueGray.withOpacity(0.18),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
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
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Jalan Brigjend Katamso Dalam No.62. A U R, Kec. Medan Maimun, Kota Medan',
                    style: TextStyle(
                      fontSize: 12,
                      color: kBlueGray,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on_outlined, size: 16),
                    label: const Text('Dapatkan Lokasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSkyBlue,
                      foregroundColor: Colors.white,
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

  Widget _buildParticipantsInfo() {
    Widget buildAvatar(String url) {
      return CircleAvatar(radius: 15, backgroundImage: NetworkImage(url));
    }

    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 30,
                child: buildAvatar(
                  'https://randomuser.me/api/portraits/women/1.jpg',
                ),
              ),
              Positioned(
                left: 15,
                child: buildAvatar(
                  'https://randomuser.me/api/portraits/men/1.jpg',
                ),
              ),
              buildAvatar('https://randomuser.me/api/portraits/women/2.jpg'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '43+ Bergabung',
          style: TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_border,
                  color: kSkyBlue,
                  size: 28,
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '0 suka',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: kBlueGray,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: kSkyBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            ),
            child: const Text(
              'Daftar Kegiatan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          const Icon(Icons.check_circle, color: kSkyBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
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
          color: kBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kSoftBlue.withOpacity(0.9), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.picture_as_pdf, size: 40, color: kDarkBlueGray),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Dokumen Pedoman Volunteer.pdf',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kDarkBlueGray,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Klik untuk melihat',
                    style: TextStyle(fontSize: 12, color: kBlueGray),
                  ),
                ],
              ),
            ),
            const Icon(Icons.download_for_offline_outlined, color: kSkyBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildOrganizersList() {
    final List<String> logoPaths = [
      'assets/images/event1.jpg',
      'assets/images/event2.jpg',
      'assets/images/event1.jpg',
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: logoPaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kSoftBlue.withOpacity(0.9), width: 1),
                image: DecorationImage(
                  image: AssetImage(logoPaths[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// --- DELEGATE UNTUK HEADER YANG PINNED ---
class _MyPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String date;
  final String time;

  final double _minHeight = 170;
  final double _maxHeight = 170;

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kDarkBlueGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTag('Pendidikan', Icons.school_outlined),
                const SizedBox(width: 8),
                _buildTag('Sosial', Icons.people_outline),
              ],
            ),
            const SizedBox(height: 8),
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

  Widget _buildTag(String label, IconData icon) {
    return Chip(
      avatar:  Icon(icon, size: 16, color: kDarkBlueGray),
      label: Text(label),
      backgroundColor: kSoftBlue,
      labelStyle: const TextStyle(
        color: kDarkBlueGray,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kSkyBlue),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
         Icon(icon, color: kBlueGray, size: 16),
        const SizedBox(width: 4),
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
    return title != oldDelegate.title ||
        date != oldDelegate.date ||
        time != oldDelegate.time;
  }
}
