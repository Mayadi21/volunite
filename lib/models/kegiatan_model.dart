import 'dart:io'; 
import 'package:flutter/foundation.dart'; 
import 'kategori_model.dart';
import 'user_model.dart';

class Kegiatan {
  final int id;
  final int userId;
  final String judul;
  final String? thumbnail;
  final String? deskripsi;
  final String? linkGrup;
  final String? lokasi;
  final String? syaratKetentuan;
  final int? kuota;
  final DateTime? tanggalMulai;
  final DateTime? tanggalBerakhir;
  final String status;
  final int pendaftarCount; 
  
  final bool isRegistered;

  final User? organizer;
  final List<Kategori> kategori;

  Kegiatan({
    required this.id,
    required this.userId,
    required this.judul,
    this.thumbnail,
    this.deskripsi,
    this.linkGrup,
    this.lokasi,
    this.syaratKetentuan,
    this.kuota,
    this.tanggalMulai,
    this.tanggalBerakhir,
    required this.status,
    this.pendaftarCount = 0, 
    this.isRegistered = false,
    this.organizer,
    this.kategori = const [],
  });

  factory Kegiatan.fromJson(Map<String, dynamic> json) {
    String? thumbUrl = json['thumbnail'];
    if (thumbUrl != null && !kIsWeb && Platform.isAndroid) {
      if (thumbUrl.contains('127.0.0.1')) thumbUrl = thumbUrl.replaceFirst('127.0.0.1', '10.0.2.2');
      else if (thumbUrl.contains('localhost')) thumbUrl = thumbUrl.replaceFirst('localhost', '10.0.2.2');
    }

    return Kegiatan(
      id: json['id'],
      userId: json['user_id'],
      judul: json['judul'],
      thumbnail: thumbUrl,
      deskripsi: json['deskripsi'],
      linkGrup: json['link_grup'],
      lokasi: json['lokasi'],
      syaratKetentuan: json['syarat_ketentuan'],
      kuota: json['kuota'],
      tanggalMulai: json['tanggal_mulai'] != null ? DateTime.parse(json['tanggal_mulai']) : null,
      tanggalBerakhir: json['tanggal_berakhir'] != null ? DateTime.parse(json['tanggal_berakhir']) : null,
      status: json['status'],
      pendaftarCount: json['pendaftaran_count'] ?? 0, 
      organizer: json['user'] != null ? User.fromJson(json['user']) : null,
      kategori: json['kategori'] != null
          ? (json['kategori'] as List).map((i) => Kategori.fromJson(i)).toList()
          : [],
    );
  }
}