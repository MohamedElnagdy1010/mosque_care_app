import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';

class MosqueNeedsPage {
  const MosqueNeedsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  final List<Map<String, dynamic>> items;
  final int total;
  final int page;
  final int totalPages;
}

class MosqueNeedsRepository {
  const MosqueNeedsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<MosqueNeedsPage> getNeeds({
    required String mosqueId,
    int page = 1,
    int perPage = 9,
  }) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      'khadim/v1/needs',
      queryParameters: {
        'mosque_id': mosqueId,
        'page': page,
        'per_page': perPage,
      },
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;

    if (data == null || data['items'] is! List) {
      throw const FormatException('استجابة احتياجات المسجد غير صالحة.');
    }

    final items = (data['items'] as List).map((item) {
      if (item is! Map) {
        throw const FormatException('بيانات أحد الاحتياجات غير صالحة.');
      }

      return Map<String, dynamic>.from(item);
    }).toList();

    int parseInt(String key, int fallback) {
      final value = data[key];

      if (value is int) return value;

      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    return MosqueNeedsPage(
      items: items,
      total: parseInt('total', items.length),
      page: parseInt('page', page),
      totalPages: parseInt('total_pages', 0),
    );
  }
}
