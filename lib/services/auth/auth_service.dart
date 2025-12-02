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
import 'package:volunite/models/user_model.dart';

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
  Future<User?> getCurrentUser() async {
        final token = await TokenStorage.getToken();
        
        // 1. Cek apakah ada token. Jika tidak ada, user tidak login.
        if (token == null) {
            return null;
        }

        try {
            // 2. Panggil endpoint profil/user yang membutuhkan token (auth: true)
            // Asumsi: Endpoint '/user' mengembalikan data pengguna saat ini.
            final http.Response response = await ApiClient.get(
                '/user',
                auth: true, 
            );

            final jsonBody = jsonDecode(response.body);

            if (response.statusCode == 200) {
                // Asumsi: Data user berada langsung di root body atau di 'data'
                final userData = jsonBody['data'] ?? jsonBody; 
                return User.fromJson(userData);
            } else if (response.statusCode == 401) {
                // Token expired/tidak valid. Hapus token lokal.
                await TokenStorage.clearToken();
                return null;
            } else {
                // Gagal mengambil data user karena alasan lain
                return null;
            }
        } catch (e) {
            // Kesalahan jaringan atau parsing
            print('Error fetching current user: $e');
            return null;
        }
    }
}
