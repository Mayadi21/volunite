import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Organizer/Activity/edit_activity_page.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_list_page.dart';

class OrganizerDetailActivityPage extends StatelessWidget {
  final Kegiatan kegiatan;
  const OrganizerDetailActivityPage({super.key, required this.kegiatan});

  @override
  Widget build(BuildContext context) {
    final item = kegiatan;
    final start = item.tanggalMulai ?? DateTime.now();
    final end = item.tanggalBerakhir ?? DateTime.now();

    final dateStr = DateFormat('EEEE, dd MMM yyyy', 'id_ID').format(start);
    final timeStr =
        '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)} WIB';
    final pendaftar = item.pendaftarCount;
    final kuota = item.kuota ?? 0;

    // Cek apakah boleh diedit (Jika status selesai/batal/ditolak, tombol edit hilang)
    bool canEdit = !['finished', 'cancelled', 'Rejected'].contains(item.status);

    return Scaffold(
      backgroundColor: kBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: kSkyBlue,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: kDarkBlueGray),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (canEdit)
                IconButton(
                  icon: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, color: kSkyBlue),
                  ),
                  onPressed: () async {
                    final res = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditActivityPage(kegiatan: item),
                      ),
                    );
                    if (res == true && context.mounted)
                      Navigator.pop(context, true);
                  },
                ),
              const SizedBox(width: 16),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: item.thumbnail != null
                  ? Image.network(item.thumbnail!, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                decoration: const BoxDecoration(
                  color: kBackground,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge Status
                      _buildStatusBadge(item.status),
                      const SizedBox(height: 12),

                      Text(
                        item.judul,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: kDarkBlueGray,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Statistik
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: kLightGray, blurRadius: 5),
                          ],
                        ),
                        child: Row(
                          children: [
                            _buildStatItem(
                              "Kuota",
                              "$kuota Orang",
                              Icons.group_outlined,
                              kBlueGray,
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: kLightGray,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                            ),
                            _buildStatItem(
                              "Terisi",
                              "$pendaftar Orang",
                              Icons.check_circle_outline,
                              kSkyBlue,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      _sectionTitle("Waktu & Tempat"),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.calendar_today, dateStr),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.access_time, timeStr),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.location_on_outlined,
                        item.lokasi ?? 'Lokasi tidak diset',
                      ),

                      const SizedBox(height: 24),

                      if (item.kategori.isNotEmpty) ...[
                        _sectionTitle("Kategori"),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: item.kategori
                              .map(
                                (k) => Chip(
                                  label: Text(
                                    k.namaKategori,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  backgroundColor: kSkyBlue,
                                  side: BorderSide.none,
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                      ],

                      _sectionTitle("Deskripsi Kegiatan"),
                      const SizedBox(height: 8),
                      Text(
                        item.deskripsi ?? 'Tidak ada deskripsi',
                        style: const TextStyle(
                          color: kDarkBlueGray,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _sectionTitle("Syarat & Ketentuan"),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: kLightGray),
                        ),
                        child: Text(
                          item.syaratKetentuan ?? '-',
                          style: const TextStyle(
                            color: kDarkBlueGray,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      if (item.linkGrup != null &&
                          item.linkGrup!.isNotEmpty) ...[
                        _sectionTitle("Grup Komunitas"),
                        const SizedBox(height: 8),
                        ListTile(
                          tileColor: Colors.green[50],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          leading: const Icon(Icons.chat, color: Colors.green),
                          title: const Text(
                            "Gabung Grup WhatsApp",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(
                            item.linkGrup!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            // Implement launchUrl here
                          },
                        ),
                        const SizedBox(height: 30),
                      ],

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ApplicantListPage(kegiatanId: kegiatan.id, statusKegiatan: kegiatan.status,),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.people_alt_outlined,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Lihat Data Pelamar",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kDarkBlueGray,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: kDarkBlueGray,
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'Waiting':
        color = Colors.orange;
        text = "Menunggu Verifikasi";
        break;
      case 'scheduled':
        color = kSkyBlue;
        text = "Terjadwal";
        break;
      case 'on progress':
        color = Colors.blueAccent;
        text = "Sedang Berjalan";
        break;
      case 'finished':
        color = Colors.green;
        text = "Selesai";
        break;
      case 'cancelled':
        color = Colors.red;
        text = "Dibatalkan";
        break;
      case 'Rejected':
        color = Colors.redAccent;
        text = "Ditolak";
        break;
      default:
        color = kBlueGray;
        text = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: kBlueGray),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 14, color: kDarkBlueGray),
          ),
        ),
      ],
    );
  }
}
