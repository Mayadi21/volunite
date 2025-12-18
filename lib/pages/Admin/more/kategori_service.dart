import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';

class KategoriService {
  Future<List<Kategori>> fetchKategori() async {
    final response = await ApiClient.get('/admin/kategori', auth: true);
    final jsonBody = jsonDecode(response.body);

    return (jsonBody['data'] as List).map((e) => Kategori.fromJson(e)).toList();
  }

  Future<void> createKategori({
    required String nama,
    String? deskripsi,
    XFile? thumbnail,
  }) async {
    await ApiClient.postMultipart(
      '/admin/kategori',
      fields: {'nama_kategori': nama, 'deskripsi': deskripsi ?? ''},
      file: thumbnail,
      fileKey: 'thumbnail',
    );
  }

  Future<void> updateKategori({
    required int id,
    required String nama,
    String? deskripsi,
    XFile? thumbnail,
  }) async {
    await ApiClient.postMultipart(
      '/admin/kategori/$id?_method=PUT',
      fields: {'nama_kategori': nama, 'deskripsi': deskripsi ?? ''},
      file: thumbnail,
      fileKey: 'thumbnail',
    );
  }

  Future<void> deleteKategori(int id) async {
    await ApiClient.delete('/admin/kategori/$id', auth: true);
  }

  Future<List<KategoriSimple>> getAllSimple() async {
    final response = await ApiClient.get('/admin/kategori/simple');

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => KategoriSimple.fromJson(e)).toList();
    }
    return [];
  }
}
