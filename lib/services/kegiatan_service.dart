import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kegiatan_model.dart';

class KegiatanService {
  // Contoh untuk Android emulator:
  // static const String baseUrl = "http://10.0.2.2:8000/api/kegiatan";
  // iOS simulator:
  // static const String baseUrl = "http://127.0.0.1:8000/api/kegiatan";
  // Real device -> gunakan IP mesin dev: http://192.168.x.x:8000/api/kegiatan

  // static const String baseUrl = "http://10.0.2.2:8000/api/kegiatan";
  // static const String baseUrl = "http://127.0.0.1:8000/api/kegiatan";
  static const String baseUrl = "http://192.168.1.6:8000/api/kegiatan";


  static Future<List<Kegiatan>> fetchKegiatan() async {
    final uri = Uri.parse(baseUrl);
    final response = await http.get(uri, headers: {
      'Accept': 'application/json',
    });

    if (response.statusCode == 200) {
      // Response assumed berupa JSON array: [ {kegiatan}, {kegiatan}, ... ]
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList.map((e) => Kegiatan.fromJson(e as Map<String, dynamic>)).toList();
    } else {
      // lempar error informatif
      throw Exception('Gagal fetch kegiatan. Status: ${response.statusCode}. Body: ${response.body}');
    }
  }
}
