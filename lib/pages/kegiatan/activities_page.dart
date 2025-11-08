// lib/pages/kegiatan/activities_page.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../landing.dart';

class ActivitiesPage extends StatelessWidget {
  const ActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF005271);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Kegiatan',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(text: 'Mendatang'),
              Tab(text: 'Riwayat'),
            ],
          ),
        ),

        body: const TabBarView(children: [_UpcomingTab(), _HistoryTab()]),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 1,
          selectedItemColor: primary,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LandingPage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: "Beranda",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.calendar),
              label: "Kegiatan",
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.users),
              label: "Komunitas",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profil",
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB - MENDATANG
// -----------------------------------------------------------------------------
class _UpcomingTab extends StatelessWidget {
  const _UpcomingTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SearchField(),
        SizedBox(height: 16),
        _ActivityCard(
          imagePath: 'assets/event1.jpg',
          title: 'Pintar Bersama - KMB USU',
          date: 'Sabtu, 19 Oktober 2024',
          time: '12.00 WIB - 17.00 WIB',
        ),
        SizedBox(height: 14),
        _ActivityCard(
          imagePath: 'assets/event2.jpg',
          title: 'Aksi Bersih Pantai',
          date: 'Minggu, 20 Oktober 2024',
          time: '09.00 WIB - 12.00 WIB',
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// TAB - RIWAYAT
// -----------------------------------------------------------------------------
class _HistoryTab extends StatelessWidget {
  const _HistoryTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        _SearchField(),
        SizedBox(height: 16),
        _ActivityCard(
          imagePath: 'assets/event1.jpg',
          title: 'Pintar Bersama - KMB USU',
          date: 'Sabtu, 19 Oktober 2024',
          time: '12.00 WIB - 17.00 WIB',
          trailingChip: _FinishedChip(),
        ),
        SizedBox(height: 14),
        _ActivityCard(
          imagePath: 'assets/event2.jpg',
          title: 'Aksi Bersih Pantai',
          date: 'Minggu, 20 Oktober 2024',
          time: '09.00 WIB - 12.00 WIB',
          trailingChip: _FinishedChip(),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// SEARCH FIELD COMPONENT
// -----------------------------------------------------------------------------
class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari kegiatan di sini...',
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// CARD COMPONENT
// -----------------------------------------------------------------------------
class _ActivityCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String date;
  final String time;
  final Widget? trailingChip;

  const _ActivityCard({
    required this.imagePath,
    required this.title,
    required this.date,
    required this.time,
    this.trailingChip,
  });

  @override
  Widget build(BuildContext context) {
    const cardBg = Color(0xFFCCDEDC);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              imagePath,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),

                _InfoRow(icon: Icons.calendar_today, text: date),
                const SizedBox(height: 4),
                _InfoRow(icon: Icons.access_time, text: time),

                if (trailingChip != null) ...[
                  const SizedBox(height: 12),
                  Align(alignment: Alignment.centerRight, child: trailingChip!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Row icon + text
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// Chip status selesai
class _FinishedChip extends StatelessWidget {
  const _FinishedChip();

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: const Text(
        'Sudah Selesai',
        style: TextStyle(color: Color(0xFF1E7D4E)),
      ),
      backgroundColor: const Color(0xFFE6F4EA),
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
