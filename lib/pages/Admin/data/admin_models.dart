// lib/pages/Admin/data/admin_models.dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

// Warna primer untuk konsistensi
const Color primaryColor = Color(0xFF0C5E70);

class Volunteer {
  int id;
  String name;
  String email;
  int events;
  String status;
  Volunteer({
    required this.id,
    required this.name,
    required this.email,
    this.events = 0,
    this.status = 'Aktif',
  });
}

class Organization {
  int id;
  String name;
  String email;
  int eventsPosted;
  String status;
  Organization({
    required this.id,
    required this.name,
    required this.email,
    this.eventsPosted = 0,
    this.status = 'Pending',
  });
}

class PencapaianModel {
  final int id;
  final String nama;
  final int? requiredExp;
  final int? requiredCountKategori;
  final int? requiredKategori;

  final String description;
  final String? thumbnailUrl; // URL lengkap dari Laravel

  PencapaianModel({
    required this.id,
    required this.nama,
    required this.description,
    this.thumbnailUrl,
    this.requiredExp,
    this.requiredCountKategori,
    this.requiredKategori,
  });

  factory PencapaianModel.fromJson(Map<String, dynamic> json) {
    return PencapaianModel(
      id: json['id'],
      nama: json['nama'],
      description: json['deskripsi'] ?? '',
      thumbnailUrl: json['thumbnail_url'],
      requiredExp: json['required_exp'],
      requiredCountKategori: json['required_count_kategori'],
      requiredKategori: json['required_kategori'],
    );
  }
}

class KategoriSimple {
  final int id;
  final String namaKategori;

  KategoriSimple({required this.id, required this.namaKategori});

  factory KategoriSimple.fromJson(Map<String, dynamic> json) {
    return KategoriSimple(id: json['id'], namaKategori: json['nama_kategori']);
  }
}

// --- MODEL BARU UNTUK MANAJEMEN KEGIATAN ---
class Activity {
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
  String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? organizerName;

  Activity({
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
    required this.createdAt,
    required this.updatedAt,
    this.organizerName,
  });

  static DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return null;
    }
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    // ===============================
    // THUMBNAIL (SAMA DENGAN VOLUNTEER)
    // ===============================
    String? thumbUrl = json['thumbnail'];
    if (thumbUrl != null && !kIsWeb && Platform.isAndroid) {
      if (thumbUrl.contains('127.0.0.1')) {
        thumbUrl = thumbUrl.replaceFirst('127.0.0.1', '10.0.2.2');
      } else if (thumbUrl.contains('localhost')) {
        thumbUrl = thumbUrl.replaceFirst('localhost', '10.0.2.2');
      }
    }

    // ===============================
    // ORGANIZER
    // ===============================
    String? organizer;
    if (json['user'] != null && json['user'] is Map) {
      final u = Map<String, dynamic>.from(json['user']);
      organizer = (u['nama'] ?? u['name'] ?? u['username'] ?? u['email'])
          ?.toString();
    }

    return Activity(
      id: json['id'],
      userId: json['user_id'],
      judul: json['judul'],
      thumbnail: thumbUrl,
      deskripsi: json['deskripsi'],
      linkGrup: json['link_grup'],
      lokasi: json['lokasi'],
      syaratKetentuan: json['syarat_ketentuan'],
      kuota: json['kuota'],
      tanggalMulai: _tryParseDate(json['tanggal_mulai']),
      tanggalBerakhir: _tryParseDate(json['tanggal_berakhir']),
      status: json['status'] ?? 'Waiting',
      createdAt: _tryParseDate(json['created_at']) ?? DateTime.now(),
      updatedAt: _tryParseDate(json['updated_at']) ?? DateTime.now(),
      organizerName: organizer,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'thumbnail': thumbnail,
      'status': status,
      'organizerName': organizerName,
    };
  }
}

class Kategori {
  final int id;
  final String namaKategori;
  final String? deskripsi;
  final String? thumbnail;

  Kategori({
    required this.id,
    required this.namaKategori,
    this.deskripsi,
    this.thumbnail,
  });

  factory Kategori.fromJson(Map<String, dynamic> json) {
    return Kategori(
      id: json['id'],
      namaKategori: json['nama_kategori'],
      deskripsi: json['deskripsi'],
      thumbnail: json['thumbnail'],
    );
  }
}
