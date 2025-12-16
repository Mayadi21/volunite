// lib/pages/Volunteer/Activity/detail_activities_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:flutter/foundation.dart';
import 'package:volunite/models/kategori_model.dart'; 
import 'package:volunite/services/pendaftaran_service.dart';
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/report_kegiatan_service.dart';
import 'package:share_plus/share_plus.dart';
// 🔥 Tambahkan url_launcher untuk membuka link grup
import 'package:url_launcher/url_launcher.dart'; 

class DetailActivitiesPage extends StatefulWidget {
  final Kegiatan? kegiatan;
  final String title;
  final String date;
  final String time;
  final String imagePath;

  const DetailActivitiesPage({
    super.key,
    required this.kegiatan,
    required this.title,
    required this.date,
    required this.time,
    required this.imagePath,
  });

  @override
  State<DetailActivitiesPage> createState() => _DetailActivitiesPageState();
}

class _DetailActivitiesPageState extends State<DetailActivitiesPage> {
  bool _isDescriptionExpanded = false;

  // 🔥 State untuk status pendaftaran
  String _registrationStatus = 'Memuat';
  // Nilai mungkin: 'Memuat', 'Belum Mendaftar', 'Mengajukan', 'Diterima', 'Ditolak', 'Kesalahan...'

  // State untuk status loading di modal pendaftaran
  bool _isRegistrationLoading = false;
  
  // State untuk status loading di modal laporan
  bool _isReportLoading = false;  

  // Inisialisasi Service (Dibuat final)
  final PendaftaranService _pendaftaranService = PendaftaranService();
  final AuthService _authService = AuthService();
  final ReportService _reportService = ReportService();  

  @override
  void initState() {
    super.initState();
    _checkRegistrationStatus();
  }
  
  // 🔥 Getter untuk mengambil data kegiatan yang sering digunakan
  String get _metodePenerimaan => widget.kegiatan?.metodePenerimaan?.toLowerCase() ?? 'manual';
  String? get _linkGrup => widget.kegiatan?.linkGrup;

  // =========================================================
  // FUNGSI UTILITY
  // =========================================================
  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membuka link: $url'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // =========================================================
  // 🔥 FUNGSI: Memeriksa status pendaftaran
  // =========================================================
  Future<void> _checkRegistrationStatus() async {
    final kegiatanId = widget.kegiatan?.id;
    final user = await _authService.getCurrentUser();

    // Reset status menjadi memuat sebentar jika dipanggil ulang
    if (mounted) {
      setState(() {
        _registrationStatus = 'Memuat';
      });
    }

    if (kegiatanId != null && user != null) {
      try {
        final status = await _pendaftaranService.getRegistrationStatus(
          kegiatanId as int,
        );

        // 🔥 LOGIC TAMBAHAN UNTUK PENERIMAAN OTOMATIS:
        // Jika status yang dikembalikan adalah 'Mengajukan' DAN metode penerimaan otomatis,
        // kita paksa status di UI menjadi 'Diterima' untuk segera menampilkan link grup.
        if (status == 'Mengajukan' && _metodePenerimaan == 'otomatis') {
            if (mounted) {
                setState(() {
                    _registrationStatus = 'Diterima';
                });
            }
            return;
        }

        if (mounted) {
          setState(() {
            _registrationStatus = status; // Set status dari service
          });
        }
      } catch (e) {
        print('Error checking registration status: $e');
        if (mounted) {
          setState(() {
            _registrationStatus = 'Kesalahan Jaringan'; // Fallback error
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _registrationStatus = 'Belum Mendaftar';
        });
      }
    }
  }

  String get _dynamicDescription {
    return widget.kegiatan?.deskripsi ?? 'Deskripsi tidak tersedia.';
  }

  List<String> get _dynamicRequirements {
    final reqString = widget.kegiatan?.syaratKetentuan;
    if (reqString == null || reqString.trim().isEmpty) {
      return ['Syarat dan ketentuan belum ditetapkan.'];
    }
    return reqString.split('\n').where((s) => s.trim().isNotEmpty).toList();
  }

  void _shareActivity() async {
    final kegiatan = widget.kegiatan;
    // ... (kode _shareActivity tetap sama)
    String shareText = "Yuk, gabung di kegiatan relawan ini!";

    if (kegiatan != null) {
      final title = kegiatan.judul;
      final location = kegiatan.lokasi ?? "Lokasi tidak tercantum";
      final date = widget.date;
      final time = widget.time;

      final activityLink = "Cek detail kegiatan di aplikasi Volunite sekarang !";

      shareText = """
📢 **Kesempatan Relawan: ${title}**

🗓️ Tanggal: ${date}
⏰ Waktu: ${time}
📍 Lokasi: ${location}

Gabung sekarang dan buat perubahan!
${activityLink}
""";
    }

    try {
      await Share.share(
        shareText,
        subject: 'Ajakan Bergabung Kegiatan Relawan: ${widget.title}',
      );
    } catch (e) {
      print('Error sharing: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal membagikan. Silakan coba lagi.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // =========================================================
  // FUNGSI: Menampilkan form pendaftaran
  // =========================================================
  void _showRegistrationForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final domisiliController = TextEditingController();
    final noHpController = TextEditingController();
    final komitmenController = TextEditingController();
    final keterampilanController = TextEditingController();
    final isOtomatis = _metodePenerimaan == 'otomatis'; // 🔥 Cek apakah otomatis

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: kBackground,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            // LOGIKA SUBMIT FORM
            void _submitForm() async {
              if (formKey.currentState!.validate()) {
                setModalState(() => _isRegistrationLoading = true); 

                final user = await _authService.getCurrentUser();

                if (user == null || widget.kegiatan?.id == null) {
                  setModalState(() => _isRegistrationLoading = false);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "⚠ Anda harus login atau ID kegiatan tidak valid.",
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                final success = await _pendaftaranService.daftarKegiatan(
                  kegiatanId: widget.kegiatan!.id as int,
                  nomorTelepon: noHpController.text,
                  domisili: domisiliController.text,
                  komitmen: komitmenController.text,
                  keterampilan: keterampilanController.text,
                );

                setModalState(() => _isRegistrationLoading = false);
                Navigator.pop(context);

                if (success) {
                  setState(() { 
                    // 🔥 SET STATUS BERDASARKAN METODE PENERIMAAN
                    if (isOtomatis) {
                        _registrationStatus = 'Diterima'; // Langsung Diterima jika Otomatis
                    } else {
                        _registrationStatus = 'Mengajukan'; // Status standar jika Manual
                    }
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ Pendaftaran kegiatan berhasil dikirim! Status: ${isOtomatis ? 'Diterima' : 'Menunggu Persetujuan'}'),
                      backgroundColor: isOtomatis ? Colors.green : Colors.orange,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('❌ Gagal mengirim pendaftaran. Coba lagi.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
            // ... (kode form input tetap sama)
            return SingleChildScrollView( 
              child: Padding(
                // 🔥 Memastikan padding bawah mengakomodasi keyboard insets
                padding: EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (tetap)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Form Pendaftaran Kegiatan',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: kDarkBlueGray,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close, color: kBlueGray),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // 🔥 MODAL STATUS DISPLAY BARU UNTUK MENGATASI OVERFLOW
                      if (isOtomatis)
                          Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildModalStatusDisplay(
                                  'Pendaftaran akan langsung Diterima (Otomatis)', 
                                  Icons.info_outline, 
                                  kSkyBlue)
                          ),
                      
                      // Input Domisili
                      _buildFormLabel("Domisili"),
                      _buildTextFormField(
                        controller: domisiliController,
                        hintText: 'Masukkan domisili Anda',
                        validatorText: 'Domisili harus diisi',
                      ),
                      const SizedBox(height: 16),

                      // Input No HP
                      _buildFormLabel("Nomor HP Aktif"),
                      _buildTextFormField(
                        controller: noHpController,
                        hintText: 'Masukkan nomor HP Anda (e.g. 0812...)',
                        validatorText: 'Nomor HP harus diisi',
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      const SizedBox(height: 16),

                      // Input Komitmen
                      _buildFormLabel("Komitmen (Tuliskan janji komitmen Anda)"),
                      _buildTextFormField(
                        controller: komitmenController,
                        hintText: 'Tulis komitmen Anda untuk kegiatan ini',
                        validatorText: 'Komitmen harus diisi',
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),

                      // Input Keterampilan
                      _buildFormLabel("Keterampilan yang Dimiliki"),
                      _buildTextFormField(
                        controller: keterampilanController,
                        hintText: 'Contoh: Desain Grafis, Komunikasi, Editing',
                        validatorText: 'Keterampilan harus diisi',
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isRegistrationLoading ? null : _submitForm, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kSkyBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _isRegistrationLoading
                              ? const SizedBox( 
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  'Kirim Pendaftaran',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildModalStatusDisplay(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max, // Agar Row mengisi lebar penuh container
        children: [
          Icon(icon, color: color.darker, size: 20),
          const SizedBox(width: 10),
          // 🔥 Gunakan Flexible/Expanded untuk mencegah horizontal overflow
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: color.darker,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FUNGSI: Menampilkan form laporan (Tidak Berubah)
  // =========================================================
  void _showReportForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final descriptionController = TextEditingController();
    String? selectedComplaintType;

    final List<String> complaintOptions = [
      'Ilegal/Penipuan',
      'Informasi Palsu',
      'Tidak Relevan',
      'Pelanggaran S&K',
      'Diskriminasi/Pelanggaran Etika',
      'Kegiatan Fiktif',
      'lainnya'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: kBackground,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            // 🔥 LOGIKA SUBMIT LAPORAN 🔥
            void _submitReportForm() async {
              if (formKey.currentState!.validate()) {
                final kegiatanId = widget.kegiatan?.id;

                if (kegiatanId == null) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("⚠ ID Kegiatan tidak valid. Gagal melaporkan."),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  return;
                }

                setModalState(() => _isReportLoading = true); 

                try {
                  final response = await _reportService.submitReport(
                    kegiatanId: kegiatanId,
                    keluhan: selectedComplaintType ?? '',
                    detailKeluhan: descriptionController.text,
                    status: 'Diproses',
                  );

                  setModalState(() => _isReportLoading = false); 
                  Navigator.pop(context); 

                  if (response.statusCode >= 200 && response.statusCode < 300) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Laporan kegiatan berhasil dikirim!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    String serverMessage = '';
                    try {
                      final body = response.body;
                      if (body.isNotEmpty) {
                        final decoded = jsonDecode(body);
                        if (decoded is Map && decoded.containsKey('message')) {
                          serverMessage = decoded['message'].toString();
                        } else if (decoded is Map && decoded.containsKey('error')) {
                          serverMessage = decoded['error'].toString();
                        } else {
                          serverMessage = body;
                        }
                      }
                    } catch (e) {
                      serverMessage = response.body;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '❌ Gagal mengirim laporan. Status: ${response.statusCode}\n${serverMessage.isNotEmpty ? serverMessage : "Silakan coba lagi."}',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  setModalState(() => _isReportLoading = false); 
                  Navigator.pop(context); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Terjadi kesalahan jaringan: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }
            // 🔥 AKHIR LOGIKA SUBMIT LAPORAN 🔥

            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Laporkan Kegiatan',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: kBlueGray),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Jenis Keluhan
                    const Text(
                      "Jenis Keluhan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedComplaintType,
                      icon: const Icon(Icons.arrow_drop_down, color: kBlueGray),
                      decoration: InputDecoration(
                        hintText: 'Pilih jenis masalah',
                        hintStyle: const TextStyle(color: kBlueGray),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: kSkyBlue,
                            width: 1.3,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      items: complaintOptions.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(color: kDarkBlueGray),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          selectedComplaintType = newValue;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harap pilih jenis keluhan';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Input Deskripsi Keluhan
                    const Text(
                      "Deskripsi Keluhan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kDarkBlueGray,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText:
                            'Jelaskan detail masalah yang Anda temukan...',
                        hintStyle: const TextStyle(color: kBlueGray),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: kSoftBlue),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: kSkyBlue,
                            width: 1.3,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Deskripsi harus diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Tombol Kirim Laporan
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isReportLoading ? null : _submitReportForm, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDarkBlueGray,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isReportLoading
                            ? const SizedBox( 
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Kirim Laporan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================
  // WIDGET BUILDER UTAMA & WIDGET PEMBANTU
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final List<Kategori> categories = widget.kegiatan?.kategori ?? []; 

    return Scaffold(
      backgroundColor: kBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // 1. App Bar Gambar
              SliverAppBar(
                expandedHeight: screenHeight * 0.35,
                pinned: true,
                elevation: 0,
                backgroundColor: kBlueGray,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.35),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      // Mengembalikan true untuk memicu refresh di halaman sebelumnya
                      onPressed: () => Navigator.of(context).pop(true), 
                    ),
                  ),
                ),
                actions: [
                  // Tombol Report
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.35),
                      child: IconButton(
                        icon: const Icon(
                          Icons.flag_outlined,
                          color: Colors.white,
                        ),
                        tooltip: 'Laporkan',
                        onPressed: () => _showReportForm(context),
                      ),
                    ),
                  ),
                  // Tombol Share
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.35),
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {_shareActivity();},
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 80),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.black.withOpacity(0.15),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Header Konten
              SliverPersistentHeader(
                pinned: true,
                delegate: _MyPinnedHeaderDelegate(
                  title: widget.title,
                  date: widget.date,
                  time: widget.time,
                  categories: categories, 
                ),
              ),

              // 3. Konten Scroll
              SliverToBoxAdapter(
                child: Container(
                  color: kBackground,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildLocationCard(),
                        const SizedBox(height: 24),
                        _buildParticipantsInfo(),
                        const SizedBox(height: 24),
                        const Divider(
                          color: Color(0x11000000),
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 24),

                        // Deskripsi (Menggunakan Data Backend)
                        const Text(
                          'Deskripsi Kegiatan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _dynamicDescription, 
                          maxLines: _isDescriptionExpanded ? null : 4,
                          overflow: _isDescriptionExpanded
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: kBlueGray,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isDescriptionExpanded = !_isDescriptionExpanded;
                            });
                          },
                          child: Text(
                            _isDescriptionExpanded
                                ? 'Lihat Lebih Sedikit'
                                : 'Lihat Lebih Banyak',
                            style: const TextStyle(
                              color: kSkyBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Syarat & Ketentuan (Menggunakan Data Backend)
                        Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            title: const Text(
                              'Syarat dan Ketentuan',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kDarkBlueGray,
                              ),
                            ),
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: const EdgeInsets.only(
                              top: 8,
                              bottom: 16,
                            ),
                            children: [
                              for (var requirement in _dynamicRequirements)
                                _buildRequirementItem(requirement),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        SizedBox(height: bottomPadding + 120),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom Bar
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomBar()),
        ],
      ),
    );
  }

  // Widget pembantu untuk label form
  Widget _buildFormLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.w600, color: kDarkBlueGray),
    );
  }

  // Widget pembantu untuk TextFormField
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String validatorText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: kBlueGray),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kSoftBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kSoftBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kSkyBlue, width: 1.3),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
        return null;
      },
    );
  }

  Widget _buildLocationCard() {
    final locationText = widget.kegiatan?.lokasi ?? 'Lokasi tidak diketahui';
    final locationTitle =
        widget.kegiatan?.organizer?.nama ??
        'Lokasi Kegiatan'; 

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      color: Colors.white,
      shadowColor: kBlueGray.withOpacity(0.18),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/master/w_2560%2Cc_limit/GoogleMapTA.jpg',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    locationTitle, 
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    locationText, 
                    style: const TextStyle(
                      fontSize: 12,
                      color: kBlueGray,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic navigasi peta (misalnya menggunakan url_launcher)
                    },
                    icon: const Icon(Icons.location_on_outlined, size: 16),
                    label: const Text('Dapatkan Lokasi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSkyBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsInfo() {
    Widget buildAvatar(String url) {
      return CircleAvatar(radius: 15, backgroundImage: NetworkImage(url));
    }

    // Kuota dinamis
    final kuotaText = widget.kegiatan?.kuota != null
        ? '${widget.kegiatan!.kuota}+ Bergabung'
        : '43+ Bergabung'; 

    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 30,
                child: buildAvatar(
                  'https://randomuser.me/api/portraits/women/1.jpg',
                ),
              ),
              Positioned(
                left: 15,
                child: buildAvatar(
                  'https://randomuser.me/api/portraits/men/1.jpg',
                ),
              ),
              buildAvatar('https://randomuser.me/api/portraits/women/2.jpg'),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          kuotaText, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: kDarkBlueGray),
        ),
      ],
    );
  }

  // FUNGSI _buildBottomBar
  Widget _buildBottomBar() {
    Widget content;
    
    final bool isAcceptedOrAutoAccepted = _registrationStatus == 'Diterima';
    final bool shouldShowGroupLink = isAcceptedOrAutoAccepted && _linkGrup != null && _linkGrup!.isNotEmpty;

    if (shouldShowGroupLink) {
        // 🔥 KONDISI 1: Sudah Diterima (Manual) ATAU Status Diterima (Otomatis)
        content = _buildGroupLinkButton(
            onPressed: () => _launchUrl(_linkGrup!),
            label: 'Gabung Grup Relawan',
        );
    } else {
        // 🔥 KONDISI LAINNYA: Tampilkan Status atau Tombol Daftar
        switch (_registrationStatus) {
            case 'Diterima':
                // Ini terjadi jika Diterima TAPI link grup null/kosong
                content = _buildStatusDisplay(
                    'Pendaftaran Diterima',
                    Icons.verified_user,
                    Colors.green,
                );
                break;
            case 'Mengajukan':
                content = _buildStatusDisplay(
                    'Menunggu Persetujuan',
                    Icons.pending_actions,
                    Colors.orange,
                );
                break;
            case 'Ditolak':
                content = _buildStatusDisplay(
                    'Pendaftaran Ditolak',
                    Icons.cancel,
                    Colors.red,
                );
                break;
                case 'Kuota Penuh':
                 content = _buildStatusDisplay(
                    'Kuota Penuh',
                    Icons.warning_amber,
                    Colors.red.shade900, // Warna merah tua untuk bahaya/penuh
                );
                break;
            case 'Memuat':
            case 'Kesalahan Jaringan':
            case 'Kesalahan Server':
                content = _buildRegisterButton(
                    onPressed: null,
                    label: _registrationStatus == 'Memuat' ? 'Memuat Status...' : 'Coba Lagi',
                    backgroundColor: kBlueGray,
                );
                break;
            case 'Belum Mendaftar':
            default:
                content = _buildRegisterButton(
                    onPressed: () => _showRegistrationForm(context),
                    label: 'Daftar Kegiatan',
                    backgroundColor: kSkyBlue,
                );
                break;
        }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ).copyWith(bottom: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: content), 
        ],
      ),
    );
  }

  // 🔥 WIDGET PEMBANTU BARU: Tombol Link Grup
  Widget _buildGroupLinkButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.group_add_outlined, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
      ),
    );
  }

  // WIDGET PEMBANTU: Menampilkan status pendaftaran
  Widget _buildStatusDisplay(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05), 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color.darker,
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET PEMBANTU: Menampilkan tombol daftar
  Widget _buildRegisterButton({
    required VoidCallback? onPressed,
    required String label,
    required Color backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  // Widget Item Persyaratan
  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: kSkyBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text, 
              style: const TextStyle(
                fontSize: 14,
                color: kDarkBlueGray,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- DELEGATE UNTUK HEADER YANG PINNED (Tidak Berubah) ---
class _MyPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String title;
  final String date;
  final String time;
  final List<Kategori> categories; 

  final double _minHeight = 170;
  final double _maxHeight = 170;

  _MyPinnedHeaderDelegate({
    required this.title,
    required this.date,
    required this.time,
    this.categories = const [], 
  });

  // Helper untuk menentukan ikon berdasarkan nama kategori
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'pendidikan':
        return Icons.school_outlined;
      case 'lingkungan':
        return Icons.eco_outlined;
      case 'kesehatan':
        return Icons.medical_services_outlined;
      case 'sosial':
        return Icons.people_outline;
      default:
        return Icons.star_border;
    }
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: kBlueGray.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kDarkBlueGray,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            
            Wrap(
              spacing: 8.0, 
              runSpacing: 4.0, 
              children: categories.isNotEmpty
                  ? categories.map((kategori) {
                      return _buildTag(
                        kategori.namaKategori,
                        _getCategoryIcon(kategori.namaKategori),
                      );
                    }).toList()
                  : [
                      _buildTag('Kategori Umum', Icons.star_border),
                    ],
            ),
            
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoRow(Icons.calendar_today_outlined, date),
                const Spacer(),
                _buildInfoRow(Icons.access_time_outlined, time),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16, color: kDarkBlueGray),
      label: Text(label),
      backgroundColor: kSoftBlue,
      labelStyle: const TextStyle(
        color: kDarkBlueGray,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: kSkyBlue),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kBlueGray, size: 16),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 14, color: kDarkBlueGray)),
      ],
    );
  }

  @override
  double get maxExtent => _maxHeight;

  @override
  double get minExtent => _minHeight;

  @override
  bool shouldRebuild(covariant _MyPinnedHeaderDelegate oldDelegate) {
    final oldCategoryNames = oldDelegate.categories.map((k) => k.namaKategori).toList();
    final newCategoryNames = categories.map((k) => k.namaKategori).toList();
    
    return title != oldDelegate.title ||
        date != oldDelegate.date ||
        time != oldDelegate.time ||
        !listEquals(oldCategoryNames, newCategoryNames);
  }
}

// 🔥 Helper untuk mengambil warna yang lebih gelap (Diperlukan untuk _buildStatusDisplay)
extension on Color {
    Color get darker {
        int r = (red * 0.9).round();
        int g = (green * 0.9).round();
        int b = (blue * 0.9).round();
        return Color.fromARGB(alpha, r, g, b);
    }
}