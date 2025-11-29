import 'kategori_model.dart';
import 'user_model.dart';

class Kegiatan {
  final int id;
  final int userId;
  final String judul;
  final String? thumbnail;
  final String? deskripsi;
  final String? lokasi;
  final String? syaratKetentuan;
  final int? kuota;
  final DateTime? tanggalMulai;
  final DateTime? tanggalBerakhir;
  final String status; 
  final User? organizer;
  final List<Kategori> kategori;

  Kegiatan({
    required this.id,
    required this.userId,
    required this.judul,
    this.thumbnail,
    this.deskripsi,
    this.lokasi,
    this.syaratKetentuan,
    this.kuota,
    this.tanggalMulai,
    this.tanggalBerakhir,
    required this.status,
    this.organizer,
    this.kategori = const [],
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    return Kegiatan(
      id: json['id'],
      userId: json['user_id'],
      judul: json['judul'],
      thumbnail: json['thumbnail'],
      deskripsi: json['deskripsi'],
      lokasi: json['lokasi'],
      syaratKetentuan: json['syarat_ketentuan'],
      kuota: json['kuota'],
      tanggalMulai: json['tanggal_mulai'] != null 
          ? DateTime.parse(json['tanggal_mulai']) 
          : null,
      tanggalBerakhir: json['tanggal_berakhir'] != null 
          ? DateTime.parse(json['tanggal_berakhir']) 
          : null,
      status: json['status'],
      
      organizer: json['user'] != null 
          ? User.fromJson(json['user']) 
          : null,
      kategori: json['kategori'] != null
          ? (json['kategori'] as List).map((i) => Kategori.fromJson(i)).toList()
          : [],
    );
  }
}