import 'package:dio/dio.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/entities/request_draft.dart';

import '../../domain/entities/requests_page.dart';
import '../models/requests_page_model.dart';
import '../../domain/entities/request_details.dart';
import '../models/request_details_model.dart';

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

  Future<RequestsPage> getMyRequests({int page = 1, int perPage = 20}) async {
    if (page < 1 || perPage < 1) {
      throw ArgumentError('Invalid pagination parameters.');
    }

    final response = await _apiClient.dio.get(
      ApiEndpoints.requests,
      queryParameters: {'page': page, 'per_page': perPage},
      options: Options(extra: {'requiresAuth': true}),
    );

    if (response.statusCode != 200) {
      throw StateError('تعذر استرجاع الطلبات.');
    }

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('استجابة قائمة الطلبات غير صالحة.');
    }

    final result = RequestsPageModel.fromJson(data);

    if (result.page != page) {
      throw const FormatException('رقم الصفحة المسترجعة غير مطابق.');
    }

    return result;
  }

  Future<RequestDetails> getRequestDetails(int id) async {
    if (id <= 0) {
      throw ArgumentError('Invalid request ID.');
    }

    final response = await _apiClient.dio.get(
      '${ApiEndpoints.requests}/$id',
      options: Options(extra: {'requiresAuth': true}),
    );

    if (response.statusCode != 200) {
      throw StateError('تعذر استرجاع تفاصيل الطلب.');
    }

    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('استجابة تفاصيل الطلب غير صالحة.');
    }

    final result = RequestDetailsModel.fromJson(data);

    if (result.id != id) {
      throw const FormatException('رقم الطلب المسترجع غير مطابق.');
    }

    return result;
  }
}
