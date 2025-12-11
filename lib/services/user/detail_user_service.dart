// FILE: services/user/detail_user_service.dart
// Fungsi: Menyimpan detail user ke backend.
// Cara pakai: await DetailUserService().saveDetailUser(...);

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:volunite/services/core/api_client.dart';

class DetailUserService {
  Future<void> saveDetailUser({
    required String tanggalLahir,
    String? jenisKelamin,
    String? noTelepon,
    String? domisili,
  }) async {
    final response = await ApiClient.post(
      '/user/detail', // -> akan jadi http://10.0.2.2:8000/api/user/detail
      auth: true, // penting: kirim token
      body: {
        'tanggal_lahir': tanggalLahir,
        if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
        if (noTelepon != null) 'no_telepon': noTelepon,
        if (domisili != null) 'domisili': domisili,
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception('Gagal menyimpan detail user: ${jsonEncode(data)}');
    }
  }
}
