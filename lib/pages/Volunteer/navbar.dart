// lib/pages/navbar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/pages/Volunteer/home.dart';
import 'package:volunite/pages/Volunteer/Activity/activities_page.dart';
import 'package:volunite/pages/Volunteer/Profile/profile.dart';
import 'package:volunite/color_pallete.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  // Daftar halaman/tab (Sekarang hanya ada 3 item)
  final List<Widget> _pages = const [
    HomeTab(), // Index 0
    ActivitiesPage(), // Index 1
    ProfilePage(), // Index 2 (Sebelumnya index 3)
  ];

  @override
  Widget build(BuildContext context) {
    // Menggunakan kSkyBlue sebagai warna utama yang dipilih
    const Color selectedColor = kSkyBlue;
    // Menggunakan kBlueGray sebagai warna yang tidak dipilih
    const Color unselectedColor = kBlueGray;

    return Scaffold(
      // Menggunakan warna background aplikasi yang sudah didefinisikan
      backgroundColor: kBackground,
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // Disesuaikan: menggunakan warna dari color_pallete.dart
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        // Warna latar disetel ke putih agar bersih
        backgroundColor: Colors.white,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          // Item 1: Beranda
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Beranda",
          ),
          // Item 2: Kegiatan
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidCalendar),
            label: "Kegiatan",
          ),
          // Item 3: Profil (Komunitas sudah dihapus)
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}
