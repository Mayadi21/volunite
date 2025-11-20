// lib/pages/Volunteer/home.dart
import 'package:flutter/material.dart';
import 'package:volunite/pages/Volunteer/Activity/detail_activities_page.dart';
import 'package:volunite/pages/Volunteer/Notification/notification.dart';
import 'package:volunite/pages/Volunteer/Category/categories_page.dart';
import 'package:volunite/pages/Volunteer/Category/category_activities_page.dart';
import 'package:volunite/color_pallete.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      color: kBackground,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👋 Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(
                        'assets/images/profile_placeholder.jpeg',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Hi, Selamat Datang 👋",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: kDarkBlueGray,
                          ),
                        ),
                        Text(
                          "Evan Arga",
                          style: TextStyle(fontSize: 14, color: kBlueGray),
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: kSoftBlue,
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      size: 20,
                      color: kDarkBlueGray,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🔍 Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Cari kegiatan relawan...",
                hintStyle: const TextStyle(color: kBlueGray),
                prefixIcon: const Icon(Icons.search, color: kBlueGray),
                filled: true,
                fillColor: kSoftBlue.withOpacity(0.5),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: kSkyBlue, width: 1.2),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // 🧭 Kategori
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kategori Pilihan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategoriesPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lihat semua',
                    style: TextStyle(
                      color: kBlueGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // LIST KATEGORI
            SizedBox(
              height: 95, // Sedikit diperbesar agar tidak terpotong bayangannya
              child: ListView(
                scrollDirection: Axis.horizontal,
                // Perhatikan penambahan parameter 'context' disini:
                children: [
                  categoryItem(context, Icons.nature, "Lingkungan", primary),
                  categoryItem(context, Icons.school, "Pendidikan", primary),
                  categoryItem(
                    context,
                    Icons.health_and_safety,
                    "Kesehatan",
                    primary,
                  ),
                  categoryItem(context, Icons.people, "Sosial", primary),
                  categoryItem(context, Icons.palette, "Seni", primary),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 💎 Exp Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [kSkyBlue, kBlueGray],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kBlueGray.withOpacity(0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Your Voluntree Exp",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "18,000",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: LinearProgressIndicator(
                      value: 0.8,
                      minHeight: 8,
                      backgroundColor: Colors.white24,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your Coins: 10,000",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Daftar Sekarang (Tidak berubah)
            const Text(
              "Daftar Sekarang",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kDarkBlueGray,
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              height: 230,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  eventCard(
                    context,
                    "assets/images/event1.jpg",
                    "Pintar Bersama - KMB USU",
                    "Sabtu, 19 Oktober 2024",
                    "12.00 WIB - 17.00 WIB",
                    primary,
                  ),
                  eventCard(
                    context,
                    "assets/images/event2.jpg",
                    "Aksi Bersih Pantai",
                    "Minggu, 20 Oktober 2024",
                    "09.00 WIB - 12.00 WIB",
                    primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Kategori item (UPDATED)
  // Kita menambahkan BuildContext context agar bisa melakukan Navigasi
  static Widget categoryItem(
    BuildContext context,
    IconData icon,
    String title,
    Color primary,
  ) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman list kegiatan berdasarkan kategori
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryActivitiesPage(categoryName: title),
          ),
        );
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(
          right: 15,
          top: 5,
          bottom: 5,
        ), // Margin disesuaikan untuk shadow
        child: Column(
          children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kSoftBlue, kSkyBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: kBlueGray.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 26, color: kDarkBlueGray),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: kDarkBlueGray),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 Event card (Tidak berubah)
  static Widget eventCard(
    BuildContext context,
    String image,
    String title,
    String date,
    String time,
    Color primary,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailActivitiesPage(
              title: title,
              date: date,
              time: time,
              imagePath: image,
            ),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: kBlueGray.withOpacity(0.18),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                image,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    Container(height: 130, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ).copyWith(top: 10, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // badge "2 hari lagi"
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: kSkyBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "2 hari lagi",
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kDarkBlueGray,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: kBlueGray,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: kBlueGray,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: kBlueGray),
                      const SizedBox(width: 5),
                      Text(
                        time,
                        style: const TextStyle(color: kBlueGray, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
