import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';

// Model Data (Bisa dipisah ke folder models/ jika ingin lebih rapi lagi)
class OrganizerActivityItem {
  final String title;
  final String banner;
  final DateTime start;
  final DateTime end;
  final String location;
  final int registered;
  final int quota;

  OrganizerActivityItem({
    required this.title,
    required this.banner,
    required this.start,
    required this.end,
    required this.location,
    required this.registered,
    required this.quota,
  });
}

class OrganizerActivityCard extends StatelessWidget {
  const OrganizerActivityCard({
    super.key,
    required this.item,
    this.isHistory = false,
    required this.onManage,
    required this.onApplicants,
  });

  final OrganizerActivityItem item;
  final bool isHistory;
  final VoidCallback onManage;
  final VoidCallback onApplicants;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final progress = (item.registered / item.quota).clamp(0, 1).toDouble();
    final dDay = _dDayLabel(item.start);
    final timeRange =
        '${_formatTime(item.start)} - ${_formatTime(item.end)} WIB';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.20),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            child: Image.asset(
              item.banner,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: kDarkBlueGray,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (isHistory)
                      const _FinishedChip()
                    else
                      _StatusBadge(text: dDay, color: kSkyBlue),
                  ],
                ),
                const SizedBox(height: 8),

                // Info Rows
                _InfoRow(
                  icon: Icons.calendar_today,
                  text: _formatDate(item.start),
                ),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: timeRange),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.place, text: item.location),

                const SizedBox(height: 12),
                const Divider(height: 1, color: kSoftBlue),
                const SizedBox(height: 12),

                // Organizer Specifics (Progress)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Pendaftar: ${item.registered}/${item.quota}",
                      style: const TextStyle(fontSize: 12, color: kBlueGray),
                    ),
                    Text(
                      "${(progress * 100).round()}%",
                      style: TextStyle(
                        fontSize: 12,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: kSoftBlue.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),
                const SizedBox(height: 14),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: _ActionButton(
                        label: "Kelola",
                        icon: Icons.dashboard_customize,
                        onTap: onManage,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _ActionButton(
                        label: "Pelamar",
                        icon: Icons.person_search,
                        onTap: onApplicants,
                        color: kDarkBlueGray,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helpers Internal Card ---
  String _formatTime(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}.${t.minute.toString().padLeft(2, '0')}';

  String _formatDate(DateTime d) {
    const hari = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    const bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${hari[d.weekday % 7]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  String _dDayLabel(DateTime start) {
    final now = DateTime.now();
    if (start.isAfter(now)) {
      final days = start.difference(now).inDays;
      if (days <= 0) return "Hari ini";
      if (days == 1) return "Besok";
      return "$days hari lagi";
    }
    return "Berjalan";
  }
}

// --- Private Widgets (Hanya dipakai di card ini) ---

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: color,
        side: BorderSide(color: color.withOpacity(0.5)),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: kBlueGray),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: kBlueGray)),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _FinishedChip extends StatelessWidget {
  const _FinishedChip();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F1FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 12, color: kDarkBlueGray),
          SizedBox(width: 4),
          Text(
            'Selesai',
            style: TextStyle(
              color: kDarkBlueGray,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
