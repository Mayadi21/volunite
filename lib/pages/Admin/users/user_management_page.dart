import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart'; // Import models (untuk warna)
import 'volunteer_list_page.dart';
import 'organization_list_page.dart';
// Hapus import add_new_user_page.dart

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // --- UBAH 'length' DARI 3 MENJADI 2 ---
    return DefaultTabController(
      length: 2, // <-- UBAH INI
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            labelColor: primaryColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: primaryColor,
            // --- HAPUS TAB 'TAMBAH BARU' ---
            tabs: [
              Tab(icon: Icon(Icons.person), text: 'Volunteer'),
              Tab(icon: Icon(Icons.business), text: 'Organisasi'),
            ], // <-- UBAH INI
          ),
        ),
        // --- HAPUS HALAMAN 'AddNewUserPage' DARI SINI ---
        body: const TabBarView(
          children: [
            VolunteerListPage(),
            OrganizationListPage(),
          ], // <-- UBAH INI
        ),
      ),
    );
  }
}