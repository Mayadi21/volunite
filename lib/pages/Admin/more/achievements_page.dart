import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'achievement_service.dart';
import 'achievement_form_page.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final PencapaianService _service = PencapaianService();

  List<PencapaianModel> _achievements = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPage(1);
  }

  Future<void> _fetchPage(int page) async {
    setState(() => _isLoading = true);
    try {
      final result = await _service.getAll(page: page);
      if (!mounted) return;

      setState(() {
        _achievements = result['list'];
        _lastPage = result['last_page'];
        _currentPage = page;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= DELETE =================
  Future<void> _deleteAchievement(PencapaianModel ach) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Achievement'),
        content: Text('Yakin ingin menghapus "${ach.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.delete(ach.id);
      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
        _fetchPage(_currentPage);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus data')));
      }
    }
  }

  // ================= NAVIGATE FORM =================
  Future<void> _openForm({PencapaianModel? item}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AchievementFormPage(initialData: item)),
    );

    if (result == true) {
      _fetchPage(_currentPage);
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Achievement',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _achievements.length,
              itemBuilder: (context, index) {
                final ach = _achievements[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  elevation: 3,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    // ========= THUMBNAIL =========
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: ach.thumbnailUrl != null
                            ? CachedNetworkImage(
                                imageUrl: ach.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const Icon(Icons.broken_image),
                              )
                            : Container(
                                color: Colors.indigo.shade50,
                                child: const Icon(
                                  FontAwesomeIcons.award,
                                  color: Colors.indigo,
                                  size: 20,
                                ),
                              ),
                      ),
                    ),

                    // ========= CONTENT =========
                    title: Text(
                      ach.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ach.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // ========= ACTION =========
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () => _openForm(item: ach),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteAchievement(ach),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      // ================= PAGINATION =================
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _currentPage > 1
                  ? () => _fetchPage(_currentPage - 1)
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            Text(
              'Halaman $_currentPage dari $_lastPage',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: _currentPage < _lastPage
                  ? () => _fetchPage(_currentPage + 1)
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),

      // ================= ADD =================
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
