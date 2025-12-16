import 'dart:convert';
import 'package:volunite/models/notifikasi_model.dart';
import 'package:volunite/services/core/api_client.dart';

class NotifikasiService {
  
  static Future<List<NotifikasiModel>> fetchNotifikasi() async {
    final response = await ApiClient.get('/notifikasi');
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      
      return data.map((e) => NotifikasiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat notifikasi: ${response.statusCode}');
    }
  }
  static Future<void> markAsRead(int id) async {
    await ApiClient.post('/notifikasi/$id/read');
  }

  static Future<int> countUnread() async {
  final response = await ApiClient.get('/notifikasi');

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final List data = body['data'];

    final notifications =
        data.map((e) => NotifikasiModel.fromJson(e)).toList();

    final unreadCount =
        notifications.where((n) => !n.isRead).length;

    return unreadCount;
  } else {
    throw Exception('Gagal menghitung notifikasi belum dibaca');
  }
}
}