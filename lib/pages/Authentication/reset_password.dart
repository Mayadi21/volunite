import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/color_pallete.dart'; // 1. Import Color Palette

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final newPassC = TextEditingController();
  final confirmPassC = TextEditingController();

  // Hapus variabel primary hardcoded, kita gunakan kBlueGray dari palette

  @override
  void dispose() {
    newPassC.dispose();
    confirmPassC.dispose();
    super.dispose();
  }

  void _onSelesaiPressed() {
    if (newPassC.text != confirmPassC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Konfirmasi password tidak cocok.")),
      );
      return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (Route<dynamic> route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password berhasil diubah! Silakan Login.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Background transparan untuk Gradient
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        // Gradient background konsisten
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

              // Container Putih
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray, // Judul gelap
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildPasswordField(
                          hint: "Masukkan password baru",
                          controller: newPassC,
                        ),
                        const SizedBox(height: 12),

                        _buildPasswordField(
                          hint: "Konfirmasi password baru",
                          controller: confirmPassC,
                        ),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kBlueGray, // Tombol sesuai tema
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _onSelesaiPressed,
                            child: const Text(
                              "Selesai",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
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

  Widget _buildPasswordField({
    required String hint,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.text,
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
            color: kBlueGray, // Border fokus menggunakan warna tema
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
