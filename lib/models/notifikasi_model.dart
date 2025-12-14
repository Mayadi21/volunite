class NotifikasiModel {
  final int id;
  final String judul;
  final String subjudul;
  bool isRead; 
  final DateTime createdAt;

  NotifikasiModel({
    required this.id,
    required this.judul,
    required this.subjudul,
    required this.isRead,
    required this.createdAt,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id'],
      judul: json['judul'],
      subjudul: json['subjudul'],
      isRead: json['read'] == true || json['read'] == 1, 
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}