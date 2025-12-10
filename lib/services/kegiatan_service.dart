import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:volunite/models/kegiatan_model.dart';
import 'package:volunite/services/core/api_client.dart';

class KegiatanService {
  // 1. GET PUBLIC (Volunteer)
  static Future<List<Kegiatan>> fetchKegiatan() async {
    final response = await ApiClient.get('/kegiatan');

    if (response.statusCode == 200) {
      // PERUBAHAN: Langsung terima sebagai List, bukan Map
      final List<dynamic> jsonList = jsonDecode(response.body);

      // Langsung mapping, tidak perlu jsonResponse['data']
      return jsonList.map((e) => Kegiatan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal fetch: ${response.statusCode}');
    }
  }

  // 2. CREATE (Organizer)
  static Future<bool> createKegiatan({
    required String judul,
    required String deskripsi,
    required String lokasi,
    required String syaratKetentuan,
    required String kuota,
    required String tanggalMulai,
    required String tanggalBerakhir,
    required List<int> kategoriIds,
    required XFile? imageFile,
  }) async {
    Map<String, String> fields = {
      'judul': judul,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'syarat_ketentuan': syaratKetentuan,
      'kuota': kuota,
      'tanggal_mulai': tanggalMulai,
      'tanggal_berakhir': tanggalBerakhir,
    };

    for (int i = 0; i < kategoriIds.length; i++) {
      fields['kategori_ids[$i]'] = kategoriIds[i].toString();
    }

    final response = await ApiClient.postMultipart(
      '/organizer/kegiatan',
      fields: fields,
      file: imageFile,
      fileKey: 'thumbnail',
    );

    return response.statusCode == 201;
  }

  // 3. GET LIST MILIK ORGANIZER (Read Dashboard)
  static Future<List<Kegiatan>> fetchOrganizerKegiatan() async {
    final response = await ApiClient.get('/organizer/kegiatan');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> jsonList = jsonResponse['data'];

      return jsonList
          .map((e) => Kegiatan.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal ambil data organizer: ${response.statusCode}');
    }
  }

  // 4. UPDATE KEGIATAN
  static Future<bool> updateKegiatan({
    required int id,
    required String judul,
    required String deskripsi,
    required String lokasi,
    required String syaratKetentuan,
    required String kuota,
    required String tanggalMulai,
    required String tanggalBerakhir,
    required List<int> kategoriIds,
    XFile? imageFile,
  }) async {
    Map<String, String> fields = {
      '_method': 'PUT',
      'judul': judul,
      'deskripsi': deskripsi,
      'lokasi': lokasi,
      'syarat_ketentuan': syaratKetentuan,
      'kuota': kuota,
      'tanggal_mulai': tanggalMulai,
      'tanggal_berakhir': tanggalBerakhir,
    };

    for (int i = 0; i < kategoriIds.length; i++) {
      fields['kategori_ids[$i]'] = kategoriIds[i].toString();
    }

    final response = await ApiClient.postMultipart(
      '/organizer/kegiatan/$id',
      fields: fields,
      file: imageFile,
      fileKey: 'thumbnail',
    );

    return response.statusCode == 200;
  }

  // 5. DELETE KEGIATAN (Hard Delete - Data Hilang)
  static Future<bool> deleteKegiatan(int id) async {
    final response = await ApiClient.delete('/organizer/kegiatan/$id');
    return response.statusCode == 200;
  }

  // 6. CANCEL KEGIATAN (Soft Delete - Status berubah jadi cancelled)
  static Future<bool> cancelKegiatan(int id) async {
    // Kita kirim partial update status via POST dengan _method: PUT
    final response = await ApiClient.postMultipart(
      '/organizer/kegiatan/$id',
      fields: {'_method': 'PUT', 'status': 'cancelled'},
    );
    return response.statusCode == 200;
  }
}
