// pendaftaran_service.dart

import 'dart:convert';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/models/detail_pendaftaran_model.dart'; // Import DetailPendaftaran

class PendaftaranService {
  // Ubah method dari static ke instance method, dan kembalikan Future<bool>
  Future<bool> daftarKegiatan({
    required int kegiatanId,
    required String nomorTelepon,
    required String domisili,
    required String komitmen,
    required String keterampilan,
  }) async {
    try {
      final response = await ApiClient.post(
        // API client diasumsikan menangani baseURL dan headers
        '/volunteer/kegiatan/$kegiatanId/pendaftaran',
        body: {
          "nomor_telepon": nomorTelepon,
          "domisili": domisili,
          "komitmen": komitmen,
          "keterampilan": keterampilan,
        },
      );

      // Sukses: Status Code 201 Created atau 200 OK
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        // Log error jika diperlukan
        print("API Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      // Menangani error jaringan
      print("Network Error during registration: $e");
      return false;
    }
  }

 Future<String> getRegistrationStatus(int kegiatanId) async {
    try {
      final response = await ApiClient.get(
        // Sesuaikan dengan endpoint baru di controller
        '/volunteer/kegiatan/$kegiatanId/pendaftaran/status',
        auth: true, // Pastikan ini mengirim token autentikasi
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        // Cek kunci yang dikirim oleh Controller Laravel
        if (body is Map && body.containsKey('status_pendaftaran')) {
          // Status bisa berupa 'Mengajukan', 'Diterima', 'Ditolak', 'Belum Mendaftar'
          return body['status_pendaftaran'].toString(); 
        }
        // Jika format respons tidak sesuai
        return 'Kesalahan Data'; 
      }
      
      // Jika status code bukan 200 (misal 404 Not Found dari Kegiatan, 401 Unauthorized)
      return 'Kesalahan Server'; 

    } catch (e) {
      print("Error cek status pendaftaran: $e");
      // Gagal koneksi/jaringan
      return 'Kesalahan Jaringan';
    }
  }

  static Future<List<Pendaftaran>> fetchPendaftarByKegiatan(
    int kegiatanId,
  ) async {
    final response = await ApiClient.get(
      '/organizer/kegiatan/$kegiatanId/pendaftar',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((e) => Pendaftaran.fromJson(e)).toList();
    } else {
      throw Exception("Gagal memuat pelamar");
    }
  }

  // 2. Update Status (Terima / Tolak)
  static Future<bool> updateStatusPendaftaran(
    int pendaftaranId,
    String status,
  ) async {
    final response = await ApiClient.post(
      '/organizer/pendaftar/$pendaftaranId/update-status',
      body: {'status': status}, // "Diterima" atau "Ditolak"
    );

    return response.statusCode == 200;
  }

  static Future<bool> updateKehadiran(
    int pendaftaranId,
    String statusKehadiran,
  ) async {
    final response = await ApiClient.post(
      '/organizer/pendaftar/$pendaftaranId/update-kehadiran',
      body: {'status_kehadiran': statusKehadiran},
    );

    return response.statusCode == 200;
  }
}
