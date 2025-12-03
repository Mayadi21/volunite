// lib/pages/Organizer/Activity/edit_activity.dart
import 'package:flutter/material.dart';
// Asumsikan impor ini ada di file utama Anda
import 'package:volunite/color_pallete.dart'; 


// --- DEFINISI WARNA (ASUMSI DARI color_pallete.dart) ---
// Jika kSkyBlue, kDarkBlueGray, kLightGray, dll. belum didefinisikan,
// Anda perlu memastikan impor di atas berfungsi atau mendefinisikannya di sini.
// Contoh Placeholder jika color_pallete.dart tidak tersedia:
// const kSkyBlue = Color(0xFF42A5F5); // Primary Color
// const kDarkBlueGray = Color(0xFF333333); 
// const kLightGray = Color(0xFFEEEEEE); 


const kPrimaryColor = kSkyBlue; // Ditetapkan sebagai warna utama

class EditActivityPage extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String imagePath;
  // Anda bisa menambahkan properti lain seperti deskripsi, lokasi, dll.
  // agar form lebih lengkap

  const EditActivityPage({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  @override
  State<EditActivityPage> createState() =>
      _EditActivityPageState();
}

class _EditActivityPageState
    extends State<EditActivityPage> {
  // Controller untuk form input
  late TextEditingController _titleController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai dari widget saat ini
    _titleController = TextEditingController(text: widget.title);
    _dateController = TextEditingController(text: widget.date);
    _timeController = TextEditingController(text: widget.time);
    
    // Asumsi deskripsi lengkap dari halaman detail
    _descriptionController = TextEditingController(
        text:
            'Kegiatan volunteer yang mengajak Anda untuk berbagi ilmu dan inspirasi kepada anak-anak yang membutuhkan. Melalui acara ini, Anda dapat berkontribusi dalam memberikan pendidikan dan pengalaman belajar yang menyenangkan. Mari bersama-sama menciptakan perubahan positif dan memberikan dampak nyata bagi generasi muda.'); 
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Fungsi placeholder untuk menyimpan data
  void _saveChanges() {
    final updatedTitle = _titleController.text;
    final updatedDate = _dateController.text;
    final updatedTime = _timeController.text;
    final updatedDescription = _descriptionController.text;

    // TODO: Implementasi logika penyimpanan data (API/Database) di sini

    // Tampilkan notifikasi dan kembali
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Perubahan pada "$updatedTitle" berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );
    // Pop kembali ke halaman detail
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final primary = kPrimaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Kegiatan'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Simpan',
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Input Judul ---
            _buildSectionTitle('Judul Kegiatan'),
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration.copyWith(
                hintText: 'Masukkan judul kegiatan',
              ),
            ),
            const SizedBox(height: 24),

            // --- Input Tanggal dan Waktu ---
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Tanggal'),
                      TextFormField(
                        controller: _dateController,
                        readOnly: true, // Disarankan untuk DatePicker
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030),
                          );
                          if (date != null) {
                            setState(() {
                              _dateController.text =
                                  "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
                            });
                          }
                        },
                        decoration: _inputDecoration.copyWith(
                          hintText: 'Pilih Tanggal',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Waktu'),
                      TextFormField(
                        controller: _timeController,
                        readOnly: true, // Disarankan untuk TimePicker
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _timeController.text = time.format(context);
                            });
                          }
                        },
                        decoration: _inputDecoration.copyWith(
                          hintText: 'Pilih Waktu',
                          suffixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- Input Deskripsi ---
            _buildSectionTitle('Deskripsi Kegiatan'),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: _inputDecoration.copyWith(
                hintText: 'Jelaskan kegiatan secara detail',
              ),
            ),
            const SizedBox(height: 24),

            // --- Input Gambar ---
            _buildSectionTitle('Gambar Kegiatan'),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    // Tambahkan placeholder jika gambar tidak ditemukan
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Logic untuk memilih gambar baru
                      },
                      icon: const Icon(Icons.file_upload, size: 18),
                      label: const Text('Ganti Gambar'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: primary,
                        backgroundColor: primary.withOpacity(0.1),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Format: JPG, PNG (Max 5MB)',
                      style: TextStyle(
                        fontSize: 12,
                        color: kDarkBlueGray.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // --- Tombol Simpan Akhir ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk judul bagian
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: kDarkBlueGray,
        ),
      ),
    );
  }
  
  // Helper untuk dekorasi input
  final InputDecoration _inputDecoration = const InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: kLightGray),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: kLightGray, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
    ),
  );
}