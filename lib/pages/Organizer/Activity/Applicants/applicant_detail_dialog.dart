import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pendaftaran_model.dart';

class ApplicantDetailDialog extends StatelessWidget {
  final Pendaftaran pendaftaran;

  const ApplicantDetailDialog({super.key, required this.pendaftaran});

  @override
  Widget build(BuildContext context) {
    final user = pendaftaran.user;
    final detail = pendaftaran.detailPendaftaran;
    
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Foto & Nama Background
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: kSkyBlue,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    backgroundImage: user?.pathProfil != null 
                        ? NetworkImage(user!.pathProfil!) 
                        : const AssetImage('assets/images/profile_placeholder.jpeg') as ImageProvider,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.nama ?? 'Volunteer',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    user?.email ?? '-',
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            
            // Isi Detail
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _detailItem(Icons.phone, "Nomor Telepon", detail?.nomorTelepon ?? '-'),
                  const Divider(height: 24),
                  _detailItem(Icons.location_on, "Domisili", detail?.domisili ?? '-'),
                  const Divider(height: 24),
                  _detailItem(Icons.lightbulb, "Ketrampilan", detail?.keterampilan ?? '-'),
                  const Divider(height: 24),
                  _detailItem(Icons.volunteer_activism, "Alasan / Komitmen", detail?.komitmen ?? '-'),
                ],
              ),
            ),

            // Tombol Tutup
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDarkBlueGray,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Tutup", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: kSkyBlue),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 14, color: kDarkBlueGray, fontWeight: FontWeight.w500)),
            ],
          ),
        )
      ],
    );
  }
}