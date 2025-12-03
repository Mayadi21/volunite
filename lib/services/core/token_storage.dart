// FILE: token_storage.dart
// Fungsi: Menyimpan, mengambil, dan menghapus token autentikasi dari SharedPreferences.
// Kegunaan: Dipakai untuk mempertahankan token login agar bisa digunakan di semua request API.
// Cara manggil: await TokenStorage.saveToken(token); → untuk menyimpan token.
// Cara manggil: final token = await TokenStorage.getToken(); → untuk mengambil token.


import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const String _key = 'auth_token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
