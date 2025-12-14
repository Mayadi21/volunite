// FILE: api_client.dart
// Fungsi: Menjadi HTTP client utama yang menyisipkan token otomatis ke semua request.
// Kegunaan: Supaya setiap service tidak perlu lagi mengambil token atau set header berulang.
// Cara manggil: ApiClient.get('/path'); ApiClient.post('/path', body: {...});
// Keuntungan: Semua request standar (GET/POST/PUT/DELETE) jadi satu pintu terpusat.

import 'dart:convert';
import 'dart:io'; 
import 'package:flutter/foundation.dart'; // PENTING: Untuk kIsWeb
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Ganti dart:io File dengan XFile
import 'token_storage.dart';

class ApiClient {
  // Ubah baseUrl di sini saja kalau pindah server
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    if (Platform.isAndroid) return 'http://10.0.2.2:8000/api';
    return 'http://127.0.0.1:8000/api'; // iOS
  }
  // static const String baseUrl = 'http://192.168.1.7:8000/api';

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

  /// POST MultiPart(Field & File) /path
  static Future<http.Response> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    XFile? file,    // <-- GANTI TIPE DATA JADI XFile
    String? fileKey,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final request = http.MultipartRequest('POST', uri);

    final token = await TokenStorage.getToken();
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    request.headers['Accept'] = 'application/json';

    if (fields.isNotEmpty) {
      request.fields.addAll(fields);
    }

    // --- LOGIKA HYBRID (WEB & MOBILE) ---
    if (file != null && fileKey != null) {
      if (kIsWeb) {
        // KHUSUS WEB: Kirim sebagai Bytes (Memori)
        final bytes = await file.readAsBytes();
        final pic = http.MultipartFile.fromBytes(
          fileKey,
          bytes,
          filename: file.name, // Web butuh nama file eksplisit
        );
        request.files.add(pic);
      } else {
        final pic = await http.MultipartFile.fromPath(
          fileKey, 
          file.path
        );
        request.files.add(pic);
      }
    }
    // -------------------------------------

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
