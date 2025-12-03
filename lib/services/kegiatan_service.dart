// FILE: kegiatan_service.dart
// Fungsi: Mengambil daftar kegiatan dari endpoint API volunteer/kegiatan.
// Kegunaan: Dipanggil dari UI untuk menampilkan list kegiatan ke user.
// Cara manggil: final data = await KegiatanService.fetchKegiatan();
// Keunggulan: Tidak perlu lagi ambil token — ApiClient sudah sisipkan otomatis.


import 'dart:convert';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/core/api_client.dart';

class KegiatanService {
  static Future<List<Kegiatan>> fetchKegiatan() async {
    // akan otomatis kirim Authorization: Bearer <token>
    final response = await ApiClient.get('/volunteer/kegiatan');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;

      return jsonList
          .map((e) => Kegiatan.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal fetch kegiatan. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }
}
