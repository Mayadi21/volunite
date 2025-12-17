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
        SnackBar(content: Text("Status: $newStatus"), backgroundColor: newStatus == 'Diterima' ? Colors.green : Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pendaftaran;
    final user = p.user;
    final status = p.status;

    bool isActivityActive = !['finished', 'cancelled', 'rejected']
        .contains(widget.statusKegiatan.toLowerCase());

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
                  
                  if (isActivityActive) ...[
                    InkWell(
                      onTap: () => _updateStatus('Ditolak'), 
                      child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.close, color: Colors.red, size: 20))
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => _updateStatus('Diterima'), 
                      child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.check, color: Colors.green, size: 20))
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
                      decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)), 
                      child: const Text("Ditutup", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold))
                    ),
                  ]

                ] else ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: status == 'Diterima' ? Colors.green[50] : Colors.red[50], borderRadius: BorderRadius.circular(6)),
                    child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: status == 'Diterima' ? Colors.green : Colors.red)),
                  )
                ]
              ],
            ),
        ],
      ),
    );
  }
}