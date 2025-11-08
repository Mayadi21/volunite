import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'profile.dart';
import 'home.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  // Daftar halaman/tab
  final List<Widget> _pages = const [
    HomeTab(), // Halaman utama (beranda)
    Center(child: Text("Halaman Kegiatan")), // Index 1: Kegiatan
    Center(child: Text("Halaman Komunitas")), // Index 2: Komunitas
    ProfilePage(), // Profil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // Ganti body dengan IndexedStack agar tiap halaman tersimpan
      body: IndexedStack(index: _selectedIndex, children: _pages),

      // 🧭 Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        type: BottomNavigationBarType.fixed,
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
    );
  }
}
