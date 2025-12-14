// lib/services/user_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:volunite/services/core/api_client.dart';

class UserService {
  // Ambil list user berdasarkan role (Volunteer / Organizer)
  static Future<Map<String, dynamic>> fetchUsers({
    required String role,
    int page = 1,
  }) async {
    final response = await ApiClient.get('/admin/users?role=$role&page=$page');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // data contains pagination, data['data'] is list
    } else {
      throw Exception('Failed to load users (${response.statusCode})');
    }
  }

  // Ambil single user
  static Future<Map<String, dynamic>> getUser(int id) async {
    final response = await ApiClient.get('/admin/users/$id');
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get user');
    }
  }

  // Update user (json body)
  static Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await ApiClient.put('/admin/users/$id', body: body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 422) {
      final err = jsonDecode(response.body);
      throw Exception(err['errors'] ?? 'Validation error');
    } else {
      throw Exception('Failed to update user (${response.statusCode})');
    }
  }

  // Delete user
  static Future<void> deleteUser(int id) async {
    final response = await ApiClient.delete('/admin/users/$id');
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete user');
    }
  }

  static Future<Map<String, dynamic>> createUser({
    required String nama,
    required String email,
    required String password,
    required String role,
    String? tanggalLahir,
    String? jenisKelamin,
    String? noTelepon,
    String? domisili,
  }) async {
    final body = {
      'nama': nama,
      'email': email,
      'password': password,
      'role': role,
      if (tanggalLahir != null && tanggalLahir.isNotEmpty)
        'tanggal_lahir': tanggalLahir,
      if (jenisKelamin != null && jenisKelamin.isNotEmpty)
        'jenis_kelamin': jenisKelamin,
      if (noTelepon != null && noTelepon.isNotEmpty) 'no_telepon': noTelepon,
      if (domisili != null && domisili.isNotEmpty) 'domisili': domisili,
    };

    final response = await ApiClient.post('/admin/users', body: body);

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 422) {
      throw Exception(jsonDecode(response.body)['errors']);
    } else {
      throw Exception(
        'Gagal membuat user (${response.statusCode}): ${response.body}',
      );
    }
  }
}
