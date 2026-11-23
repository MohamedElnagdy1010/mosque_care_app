import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../models/service_catalog_model.dart';

class ServiceCatalogRepository {
  const ServiceCatalogRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ServiceCatalogModel> getCatalog() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      'khadim/v1/catalog',
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException('تعذر قراءة أقسام الخدمات من السيرفر.');
    }

    return ServiceCatalogModel.fromJson(data);
  }
}
