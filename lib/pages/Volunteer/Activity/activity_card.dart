// lib/pages/Volunteer/Activity/activity_card.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/services/auth/auth_service.dart';

class ActivityCard extends StatefulWidget {
  final Kegiatan kegiatan;
  // Menerima status awal dari parent
  final String? initialRegistrationStatus; 

  const ActivityCard({
    super.key,
    required this.kegiatan,
    this.initialRegistrationStatus,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final PendaftaranService _pendaftaranService = PendaftaranService();

  // State status pendaftaran. Nilai awal 'Memuat' akan lebih baik.
  String _registrationStatus = 'Memuat'; 

  @override
  void initState() {
    super.initState();
    
    // 1. Inisialisasi dengan status dari parent (jika ada) atau 'Memuat'
    _registrationStatus = widget.initialRegistrationStatus ?? 'Memuat';

    // 2. Panggil fungsi untuk mengambil status terbaru secara asynchronous
    _fetchAndSetRegistrationStatus();
  }
  
  // Mengambil status dari API saat widget diinisialisasi/refresh
  Future<void> _fetchAndSetRegistrationStatus() async {
    final kegiatanId = widget.kegiatan.id;
    final user = await AuthService().getCurrentUser();

    if (user == null) {
      if (mounted) {
        setState(() {
          _registrationStatus = 'Belum Mendaftar';
        });
      }
      return;
    }

    try {
      final status = await _pendaftaranService.getRegistrationStatus(kegiatanId);

      if (mounted) {
        setState(() {
          _registrationStatus = status; // Set status terbaru dari API
        });
      }
    } catch (e) {
      debugPrint('Error fetching registration status in card: $e');
      if (mounted) {
        setState(() {
          _registrationStatus = 'Kesalahan Jaringan';
        });
      }
    }
  }


  String _formatDate(DateTime d) {
    const hari = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${hari[d.weekday % 7]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  String _formatTimeRange(DateTime? start, DateTime? end) {
    if (start == null) return 'Waktu tidak tersedia';

    final s =
        '${start.hour.toString().padLeft(2, '0')}.${start.minute.toString().padLeft(2, '0')} WIB';
    if (end == null) return s;

    final e =
        '${end.hour.toString().padLeft(2, '0')}.${end.minute.toString().padLeft(2, '0')} WIB';
    return '$s - $e';
  }
    
  // Logika untuk menampilkan chip status pendaftaran
  bool get showRegistrationChip {
    final status = _registrationStatus;
    return status == 'Diterima' || 
           status == 'Mengajukan' || 
           status == 'Ditolak' ||
           status == 'Kuota Penuh'; 
  }


  @override
  Widget build(BuildContext context) {
    final isFinished =
        widget.kegiatan.status.toLowerCase() == 'finished' ||
            widget.kegiatan.status.toLowerCase() == 'completed';

    final date = _formatDate(
      widget.kegiatan.tanggalMulai ?? DateTime.now(),
    );
    final time = _formatTimeRange(
      widget.kegiatan.tanggalMulai,
      widget.kegiatan.tanggalBerakhir,
    );

    final imagePath =
        widget.kegiatan.thumbnail ?? 'assets/images/event_placeholder.jpg';
    final isUrl = imagePath.startsWith('http');
    
    // 🔥 WIDGET STATUS DARI TERNARY OPERATOR
    Widget statusWidget;
    if (showRegistrationChip) {
      statusWidget = _RegistrationStatusChip(status: _registrationStatus);
    } else if (_registrationStatus == 'Memuat') {
      statusWidget = const Padding(
        padding: EdgeInsets.only(left: 6),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2, color: kBlueGray),
        ),
      );
    } else {
      statusWidget = const SizedBox.shrink(); // Sembunyikan jika tidak ada status
    }


    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final bool? needsRefresh = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => DetailActivitiesPage(
                kegiatan: widget.kegiatan,
                title: widget.kegiatan.judul,
                date: date,
                time: time,
                imagePath: imagePath,
              ),
            ),
          );

          // Panggil refresh jika ada indikasi perubahan dari halaman detail
          if (needsRefresh == true && mounted) {
            _fetchAndSetRegistrationStatus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: kBlueGray.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(18)),
                child: isUrl
                    ? Image.network(
                        imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                            return Container(
                                height: 160,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 40, color: kBlueGray),
                            );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.kegiatan.judul,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: kDarkBlueGray,
                            ),
                          ),
                        ),

                        // 🔥 MASUKKAN WIDGET STATUS YANG SUDAH DITENTUKAN
                        statusWidget,

                        // Badge Selesai
                        if (isFinished) const _FinishedChip(),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(icon: Icons.calendar_today, text: date),
                    const SizedBox(height: 4),
                    _InfoRow(icon: Icons.access_time, text: time),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================================================
// BADGE WIDGETS
// =========================================================

class _RegistrationStatusChip extends StatelessWidget {
  final String status;

  const _RegistrationStatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    IconData icon;
    String label;

    switch (status) {
      case 'Diterima':
        color = Colors.green[700]!;
        bgColor = Colors.green[50]!;
        icon = Icons.check_circle;
        label = 'Diterima';
        break;
      case 'Mengajukan':
        color = Colors.orange[700]!;
        bgColor = Colors.orange[50]!;
        icon = Icons.pending_actions;
        label = 'Mengajukan';
        break;
      case 'Ditolak':
        color = Colors.red[700]!;
        bgColor = Colors.red[50]!;
        icon = Icons.cancel;
        label = 'Ditolak';
        break;
      case 'Kuota Penuh':
        color = kDarkBlueGray;
        bgColor = Colors.grey[300]!;
        icon = Icons.block;
        label = 'Penuh';
        break;
      default:
        return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishedChip extends StatelessWidget {
  const _FinishedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Selesai',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: kDarkBlueGray,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: kBlueGray),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontSize: 12, color: kBlueGray),
        ),
      ],
    );
  }
}