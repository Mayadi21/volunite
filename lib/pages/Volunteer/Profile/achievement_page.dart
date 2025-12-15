import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/pencapaian_model.dart';
import 'package:volunite/pages/Volunteer/Profile/achievement_dialog.dart';

class AllAchievementsPage extends StatelessWidget {
  final List<Pencapaian> achievements;

  const AllAchievementsPage({super.key, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text("Semua Pencapaian", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: kSkyBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: achievements.isEmpty
          ? const Center(child: Text("Belum ada data pencapaian"))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 Kolom
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75, // Rasio tinggi vs lebar kartu
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final item = achievements[index];
                return _AchievementGridItem(item: item);
              },
            ),
    );
  }
}

class _AchievementGridItem extends StatelessWidget {
  final Pencapaian item;
  const _AchievementGridItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isUnlocked = item.isUnlocked;
    final Color iconColor = isUnlocked ? Colors.orange : Colors.grey;
    final double opacity = isUnlocked ? 1.0 : 0.5;

    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (_) => AchievementDialog(item: item));
      },
      child: Opacity(
        opacity: opacity,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isUnlocked ? Colors.orange.withOpacity(0.3) : kLightGray),
            boxShadow: [
              BoxShadow(
                color: kLightGray.withOpacity(0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item.thumbnail != null
                  ? Image.network(item.thumbnail!, width: 40, height: 40, fit: BoxFit.cover)
                  : Icon(Icons.emoji_events_rounded, size: 40, color: iconColor),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.nama,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11, 
                    fontWeight: FontWeight.bold, 
                    color: isUnlocked ? kDarkBlueGray : Colors.grey
                  ),
                ),
              ),
              if (!isUnlocked)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.lock, size: 12, color: Colors.grey),
                )
            ],
          ),
        ),
      ),
    );
  }
}