import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volunite/pages/Authentication/login.dart';

class OnboardingItem {
  String image;
  String title;
  String description;

  OnboardingItem(
      {required this.image, required this.title, required this.description});
}

List<OnboardingItem> contents = [
  OnboardingItem(
    title: 'Temukan Peluang',
    image: 'assets/images/onboard/onboard1.png',
    description:
        'Jelajahi ratusan kegiatan relawan dari berbagai organisasi di sekitar Anda.',
  ),
  OnboardingItem(
    title: 'Terhubung dengan Komunitas',
    image: 'assets/images/onboard/onboard2.png',
    description:
        'Bertemu dengan relawan lain, bangun jaringan, dan jadi bagian dari komunitas peduli.',
  ),
  OnboardingItem(
    title: 'Buat Perubahan Nyata',
    image: 'assets/images/onboard/onboard3.png',
    description:
        'Setiap jam yang Anda berikan membawa dampak positif bagi yang membutuhkan.',
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // Warna primer dari file login.dart Anda
  static const Color primary = Color(0xFF0C5E70);

  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi untuk menyimpan status & pindah ke halaman Login
  Future<void> _selesaiOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('telahLihatOnboarding', true);

    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // --- Tombol Lewati (Skip) ---
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextButton(
                onPressed: () => _selesaiOnboarding(context),
                child: const Text(
                  'LEWATI',
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // --- PageView (Slides) ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: contents.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Ganti Image.network dengan Image.asset jika pakai aset lokal
                        Image.network(
                          contents[index].image,
                          height: 300,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              width: 300,
                              color: Colors.grey[200],
                              child: Icon(
                                Icons.image_not_supported,
                                color: Colors.grey[400],
                                size: 50,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          contents[index].title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          contents[index].description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- Indikator Titik dan Tombol Navigasi ---
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // --- Dots ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      contents.length,
                      (index) => buildDot(index, context),
                    ),
                  ),

                  // --- Tombol Lanjut / Mulai ---
                  SizedBox(
                    height: 50,
                    width: 120,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == contents.length - 1) {
                          _selesaiOnboarding(context);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary, // Warna dari tema Anda
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(
                        _currentPage == contents.length - 1 ? 'MULAI' : 'LANJUT',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat titik indikator
  AnimatedContainer buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? primary : Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}