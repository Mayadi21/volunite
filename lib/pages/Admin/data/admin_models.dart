// lib/pages/Admin/data/admin_models.dart
import 'package:flutter/material.dart';

// Warna primer untuk konsistensi
const Color primaryColor = Color(0xFF0C5E70);

class Volunteer {
  int id;
  String name;
  String email;
  int events;
  String status;
  Volunteer(
      {required this.id,
      required this.name,
      required this.email,
      this.events = 0,
      this.status = 'Aktif'});
}

class Organization {
  int id;
  String name;
  String email;
  int eventsPosted;
  String status;
  Organization(
      {required this.id,
      required this.name,
      required this.email,
      this.eventsPosted = 0,
      this.status = 'Pending'});
}

class Achievement {
  int id;
  String name;
  String description;
  Achievement({required this.id, required this.name, required this.description});
}

// --- MODEL BARU UNTUK MANAJEMEN KEGIATAN ---
// Kita tambahkan detail seperti di halaman volunteer
class Activity {
  int id;
  String name;
  String organizerName;
  String date;
  String time; // Tambahan
  String location; // Tambahan
  String description; // Tambahan
  String imageAsset; // Tambahan (pakai aset dari app volunteer)
  String status;
  Activity(
      {required this.id,
      required this.name,
      required this.organizerName,
      required this.date,
      required this.time,
      required this.location,
      required this.description,
      required this.imageAsset,
      required this.status});
}