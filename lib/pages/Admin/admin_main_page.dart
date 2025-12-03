import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart'; // Import models (untuk warna)

// Import semua halaman utama
import 'package:volunite/pages/Admin/dashboard/dashboard_page.dart';
import 'package:volunite/pages/Admin/users/user_management_page.dart';
import 'package:volunite/pages/Admin/activities/activity_management_page.dart'; // <-- HALAMAN BARU
import 'package:volunite/pages/Admin/reports/reports_page.dart';
import 'package:volunite/pages/Admin/more/more_page.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _selectedIndex = 0;

  // --- DAFTAR HALAMAN DIPERBARUI (5 HALAMAN) ---
  static const List<Widget> _pages = <Widget>[
    DashboardPage(),
    UserManagementPage(),
    ActivityManagementPage(), // <-- HALAMAN BARU
    ReportsPage(),
    MorePage(),
  ];

  // --- DAFTAR JUDUL DIPERBARUI (5 JUDUL) ---
  static const List<String> _pageTitles = [
    'Dashboard',
    'Manajemen Pengguna',
    'Manajemen Kegiatan', // <-- JUDUL BARU
    'Laporan',
    'Lainnya',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex],
            style: const TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false, // Sembunyikan tombol kembali
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        // --- DAFTAR ITEM DIPERBARUI (5 ITEM) ---
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_note_rounded), // <-- ITEM BARU
            label: 'Kegiatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment_rounded),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            label: 'Lainnya',
          ),
        ],
      ),
    );
  }
}