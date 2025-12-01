// FILE: auth_service.dart
// Fungsi: Menangani proses login (dan logout) user menggunakan endpoint API.
// Kegunaan: Di-UI, kamu panggil login() untuk memverifikasi akun user.
// Cara manggil: await AuthService().login(email: x, password: y);
// Catatan: Setelah login, token otomatis disimpan via TokenStorage.


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:volunite/services/auth/auth_response.dart';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/services/core/token_storage.dart';

class AuthService {
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    // /login tidak butuh token → auth: false
    final http.Response response = await ApiClient.post(
      '/login',
      auth: false,
      body: {'email': email, 'password': password},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(data);

      // SIMPAN TOKEN UNTUK DIPAKAI DI REQUEST BERIKUTNYA
      await TokenStorage.saveToken(authResponse.token);

      return authResponse;
    } else {
      final message = data['message'] ?? 'Email atau password salah.';
      throw Exception(message);
    }
  }

  Future<void> logout() async {
    // kalau backend punya /logout, bisa panggil:
    // await ApiClient.post('/logout', body: {}, auth: true);
    await TokenStorage.clearToken();
  }
}
