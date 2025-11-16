import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/pages/Admin/data/mock_data.dart';
import 'add_new_user_page.dart'; // <-- 1. DITAMBAHKAN

class OrganizationListPage extends StatefulWidget {
  const OrganizationListPage({super.key});

  @override
  State<OrganizationListPage> createState() => _OrganizationListPageState();
}

class _OrganizationListPageState extends State<OrganizationListPage> {
  // --- 2. FUNGSI BARU (SESUAI PERMINTAAN ANDA) ---
  void _deleteOrganization(Organization org) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Organisasi'), // Diubah
        content: Text('Anda yakin ingin menghapus ${org.name}?'), // Diubah
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal')),
          TextButton(
            onPressed: () {
              setState(() {
                // Diubah ke mockOrganizations
                mockOrganizations.removeWhere((o) => o.id == org.id);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // --- 3. FUNGSI BARU (UNTUK EDIT & TAMBAH) ---
  void _showOrganizationForm([Organization? org]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewUserPage(
          // Kirim data organisasi untuk mode edit
          organizationToEdit: org,
        ),
      ),
    ).then((berhasilDitambahkan) {
      // then() akan berjalan saat halaman AddNewUserPage ditutup (pop)
      if (berhasilDitambahkan == true) {
        setState(() {
          // Ini akan me-refresh list untuk menampilkan data baru/yang diubah
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: mockOrganizations.length,
        itemBuilder: (context, index) {
          final org = mockOrganizations[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.withOpacity(0.2),
                child: const Icon(Icons.business, color: Colors.green),
              ),
              title: Text(org.name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(org.status),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    // --- 4. DIPERBARUI ---
                    onPressed: () => _showOrganizationForm(org), // Mode edit
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    // --- 5. DIPERBARUI (SESUAI PERMINTAAN ANDA) ---
                    onPressed: () => _deleteOrganization(org),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // --- 6. DIPERBARUI ---
        onPressed: () => _showOrganizationForm(), // Mode tambah
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}