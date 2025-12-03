import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volunite/pages/Authentication/reset_password.dart';
import 'package:volunite/color_pallete.dart'; // 1. Import Palette

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({super.key, required this.email});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  // Warna diambil dari palette, tidak di-hardcode lagi

  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].addListener(_handleFocusChange);
      otpControllers[i].addListener(_handleTextChange);
    }
  }

  void _handleFocusChange() {
    setState(() {});
  }

  void _handleTextChange() {
    setState(() {});
  }

  @override
  void dispose() {
    for (int i = 0; i < focusNodes.length; i++) {
      focusNodes[i].removeListener(_handleFocusChange);
      otpControllers[i].removeListener(_handleTextChange);
      focusNodes[i].dispose();
      otpControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 2. Background transparan untuk Gradient
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        // Gradient background agar konsisten
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

              // Container Putih (Bottom Sheet look)
              Expanded(
                // Menggunakan Expanded agar mengisi sisa layar ke bawah
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
                          "Verifikasi OTP",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray, // Judul Gelap
                          ),
                        ),
                        const SizedBox(height: 8),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Silahkan masukkan kode OTP yang telah dikirim ke email Anda",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kBlueGray, fontSize: 13),
                          ),
                        ),

                        const SizedBox(height: 8),
                        Text(
                          widget
                              .email, // Menghapus '@' manual jika email sudah lengkap
                          style: const TextStyle(
                            color: kDarkBlueGray,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(4, (index) {
                            return _buildOTPBox(
                              controller: otpControllers[index],
                              focusNode: focusNodes[index],
                              onChanged: (value) {
                                if (value.length == 1 && index < 3) {
                                  focusNodes[index + 1].requestFocus();
                                }
                                if (value.isEmpty &&
                                    index > 0 &&
                                    !focusNodes[index].hasFocus) {
                                  focusNodes[index - 1].requestFocus();
                                }
                              },
                            );
                          }),
                        ),

                        const SizedBox(height: 50),

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
                            onPressed: () {
                              final otpCode = otpControllers
                                  .map((c) => c.text)
                                  .join();
                              print("Kode OTP yang dimasukkan: $otpCode");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ResetPasswordPage(),
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

  Widget _buildOTPBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String)? onChanged,
  }) {
    // 3. Logika warna menggunakan Palette
    const activeColor = kBlueGray;
    final bool isFilled = controller.text.isNotEmpty;

    final Color boxColor = isFilled ? activeColor : Colors.white;
    final Color textColor = isFilled ? Colors.white : activeColor;

    return SizedBox(
      width: 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: boxColor,
          contentPadding: EdgeInsets.zero,
          // Border default (saat tidak fokus)
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: activeColor, width: 1.5),
          ),
          // Border saat diklik (fokus)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: activeColor, // Bisa diganti kDarkBlueGray jika ingin beda
              width: 2.5,
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
