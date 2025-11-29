import 'user_model.dart';

class RatingKegiatan {
  final int id;
  final int kegiatanId;
  final int userId;
  final int rate; 
  final User? user; 

  RatingKegiatan({
    required this.id,
    required this.kegiatanId,
    required this.userId,
    required this.rate,
    this.user,
  });

  factory RatingKegiatan.fromJson(Map<String, dynamic> json) {
    return RatingKegiatan(
      id: json['id'],
      kegiatanId: json['kegiatan_id'],
      userId: json['user_id'],
      rate: json['rate'],
      user: json['user'] != null 
          ? User.fromJson(json['user']) 
          : null,
    );
  }
}