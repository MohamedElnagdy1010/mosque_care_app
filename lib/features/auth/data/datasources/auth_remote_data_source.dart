import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._apiClient);

  final ApiClient _apiClient;

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiClient.dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {'username': username.trim(), 'password': password},
      options: Options(
        contentType: Headers.jsonContentType,
        extra: {'requiresAuth': false},
      ),
    );

    final data = response.data;

    if (data == null) {
      throw const FormatException('رد تسجيل الدخول فارغ.');
    }

    return LoginResponseModel.fromJson(data);
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _apiClient.dio.get<Map<String, dynamic>>(
      ApiEndpoints.profile,
      options: Options(extra: {'requiresAuth': true}),
    );

    final data = response.data;

    if (data == null || data.isEmpty) {
      throw const FormatException('تعذر قراءة بيانات المستخدم.');
    }

    return data;
  }

  Future<void> logout() async {
    await _apiClient.dio.post<void>(
      ApiEndpoints.logout,
      options: Options(extra: {'requiresAuth': true}),
    );
  }
}
