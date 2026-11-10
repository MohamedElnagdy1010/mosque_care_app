import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'api_endpoints.dart';

class ApiClient {
  ApiClient(this._tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          try {
            if (options.extra['requiresAuth'] == true) {
              final token = await _tokenStorage.readToken();

              if (token == null || token.trim().isEmpty) {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    error: 'لا توجد جلسة دخول. سجّل الدخول أولًا.',
                  ),
                );
                return;
              }

              options.headers['Authorization'] = 'Bearer $token';
            }

            handler.next(options);
          } catch (error) {
            handler.reject(DioException(requestOptions: options, error: error));
          }
        },
      ),
    );
  }

  final TokenStorage _tokenStorage;
  late final Dio dio;
}
