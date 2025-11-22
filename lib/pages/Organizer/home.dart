// lib/pages/Organizer/home.dart
import 'package:flutter/material.dart';
import 'package:volunite/pages/Organizer/Notification/notification.dart';
import 'package:volunite/pages/Organizer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Organizer/Activity/edit_activity.dart';
import 'package:volunite/color_pallete.dart'; // Import Color Pallete

class OrganizerHomeTab extends StatelessWidget {
  const OrganizerHomeTab({super.key});

  static const Color kPrimaryAction = kSkyBlue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =======================
            // 👋 Header
            // =======================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        'assets/images/profile_placeholder.jpeg',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Halo, Penyelenggara 👋",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        Text(
                          "Dashboard Kegiatanmu",
                          style: TextStyle(fontSize: 14, color: kBlueGray),
                        ),
                      ],
                    ),
                  ],
                ),
                // --- MODIFIKASI: Ikon Notifikasi dengan Background kSkyBlue ---
                // Bungkus IconButton dengan CircleAvatar untuk background bulat
                CircleAvatar(
                  radius: 22, // Sesuaikan radius agar pas
                  backgroundColor: kSkyBlue, // Latar belakang kSkyBlue
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ), // Ikon menjadi putih
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiPage(),
                        ),
                      );
                    },
                  ),
                ),
                // --- AKHIR MODIFIKASI ---
              ],
            ),

            const SizedBox(height: 20),

            // =======================
            // 📊 Metrics
            // =======================
            _MetricsGrid(primary: kPrimaryAction),

            const SizedBox(height: 24),

            // =======================
            // ➕ Tombol Buat Kegiatan (full width)
            // =======================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const _CreateEventPlaceholder(),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 22),
                label: const Text(
                  "Buat Kegiatan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryAction,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // =======================
            // Kegiatan Mendatang
            // =======================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Kegiatan Mendatang",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlueGray,
                  ),
                ),
                Text(
                  "Kelola",
                  style: TextStyle(
                    color: kBlueGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 340,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _EventManageCard(
                    primary: kPrimaryAction,
                    image: 'assets/images/event1.jpg',
                    title: 'Pintar Bersama - KMB USU',
                    date: 'Sabtu, 19 Okt 2024',
                    time: '12.00 - 17.00 WIB',
                    dDayLabel: '2 hari lagi',
                    registered: 46,
                    quota: 60,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OrganizerDetailActivityPage(
                                title: 'Pintar Bersama - KMB USU',
                                date: 'Sabtu, 19 Okt 2024',
                                time: '12.00 - 17.00 WIB',
                                imagePath: 'assets/images/event1.jpg',
                              ),
                        ),
                      );
                    },
                  ),
                  _EventManageCard(
                    primary: kPrimaryAction,
                    image: 'assets/images/event2.jpg',
                    title: 'Aksi Bersih Pantai',
                    date: 'Minggu, 20 Okt 2024',
                    time: '09.00 - 12.00 WIB',
                    dDayLabel: '3 hari lagi',
                    registered: 82,
                    quota: 120,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OrganizerDetailActivityPage(
                                title: 'Aksi Bersih Pantai',
                                date: 'Minggu, 20 Okt 2024',
                                time: '09.00 - 12.00 WIB',
                                imagePath: 'assets/images/event2.jpg',
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // =======================
            // 👥 Pelamar Terbaru
            // =======================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pelamar Terbaru",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: kDarkBlueGray,
                  ),
                ),
                Text(
                  "Lihat semua",
                  style: TextStyle(
                    color: kBlueGray,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const _ApplicantTile(
              name: "Rina Marlina",
              event: "Pintar Bersama - KMB USU",
              submittedAt: "Baru saja",
            ),
            const _ApplicantTile(
              name: "Andi Saputra",
              event: "Aksi Bersih Pantai",
              submittedAt: "10 menit lalu",
            ),
            const _ApplicantTile(
              name: "Kevin H.",
              event: "Donor Darah",
              submittedAt: "30 menit lalu",
            ),
          ],
        ),
      ),
    );
  }
}

// ... (Widget _MetricsGrid, _MetricItem, _MetricTile, _EventManageCard, _ApplicantTile, _CreateEventPlaceholder, _ManageEventPage tetap sama seperti sebelumnya, tidak ada perubahan di sini) ...

// ---------------------------------------------------------------------
// WIDGET METRICS GRID
// ---------------------------------------------------------------------

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.primary});
  final Color primary;

  @override
  Widget build(BuildContext context) {
    const items = [
      _MetricItem(icon: Icons.event_available, label: "Aktif", value: "4"),
      _MetricItem(
        icon: Icons.pending_actions,
        label: "Menunggu Verif",
        value: "12",
      ),
      _MetricItem(icon: Icons.group, label: "Pendaftar", value: "265"),
      _MetricItem(icon: Icons.star_rate, label: "Rating", value: "4.8"),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final isWide = c.maxWidth > 520;
        final crossAxisCount = isWide ? 4 : 2;
        return GridView.builder(
          itemCount: items.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, i) => _MetricTile(
            icon: items[i].icon,
            label: items[i].label,
            value: items[i].value,
            primary: primary, // primary = kSkyBlue
          ),
        );
      },
    );
  }
}

class _MetricItem {
  final IconData icon;
  final String label;
  final String value;
  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.primary,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            // Ganti Colors.grey.shade200 dengan kLightGray
            color: kLightGray.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              // Background ikon: primary.withOpacity(0.1)
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  // Ganti Colors.grey dengan kBlueGray
                  style: const TextStyle(color: kBlueGray, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: kDarkBlueGray, // Warna utama untuk nilai
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WIDGET EVENT MANAGE CARD
// ---------------------------------------------------------------------

class _EventManageCard extends StatelessWidget {
  const _EventManageCard({
    required this.primary,
    required this.image,
    required this.title,
    required this.date,
    required this.time,
    required this.dDayLabel,
    required this.registered,
    required this.quota,
    this.onTap,
  });

  final Color primary;
  final String image;
  final String title;
  final String date;
  final String time;
  final String dDayLabel;
  final int registered;
  final int quota;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = (registered / quota).clamp(0, 1).toDouble();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // Ganti Colors.grey.shade300 dengan kBlueGray
              color: kBlueGray.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image banner
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // content
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
              ).copyWith(top: 10, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dDayLabel,
                    style: TextStyle(
                      color: primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: kDarkBlueGray, // Warna Judul
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: kBlueGray, // Ganti Colors.grey
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date,
                        style: const TextStyle(
                          color: kBlueGray,
                          fontSize: 12,
                        ), // Ganti Colors.grey
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: kBlueGray,
                      ), // Ganti Colors.grey
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(
                          color: kBlueGray,
                          fontSize: 12,
                        ), // Ganti Colors.grey
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // capacity progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$registered / $quota",
                        style: const TextStyle(
                          fontSize: 12,
                          color: kBlueGray,
                        ), // Ganti Colors.grey
                      ),
                      Text(
                        "${(progress * 100).round()}%",
                        style: TextStyle(fontSize: 12, color: primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      // Ganti Colors.grey.shade200 dengan kLightGray
                      backgroundColor: kLightGray,
                      valueColor: AlwaysStoppedAnimation<Color>(primary),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // actions (OutlinedButton)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditActivityPage(
                                  title: title,
                                  date: date,
                                  time: time,
                                  imagePath: image,
                              ),
                              )
                            );
                          },
                          icon: const Icon(Icons.dashboard_customize, size: 18),
                          label: const Text("Kelola"),
                          style: OutlinedButton.styleFrom(
                            // Warna teks dan ikon di OutlinedButton secara default akan menggunakan primary/foregroundColor
                            foregroundColor: primary,
                            side: BorderSide(
                              color: primary,
                            ), // Border menggunakan primary color
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.person_search, size: 18),
                          label: const Text("Pelamar"),
                          style: OutlinedButton.styleFrom(
                            // Warna teks dan ikon di OutlinedButton secara default akan menggunakan primary/foregroundColor
                            foregroundColor: primary,
                            side: BorderSide(
                              color: primary,
                            ), // Border menggunakan primary color
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WIDGET APPLICANT TILE
// ---------------------------------------------------------------------

class _ApplicantTile extends StatelessWidget {
  const _ApplicantTile({
    required this.name,
    required this.event,
    required this.submittedAt,
  });
  final String name;
  final String event;
  final String submittedAt;

  // Mendefinisikan warna aksi (Tombol Terima)
  static const Color acceptColor = kSkyBlue; // Gunakan kSkyBlue
  static const Color rejectColor = Color(0xFFE57373); // Merah lembut/soft red

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            // Ganti Colors.grey.shade200 dengan kLightGray
            color: kLightGray.withOpacity(0.8),
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile_placeholder.jpeg'),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: kDarkBlueGray,
          ),
        ),
        // Ganti warna teks subtitle
        subtitle: Text(
          "$event • $submittedAt",
          style: const TextStyle(color: kBlueGray),
        ),
        trailing: Wrap(
          spacing: 8,
          children: [
            // Tombol Tolak
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                // Ganti Colors.red dengan rejectColor
                foregroundColor: rejectColor,
                side: BorderSide(color: rejectColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Tolak"),
            ),
            // Tombol Terima
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                // Warna latar belakang tombol Terima
                backgroundColor: acceptColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Terima",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------
// WIDGET PLACEHOLDERS
// ---------------------------------------------------------------------

class _CreateEventPlaceholder extends StatelessWidget {
  const _CreateEventPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kSkyBlue,
        title: const Text(
          "Buat Kegiatan",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Text(
          "Form pembuatan kegiatan di sini.",
          style: TextStyle(color: kBlueGray),
        ),
      ),
    );
  }
}

// class _ManageEventPage extends StatelessWidget {
//   const _ManageEventPage({super.key, required this.title});
//   final String title;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kBackground,
//       appBar: AppBar(
//         backgroundColor: kSkyBlue,
//         title: Text(
//           "Kelola: $title",
//           style: const TextStyle(color: Colors.white),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: const Center(
//         child: Text(
//           "Halaman kelola kegiatan.",
//           style: TextStyle(color: kBlueGray),
//         ),
//       ),
//     );
//   }
// }
