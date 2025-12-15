import 'package:volunite/models/pencapaian_model.dart';

class VolunteerProfileData {
  final String nama;
  final String? pathProfil;
  final int totalXp;
  final int currentLevelXp;
  final int nextLevelTarget;
  final int activityCount;
  
  final List<Pencapaian> achievements;

  VolunteerProfileData({
    required this.nama,
    this.pathProfil,
    required this.totalXp,
    required this.currentLevelXp,
    required this.nextLevelTarget,
    required this.activityCount,
    required this.achievements,
  });

  factory VolunteerProfileData.fromJson(Map<String, dynamic> json) {
    return VolunteerProfileData(
      nama: json['user']['nama'],
      pathProfil: json['user']['path_profil'],
      totalXp: json['xp_info']['total_xp'],
      currentLevelXp: json['xp_info']['current_level_xp'],
      nextLevelTarget: json['xp_info']['next_level_target'],
      activityCount: json['xp_info']['activity_count'],
      achievements: (json['achievements'] as List)
          .map((e) => Pencapaian.fromJson(e))
          .toList(),
    );
  }
}