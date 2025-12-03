// lib/pages/Organizer/navbar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/pages/Organizer/home.dart';
import 'package:volunite/pages/Organizer/Activity/activities_page.dart';
import 'package:volunite/pages/Organizer/Profile/profile.dart';
// 1. IMPORT PALET WARNA (Asumsi ini file yang sama dengan Volunteer)
import 'package:volunite/color_pallete.dart';

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
    // 2. Tentukan warna yang akan digunakan (mengacu pada Volunteer)
    const Color selectedColor = kSkyBlue;
    const Color unselectedColor = kBlueGray;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // 3. Gunakan warna dari color_pallete.dart
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        // 4. Atur warna latar belakang menjadi putih
        backgroundColor: Colors.white,
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
