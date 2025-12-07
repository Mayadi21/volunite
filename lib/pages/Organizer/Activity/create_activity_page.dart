// lib/pages/Organizer/Activity/create_activity_page.dart

import 'dart:io'; 
import 'package:flutter/foundation.dart'; // Untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // WAJIB: Untuk memblokir input huruf
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart'; // Pastikan path ini benar
import 'package:volunite/models/kategori_model.dart';
import 'package:volunite/services/kategori_service.dart';
import 'package:volunite/services/kegiatan_service.dart';

class CreateActivityPage extends StatefulWidget {
  const CreateActivityPage({super.key});

  @override
  State<CreateActivityPage> createState() => _CreateActivityPageState();
}

class _CreateActivityPageState extends State<CreateActivityPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoadingKategori = true;

  // Controllers
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _syaratController = TextEditingController();
  final _kuotaController = TextEditingController();

  // Data Variables
  DateTime? _tanggalMulai;
  DateTime? _tanggalBerakhir;
  
  // Menggunakan XFile agar kompatibel Web & Mobile
  XFile? _selectedImage;
  
  // Data Kategori
  List<Kategori> _kategoriList = [];
  final List<int> _selectedKategoriIds = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadKategori();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _syaratController.dispose();
    _kuotaController.dispose();
    super.dispose();
  }

  // --- 1. LOAD KATEGORI DARI API ---
  Future<void> _loadKategori() async {
    try {
      final data = await KategoriService.fetchKategori();
      setState(() {
        _kategoriList = data;
        _isLoadingKategori = false;
      });
    } catch (e) {
      setState(() => _isLoadingKategori = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat kategori: $e')),
        );
      }
    }
  }

  // --- 2. PICK IMAGE (WEB & MOBILE COMPATIBLE) ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  // --- 3. PICK DATE TIME ---
  Future<void> _selectDateTime(bool isStart) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate == null) return;

    if (!mounted) return;
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: kPrimaryColor),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime == null) return;

    final DateTime fullDateTime = DateTime(
      pickedDate.year, pickedDate.month, pickedDate.day,
      pickedTime.hour, pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _tanggalMulai = fullDateTime;
      } else {
        _tanggalBerakhir = fullDateTime;
      }
    });
  }

  // --- 4. SUBMIT FORM ---
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Validasi Manual
    if (_selectedImage == null) {
      _showErrorSnackBar('Gambar kegiatan wajib diupload!');
      return;
    }
    if (_tanggalMulai == null || _tanggalBerakhir == null) {
      _showErrorSnackBar('Tanggal mulai dan selesai wajib diisi!');
      return;
    }
    if (_tanggalBerakhir!.isBefore(_tanggalMulai!)) {
      _showErrorSnackBar('Tanggal selesai tidak boleh sebelum tanggal mulai!');
      return;
    }
    if (_selectedKategoriIds.isEmpty) {
      _showErrorSnackBar('Pilih minimal 1 kategori!');
      return;
    }

    setState(() => _isLoading = true);

    // Format Tanggal untuk Laravel
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    // Panggil Service
    final success = await KegiatanService.createKegiatan(
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      lokasi: _lokasiController.text,
      syaratKetentuan: _syaratController.text,
      kuota: _kuotaController.text,
      tanggalMulai: dateFormat.format(_tanggalMulai!),
      tanggalBerakhir: dateFormat.format(_tanggalBerakhir!),
      kategoriIds: _selectedKategoriIds,
      imageFile: _selectedImage, // Kirim XFile
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kegiatan Berhasil Dibuat!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Kembali ke dashboard & refresh
      } else {
        _showErrorSnackBar('Gagal membuat kegiatan. Silakan coba lagi.');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Kegiatan Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: _isLoading 
                ? const SizedBox(
                    width: 20, height: 20, 
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  )
                : const Icon(Icons.check),
            tooltip: 'Publish',
            onPressed: _isLoading ? null : _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // --- 1. UPLOAD GAMBAR (HYBRID PREVIEW) ---
              _buildSectionTitle('Gambar Kegiatan'),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kLightGray, width: 1.5),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.5),
                          child: kIsWeb
                              ? Image.network(
                                  _selectedImage!.path, // Web pakai path (blob url)
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(_selectedImage!.path), // Mobile convert ke File
                                  fit: BoxFit.cover,
                                ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined, size: 40, color: kPrimaryColor.withOpacity(0.7)),
                            const SizedBox(height: 8),
                            Text(
                              "Tap untuk upload thumbnail",
                              style: TextStyle(color: kDarkBlueGray.withOpacity(0.6)),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // --- 2. INFORMASI DASAR ---
              _buildSectionTitle('Informasi Dasar'),
              _buildTextField(
                controller: _judulController, 
                hint: 'Judul Kegiatan', 
                icon: Icons.title
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _lokasiController, 
                hint: 'Lokasi Pelaksanaan', 
                icon: Icons.location_on_outlined
              ),
              const SizedBox(height: 16),
               _buildTextField(
                controller: _kuotaController, 
                hint: 'Kuota Relawan', 
                icon: Icons.people_outline,
                inputType: TextInputType.number, // Ini mentrigger logika di bawah
              ),
              const SizedBox(height: 24),

              // --- 3. WAKTU PELAKSANAAN ---
              _buildSectionTitle('Waktu Pelaksanaan'),
              Row(
                children: [
                  Expanded(
                    child: _buildDateTimePicker(
                      label: "Mulai",
                      value: _tanggalMulai,
                      onTap: () => _selectDateTime(true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateTimePicker(
                      label: "Selesai",
                      value: _tanggalBerakhir,
                      onTap: () => _selectDateTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // --- 4. DETAIL ---
              _buildSectionTitle('Detail Kegiatan'),
              _buildTextField(
                controller: _deskripsiController, 
                hint: 'Deskripsi lengkap kegiatan...', 
                maxLines: 4
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _syaratController, 
                hint: 'Syarat & Ketentuan...', 
                maxLines: 3
              ),
              const SizedBox(height: 24),

              // --- 5. KATEGORI ---
              _buildSectionTitle('Kategori (Min. 1)'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kLightGray, width: 1.5),
                ),
                child: _isLoadingKategori
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ))
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _kategoriList.map((kategori) {
                          final isSelected = _selectedKategoriIds.contains(kategori.id);
                          return FilterChip(
                            label: Text(kategori.namaKategori),
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : kDarkBlueGray,
                              fontSize: 12,
                            ),
                            selected: isSelected,
                            selectedColor: kPrimaryColor,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color: isSelected ? kPrimaryColor : kLightGray,
                              ),
                            ),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  _selectedKategoriIds.add(kategori.id);
                                } else {
                                  _selectedKategoriIds.remove(kategori.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
              ),
              
              const SizedBox(height: 40),

              // --- TOMBOL SUBMIT BAWAH ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading 
                    ? const Text('Memproses...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                    : const Text('Buat Kegiatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: inputType,
      
      // >>> PERBAIKAN DI SINI <<<
      // Jika inputType == number, paksa hanya angka (tidak bisa ketik huruf)
      inputFormatters: inputType == TextInputType.number 
          ? [FilteringTextInputFormatter.digitsOnly] 
          : [],
      // ------------------------

      validator: (v) => v == null || v.isEmpty ? '$hint wajib diisi' : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: kDarkBlueGray.withOpacity(0.6)) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: kLightGray),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: kLightGray, width: 1.5),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: kPrimaryColor, width: 2.0),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kLightGray, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: kDarkBlueGray.withOpacity(0.7))),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: kPrimaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value == null ? "- Pilih -" : DateFormat('dd/MM/yy HH:mm').format(value),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: value == null ? Colors.grey : kDarkBlueGray,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}