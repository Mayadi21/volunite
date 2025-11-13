// lib/pages/Organizer/navbar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/pages/Organizer/home.dart';
import 'package:volunite/pages/Organizer/activities_page.dart';
import 'package:volunite/pages/Organizer/profile.dart';

class OrganizerLandingPage extends StatefulWidget {
  const OrganizerLandingPage({super.key});

  @override
  State<OrganizerLandingPage> createState() => _OrganizerLandingPageState();
}

class _OrganizerLandingPageState extends State<OrganizerLandingPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    OrganizerHomeTab(), // 🏠 Beranda
    OrganizerActivitiesPage(), // 📅 Kegiatan
    OrganizerProfilePage(), // 🙍‍♂️ Profil
  ];

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            label: "Kegiatan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
