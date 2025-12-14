import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';

class PencapaianService {
// Return type kita ubah jadi Map biar bisa bawa info 'last_page'
  Future<Map<String, dynamic>> getAll({int page = 1}) async {
    // Laravel otomatis baca parameter ?page=X
    final response = await ApiClient.get('/admin/pencapaian?page=$page');

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      // Struktur JSON Laravel Pagination: { "data": [...], "current_page": 1, "last_page": 5, ... }
      final List data = json['data'];
      final int lastPage = json['last_page'];

      return {
        'list': data.map((e) => PencapaianModel.fromJson(e)).toList(),
        'last_page': lastPage,
      };
    }
    return {'list': <PencapaianModel>[], 'last_page': 1};
  }
  Future<bool> create(Map<String, String> fields, XFile? file) async {
    // Menggunakan postMultipart dari ApiClient kamu
    final response = await ApiClient.postMultipart(
      '/admin/pencapaian',
      fields: fields,
      file: file,
      fileKey: 'thumbnail',
    );
    return response.statusCode == 201;
  }

Future<bool> update(int id, Map<String, String> fields, XFile? file) async {
    // TRIK PENTING:
    // Laravel Multipart tidak bisa baca method PUT.
    // Jadi kita kirim POST, tapi kita bilang "Ini sebenarnya PUT lho" lewat field _method.
    fields['_method'] = 'PUT';

    print("Mengupdate ID: $id dengan data: $fields"); // Debug Log

    try {
      final response = await ApiClient.postMultipart(
        '/admin/pencapaian/$id', // Pastikan URL-nya benar (/pencapaian/1)
        fields: fields,
        file: file,
        fileKey: 'thumbnail',
      );

      print('Status Update: ${response.statusCode}');
      print('Respon Update: ${response.body}'); // << BACA INI DI CONSOLE

      return response.statusCode == 200;
    } catch (e) {
      print("Error Update: $e");
      return false;
    }
  }

  Future<bool> delete(int id) async {
    try {
      print("Mencoba menghapus ID: $id");
      final response = await ApiClient.delete('/admin/pencapaian/$id');

      print('Status Delete: ${response.statusCode}');
      print('Respon Delete: ${response.body}'); // << BACA INI DI CONSOLE

      return response.statusCode == 200;
    } catch (e) {
      print("Error Delete: $e");
      return false;
    }
  }
}
