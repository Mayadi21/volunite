import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/pages/Volunteer/navbar.dart';
import 'package:volunite/color_pallete.dart'; // 1. Import Color Palette

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // --- STATE BARU: Variable untuk menyimpan role yang dipilih ---
  String _selectedRole = 'Volunteer';
  // -------------------------------------------------------------

  // step 1
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();

  // step 2
  final tglC = TextEditingController();
  final genderC = TextEditingController();
  final telpC = TextEditingController();
  final domisiliC = TextEditingController();

  int _currentStep = 1;

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    pass2C.dispose();
    tglC.dispose();
    genderC.dispose();
    telpC.dispose();
    domisiliC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan kBlueGray sesuai permintaan
    const primary = kBlueGray;

    return PopScope(
      canPop: _currentStep == 1,
      onPopInvoked: (didPop) {
        if (!didPop && _currentStep == 2) {
          setState(() => _currentStep = 1);
        }
      },
      child: _currentStep == 1
          ? _buildStep1(context, primary)
          : _buildStep2(context, primary),
    );
  }

  // ================== STEP 1 ==================
  Widget _buildStep1(BuildContext context, Color primary) {
    return Scaffold(
      // Background transparan untuk Gradient
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        // Gradient konsisten dengan halaman Login
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBlueGray, kSkyBlue],
            begin: Alignment.topLeft, stops: [0.0, 0.5],
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Header Teks
              const Text(
                "Registrasi Akun",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.0),
                child: Text(
                  "Daftarkan akun Anda sekarang dan mulai kegiatan volunteer!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),

              // Container Putih
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground, // Menggunakan kBackground/Putih
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Indikator Langkah
                      Center(
                        child: Column(
                          children: [
                            const Text(
                              "Langkah 1 dari 2",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: kDarkBlueGray,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: LinearProgressIndicator(
                                value: 1 / 2,
                                minHeight: 6,
                                backgroundColor: Colors.grey.shade200,
                                color: primary, // kBlueGray
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Konten Form (Scrollable)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Buat Akun",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: kDarkBlueGray,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Pastikan data yang dimasukkan akurat.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 20),

                              _field(
                                icon: Icons.person,
                                hint: "Masukkan nama Anda",
                                controller: nameC,
                                primaryColor: primary,
                              ),
                              const SizedBox(height: 16),
                              _field(
                                icon: Icons.email,
                                hint: "Masukkan email Anda",
                                controller: emailC,
                                keyboard: TextInputType.emailAddress,
                                primaryColor: primary,
                              ),
                              const SizedBox(height: 16),
                              _field(
                                icon: Icons.lock,
                                hint: "Masukkan password Anda",
                                controller: passC,
                                obscure: true,
                                primaryColor: primary,
                              ),
                              const SizedBox(height: 16),
                              _field(
                                icon: Icons.lock,
                                hint: "Konfirmasi password Anda",
                                controller: pass2C,
                                obscure: true,
                                primaryColor: primary,
                              ),

                              // --- PILIHAN ROLE ---
                              const SizedBox(height: 24),
                              const Text(
                                "Daftar Sebagai:",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: kDarkBlueGray,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildRoleButton(
                                      role: 'Volunteer',
                                      icon: Icons.person_outline,
                                      isSelected: _selectedRole == 'Volunteer',
                                      primaryColor: primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildRoleButton(
                                      role: 'Organisasi',
                                      icon: Icons.apartment,
                                      isSelected: _selectedRole == 'Organisasi',
                                      primaryColor: primary,
                                    ),
                                  ),
                                ],
                              ),

                              // --------------------
                              const SizedBox(height: 30),
                              SizedBox(
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
                                  onPressed: () {
                                    setState(() {
                                      _currentStep = 2;
                                    });
                                  },
                                  child: const Text(
                                    "Selanjutnya",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Sudah punya akun? ",
                                    style: TextStyle(color: kBlueGray),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const LoginPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                        color: primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET TOMBOL ROLE ---
  Widget _buildRoleButton({
    required String role,
    required IconData icon,
    required bool isSelected,
    required Color primaryColor,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade500,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade500,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== STEP 2 ==================
  Widget _buildStep2(BuildContext context, Color primary) {
    return Scaffold(
      backgroundColor: kBackground, // Putih
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    color: primary,
                    onPressed: () {
                      setState(() {
                        _currentStep = 1;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Kembali",
                    style: TextStyle(
                      color: primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    "Langkah 2 dari 2",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 2 / 2,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    "Isi Data Diri",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedRole == 'Organisasi'
                        ? "Lengkapi data organisasi Anda"
                        : "Data diri hanya digunakan untuk informasi semata",
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 20),

                  _fieldStep2(
                    icon: Icons.calendar_today,
                    hint: _selectedRole == 'Organisasi'
                        ? "Tanggal Berdiri"
                        : "Tanggal Lahir",
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
                              colorScheme: ColorScheme.light(
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
                  _fieldStep2(
                    icon: Icons.female,
                    hint: "Jenis Kelamin",
                    controller: genderC,
                    primaryColor: primary,
                  ),
                  const SizedBox(height: 16),
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
                ],
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LandingPage()),
                    );
                  },
                  child: const Text(
                    "Daftar",
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

  // ================== WIDGET FIELD STEP 1 ==================
  Widget _field({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    required Color primaryColor,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: kLightGray, // Menggunakan kLightGray/Putih Abu
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

  // ================== WIDGET FIELD STEP 2 ==================
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
