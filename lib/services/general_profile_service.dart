import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:volunite/models/user_model.dart';
import 'package:volunite/services/core/api_client.dart';
import 'package:flutter/foundation.dart';

class GeneralProfileService {
  
  static final ValueNotifier<bool> shouldRefresh = ValueNotifier(false);

  static Future<Map<String, dynamic>> fetchMyProfile() async {
    final response = await ApiClient.get('/profile/me');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      
      final data = body['data']; 
      
      return {
        'user': User.fromJson(data['user']),
        'detail': data['detail'] != null 
            ? DetailUser.fromJson(data['detail']) 
            : DetailUser(),
      };
    } else {
      throw Exception('Gagal memuat profil: ${response.statusCode}');
    }
  }

  static Future<bool> updateProfile({
    required String nama,
    String? jenisKelamin,
    String? tanggalLahir,
    String? noTelepon,
    String? domisili,
    XFile? fotoProfil, 
  }) async {
    
    Map<String, String> fields = {
      'nama': nama,
      if (jenisKelamin != null) 'jenis_kelamin': jenisKelamin,
      if (tanggalLahir != null) 'tanggal_lahir': tanggalLahir,
      if (noTelepon != null) 'no_telepon': noTelepon,
      if (domisili != null) 'domisili': domisili,
    };

    final response = await ApiClient.postMultipart(
      '/profile/update',
      fields: fields,
      file: fotoProfil, 
      fileKey: 'foto',
    );

    if (response.statusCode == 200) {
      shouldRefresh.value = !shouldRefresh.value; 
      return true;
    }
    return false;
  }

  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await ApiClient.post(
      '/profile/password',
      body: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPasswordConfirmation,
      },
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Gagal mengubah sandi');
    }
  }
}