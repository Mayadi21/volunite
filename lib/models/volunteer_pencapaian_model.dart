import 'package:volunite/models/pencapaian_model.dart'; 

class VolunteerProfileData {
  final String nama;
  final String? pathProfil;
  final int totalXp;
  final int currentLevelXp;
  final int nextLevelTarget;
  final int activityCount;
  final int globalRank;
  final List<Pencapaian> achievements;

  VolunteerProfileData({
    required this.nama,
    this.pathProfil,
    required this.totalXp,
    required this.currentLevelXp,
    required this.nextLevelTarget,
    required this.activityCount,
    required this.globalRank,
    required this.achievements,
  });

  factory VolunteerProfileData.fromJson(Map<String, dynamic> json) {

    
    return VolunteerProfileData(
      nama: json['nama'] ?? 'User',
      pathProfil: json['path_profil'], 
      
      totalXp: int.tryParse(json['total_xp'].toString()) ?? 0,
      currentLevelXp: int.tryParse(json['current_level_xp'].toString()) ?? 0,
      nextLevelTarget: int.tryParse(json['next_level_target'].toString()) ?? 1000,
      activityCount: int.tryParse(json['activity_count'].toString()) ?? 0,
      globalRank: int.tryParse(json['global_rank'].toString()) ?? 0,
      
      achievements: (json['achievements'] as List? ?? [])
          .map((e) => Pencapaian.fromJson(e))
          .toList(),
    );
  }
}