import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/users/edit_user_page.dart';
import 'user_service.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'add_new_user_page.dart';
import 'package:volunite/color_pallete.dart';


class VolunteerListPage extends StatefulWidget {
  const VolunteerListPage({super.key});

  @override
  State<VolunteerListPage> createState() => _VolunteerListPageState();
}

class _VolunteerListPageState extends State<VolunteerListPage> {
  bool _loading = true;
  List<dynamic> _volunteers = [];

  @override
  void initState() {
    super.initState();
    _fetchVolunteers();
  }

  Future<void> _fetchVolunteers() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await UserService.fetchUsers(role: 'Volunteer');
      setState(() {
        _volunteers = data['data'] ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat: $e')));
    }
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Volunteer'),
        content: Text('Anda yakin ingin menghapus $name ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await UserService.deleteUser(id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Berhasil dihapus')),
                );
                _fetchVolunteers();
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openEditPage(int id) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditUserPage(userId: id, title: 'Edit Volunteer'),
      ),
    );
    if (result == true) {
      _fetchVolunteers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchVolunteers,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _volunteers.length,
                itemBuilder: (context, index) {
                  final v = _volunteers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: kPrimaryColor.withOpacity(0.2),
                        child: Text(
                          (v['nama'] ?? 'U')[0],
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ),
                      title: Text(v['nama'] ?? ''),
                      subtitle: Text(v['email'] ?? ''),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _openEditPage(v['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _confirmDelete(v['id'], v['nama'] ?? ''),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddUserPage()),
          );
          if (result == true) {
            _fetchVolunteers(); // refresh list
          }
        },
      )

    );
  }
}
