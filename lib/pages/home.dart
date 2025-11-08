import 'package:flutter/material.dart';
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                    backgroundImage: AssetImage('assets/profile.jpg'),
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
                        ),
                      ),
                      Text(
                        "Evan Arga",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 25),

          // 🔍 Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Cari disini...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 25),

          // 🧭 Kategori
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Berdasarkan Kategori ✨",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("Lihat semua", style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                categoryItem(Icons.nature, "Lingkungan"),
                categoryItem(Icons.school, "Pendidikan"),
                categoryItem(Icons.health_and_safety, "Kesehatan"),
                categoryItem(Icons.people, "Sosial"),
                categoryItem(Icons.palette, "Seni"),
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
                colors: [Color(0xFF006994), Color(0xFF00AEEF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Your Voluntree Exp",
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 5),
                const Text(
                  "18,000",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: const LinearProgressIndicator(
                    value: 0.8,
                    minHeight: 8,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Your Coins: 10,000",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // 🔥 Daftar Sekarang
          const Text(
            "Daftar Sekarang 🔥",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                eventCard(
                  "assets/event1.jpg",
                  "Pintar Bersama - KMB USU",
                  "Sabtu, 19 Oktober 2024",
                  "12.00 WIB - 17.00 WIB",
                ),
                eventCard(
                  "assets/event2.jpg",
                  "Aksi Bersih Pantai",
                  "Minggu, 20 Oktober 2024",
                  "09.00 WIB - 12.00 WIB",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget categoryItem(IconData icon, String title) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 15),
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  static Widget eventCard(
      String image, String title, String date, String time) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              image,
              height: 130,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("2 hari lagi",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(date,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
