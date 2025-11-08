import 'package:flutter/material.dart';
import 'navbar.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
    const primary = Color(0xFF0C5E70); // biru hijau seperti desain

    return Scaffold(
      backgroundColor: primary,
      // Biar tampilan menyesuaikan saat keyboard muncul
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        // ❗ TANPA SCROLL: pakai Column + Expanded supaya pas 1 layar
        child: Column(
          children: [
            // Header kecil (ringkas supaya muat 1 layar)
            const SizedBox(height: 12),
            const Text(
              "Registrasi Akun",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28.0),
              child: Text(
                "Daftarkan akun Anda sekarang dan mulai kegiatan volunteer!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 12.5),
              ),
            ),
            const SizedBox(height: 16),

            // Kartu putih isi form — dibuat Expanded agar mengisi sisa layar TANPA scroll
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step indicator
                    const Center(
                      child: Text(
                        "Langkah Ke 1 dari 3",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 1 / 3,
                        minHeight: 4,
                        backgroundColor: Colors.grey.shade300,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "Buat Akun",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      "Pastikan data yang dimasukkan akurat dan sesuai kebutuhan.",
                      style: TextStyle(color: Colors.black54, fontSize: 12.5),
                    ),
                    const SizedBox(height: 14),

                    // ====== FORM (bisa diketik) ======
                    _field(
                      icon: Icons.person,
                      hint: "Masukkan nama Anda",
                      controller: nameC,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      icon: Icons.email,
                      hint: "Masukkan email Anda",
                      controller: emailC,
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      icon: Icons.lock,
                      hint: "Masukkan password Anda",
                      controller: passC,
                      obscure: true,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      icon: Icons.lock,
                      hint: "Konfirmasi password Anda",
                      controller: pass2C,
                      obscure: true,
                    ),

                    const Spacer(), // dorong tombol ke bawah
                    // Tombol Selanjutnya
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          // Tidak mengirim apa-apa; hanya pindah halaman
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LandingPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Selanjutnya",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Sudah punya akun? Login (non-aktif dulu)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
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
                  ],
                ),
              ),
            ),
          ],
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
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: const Color(0xFFF5F6F8),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
