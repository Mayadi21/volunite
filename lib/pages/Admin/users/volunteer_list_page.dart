import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:volunite/pages/Admin/data/mock_data.dart';
import 'package:volunite/pages/Admin/users/add_new_user_page.dart';

class VolunteerListPage extends StatefulWidget {
  const VolunteerListPage({super.key});

  @override
  State<VolunteerListPage> createState() => _VolunteerListPageState();
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  void _deleteVolunteer(Volunteer volunteer) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Volunteer'),
        content: Text('Anda yakin ingin menghapus ${volunteer.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                mockVolunteers.removeWhere((v) => v.id == volunteer.id);
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showVolunteerForm([Volunteer? volunteer]) {
    // Navigasi ke halaman AddNewUserPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddNewUserPage(
          // Kita bisa kirim data jika ini mode 'Edit'
          // Jika tidak, kirim null untuk mode 'Tambah'
          volunteerToEdit: volunteer,
        ),
      ),
    ).then((berhasilDitambahkan) {
      // Jika halaman ditutup dan mengembalikan nilai 'true' (berhasil)
      if (berhasilDitambahkan == true) {
        setState(() {
          // Refresh list untuk menampilkan data baru
          // (Di aplikasi nyata, Anda akan memuat ulang data dari database)
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: mockVolunteers.length,
        itemBuilder: (context, index) {
          final volunteer = mockVolunteers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.2),
                child: Text(
                  volunteer.name[0],
                  style: const TextStyle(color: primaryColor),
                ),
              ),
              title: Text(
                volunteer.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(volunteer.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showVolunteerForm(volunteer),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteVolunteer(volunteer),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // --- 3. PASTIKAN ONPRESSED SEPERTI INI ---
        onPressed: () =>
            _showVolunteerForm(), // Panggil fungsi tanpa parameter (mode Tambah)
        backgroundColor: primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
