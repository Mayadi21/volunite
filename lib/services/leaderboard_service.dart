import 'dart:convert';
import 'package:volunite/models/leaderboard_model.dart';
import 'package:volunite/services/core/api_client.dart';

class LeaderboardService {
  
  static Future<List<LeaderboardUser>> fetchLeaderboard() async {
    // Panggil endpoint /leaderboard
    final response = await ApiClient.get('/volunteer/leaderboard');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      
      // Safety check: pastikan key 'data' ada
      if (jsonResponse['data'] != null) {
        final List<dynamic> data = jsonResponse['data'];
        return data.map((e) => LeaderboardUser.fromJson(e)).toList();
      } else {
        return []; // Return list kosong jika data null
      }
    } else {
      // [DEBUG] Tampilkan status code & pesan error dari server di layar HP
      // Contoh: "Error 500: Class 'User' not found" atau "Error 404"
      throw Exception('Error ${response.statusCode}: ${response.body}');
    }
  }
}