import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart'; // Halaman login Anda
import 'onboarding_page.dart'; // Halaman onboarding Anda

class DecisionPage extends StatefulWidget {
  const DecisionPage({super.key});

  @override
  State<DecisionPage> createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  // --- PERUBAHAN DIMULAI DI SINI ---

  // 1. Buat variabel untuk menampung Future
  late Future<bool> _statusOnboardingFuture;

  @override
  void initState() {
    super.initState();
    // 2. Panggil fungsi HANYA SEKALI di dalam initState
    _statusOnboardingFuture = _cekStatusOnboarding();
  }

  // Fungsinya tetap sama
  Future<bool> _cekStatusOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('telahLihatOnboarding') ?? false;
  }

  // --- PERUBAHAN SELESAI ---

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // 3. Gunakan variabel Future yang sudah disimpan
      future: _statusOnboardingFuture,
      builder: (context, snapshot) {
        // Saat sedang loading (mengecek SharedPreferences)
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Ini adalah layar loading yang mungkin Anda lihat
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(
              color: Color(0xFF0C5E70), // Sesuaikan dengan warna primer Anda
            )),
          );
        }

        // Jika sudah dapat data
        if (snapshot.hasData) {
          final bool telahLihat = snapshot.data!;
          
          if (telahLihat) {
            // JIKA SUDAH lihat onboarding, langsung ke Login
            return const LoginPage(); 
          } else {
            // JIKA BELUM lihat, tampilkan Onboarding
            return const OnboardingPage();
          }
        }

        // Jika ada error
        return const Scaffold(
          body: Center(child: Text("Error memuat aplikasi...")),
        );
      },
    );
  }
}