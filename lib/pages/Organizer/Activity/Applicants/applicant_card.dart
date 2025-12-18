import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/services/pendaftaran_service.dart';

class ApplicantCard extends StatefulWidget {
  final Pendaftaran pendaftaran;
  final VoidCallback onUpdate;
  final String statusKegiatan; 

  const ApplicantCard({
    super.key, 
    required this.pendaftaran, 
    required this.onUpdate,
    required this.statusKegiatan, 
  });

  @override
  State<ApplicantCard> createState() => _ApplicantCardState();
}

class _ApplicantCardState extends State<ApplicantCard> {
  bool _isLoading = false;

  Future<void> _updateStatus(String newStatus) async {
    setState(() => _isLoading = true);
    final success = await PendaftaranService.updateStatusPendaftaran(
      widget.pendaftaran.id, 
      newStatus
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      widget.onUpdate();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Status diubah ke $newStatus"), backgroundColor: newStatus == 'Diterima' ? Colors.green : Colors.red),
      );
    }
  }

  Future<void> _updateKehadiran(String statusKehadiran) async {
    setState(() => _isLoading = true);
    final success = await PendaftaranService.updateKehadiran(
      widget.pendaftaran.id, 
      statusKehadiran
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      widget.onUpdate();
      Navigator.pop(context); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kehadiran berhasil dicatat"), backgroundColor: Colors.blueAccent),
      );
    }
  }

  void _showAttendanceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Update Kehadiran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pendaftaran;
    final user = p.user;
    final status = p.status;
    
    final String actStatus = widget.statusKegiatan.toLowerCase();

    bool isRecruitmentActive = !['finished', 'cancelled', 'rejected'].contains(actStatus);

    bool isAttendanceAllowed = !['cancelled', 'rejected'].contains(actStatus);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: kLightGray)),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: kLightGray,
            backgroundImage: user?.pathProfil != null 
                ? NetworkImage(user!.pathProfil!) 
                : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.nama ?? "Relawan", style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray)),
               
                if (status == 'Diterima')
                  Text(
                    "Kehadiran: ${p.statusKehadiran ?? 'Belum diabsen'}", 
                    style: TextStyle(
                      fontSize: 11, 
                      fontWeight: FontWeight.bold,
                      color: p.statusKehadiran == 'Hadir' ? Colors.green : Colors.orange
                    )
                  ),
              ],
            ),
          ),

          if (_isLoading)
            const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: kSkyBlue))
          else 
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status == 'Mengajukan') ...[
                  if (isRecruitmentActive) ...[
                    InkWell(onTap: () => _updateStatus('Ditolak'), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.close, color: Colors.red, size: 20))),
                    const SizedBox(width: 8),
                    InkWell(onTap: () => _updateStatus('Diterima'), child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check, color: Colors.green, size: 20))),
                  ] else ...[
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)), child: const Text("Ditutup", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))),
                  ]
                
                ] else if (status == 'Diterima') ...[
                  
                  if (isAttendanceAllowed) 
                    ElevatedButton(
                      onPressed: _showAttendanceOptions,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSkyBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        minimumSize: const Size(60, 30),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text("Absen", style: TextStyle(fontSize: 11, color: Colors.white)),
                    ),

                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(6)),
                    child: Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red)),
                  )
                ]
              ],
            ),
        ],
      ),
    );
  }
}