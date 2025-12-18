import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

// Ganti import ini sesuai lokasi file service & model kamu
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'achievement_service.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  final PencapaianService _service = PencapaianService();

  // State Data & Pagination
  List<PencapaianModel> _achievements = [];
  bool _isLoading = true;
  int _currentPage = 1;
  int _lastPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPage(1); // Load halaman 1 saat awal
  }

  // Fungsi ambil data per halaman
  Future<void> _fetchPage(int page) async {
    setState(() => _isLoading = true);
    try {
      final result = await _service.getAll(page: page);
      if (mounted) {
        setState(() {
          _achievements = result['list'];
          _lastPage = result['last_page'];
          _currentPage = page;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      print("Error fetching data: $e");
    }
  }

  // --- FUNGSI YANG HILANG SEBELUMNYA (DELETE) ---
  Future<void> _deleteAchievement(PencapaianModel ach) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Achievement'),
        content: Text('Anda yakin ingin menghapus "${ach.nama}"?'),
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
      if (success && mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Berhasil dihapus")));
        _fetchPage(_currentPage); // Refresh halaman saat ini
      } else if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Gagal menghapus data")));
      }
    }
  }

  // --- FUNGSI YANG HILANG SEBELUMNYA (SHOW FORM) ---
  void _showFormDialog({PencapaianModel? item}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AchievementFormDialog(
        initialData: item,
        onSaved: () {
          _fetchPage(_currentPage); // Refresh halaman saat ini setelah simpan
        },
      ),
    );
  }

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
                    // Logika Gambar (Thumbnail)
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipOval(
                        child: ach.thumbnailUrl != null
                            ? CachedNetworkImage(
                                imageUrl: ach.thumbnailUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
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
                    title: Text(
                      ach.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      ach.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showFormDialog(item: ach),
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

      // Tombol Pagination di Bawah
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
              "Halaman $_currentPage dari $_lastPage",
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

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// =========================================================
// WIDGET FORM DIALOG (Sama seperti sebelumnya)
// =========================================================

class AchievementFormDialog extends StatefulWidget {
  final PencapaianModel? initialData;
  final VoidCallback onSaved;

  const AchievementFormDialog({
    super.key,
    this.initialData,
    required this.onSaved,
  });

  @override
  State<AchievementFormDialog> createState() => _AchievementFormDialogState();
}

class _AchievementFormDialogState extends State<AchievementFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  XFile? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialData?.nama ?? '');
    _descCtrl = TextEditingController(
      text: widget.initialData?.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final service = PencapaianService();
    final fields = {
      'nama': _nameCtrl.text,
      'deskripsi': _descCtrl.text,
      'required_exp': '100', // Default value
    };

    bool success;
    if (widget.initialData == null) {
      success = await service.create(fields, _selectedImage);
    } else {
      success = await service.update(
        widget.initialData!.id,
        fields,
        _selectedImage,
      );
    }

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        Navigator.pop(context);
        widget.onSaved();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan data')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialData == null ? 'Tambah Pencapaian' : 'Edit Pencapaian',
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _displayImagePreview(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Ketuk kotak untuk ubah foto",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Pencapaian',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                validator: (v) => v!.isEmpty ? 'Nama harus diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 3,
                validator: (v) => v!.isEmpty ? 'Deskripsi harus diisi' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _submit,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
          child: _isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text('Simpan', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _displayImagePreview() {
    if (_selectedImage != null) {
      if (kIsWeb) {
        return Image.network(_selectedImage!.path, fit: BoxFit.cover);
      } else {
        return Image.file(File(_selectedImage!.path), fit: BoxFit.cover);
      }
    }
    if (widget.initialData?.thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: widget.initialData!.thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    }
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt, color: Colors.grey),
        SizedBox(height: 4),
        Text("Upload", style: TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}
