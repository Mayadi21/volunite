import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pencapaian_model.dart';

class AchievementDialog extends StatelessWidget {
  final Pencapaian item;

  const AchievementDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = item.isUnlocked;
    final Color iconColor = isUnlocked ? Colors.orange : Colors.grey;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Gambar / Icon Besar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: kBackground,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isUnlocked
                      ? Colors.orange.withOpacity(0.5)
                      : Colors.grey.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: item.thumbnail != null
                  ? Image.network(
                      item.thumbnail!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.broken_image,
                          size: 60,
                          color: Colors.grey,
                        );
                      },
                      color: isUnlocked ? null : Colors.grey,
                    )
                  : Icon(
                      Icons.emoji_events_rounded,
                      size: 60,
                      color: iconColor,
                    ),
            ),

            const SizedBox(height: 16),

            // 2. Status (Didapat / Belum)
            if (!isUnlocked)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock, size: 14, color: Colors.grey),
                    SizedBox(width: 6),
                    Text(
                      "Belum Didapat",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Tercapai",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // 3. Nama Pencapaian
            Text(
              item.nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kDarkBlueGray,
              ),
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // 4. Deskripsi / Syarat
            const Text(
              "Deskripsi & Syarat:",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kBlueGray,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.deskripsi ?? "Tidak ada deskripsi.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: kDarkBlueGray,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            // 5. Tombol Tutup
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSkyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Tutup",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
