// FILE: api_client.dart
// Fungsi: Menjadi HTTP client utama yang menyisipkan token otomatis ke semua request.
// Kegunaan: Supaya setiap service tidak perlu lagi mengambil token atau set header berulang.
// Cara manggil: ApiClient.get('/path'); ApiClient.post('/path', body: {...});
// Keuntungan: Semua request standar (GET/POST/PUT/DELETE) jadi satu pintu terpusat.

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'token_storage.dart';

class ApiClient {
  // Ubah baseUrl di sini saja kalau pindah server
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  // static const String baseUrl = 'http://127.0.0.1:8000/api';

  /// Build header dasar
  static Future<Map<String, String>> _buildHeaders({
    bool withAuth = true,
    bool jsonBody = false,
  }) async {
    final headers = <String, String>{'Accept': 'application/json'};

    if (jsonBody) {
      headers['Content-Type'] = 'application/json';
    }

    if (withAuth) {
      final token = await TokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  /// GET /path
  static Future<http.Response> get(String path, {bool auth = true}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(withAuth: auth);
    return http.get(uri, headers: headers);
  }

  /// POST /path (JSON body)
  static Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(withAuth: auth, jsonBody: true);
    final encodedBody = body != null ? jsonEncode(body) : null;
    return http.post(uri, headers: headers, body: encodedBody);
  }

  /// PUT /path (JSON body)
  static Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    bool auth = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(withAuth: auth, jsonBody: true);
    final encodedBody = body != null ? jsonEncode(body) : null;
    return http.put(uri, headers: headers, body: encodedBody);
  }

  /// DELETE /path
  static Future<http.Response> delete(String path, {bool auth = true}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = await _buildHeaders(withAuth: auth);
    return http.delete(uri, headers: headers);
  }
}
