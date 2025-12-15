import 'dart:convert';
import 'package:volunite/models/volunteer_pencapaian_model.dart';
import 'package:volunite/services/core/api_client.dart';

class VolunteerService {
  static Future<VolunteerProfileData> fetchProfile() async {
    final response = await ApiClient.get('/volunteer/profile');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return VolunteerProfileData.fromJson(body['data']);
    } else {
      throw Exception('Gagal memuat profil');
    }
  }
}