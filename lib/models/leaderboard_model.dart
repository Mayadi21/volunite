class LeaderboardUser {
  final int id;
  final String nama;
  final String? pathProfil;
  final int totalXp;

  LeaderboardUser({
    required this.id,
    required this.nama,
    this.pathProfil,
    required this.totalXp,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      id: json['id'],
      nama: json['nama'] ?? 'Volunteer',
      pathProfil: json['path_profil'],
      totalXp: int.tryParse(json['total_xp'].toString()) ?? 0,
    );
  }
}