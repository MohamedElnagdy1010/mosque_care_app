import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/home_statistics_model.dart';

class HomeStatisticsRepository {
  const HomeStatisticsRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<HomeStatisticsModel> getStatistics() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.statistics,
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException('رد الإحصائيات فارغ.');
    }

    return HomeStatisticsModel.fromJson(data);
  }
}
