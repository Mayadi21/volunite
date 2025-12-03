import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/pages/Authentication/otp_verification.dart';
import 'package:volunite/color_pallete.dart'; // 1. Import Color Palette

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailC = TextEditingController();

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mengambil warna dari palette
    const primaryColor = kBlueGray;
    const darkColor = kDarkBlueGray;

    return Scaffold(
      // Menggunakan background transparan karena kita akan pakai Gradient di Container
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        // 2. Menerapkan Gradient yang sama dengan AppBar ProfilePage
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

              Image.asset(
                'assets/images/logo/volunite_logo.png',
                height: 200,
                color: Colors.white,
              ),
              const SizedBox(height: 20),

              // Bagian Putih (Bottom Sheet Look)
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: kBackground, // Menggunakan kBackground atau white
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
                  child: SingleChildScrollView(
                    // Agar aman saat keyboard muncul
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Lupa Kata Sandi",
                          style: TextStyle(
                            fontSize: 22, // Sedikit diperbesar
                            fontWeight: FontWeight.bold,
                            color: darkColor, // 3. Menggunakan kDarkBlueGray
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Jangan khawatir, Anda dapat mengganti passwordnya",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kBlueGray, fontSize: 13),
                          ),
                        ),

                        const SizedBox(height: 30),

                        _buildEmailField(
                          hint: "Masukkan email anda",
                          controller: emailC,
                          keyboard: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primaryColor, // 4. Tombol menggunakan kBlueGray
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OTPVerificationPage(email: emailC.text),
                                ),
                              );
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

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Kembali Ke Login",
                            style: TextStyle(
                              color:
                                  darkColor, // Link menggunakan warna gelap konsisten
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20), // Tambahan padding bawah
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

  Widget _buildEmailField({
    required String hint,
    required TextEditingController controller,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: kBlueGray, // Border saat fokus menggunakan warna tema
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
