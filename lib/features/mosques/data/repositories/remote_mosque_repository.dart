import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/repositories/mosque_repository.dart';
import '../models/mosque_model.dart';
import '../models/mosque_request_model.dart';
import '../models/mosque_visit_model.dart';

class MosqueDirectoryPage {
  const MosqueDirectoryPage({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
  });

  final List<MosqueModel> items;
  final int page;
  final int totalPages;
  final int total;
}

class RemoteMosqueRepository implements MosqueRepository {
  RemoteMosqueRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<MosqueDirectoryPage> getDirectoryPage({
    int page = 1,
    int perPage = 9,
    String search = '',
    String status = 'all',
    String sort = 'newest',
    int? categoryId,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      'status': status,
      'sort': sort,
    };

    if (search.trim().isNotEmpty) {
      params['search'] = search.trim();
    }

    if (categoryId != null && categoryId > 0) {
      params['category_id'] = categoryId;
    }

    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.mosques,
      queryParameters: params,
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;
    if (data == null || data['items'] is! List) {
      throw const FormatException('استجابة دليل المساجد غير صالحة.');
    }

    final rawItems = data['items'] as List;

    final items = rawItems.map((item) {
      if (item is! Map) {
        throw const FormatException('بيانات أحد المساجد غير صالحة.');
      }

      return MosqueModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    int readInt(String key, int fallback) {
      final value = data[key];
      if (value is int) return value;
      return int.tryParse(value?.toString() ?? '') ?? fallback;
    }

    final total = readInt('total', items.length);
    final totalPages = readInt('total_pages', (total / perPage).ceil());

    return MosqueDirectoryPage(
      items: items,
      page: readInt('page', page),
      totalPages: totalPages,
      total: total,
    );
  }

  @override
  Future<List<MosqueModel>> getMosques() async {
    final result = await getDirectoryPage(perPage: 20);
    return result.items;
  }

  @override
  Future<MosqueModel?> getMosqueById(String mosqueId) async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      '${ApiEndpoints.mosques}/$mosqueId',
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException('بيانات المسجد غير متاحة.');
    }

    return MosqueModel.fromJson(data);
  }

  @override
  Future<MosqueVisitModel?> getLastCompletedVisit(String mosqueId) async {
    return null;
  }

  @override
  Future<List<MosqueRequestModel>> getRecentRequests(String mosqueId) async {
    return [];
  }
}
