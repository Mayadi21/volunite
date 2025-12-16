import 'dart:convert';
import 'dart:io';
import  'package:image_picker/image_picker.dart';

import 'package:volunite/models/user_model.dart';
import 'package:volunite/services/core/api_client.dart';

class ProfileService {
  /// ===============================
  /// GET PROFILE
  /// ===============================
  static Future<Map<String, dynamic>> fetchProfile() async {
    final response = await ApiClient.get('/profile');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse =
          jsonDecode(response.body);

      return {
        'user': User.fromJson(jsonResponse['user']),
        'detail': jsonResponse['detail'] != null
            ? DetailUser.fromJson(jsonResponse['detail'])
            : DetailUser(),
      };
    } else {
      throw Exception(
        'Gagal load profile. Status: ${response.statusCode}',
      );
    }
  }

  /// ===============================
  /// UPDATE PROFILE (+ FOTO)
  /// ===============================
  static Future<void> updateProfile({
  required String nama,
  String? jenisKelamin,
  String? tanggalLahir,
  String? noTelepon,
  String? domisili,
  XFile? fotoProfil, // <-- HARUS ADA DI PARAMETER
}) async {
  final fields = <String, String>{
    'nama': nama,
    if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
    if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
    if (noTelepon != null) 'no_telepon': noTelepon,
    if (domisili != null) 'domisili': domisili,
  };

  final response = await ApiClient.postMultipart(
    '/profile',
    fields: fields,
    file: fotoProfil,      // <-- Kirim file di sini    
    fileKey: 'foto',       
  );

  if (response.statusCode != 200) {
    throw Exception('Gagal update profile');
  }
}

static Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
  required String newPasswordConfirmation,
}) async {
  final body = {
    'current_password': currentPassword,
    'password': newPassword,
    'password_confirmation': newPasswordConfirmation,
  };

  final response = await ApiClient.post('/profile/password', body: body);

  if (response.statusCode == 200) {
    return;
  } else {
    // Coba ambil pesan error dari body response
    try {
      final jsonResponse = jsonDecode(response.body);
      final message = jsonResponse['message'] ?? 'Gagal ubah kata sandi.';
      // Jika Laravel mengembalikan error validasi, tampilkan detailnya
      if (jsonResponse['errors'] != null) {
        final errors = (jsonResponse['errors'] as Map).values.expand((e) => e).join(', ');
        throw Exception('$message Detail: $errors');
      }
      throw Exception(message);
    } catch (_) {
      throw Exception(
        'Gagal ubah kata sandi. Status: ${response.statusCode}',
      );
    }
  }
}
}
