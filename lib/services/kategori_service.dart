import 'dart:convert';
import 'package:volunite/models/kategori_model.dart';
import 'package:volunite/services/core/api_client.dart';

class KategoriService {
  
  static Future<List<Kategori>> fetchKategori() async {
    final response = await ApiClient.get('/kategori');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      
      final List<dynamic> jsonList = jsonResponse['data'];

      return jsonList
          .map((item) => Kategori.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Gagal load kategori. Status: ${response.statusCode}',
      );
    }
  }
}