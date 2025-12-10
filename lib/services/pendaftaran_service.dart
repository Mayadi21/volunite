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
  Future<bool> isUserRegistered(int kegiatanId) async {
    try {
        final response = await ApiClient.get(
            // Endpoint API yang Anda buat di Laravel
            '/volunteer/kegiatan/$kegiatanId/pendaftaran/status',
            auth: true, // Pastikan ini mengirim token autentikasi
        );

        if (response.statusCode == 200) {
            final body = json.decode(response.body);
            // 🔥 PERBAIKAN LOGIC: Pastikan kita mendapatkan boolean dari 'is_registered'
            if (body is Map && body.containsKey('is_registered')) {
                 return body['is_registered'] == true;
            }
            return false; // Jika format respons tidak sesuai
        }

        // Jika status code bukan 200 (misal 401 Unauthorized atau 404 Not Found)
        return false; 
    } catch (e) {
        print("Error cek status pendaftaran: $e");
        return false;
    }
}
}
