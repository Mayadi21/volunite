// ... (Import sama)
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kategori_model.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/kategori_service.dart';
import 'package:volunite/services/kegiatan_service.dart';

class EditActivityPage extends StatefulWidget {
  final Kegiatan kegiatan;
  const EditActivityPage({super.key, required this.kegiatan});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  late TextEditingController _judulCtrl;
  late TextEditingController _deskripsiCtrl;
  late TextEditingController _linkGrupCtrl;
  late TextEditingController _lokasiCtrl;
  late TextEditingController _syaratCtrl;
  late TextEditingController _kuotaCtrl;

  DateTime? _tglMulai;
  DateTime? _tglSelesai;
  XFile? _newImage;
  String _selectedMetode = 'Manual';

  List<Kategori> _kategoriList = [];
  List<int> _selectedKategoriIds = [];

  @override
  void initState() {
    super.initState();
    final k = widget.kegiatan;

    _judulCtrl = TextEditingController(text: k.judul);
    _deskripsiCtrl = TextEditingController(text: k.deskripsi);
    _linkGrupCtrl = TextEditingController(text: k.linkGrup ?? '');
    _lokasiCtrl = TextEditingController(text: k.lokasi);
    _syaratCtrl = TextEditingController(text: k.syaratKetentuan);
    _kuotaCtrl = TextEditingController(text: k.kuota?.toString() ?? '0');

    _tglMulai = k.tanggalMulai;
    _tglSelesai = k.tanggalBerakhir;

    String rawMetode = k.metodePenerimaan ?? 'Manual';
    if (rawMetode.isNotEmpty) {
      _selectedMetode =
          rawMetode[0].toUpperCase() + rawMetode.substring(1).toLowerCase();
    } else {
      _selectedMetode = 'Manual';
    }
    const validOptions = ['Manual', 'Otomatis'];
    if (!validOptions.contains(_selectedMetode)) {
      _selectedMetode = 'Manual';
    }

    _selectedKategoriIds = k.kategori.map((e) => e.id).toList();
    _loadKategori();
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    _linkGrupCtrl.dispose();
    _lokasiCtrl.dispose();
    _syaratCtrl.dispose();
    _kuotaCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadKategori() async {
    try {
      final data = await KategoriService.fetchKategori();
      if (mounted) setState(() => _kategoriList = data);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _pickImage() async {
    final file = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (file != null) setState(() => _newImage = file);
  }

  Future<void> _selectDateTime(bool isStart) async {
    final now = DateTime.now();
    final initialDate = isStart ? (_tglMulai ?? now) : (_tglSelesai ?? now);
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: kSkyBlue,
            onPrimary: Colors.white,
            onSurface: kDarkBlueGray,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (time == null) return;
    setState(() {
      final val = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      if (isStart)
        _tglMulai = val;
      else
        _tglSelesai = val;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_tglMulai == null || _tglSelesai == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tanggal Mulai dan Selesai wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');

    final success = await KegiatanService.updateKegiatan(
      id: widget.kegiatan.id,
      judul: _judulCtrl.text,
      deskripsi: _deskripsiCtrl.text,
      linkGrup: _linkGrupCtrl.text,
      lokasi: _lokasiCtrl.text,
      syaratKetentuan: _syaratCtrl.text,
      kuota: _kuotaCtrl.text,
      metodePenerimaan: _selectedMetode,
      tanggalMulai: fmt.format(_tglMulai!),
      tanggalBerakhir: fmt.format(_tglSelesai!),
      kategoriIds: _selectedKategoriIds,
      imageFile: _newImage,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // --- [5] BUNYIKAN SINYAL REFRESH ---
        KegiatanService.triggerRefresh();
        // ------------------------------------

        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Berhasil diperbarui!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal update data."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ... (SISA KODE UI build() dan helper widget _CustomTextField dll SAMA PERSIS DENGAN SEBELUMNYA)
  // Pastikan Anda menggunakan kode UI yang sudah saya berikan sebelumnya.
  @override
  Widget build(BuildContext context) {
    // Paste isi build yang lengkap di sini
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        title: const Text("Edit Kegiatan"),
        backgroundColor: kSkyBlue,
        foregroundColor: Colors.white,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImagePreview(),
                const SizedBox(height: 24),
                _sectionLabel("Informasi Utama"),
                _CustomTextField(
                  label: "Judul",
                  controller: _judulCtrl,
                  icon: Icons.event,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Kategori",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kBlueGray,
                  ),
                ),
                const SizedBox(height: 8),
                _buildKategoriChips(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _DateTimePicker(
                        label: "Mulai",
                        val: _tglMulai,
                        onTap: () => _selectDateTime(true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DateTimePicker(
                        label: "Selesai",
                        val: _tglSelesai,
                        onTap: () => _selectDateTime(false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  label: "Lokasi",
                  controller: _lokasiCtrl,
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  label: "Kuota",
                  controller: _kuotaCtrl,
                  icon: Icons.group,
                  isNumber: true,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Metode Penerimaan",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: kBlueGray,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kLightGray),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedMetode,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: kSkyBlue),
                      items: const [
                        DropdownMenuItem(
                          value: 'Manual',
                          child: Text(
                            "Manual (Perlu Verifikasi)",
                            style: TextStyle(color: kDarkBlueGray),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Otomatis',
                          child: Text(
                            "Otomatis (Langsung Diterima)",
                            style: TextStyle(color: kDarkBlueGray),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedMetode = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                _sectionLabel("Detail Lengkap"),
                _CustomTextField(
                  label: "Link Grup WhatsApp",
                  controller: _linkGrupCtrl,
                  icon: Icons.chat,
                  isRequired: true,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  label: "Deskripsi",
                  controller: _deskripsiCtrl,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                _CustomTextField(
                  label: "Syarat & Ketentuan",
                  controller: _syaratCtrl,
                  maxLines: 3,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSkyBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("SIMPAN PERUBAHAN"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper functions
  Widget _buildImagePreview() => GestureDetector(
    onTap: _pickImage,
    child: Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: kLightGray),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _newImage != null
            ? (kIsWeb
                  ? Image.network(_newImage!.path, fit: BoxFit.cover)
                  : Image.file(File(_newImage!.path), fit: BoxFit.cover))
            : (widget.kegiatan.thumbnail != null
                  ? Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          widget.kegiatan.thumbnail!,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black26,
                          child: const Center(
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Icon(
                        Icons.add_a_photo,
                        color: kBlueGray,
                        size: 40,
                      ),
                    )),
      ),
    ),
  );
  Widget _buildKategoriChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _kategoriList.map((k) {
        final isSelected = _selectedKategoriIds.contains(k.id);
        return ChoiceChip(
          label: Text(k.namaKategori),
          selected: isSelected,
          selectedColor: kSkyBlue,
          backgroundColor: Colors.white,
          side: BorderSide(color: isSelected ? Colors.transparent : kLightGray),
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : kDarkBlueGray,
          ),
          onSelected: (val) => setState(
            () => val
                ? _selectedKategoriIds.add(k.id)
                : _selectedKategoriIds.remove(k.id),
          ),
        );
      }).toList(),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: kDarkBlueGray,
      ),
    ),
  );
}

// ... Helper Widgets (Sama)
class _CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData? icon;
  final int maxLines;
  final bool isNumber;
  final bool isRequired;
  const _CustomTextField({
    required this.label,
    required this.controller,
    this.icon,
    this.maxLines = 1,
    this.isNumber = false,
    this.isRequired = true,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      validator: isRequired
          ? (v) => v!.isEmpty ? '$label wajib diisi' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: kBlueGray),
        prefixIcon: icon != null ? Icon(icon, color: kSkyBlue) : null,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kLightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kSkyBlue),
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? val;
  final VoidCallback onTap;
  const _DateTimePicker({
    required this.label,
    required this.val,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kLightGray),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: kBlueGray)),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: val == null ? kBlueGray : kSkyBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  val == null
                      ? "- Pilih -"
                      : DateFormat('dd MMM, HH:mm').format(val!),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: val == null ? kBlueGray : kDarkBlueGray,
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
