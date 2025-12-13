import 'package:flutter/material.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'kategori_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'create_category_page.dart';
import 'edit_category_page.dart';

class ActivityCategoryPage extends StatefulWidget {
  const ActivityCategoryPage({super.key});

  @override
  State<ActivityCategoryPage> createState() => _ActivityCategoryPageState();
}

class _ActivityCategoryPageState extends State<ActivityCategoryPage> {
  final KategoriService _service = KategoriService();
  late Future<List<Kategori>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.fetchKategori();
  }

  void _refresh() {
    setState(() {
      _future = _service.fetchKategori();
    });
  }

  void _showForm({Kategori? kategori}) {
    final namaC = TextEditingController(text: kategori?.namaKategori);
    final descC = TextEditingController(text: kategori?.deskripsi);
    XFile? selectedImage;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          title: Text(kategori == null ? 'Tambah Kategori' : 'Edit Kategori'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null) {
                      setStateDialog(() => selectedImage = image);
                    }
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: selectedImage != null
                        ? Image.file(
                            File(selectedImage!.path),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : kategori?.thumbnail != null
                        ? Image.network(
                            kategori!.thumbnail!,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 40),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: namaC,
                  decoration: const InputDecoration(labelText: 'Nama Kategori'),
                ),
                TextField(
                  controller: descC,
                  decoration: const InputDecoration(labelText: 'Deskripsi'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (kategori == null) {
                  await _service.createKategori(
                    nama: namaC.text,
                    deskripsi: descC.text,
                    thumbnail: selectedImage,
                  );
                } else {
                  await _service.updateKategori(
                    id: kategori.id,
                    nama: namaC.text,
                    deskripsi: descC.text,
                    thumbnail: selectedImage,
                  );
                }

                Navigator.pop(context);
                _refresh();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // === PLACEHOLDER GAMBAR ===
  Widget _placeholder() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kategori Kegiatan')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateCategoryPage()),
          );

          if (result == true) {
            _refresh(); // reload data setelah create
          }
        },
        child: const Icon(Icons.add),
      ),

      body: FutureBuilder<List<Kategori>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada kategori'));
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final k = data[i];

              // ===== DEBUG WAJIB =====
              debugPrint('==============================');
              debugPrint('KATEGORI ID      : ${k.id}');
              debugPrint('NAMA KATEGORI    : ${k.namaKategori}');
              debugPrint('THUMBNAIL URL    : ${k.thumbnail}');
              debugPrint('==============================');

              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: k.thumbnail != null
                      ? Image.network(
                          k.thumbnail!,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('ERROR LOAD IMAGE (ID ${k.id}): $error');
                            return _placeholder();
                          },
                        )
                      : _placeholder(),
                ),
                title: Text(k.namaKategori),
                subtitle: Text(k.deskripsi ?? '-'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditCategoryPage(kategori: k),
                      ),
                    );

                    if (result == true) {
                      _refresh(); // reload list setelah edit
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
