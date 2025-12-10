// FILE: complete_profile_page.dart
// Fungsi: Halaman untuk melengkapi data detail user (tanggal lahir, gender, telp, domisili).
// Kegunaan: Dipanggil setelah user login / daftar (termasuk via Google).
// Cara manggil: Navigator.pushReplacement(... CompleteProfilePage(role: user.role));
// Catatan: Menggunakan DetailUserService untuk menyimpan ke backend.
// Catatan tambahan: Role dipakai untuk menyesuaikan teks & routing akhir.

import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/services/user/detail_user_service.dart';
import 'package:volunite/pages/Volunteer/navbar.dart';
import 'package:volunite/pages/Organizer/navbar.dart';

class CompleteProfilePage extends StatefulWidget {
  final String role; // misal: 'Volunteer' / 'Organizer' / 'Admin'

  const CompleteProfilePage({super.key, required this.role});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  final tglC = TextEditingController();
  final genderC = TextEditingController();
  final telpC = TextEditingController();
  final domisiliC = TextEditingController();

  @override
  void dispose() {
    tglC.dispose();
    genderC.dispose();
    telpC.dispose();
    domisiliC.dispose();
    super.dispose();
  }

  bool get isVolunteer => widget.role == 'Volunteer';
  bool get isOrganizer => widget.role == 'Organizer';

  @override
  Widget build(BuildContext context) {
    const primary = kBlueGray;

    // widget2 yang sama seperti di _buildStep2 kamu
    final List<Widget> step2Fields = [
      _fieldStep2(
        icon: Icons.calendar_today,
        hint: isOrganizer ? "Tanggal Berdiri" : "Tanggal Lahir",
        controller: tglC,
        readOnly: true,
        primaryColor: primary,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime(2005, 1, 1),
            firstDate: DateTime(1970),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: primary,
                    onPrimary: Colors.white,
                    onSurface: kDarkBlueGray,
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            tglC.text =
                "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
          }
        },
      ),
      const SizedBox(height: 16),

      if (isVolunteer)
        Column(
          children: [
            _fieldStep2(
              icon: Icons.female,
              hint: "Jenis Kelamin",
              controller: genderC,
              primaryColor: primary,
              readOnly: true,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: const Text('Laki-Laki'),
                          onTap: () {
                            genderC.text = 'Laki-Laki';
                            Navigator.pop(ctx);
                          },
                        ),
                        ListTile(
                          title: const Text('Perempuan'),
                          onTap: () {
                            genderC.text = 'Perempuan';
                            Navigator.pop(ctx);
                          },
                        ),
                        ListTile(
                          title: const Text('Tidak ingin memberi tahu'),
                          onTap: () {
                            genderC.text = 'Tidak Ingin Memberi Tahu';
                            Navigator.pop(ctx);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),

      _fieldStep2(
        icon: Icons.phone,
        hint: "No Telepon",
        controller: telpC,
        keyboard: TextInputType.phone,
        primaryColor: primary,
      ),
      const SizedBox(height: 16),
      _fieldStep2(
        icon: Icons.location_on_outlined,
        hint: "Domisili",
        controller: domisiliC,
        primaryColor: primary,
      ),
      const SizedBox(height: 16),
    ];

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        backgroundColor: kBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: kBlueGray,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Lengkapi Data",
          style: TextStyle(color: kDarkBlueGray, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Text(
                    isOrganizer
                        ? "Lengkapi data organisasi Anda"
                        : "Data diri hanya digunakan untuk informasi",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [...step2Fields],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _onSubmit,
                  child: const Text(
                    "Simpan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onSubmit() async {
    if (tglC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal tidak boleh kosong')),
      );
      return;
    }

    if (isVolunteer && genderC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jenis kelamin tidak boleh kosong')),
      );
      return;
    }

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final detailService = DetailUserService();
      await detailService.saveDetailUser(
        tanggalLahir: tglC.text,
        jenisKelamin: isVolunteer ? genderC.text : null,
        noTelepon: telpC.text.isEmpty ? null : telpC.text,
        domisili: domisiliC.text.isEmpty ? null : domisiliC.text,
      );

      Navigator.of(context).pop(); // tutup loading

      // Routing akhir berdasarkan role
      if (isVolunteer) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      } else if (isOrganizer) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrganizerLandingPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      }
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    }
  }

  Widget _fieldStep2({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required Color primaryColor,
    bool readOnly = false,
    void Function()? onTap,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: kLightGray,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
      ),
    );
  }
}
