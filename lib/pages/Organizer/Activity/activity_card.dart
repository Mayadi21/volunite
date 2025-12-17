import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';

class OrganizerActivityCard extends StatelessWidget {
  final Kegiatan item;
  final VoidCallback onManage;
  
  final VoidCallback? onApplicants; 
  final bool isHistory;

  const OrganizerActivityCard({
    super.key,
    required this.item,
    required this.onManage,
    this.onApplicants, 
    this.isHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    final start = item.tanggalMulai ?? DateTime.now();
    final int kuota = item.kuota ?? 0;
    final int pendaftar = item.pendaftarCount; 
    final double progress = (kuota > 0) ? (pendaftar / kuota).clamp(0.0, 1.0) : 0.0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightGray),
        boxShadow: [
          BoxShadow(color: kBlueGray.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: item.thumbnail != null
                    ? Image.network(
                        item.thumbnail!, 
                        height: 120, 
                        width: double.infinity, 
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(height: 120, color: kLightGray, child: const Icon(Icons.broken_image, color: kBlueGray)),
                      )
                    : Container(height: 120, color: kLightGray, child: const Center(child: Icon(Icons.image, color: kBlueGray))),
              ),
              Positioned(top: 10, right: 10, child: _buildStatusBadge(item.status)),
              Positioned(
                top: 10, left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
                  child: Text(_dDayLabel(start), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.judul, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: kDarkBlueGray)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.calendar_today_outlined, size: 12, color: kBlueGray),
                  const SizedBox(width: 4),
                  Text(DateFormat('dd MMM yyyy').format(start), style: const TextStyle(fontSize: 12, color: kBlueGray)),
                ]),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Kuota Terisi", style: TextStyle(fontSize: 11, color: kBlueGray)),
                    Text("$pendaftar/$kuota", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: kSkyBlue)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(value: progress, backgroundColor: kBackground, color: kSkyBlue, minHeight: 6),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 38,
                        child: OutlinedButton(
                          onPressed: onManage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kSkyBlue,
                            side: const BorderSide(color: kSkyBlue),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text("Kelola", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ),
                    ),
                    
                    if (onApplicants != null) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 38,
                          child: ElevatedButton(
                            onPressed: onApplicants,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kSkyBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("Pelamar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ),
                      ),
                    ]
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    switch (status) {
      case 'Waiting': color = Colors.orange; text = "Menunggu"; break;
      case 'scheduled': color = kSkyBlue; text = "Terjadwal"; break;
      case 'on progress': color = Colors.blueAccent; text = "Berjalan"; break;
      case 'finished': color = Colors.green; text = "Selesai"; break;
      case 'cancelled': color = Colors.red; text = "Batal"; break;
      case 'Rejected': color = Colors.redAccent; text = "Ditolak"; break;
      default: color = kBlueGray; text = status;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  String _dDayLabel(DateTime start) {
    final diff = start.difference(DateTime.now()).inDays;
    return diff < 0 ? "Lewat" : (diff == 0 ? "Hari Ini" : "H-$diff");
  }
}