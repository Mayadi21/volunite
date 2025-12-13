// lib/pages/Volunteer/Activity/activity_card.dart
import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/services/auth/auth_service.dart';

class ActivityCard extends StatefulWidget {
  final Kegiatan kegiatan;

  const ActivityCard({
    super.key,
    required this.kegiatan,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  final PendaftaranService _pendaftaranService = PendaftaranService();
  final AuthService _authService = AuthService();

  bool _isRegistered = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }

  // =========================================================
  // 🔥 LOGIC SAMA PERSIS DENGAN DetailActivitiesPage
  // =========================================================
  Future<void> _checkRegistrationStatus() async {
    final kegiatanId = widget.kegiatan.id;
    final user = await _authService.getCurrentUser();

    if (user == null) {
      setState(() {
        _isRegistered = false;
        _isChecking = false;
      });
      return;
    }

    try {
      final isRegistered =
          await _pendaftaranService.isUserRegistered(kegiatanId);

      if (mounted) {
        setState(() {
          _isRegistered = isRegistered;
          _isChecking = false;
        });
      }
    } catch (e) {
      debugPrint('Error checking registration status: $e');
      if (mounted) {
        setState(() {
          _isRegistered = false;
          _isChecking = false;
        });
      }
    }
  }

  String _formatDate(DateTime d) {
    const hari = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    const bulan = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
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

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          final bool? result = await Navigator.push<bool>(
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

        if (result == true && mounted) {
          _checkRegistrationStatus();
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

                        // 🔥 Badge Terdaftar
                        if (!_isChecking && _isRegistered)
                          const _RegisteredChip(),

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
// BADGE WIDGET
// =========================================================

class _RegisteredChip extends StatelessWidget {
  const _RegisteredChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle, size: 12, color: Colors.green),
          SizedBox(width: 4),
          Text(
            'Terdaftar',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.green,
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
