import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/request_draft.dart';

class RequestRepository {
  const RequestRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<int> submitRequest(RequestDraft draft) async {
    final validationError = draft.validate();

    if (validationError != null) {
      throw FormatException(validationError);
    }

    final response = await _apiClient.dio.post(
      ApiEndpoints.requests,
      data: draft.toApiJson(),
      options: Options(
        contentType: Headers.jsonContentType,
        extra: {'requiresAuth': true},
      ),
    );

    if (response.statusCode != 201) {
      throw StateError('لم يؤكد السيرفر إنشاء الطلب.');
    }

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('استجابة إنشاء الطلب غير صالحة.');
    }

    final rawId = data['id'];

    final requestId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '');

    if (requestId == null || requestId <= 0) {
      throw const FormatException('لم يرجع السيرفر رقم طلب صالحًا.');
    }

    return requestId;
  }
}
