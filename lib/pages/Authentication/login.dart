import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/forgot_password.dart';
import 'package:volunite/pages/Authentication/register.dart';
import 'package:volunite/pages/Organizer/home.dart';
import 'package:volunite/pages/Volunteer/navbar.dart';
import 'package:volunite/pages/Admin/admin_main_page.dart';
import 'package:volunite/color_pallete.dart';

// tambahkan ini:
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/core/token_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();
  final passC = TextEditingController();
  bool _rememberMe = false;

  // tambahan:
  bool _isLoading = false;
  final _authService = AuthService();

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  // === FUNGSI LOGIN EMAIL/PASSWORD ===
  Future<void> _login() async {
    final email = emailC.text.trim();
    final password = passC.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = await _authService.login(email: email, password: password);

      // simpan token (sebenernya AuthService.login udah simpan juga, tapi gapapa)
      await TokenStorage.saveToken(auth.token);

      final role =
          auth.user.role; // "Volunteer", "Organizer", "Admin", "Banned"

      if (role == 'Banned') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Akun Anda diblokir.')));
        return;
      }

      // Arahkan sesuai role dari backend
      if (role == 'Volunteer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      } else if (role == 'Organizer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrganizerHomeTab()),
        );
      } else if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminMainPage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Role tidak dikenali: $role')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // === FUNGSI LOGIN DENGAN GOOGLE ===
  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      // panggil loginWithGoogle TANPA role (role diambil dari DB)
      final auth = await _authService.loginWithGoogle();

      final role = auth.user.role;

      if (role == 'Banned') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Akun Anda diblokir.')));
        return;
      }

      // arahkan sesuai role, sama seperti _login()
      if (role == 'Volunteer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingPage()),
        );
      } else if (role == 'Organizer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OrganizerLandingPage()),
        );
      } else if (role == 'Admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminMainPage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Role tidak dikenali: $role')));
      }
    } catch (e) {
      // misal: user cancel dialog Google → Exception('Login dengan Google dibatalkan.')
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  // ===============================

  @override
  Widget build(BuildContext context) {
    const primaryColor = kBlueGray;
    const darkColor = kDarkBlueGray;

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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Selamat Datang Kembali",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: darkColor,
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

                        // TOMBOL MASUK EMAIL/PASSWORD
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
                            onPressed: _isLoading ? null : _login,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    "Masuk",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // TOMBOL MASUK DENGAN GOOGLE
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            onPressed: _isLoading ? null : _loginWithGoogle,
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
                              side: const BorderSide(color: kBlueGray),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(height: 20),
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
        prefixIcon: Icon(icon, color: kBlueGray),
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
          borderSide: const BorderSide(color: kBlueGray, width: 1.5),
        ),
      ),
    );
  }
}
