// pendaftaran_service.dart

import 'dart:convert';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/models/pendaftaran_model.dart';
import 'package:volunite/models/detail_pendaftaran_model.dart'; // Import DetailPendaftaran

class PendaftaranService {
  // Ubah method dari static ke instance method, dan kembalikan Future<bool>
  Future<bool> daftarKegiatan({
    required int kegiatanId,
    required int userId,
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
          "user_id": userId,
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
}