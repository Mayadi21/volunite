import 'kegiatan_model.dart';
import 'user_model.dart';

class Pendaftaran {
  final int id;
  final String status;
  final String statusKehadiran;
  final Kegiatan? kegiatan;
  final User? user;

  Pendaftaran({
    required this.id,
    required this.status,
    required this.statusKehadiran,
    this.kegiatan,
    this.user,
  });

  factory Pendaftaran.fromJson(Map<String, dynamic> json) {
    return Pendaftaran(
      id: json['id'],
      status: json['status'],
      statusKehadiran: json['status_kehadiran'],
      kegiatan: json['kegiatan'] != null 
          ? Kegiatan.fromJson(json['kegiatan']) 
          : null,
      user: json['user'] != null 
          ? User.fromJson(json['user']) 
          : null,
    );
  }
}