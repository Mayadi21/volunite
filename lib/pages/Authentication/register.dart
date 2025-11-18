import 'package:flutter/material.dart';
import 'package:volunite/pages/Authentication/login.dart';
import 'package:volunite/pages/Volunteer/navbar.dart';

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
    final primary = Theme.of(context).colorScheme.primary;

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
      backgroundColor: primary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
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
                    const Center(
                      child: Text(
                        "Langkah Ke 1 dari 2",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 1 / 2,
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

                    // --- MODIFIKASI: PENAMBAHAN TOMBOL ROLE ---
                    const SizedBox(height: 20),
                    const Text(
                      "Daftar Sebagai:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    // ------------------------------------------

                    const Spacer(),
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
                          setState(() {
                            _currentStep = 2;
                          });
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
          // Jika dipilih: Warna Primary, Jika tidak: Abu-abu gelap/dimmed
          color: isSelected ? primaryColor : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey.shade500, // Icon gelapkan jika tidak aktif
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              role,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade500, // Text gelapkan jika tidak aktif
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
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
            const SizedBox(height: 2),
            const Text(
              "Langkah Ke 2 dari 2",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(height: 2, color: primary),
            ),
            const SizedBox(height: 14),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Isi Data Diri",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  // Update text agar sesuai role
                  _selectedRole == 'Organisasi' 
                      ? "Lengkapi data organisasi Anda" 
                      : "Data diri hanya digunakan untuk informasi semata",
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _fieldStep2(
                    icon: Icons.calendar_today,
                    hint: _selectedRole == 'Organisasi' ? "Tanggal Berdiri" : "Tanggal Lahir",
                    controller: tglC,
                    readOnly: true,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime(2005, 1, 1),
                        firstDate: DateTime(1970),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        tglC.text =
                            "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  _fieldStep2(
                    icon: Icons.female,
                    hint: "Jenis Kelamin",
                    controller: genderC,
                  ),
                  const SizedBox(height: 14),
                  _fieldStep2(
                    icon: Icons.phone,
                    hint: "No Telepon",
                    controller: telpC,
                    keyboard: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  _fieldStep2(
                    icon: Icons.location_on_outlined,
                    hint: "Domisili",
                    controller: domisiliC,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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

  // ================== WIDGET FIELD STEP 2 ==================
  Widget _fieldStep2({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
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
        prefixIcon: Icon(icon, color: Colors.grey),
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