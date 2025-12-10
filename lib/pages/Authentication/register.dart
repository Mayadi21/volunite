// FILE: register.dart
// Fungsi: Halaman registrasi awal (akun + role + Google).
// Kegunaan: User membuat akun (manual) atau login/daftar via Google.
// Cara ke tahap berikutnya: setelah akun siap, arahkan ke CompleteProfilePage(role: ...).

import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/color_pallete.dart';
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/auth/auth_response.dart';
import 'package:volunite/pages/Authentication/complete_profile_page.dart'; // <--- import halaman baru

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // role yang dipilih
  String _selectedRole = 'Volunteer';

  // form akun
  final nameC = TextEditingController();
  final emailC = TextEditingController();
  final passC = TextEditingController();
  final pass2C = TextEditingController();

  @override
  void dispose() {
    nameC.dispose();
    emailC.dispose();
    passC.dispose();
    pass2C.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = kBlueGray;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBlueGray, kSkyBlue],
            begin: Alignment.topLeft,
            stops: [0.0, 0.5],
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
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

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // indikator (optional, bisa dihapus kalau mau)
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
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

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

                              const SizedBox(height: 24),

                              // === TOMBOL LANJUTKAN DENGAN GOOGLE ===
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: OutlinedButton.icon(
                                  onPressed: _handleGoogleRegister,
                                  icon: Image.asset(
                                    'assets/images/logo/google_logo.png',
                                    height: 20,
                                  ),
                                  label: const Text(
                                    "Lanjutkan dengan Google",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // === TOMBOL DAFTAR MANUAL ===
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
                                  onPressed: _handleManualRegister,
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

  // === LOGIN/REGISTER VIA GOOGLE → LANJUT KE COMPLETE PROFILE ===
  Future<void> _handleGoogleRegister() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final authService = AuthService();

      // mapping role UI -> role backend
      final roleForBackend = _selectedRole == 'Organisasi'
          ? 'Organizer'
          : 'Volunteer';

      final AuthResponse auth = await authService.loginWithGoogle(
        role: roleForBackend,
      );

      Navigator.of(context).pop(); // tutup loading

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfilePage(role: auth.user.role),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal masuk dengan Google: $e')));
    }
  }

  // === REGISTER MANUAL → (NANTI) PANGGIL API /register → COMPLETE PROFILE ===
  Future<void> _handleManualRegister() async {
    // 1. Validasi input sederhana
    if (nameC.text.isEmpty ||
        emailC.text.isEmpty ||
        passC.text.isEmpty ||
        pass2C.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    if (passC.text != pass2C.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan konfirmasi tidak sama')),
      );
      return;
    }

    // mapping role UI → role di DB
    final String roleForBackend = _selectedRole == 'Organisasi'
        ? 'Organizer'
        : 'Volunteer';

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final authService = AuthService();
      final AuthResponse auth = await authService.register(
        nama: nameC.text.trim(),
        email: emailC.text.trim(),
        password: passC.text,
        role: roleForBackend,
      );

      Navigator.of(context).pop(); // tutup dialog

      // 3. Setelah register berhasil → ke halaman lengkapi profil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CompleteProfilePage(role: auth.user.role),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop(); // tutup dialog kalau error

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mendaftar: $e')));
    }
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

  // field input umum
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
