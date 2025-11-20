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
List<Activity> mockActivities = [
  Activity(
      id: 1,
      name: 'Bersih Pantai Ancol',
      organizerName: 'Komunitas Ciliwung',
      date: '20 Desember 2025',
      time: '08:00 - 12:00 WIB',
      location: 'Pantai Ancol, Jakarta Utara',
      description:
          'Bergabunglah bersama kami dalam membersihkan sampah plastik di sepanjang Pantai Ancol untuk menyelamatkan biota laut. Peralatan disediakan.',
      imageAsset: 'assets/images/event2.jpg', // Ambil dari aset volunteer
      status: 'Disetujui'),
  Activity(
      id: 2,
      name: 'Mengajar Anak Jalanan',
      organizerName: 'Yayasan Peduli Anak',
      date: '22 Desember 2025',
      time: '14:00 - 17:00 WIB',
      location: 'Rumah Singgah YPA, Blok M',
      description:
          'Berbagi ilmu dan keceriaan dengan adik-adik di rumah singgah. Kita akan belajar matematika dasar dan membaca cerita.',
      imageAsset: 'assets/images/event1.jpg', // Ambil dari aset volunteer
      status: 'Disetujui'),
  Activity(
      id: 3,
      name: 'Pesta Rakyat & Donor Darah',
      organizerName: 'Pemuda Setempat',
      date: '25 Desember 2025',
      time: '09:00 - 15:00 WIB',
      location: 'Lapangan Banteng, Jakarta Pusat',
      description:
          'Kegiatan donor darah massal yang dirangkai dengan bazar UMKM dan panggung hiburan rakyat. Setetes darahmu berarti bagi mereka.',
      imageAsset: 'assets/images/event2.jpg', // Ganti dengan gambar yang sesuai
      status: 'Pending'), // <-- INI YANG AKAN KITA ACC
  Activity(
      id: 4,
      name: 'Bagi-Bagi Takjil Gratis',
      organizerName: 'Masjid Istiqlal',
      date: '28 Desember 2025',
      time: '16:00 - 18:00 WIB',
      location: 'Area Masjid Istiqlal',
      description:
          'Membantu persiapan dan pembagian 1000 paket takjil gratis untuk musafir dan masyarakat sekitar. Ditunggu partisipasinya!',
      imageAsset: 'assets/images/event1.jpg', // Ganti dengan gambar yang sesuai
      status: 'Pending'), // <-- INI JUGA AKAN KITA ACC
];