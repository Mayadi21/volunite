import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:volunite/services/auth/auth_service.dart';
import 'package:volunite/services/core/api_client.dart';

class ReportService {
  /// Mengirim laporan ke endpoint.
  /// 
  /// DULU: mengembalikan bool. SEKARANG: mengembalikan http.Response agar pemanggil
  /// (UI) dapat membaca statusCode dan body jika ingin menampilkan error message.
  Future<http.Response> submitReport({
    required int kegiatanId,
    required String keluhan,
    required String detailKeluhan,
    required String status,
  }) async {
    try {
      final response = await ApiClient.post(
        '/volunteer/kegiatan/$kegiatanId/report',
        body: {
          "kegiatan_id": kegiatanId,
          "keluhan": keluhan,
          "detail_keluhan": detailKeluhan,
          "status": status,
        },
        auth: true, // kirim token
      );

      // Kembalikan response apa adanya, biarkan UI yang menentukan
      // apakah berhasil berdasarkan response.statusCode.
      return response;
    } catch (e) {
      // Cetak log untuk debugging, lalu teruskan exception agar UI dapat menangkapnya.
      print("Network Error during report: $e");
      rethrow;
}
}
}