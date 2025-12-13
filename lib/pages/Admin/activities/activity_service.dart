// lib/services/admin/activity_service.dart
import 'dart:convert';
import 'package:volunite/services/core/api_client.dart';
import 'package:volunite/pages/Admin/data/admin_models.dart';
import 'package:flutter/foundation.dart';

class ActivityService {
    static Future<List<Activity>> fetchAll({
    int page = 1,
    int perPage = 50,
    String? status,
    bool includeUser = true,
  }) async {
    final q = <String, dynamic>{
      'page': page.toString(),
      'per_page': perPage.toString(),
    };
    if (status != null) q['status'] = status;
    if (includeUser) q['include'] = 'user';

    final uri =
        '/kegiatan?' +
        q.entries
            .map((e) => '${e.key}=${Uri.encodeQueryComponent(e.value)}')
            .join('&');
    final res = await ApiClient.get(uri);

    // Debug: print body supaya kita tahu apa yang diterima
    if (kDebugMode) {
      debugPrint('DEBUG ActivityService GET $uri => ${res.statusCode}');
      debugPrint('DEBUG body: ${res.body}');
    }

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final listJson = (body['data'] as List);
      return listJson
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal memuat kegiatan (${res.statusCode})');
    }
  }

  static Future<Activity> fetchById(int id) async {
    final res = await ApiClient.get('/admin/kegiatan/$id');
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final json = body['data'];
      return Activity.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Gagal memuat kegiatan ($id) - ${res.statusCode}');
    }
  }

  /// Hanya update status
  static Future<Activity> updateStatus(int id, String status) async {
    final res = await ApiClient.put(
      '/admin/kegiatan/$id/status',
      body: {'status': status},
    );
    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final json = body['data'];
      return Activity.fromJson(json as Map<String, dynamic>);
    } else {
      final msg = res.body.isNotEmpty ? res.body : '(${res.statusCode})';
      throw Exception('Gagal update status $msg');
    }
  }
}
