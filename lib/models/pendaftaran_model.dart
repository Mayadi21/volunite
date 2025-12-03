import 'detail_pendaftaran_model.dart';
import 'kegiatan_model.dart';
import 'user_model.dart';

class Pendaftaran {
  final int id;
  final int userId;
  final int kegiatanId;
  final String status;
  final String statusKehadiran;

  final Kegiatan? kegiatan;
  final User? user;
  final DetailPendaftaran? detailPendaftaran;

  Pendaftaran({
    required this.id,
    required this.userId,
    required this.kegiatanId,
    required this.status,
    required this.statusKehadiran,
    this.kegiatan,
    this.user,
    this.detailPendaftaran,
  });

  factory Pendaftaran.fromJson(Map<String, dynamic> json) {
    return Pendaftaran(
      id: json['id'],
      userId: json['user_id'],
      kegiatanId: json['kegiatan_id'],
      status: json['status'],
      statusKehadiran: json['status_kehadiran'],

      kegiatan: json['kegiatan'] != null 
          ? Kegiatan.fromJson(json['kegiatan'])
          : null,

      user: json['user'] != null 
          ? User.fromJson(json['user'])
          : null,

      detailPendaftaran: json['detail_pendaftaran'] != null
          ? DetailPendaftaran.fromJson(json['detail_pendaftaran'])
          : null,
    );
  }
}
