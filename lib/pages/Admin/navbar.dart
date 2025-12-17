// lib/pages/Admin/navbar.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:volunite/color_pallete.dart';

// Import halaman admin (Laporan dihapus)
import 'package:volunite/pages/Admin/dashboard/dashboard_page.dart';
import 'package:volunite/pages/Admin/users/user_management_page.dart';
import 'package:volunite/pages/Admin/activities/activity_management_page.dart';
// import 'package:volunite/pages/Admin/reports/reports_page.dart'; // Dihapus
import 'package:volunite/pages/Admin/more/more_page.dart';

class AdminLandingPage extends StatefulWidget {
  const AdminLandingPage({super.key});

  @override
  State<AdminLandingPage> createState() => _AdminLandingPageState();
}

class _AdminLandingPageState extends State<AdminLandingPage> {
  int _selectedIndex = 0;

  // List halaman sekarang hanya berisi 4 item
  late final List<Widget> _pages = [
    const DashboardPage(),
    const UserManagementPage(),
    const ActivityManagementPage(),
    // const ReportsPage(), // Dihapus
    const MorePage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = kSkyBlue;
    const Color unselectedColor = kBlueGray;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        // Item navbar sekarang hanya ada 4
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: "Users",
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clipboardList),
            label: "Kegiatan",
          ),
          // Item Laporan dihapus dari sini
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            label: "Lainnya",
          ),
        ],
      ),
    );
  }
}