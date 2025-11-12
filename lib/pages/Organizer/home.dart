// lib/pages/Organizer/home.dart
import 'package:flutter/material.dart';

class OrganizerHomeTab extends StatelessWidget {
  const OrganizerHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return SingleChildScrollView(
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
                    backgroundImage: AssetImage('assets/profile.jpg'),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Halo, Penyelenggara 👋",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Dashboard Kegiatanmu",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: primary),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 20),

          // =======================
          // 📊 Metrics
          // =======================
          _MetricsGrid(primary: primary),

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
                backgroundColor: primary,
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
          // 📅 Kegiatan Mendatang
          // =======================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Kegiatan Mendatang 📅",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Kelola",
                style: TextStyle(color: primary, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 240,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _EventManageCard(
                  primary: primary,
                  image: 'assets/event1.jpg',
                  title: 'Pintar Bersama - KMB USU',
                  date: 'Sabtu, 19 Okt 2024',
                  time: '12.00 - 17.00 WIB',
                  dDayLabel: '2 hari lagi',
                  registered: 46,
                  quota: 60,
                ),
                _EventManageCard(
                  primary: primary,
                  image: 'assets/event2.jpg',
                  title: 'Aksi Bersih Pantai',
                  date: 'Minggu, 20 Okt 2024',
                  time: '09.00 - 12.00 WIB',
                  dDayLabel: '3 hari lagi',
                  registered: 82,
                  quota: 120,
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
                "Pelamar Terbaru 👥",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "Lihat semua",
                style: TextStyle(color: primary, fontWeight: FontWeight.w500),
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
    );
  }
}

// ===================================================================
// Widgets Kecil (yang dipakai saja)
// ===================================================================

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
            primary: primary,
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
            color: Colors.grey.shade200,
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
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
  });

  final Color primary;
  final String image;
  final String title;
  final String date;
  final String time;
  final String dDayLabel;
  final int registered;
  final int quota;

  @override
  Widget build(BuildContext context) {
    final progress = (registered / quota).clamp(0, 1).toDouble();

    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
                const SizedBox(height: 10),
                // actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => _ManageEventPage(title: title),
                            ),
                          );
                        },
                        icon: const Icon(Icons.dashboard_customize, size: 18),
                        label: const Text("Kelola"),
                        style: OutlinedButton.styleFrom(
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
    );
  }
}

class _ApplicantTile extends StatelessWidget {
  const _ApplicantTile({
    required this.name,
    required this.event,
    required this.submittedAt,
  });
  final String name;
  final String event;
  final String submittedAt;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/profile.jpg'),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("$event • $submittedAt"),
        trailing: Wrap(
          spacing: 8,
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
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
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Terima"),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================================================================
// Placeholder (agar navigasi tombol tidak error)
// ===================================================================
class _CreateEventPlaceholder extends StatelessWidget {
  const _CreateEventPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Kegiatan")),
      body: const Center(child: Text("Form pembuatan kegiatan di sini.")),
    );
  }
}

class _ManageEventPage extends StatelessWidget {
  const _ManageEventPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelola: $title")),
      body: const Center(child: Text("Halaman kelola kegiatan.")),
    );
  }
}
