// lib/pages/kategori/detail_category.dart

import 'package:flutter/material.dart';
import 'package:volunite/color_pallete.dart';
// Impor model Kategori yang benar dari file model Anda
import 'package:volunite/models/kategori_model.dart'; // Pastikan path ini benar!

// Hapus atau abaikan impor categories_page.dart
// Hapus atau abaikan impor ActivityCard/Activity dummy
// Karena kita akan menggantinya dengan CategoryActivitiesPage

// Jika Anda hanya ingin menampilkan Detail Category, gunakan Kategori:
class DetailCategoryPage extends StatelessWidget {
    // 🔥 PERBAIKAN: Ganti ActivityCategory dengan Kategori (model dari database)
    final Kategori category;
    
    // Perhatikan: Karena Anda sudah punya CategoryActivitiesPage, 
    // apakah halaman ini masih dibutuhkan? 
    // Umumnya, CategoryActivitiesPage yang memuat daftar kegiatan berdasarkan nama 
    // sudah cukup (sesuai kode yang kita revisi sebelumnya).

    const DetailCategoryPage({super.key, required this.category});

    // Karena ini adalah halaman DETAIL KATEGORI, kita tidak perlu data kegiatan dummy di sini.
    // Kita hanya fokus menampilkan informasi Kategori.
    
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: kBackground,
            appBar: AppBar(
                backgroundColor: kSkyBlue,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                // Judul menggunakan nama kategori dari database
                title: Text(
                    'Detail Kategori: ${category.namaKategori}', 
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                ),
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    _buildCategoryHeader(), // Memanggil header yang diperbarui
                    
                    // Anda bisa menambahkan deskripsi kategori di sini:
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                            category.deskripsi ?? "Deskripsi tidak tersedia.",
                            style: const TextStyle(fontSize: 16, color: kDarkBlueGray),
                        ),
                    ),

                    // Jika Anda tetap ingin menampilkan daftar kegiatan di sini, 
                    // Anda harus mengintegrasikan CategoryActivitiesPage secara langsung
                    // atau membuat stateful widget baru untuk memuat data.

                    const Center(child: Text("Ini adalah halaman detail Kategori.")),
                ],
            ),
        );
    }

    Widget _buildCategoryHeader() {
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: kLightGray, width: 1)),
            ),
            child: Row(
                children: [
                    // Tampilkan Thumbnail Kategori jika ada
                    category.thumbnail != null
                        ? _buildThumbnailWidget(category.thumbnail!)
                        : Icon(Icons.category, size: 28, color: kDarkBlueGray),
                    
                    const SizedBox(width: 12),
                    Text(
                        '${category.namaKategori}', // Nama dari model Kategori
                        style: const TextStyle(
                            fontSize: 18,
                            color: kDarkBlueGray,
                            fontWeight: FontWeight.w700,
                        ),
                    ),
                ],
            ),
        );
    }
    
    // 🔥 Fungsi Pembantu untuk menampilkan thumbnail kategori
    Widget _buildThumbnailWidget(String path) {
        final bool isUrl = path.startsWith("http") || path.startsWith("https");
        const double size = 40;
        
        // Logika sederhana untuk menampilkan gambar thumbnail
        return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: kSoftBlue,
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isUrl 
                    ? Image.network(path, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error))
                    : Image.asset('assets/$path', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image)),
            ),
        );
    }
}