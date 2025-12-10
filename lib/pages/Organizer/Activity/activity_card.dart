import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';

class OrganizerActivityCard extends StatelessWidget {
  const OrganizerActivityCard({
    super.key,
    required this.item,
    this.isHistory = false,
    required this.onManage,
    required this.onApplicants,
  });

  final Kegiatan item;
  final bool isHistory;
  final VoidCallback onManage;
  final VoidCallback onApplicants;

  @override
  Widget build(BuildContext context) {
    final quota = item.kuota ?? 0;
    // Nanti ganti dengan item.pendaftaranCount jika backend sudah siap
    final registered = 0; 
    final progress = (quota > 0) ? (registered / quota).clamp(0, 1).toDouble() : 0.0;
    
    final start = item.tanggalMulai ?? DateTime.now();
    final end = item.tanggalBerakhir ?? DateTime.now();
    final timeRange = '${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)} WIB';

    // --- LOGIKA STATUS & WARNA BARU ---
    String statusLabel;
    Color statusColor;
    String dbStatus = item.status.toLowerCase(); 

    if (isHistory) {
        if (dbStatus == 'finished') {
            statusLabel = "Selesai";
            statusColor = Colors.green;
        } else if (dbStatus == 'cancelled') {
            statusLabel = "Dibatalkan";
            statusColor = Colors.red;
        } else if (dbStatus == 'rejected') {
            statusLabel = "Ditolak";
            statusColor = Colors.red;
        } else {
            statusLabel = item.status;
            statusColor = kBlueGray;
        }
    } else {
        if (dbStatus == 'waiting') {
            statusLabel = "Menunggu Verifikasi";
            statusColor = Colors.orange; 
        } else if (dbStatus == 'scheduled') {
            statusLabel = _dDayLabel(start); 
            statusColor = kSkyBlue;
        } else {
            // Fallback status lain (on progress dll)
            statusLabel = item.status;
            statusColor = kSkyBlue;
        }
    }
    // ----------------------------------

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: kBlueGray.withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: item.thumbnail != null
                ? Image.network(
                    item.thumbnail!,
                    height: 150, width: double.infinity, fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(height: 150, color: kLightGray, child: const Icon(Icons.image_not_supported)),
                  )
                : Container(height: 150, color: kLightGray, child: const Icon(Icons.image, color: Colors.white)),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(item.judul, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kDarkBlueGray))),
                    const SizedBox(width: 8),
                    _StatusBadge(text: statusLabel, color: statusColor),
                  ],
                ),
                const SizedBox(height: 8),
                _InfoRow(Icons.calendar_today, DateFormat('dd MMM yyyy').format(start)),
                const SizedBox(height: 4),
                _InfoRow(Icons.access_time, timeRange),
                const SizedBox(height: 4),
                _InfoRow(Icons.place, item.lokasi ?? 'Online'),
                
                const SizedBox(height: 12),
                LinearProgressIndicator(value: progress, backgroundColor: kLightGray, color: kSkyBlue, minHeight: 6, borderRadius: BorderRadius.circular(3)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Terisi: $registered/$quota", style: const TextStyle(fontSize: 11, color: kBlueGray)),
                    Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 11, color: kSkyBlue, fontWeight: FontWeight.bold)),
                  ],
                ),
                
                if (!isHistory) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(child: _ActionButton("Kelola", Icons.settings, onManage, kDarkBlueGray)),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionButton("Pelamar", Icons.people, onApplicants, kSkyBlue)),
                    ],
                  )
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _dDayLabel(DateTime start) {
    final diff = start.difference(DateTime.now()).inDays;
    if (diff < 0) return "Berlangsung";
    if (diff == 0) return "Hari Ini";
    return "H-$diff";
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String text;
  const _InfoRow(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 14, color: kBlueGray), const SizedBox(width: 6), Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: kBlueGray), overflow: TextOverflow.ellipsis))]);
}

class _StatusBadge extends StatelessWidget {
  final String text; final Color color;
  const _StatusBadge({required this.text, required this.color});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(text, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)));
}

class _ActionButton extends StatelessWidget {
  final String label; final IconData icon; final VoidCallback onTap; final Color color;
  const _ActionButton(this.label, this.icon, this.onTap, this.color);
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 16), label: Text(label, style: const TextStyle(fontSize: 12)), style: OutlinedButton.styleFrom(foregroundColor: color, side: BorderSide(color: color.withOpacity(0.5)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
}