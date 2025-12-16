import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/pages/Organizer/Activity/Applicants/applicant_detail_dialog.dart';
import 'package:volunite/services/kegiatan_service.dart';

class ApplicantCard extends StatefulWidget {
  final Pendaftaran pendaftaran;
  final VoidCallback onUpdate;

  const ApplicantCard({
    super.key, 
    required this.pendaftaran, 
    required this.onUpdate,
  });

  @override
  State<ApplicantCard> createState() => _ApplicantCardState();
}

class _ApplicantCardState extends State<ApplicantCard> {
  bool _isLoading = false;

  // Update Status Penerimaan (Terima/Tolak)
  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    final success = await PendaftaranService.updateStatusPendaftaran(widget.pendaftaran.id, newStatus);
    setState(() => _isLoading = false);
    if (success && mounted) {
      widget.onUpdate();
      KegiatanService.triggerRefresh();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status: $newStatus"), backgroundColor: newStatus=='Diterima'?Colors.green:Colors.red));
    }
  }

  // Update Kehadiran (Hadir/Tidak)
  Future<void> _updateKehadiran(String statusKehadiran) async {
    Navigator.pop(context); // Tutup BottomSheet
    setState(() => _isLoading = true);
    
    final success = await PendaftaranService.updateKehadiran(widget.pendaftaran.id, statusKehadiran);
    
    setState(() => _isLoading = false);
    if (success && mounted) {
      widget.onUpdate(); // Refresh UI
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Data kehadiran disimpan"), backgroundColor: kDarkBlueGray));
    }
  }

  // Menampilkan Pilihan Absensi
  void _showAttendanceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Konfirmasi Kehadiran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text("Hadir"),
                onTap: () => _updateKehadiran('Hadir'),
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: const Text("Tidak Hadir"),
                onTap: () => _updateKehadiran('Tidak Hadir'),
              ),
              ListTile(
                leading: const Icon(Icons.refresh, color: Colors.grey),
                title: const Text("Reset (Belum Dicek)"),
                onTap: () => _updateKehadiran('Belum Dicek'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.pendaftaran.user;
    final detail = widget.pendaftaran.detailPendaftaran;
    final status = widget.pendaftaran.status;
    final kehadiran = widget.pendaftaran.statusKehadiran; // 'Belum Dicek', 'Hadir', 'Tidak Hadir'

    // Tentukan Warna Tombol Absensi biar informatif
    Color btnColor;
    String btnText;
    if (kehadiran == 'Hadir') {
      btnColor = Colors.green;
      btnText = "Hadir";
    } else if (kehadiran == 'Tidak Hadir') {
      btnColor = Colors.red;
      btnText = "Tdk Hadir";
    } else {
      btnColor = kSkyBlue;
      btnText = "Absensi";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: kLightGray), boxShadow: [BoxShadow(color: kLightGray.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))]),
      child: Row(
        children: [
          CircleAvatar(radius: 22, backgroundColor: kLightGray, backgroundImage: user?.pathProfil != null ? NetworkImage(user!.pathProfil!) : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.nama ?? 'Volunteer', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: kDarkBlueGray)),
                const SizedBox(height: 2),
                Text(detail?.domisili ?? 'Lokasi -', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: kBlueGray)),
              ],
            ),
          ),

          if (_isLoading)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
          else 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.info_outline, color: kSkyBlue),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                  onPressed: () => showDialog(context: context, builder: (_) => ApplicantDetailDialog(pendaftaran: widget.pendaftaran)),
                ),

                if (status == 'Mengajukan') ...[
                  InkWell(onTap: () => _updateStatus('Ditolak'), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.close, color: Colors.red, size: 20))),
                  const SizedBox(width: 8),
                  InkWell(onTap: () => _updateStatus('Diterima'), child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check, color: Colors.green, size: 20))),
                ] else if (status == 'Diterima') ...[
                  const SizedBox(width: 4),
                  // Tombol Absensi
                  ElevatedButton(
                    onPressed: _showAttendanceOptions,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnColor, // Warna berubah sesuai status
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 32),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(btnText, style: const TextStyle(fontSize: 11)),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }
}