// lib/pages/Admin/data/mock_data.dart
import 'admin_models.dart';

// Data awal untuk simulasi
List<Volunteer> mockVolunteers = [
  Volunteer(
      id: 1,
      name: 'Budi Santoso',
      email: 'budi@example.com',
      events: 5,
      status: 'Aktif'),
  Volunteer(
      id: 2,
      name: 'Citra Lestari',
      email: 'citra@example.com',
      events: 8,
      status: 'Aktif'),
  Volunteer(
      id: 3,
      name: 'Ahmad Dahlan',
      email: 'ahmad@example.com',
      events: 2,
      status: 'Nonaktif'),
];

List<Organization> mockOrganizations = [
  Organization(
      id: 1,
      name: 'Yayasan Peduli Anak',
      email: 'info@ypa.org',
      eventsPosted: 12,
      status: 'Terverifikasi'),
  Organization(
      id: 2,
      name: 'Komunitas Ciliwung',
      email: 'ciliwung@gmail.com',
      eventsPosted: 5,
      status: 'Pending'),
];

List<Achievement> mockAchievements = [
  Achievement(
      id: 1, name: 'Relawan Emas', description: 'Menyelesaikan 50 jam volunteer'),
  Achievement(
      id: 2,
      name: 'Penggerak Komunitas',
      description: 'Mengajak 10 teman bergabung'),
];

// --- DATA BARU UNTUK MANAJEMEN KEGIATAN ---
// Saya ambil path image dari file Anda (assets/images/event1.jpg, dll.)
