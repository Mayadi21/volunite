import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/forgot_password.dart';
import 'package:volunite/pages/Authentication/register.dart';
import 'package:volunite/pages/Volunteer/navbar.dart';
import 'package:volunite/pages/Organizer/navbar.dart';
import 'package:volunite/pages/Admin/admin_main_page.dart';
import 'package:volunite/color_pallete.dart'; // 1. Import Color Palette

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 2. Menggunakan warna dari Palette
    const primaryColor = kBlueGray;
    const darkColor = kDarkBlueGray;

    return Scaffold(
      // Background transparan untuk Gradient
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        // 3. Gradient Background Konsisten
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

              // Header Teks (Di atas background gradient)
              const Text(
                "Masuk",
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
                  "Login ke akun Anda untuk mulai mengikuti kegiatan volunteer.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
              const SizedBox(height: 24),

              // Container Putih (Bottom Sheet Look)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground, // Menggunakan kBackground/White
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
                  child: SingleChildScrollView(
                    // Mencegah overflow saat keyboard muncul
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Selamat Datang Kembali",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkColor, // Warna teks gelap
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        _field(
                          icon: Icons.email,
                          hint: "Masukkan email Anda",
                          controller: emailC,
                          keyboard: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        _field(
                          icon: Icons.lock,
                          hint: "Masukkan password Anda",
                          controller: passC,
                          obscure: true,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          _rememberMe = newValue ?? false;
                                        });
                                      },
                                      activeColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "Ingat Saya",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: kBlueGray,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Lupa Kata Sandi?",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // 1. Masuk sebagai Volunteer (Primary Button)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LandingPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Masuk sebagai Volunteer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 2. Masuk sebagai Organizer (Outlined Button)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OrganizerLandingPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Masuk sebagai Organizer",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // 3. Masuk sebagai Admin (Outlined Button)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: const BorderSide(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const AdminMainPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Masuk sebagai Admin",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun? ",
                              style: TextStyle(color: kBlueGray),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20), // Padding bawah tambahan
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: kBlueGray), // Icon warna tema
        filled: true,
        fillColor: kLightGray, // Menggunakan kLightGray/Putih abu
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
          borderSide: const BorderSide(color: kBlueGray, width: 1.5),
        ),
      ),
    );
  }
}
