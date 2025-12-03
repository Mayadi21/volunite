// lib/pages/Organizer/activities_page.dart
import 'package:flutter/material.dart';

class OrganizerActivitiesPage extends StatefulWidget {
  const OrganizerActivitiesPage({super.key});

  @override
  State<OrganizerActivitiesPage> createState() =>
      _OrganizerActivitiesPageState();
}

class _OrganizerActivitiesPageState extends State<OrganizerActivitiesPage> {
  // Dummy data contoh; nanti ganti dengan data dari backend Laravel
  final List<_ActivityItem> _items = [
    _ActivityItem(
      title: 'Pintar Bersama - KMB USU',
      banner: 'assets/images/event1.jpg',
      start: DateTime(2025, 11, 15, 12, 0),
      end: DateTime(2025, 11, 15, 17, 0),
      location: 'USU - Ruang B.204',
      registered: 46,
      quota: 60,
    ),
    _ActivityItem(
      title: 'Aksi Bersih Pantai',
      banner: 'assets/images/event2.jpg',
      start: DateTime(2025, 11, 16, 9, 0),
      end: DateTime(2025, 11, 16, 12, 0),
      location: 'Pantai Cermin',
      registered: 82,
      quota: 120,
    ),
    _ActivityItem(
      title: 'Donor Darah',
      banner: 'assets/images/event2.jpg',
      start: DateTime(2025, 10, 5, 9, 0),
      end: DateTime(2025, 10, 5, 13, 0),
      location: 'Aula Fakultas',
      registered: 120,
      quota: 120,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final now = DateTime.now();

    final upcoming = _items.where((e) => e.end.isAfter(now)).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    final history = _items.where((e) => e.end.isBefore(now)).toList()
      ..sort((a, b) => b.start.compareTo(a.start));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header simple (bisa disamakan dengan Home jika perlu)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Kegiatan Penyelenggara",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: primary,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Tab pill
                  _TabPill(
                    tabs: const [
                      Tab(text: "Mendatang"),
                      Tab(text: "Riwayat"),
                    ],
                    primary: primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Mendatang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: upcoming.isEmpty
                  ? const _EmptyState(
                      title: "Belum ada kegiatan mendatang",
                      subtitle:
                          "Buat kegiatan baru agar relawan bisa mendaftar.",
                    )
                  : ListView.separated(
                      itemCount: upcoming.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _OrganizerEventTile(
                        item: upcoming[i],
                        primary: primary,
                        onManage: () => _openManage(context, upcoming[i].title),
                        onApplicants: () {},
                      ),
                    ),
            ),

            // Tab Riwayat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: history.isEmpty
                  ? const _EmptyState(
                      title: "Riwayat kosong",
                      subtitle:
                          "Kegiatan yang sudah selesai akan ditampilkan di sini.",
                    )
                  : ListView.separated(
                      itemCount: history.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _OrganizerEventTile(
                        item: history[i],
                        primary: primary,
                        isHistory: true,
                        onManage: () => _openManage(context, history[i].title),
                        onApplicants: () {},
                      ),
                    ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const _CreateEventPlaceholder(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Buat Kegiatan"),
        ),
      ),
    );
  }

  void _openManage(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ManageEventPage(title: title)),
    );
  }
}

// ------------------------------------------------------------
// UI Helpers
// ------------------------------------------------------------

class _TabPill extends StatelessWidget {
  const _TabPill({required this.tabs, required this.primary});
  final List<Widget> tabs;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        tabs: tabs,
        indicator: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _OrganizerEventTile extends StatelessWidget {
  const _OrganizerEventTile({
    required this.item,
    required this.primary,
    this.isHistory = false,
    required this.onManage,
    required this.onApplicants,
  });

  final _ActivityItem item;
  final Color primary;
  final bool isHistory;
  final VoidCallback onManage;
  final VoidCallback onApplicants;

  @override
  Widget build(BuildContext context) {
    final progress = (item.registered / item.quota).clamp(0, 1).toDouble();
    final dDay = _dDayLabel(item.start, item.end);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // banner
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              item.banner,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // badge + title
                Row(
                  children: [
                    _StatusBadge(
                      text: isHistory ? "Selesai" : dDay,
                      color: isHistory ? Colors.grey : primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _dateRange(item.start, item.end),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.place, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      item.location,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // capacity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.registered} / ${item.quota}",
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
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(primary),
                  ),
                ),
                const SizedBox(height: 12),
                // actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onManage,
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
                        onPressed: onApplicants,
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

  String _dDayLabel(DateTime start, DateTime end) {
    final now = DateTime.now();
    if (end.isBefore(now)) return "Selesai";
    if (start.isAfter(now)) {
      final days = start.difference(now).inDays;
      if (days <= 0) return "Hari ini";
      if (days == 1) return "Besok";
      return "$days hari lagi";
    }
    return "Sedang berlangsung";
  }

  String _dateRange(DateTime start, DateTime end) {
    String two(int n) => n.toString().padLeft(2, '0');
    final bulan = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    final s =
        "${_weekday(start.weekday)}, ${two(start.day)} ${bulan[start.month - 1]} ${start.year}";
    final e = "${two(end.day)} ${bulan[end.month - 1]} ${end.year}";
    final jam =
        "${two(start.hour)}.${two(start.minute)} - ${two(end.hour)}.${two(end.minute)} WIB";
    return start.year == end.year &&
            start.month == end.month &&
            start.day == end.day
        ? "$s • $jam"
        : "$s - $e • $jam";
  }

  String _weekday(int w) {
    const m = {
      1: 'Sen',
      2: 'Sel',
      3: 'Rab',
      4: 'Kam',
      5: 'Jum',
      6: 'Sab',
      7: 'Min',
    };
    return m[w] ?? '';
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Model & Placeholder
// ------------------------------------------------------------

class _ActivityItem {
  final String title;
  final String banner;
  final DateTime start;
  final DateTime end;
  final String location;
  final int registered;
  final int quota;

  _ActivityItem({
    required this.title,
    required this.banner,
    required this.start,
    required this.end,
    required this.location,
    required this.registered,
    required this.quota,
  });
}

class _CreateEventPlaceholder extends StatelessWidget {
  const _CreateEventPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Kegiatan")),
      body: const Center(child: Text("Form pembuatan kegiatan di sini.")),
    );
  }
}

class _ManageEventPage extends StatelessWidget {
  const _ManageEventPage({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kelola: $title")),
      body: const Center(child: Text("Halaman kelola kegiatan.")),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Icon(Icons.event_busy, size: 56, color: Colors.grey),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
