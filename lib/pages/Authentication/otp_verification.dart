import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volunite/pages/Authentication/reset_password.dart';

class OTPVerificationPage extends StatefulWidget {
  final String email;

  const OTPVerificationPage({super.key, required this.email});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final Color primary = const Color(0xFF0C5E70);

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
      backgroundColor: primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            Image.asset(
              'assets/images/logo/volunite_logo.png', 
              height: 200, 
              color: Colors.white, 
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                padding: const EdgeInsets.fromLTRB(22, 30, 22, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "OTP",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Silahkan masukkan kode OTP yang telah dikirim ke email Anda",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ),

                    Text(
                      "@${widget.email}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
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
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
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
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
  Widget _buildOTPBox({
    required TextEditingController controller,
    required FocusNode focusNode,
    required void Function(String)? onChanged,
  }) {
    final Color primary = const Color(0xFF0C5E70);
    final bool isFilled = controller.text.isNotEmpty;
    final Color boxColor = isFilled ? primary : Colors.white;
    final Color textColor = isFilled ? Colors.white : primary;

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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primary, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: primary,
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: primary,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
