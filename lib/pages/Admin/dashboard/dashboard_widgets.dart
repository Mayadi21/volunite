import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color; // Warna utama icon

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightGray.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon dengan background lingkaran transparan
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(
                  0.15,
                ), // Background soft sesuai warna icon
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: kDarkBlueGray, // Warna teks utama gelap
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: kBlueGray, // Warna teks label agak pudar
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;

  // Kita hapus properti color custom, kita standarisasi dengan palet
  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kLightGray), // Border tipis
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kSoftBlue.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: kDarkBlueGray, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: kDarkBlueGray,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            time,
            style: const TextStyle(fontSize: 12, color: kBlueGray),
          ),
        ),
      ),
    );
  }
}
