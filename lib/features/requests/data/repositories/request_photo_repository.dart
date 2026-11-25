import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class RequestPhotoRepository {
  const RequestPhotoRepository(this._apiClient);

  final ApiClient _apiClient;

  static const int _maxFileSize = 5 * 1024 * 1024;

  Future<int> uploadPhoto(XFile photo) async {
    final filename = photo.name;

    final extension = filename.split('.').last.toLowerCase();

    const allowedExtensions = {'jpg', 'jpeg', 'png', 'webp'};

    if (!allowedExtensions.contains(extension)) {
      throw const FormatException(
        'نوع الصورة غير مدعوم. اختر JPEG أو PNG أو WebP.',
      );
    }

    final fileSize = await photo.length();

    if (fileSize <= 0 || fileSize > _maxFileSize) {
      throw const FormatException(
        'يجب ألا يتجاوز حجم الصورة 5 MB وألا تكون فارغة.',
      );
    }

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(photo.path, filename: filename),
    });

    final response = await _apiClient.dio.post(
      ApiEndpoints.photos,
      data: formData,
      options: Options(extra: {'requiresAuth': true}),
    );

    if (response.statusCode != 201) {
      throw StateError('لم يكتمل رفع الصورة.');
    }

    final data = response.data;

    if (data is! Map) {
      throw const FormatException('استجابة رفع الصورة غير صالحة.');
    }

    final rawId = data['id'];

    final photoId = rawId is int
        ? rawId
        : int.tryParse(rawId?.toString() ?? '');

    if (photoId == null || photoId <= 0) {
      throw const FormatException('لم يرجع السيرفر معرّف صورة صالحًا.');
    }

    return photoId;
  }
}
