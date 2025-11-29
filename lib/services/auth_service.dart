import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:volunite/models/user.dart';
import 'package:volunite/models/auth_response.dart';

class AuthService {

  static const String baseUrl = 'http://10.0.2.2:8000/api';

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponse.fromJson(data);
    } else {
      final message = data['message'] ?? 'Email atau password salah.';
      throw Exception(message);
    }
  }
}
