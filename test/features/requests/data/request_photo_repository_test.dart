import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosque_care_app/core/network/api_client.dart';
import 'package:mosque_care_app/core/storage/token_storage.dart';
import 'package:mosque_care_app/features/requests/data/repositories/request_photo_repository.dart';

class FakeTokenStorage extends TokenStorage {
  FakeTokenStorage(this.token);

  final String? token;

  @override
  Future<String?> readToken() async => token;
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('photo_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<XFile> createPhoto(String name, {int size = 100}) async {
    final file = File('${tempDir.path}${Platform.pathSeparator}$name');

    await file.writeAsBytes(List<int>.filled(size, 1));

    return XFile(file.path);
  }

  test('يرفع صورة صحيحة ويعيد رقم الصورة', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));

    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, 'khadim/v1/photos');
          expect(options.headers['Authorization'], 'Bearer test-token');

          final formData = options.data as FormData;

          expect(formData.files.length, 1);
          expect(formData.files.first.key, 'photo');

          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: {'id': 123},
            ),
          );
        },
      ),
    );

    final repository = RequestPhotoRepository(client);
    final photo = await createPhoto('problem.jpg');

    final photoId = await repository.uploadPhoto(photo);

    expect(photoId, 123);
  });

  test('يرفض امتداد صورة غير مدعوم', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));
    final repository = RequestPhotoRepository(client);

    final photo = await createPhoto('problem.txt');

    await expectLater(
      repository.uploadPhoto(photo),
      throwsA(isA<FormatException>()),
    );
  });

  test('يرفض صورة أكبر من 5 MB', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));
    final repository = RequestPhotoRepository(client);

    final photo = await createPhoto('large.png', size: 5 * 1024 * 1024 + 1);

    await expectLater(
      repository.uploadPhoto(photo),
      throwsA(isA<FormatException>()),
    );
  });

  test('يرفض استجابة لا تحتوي على رقم صورة صالح', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));

    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(requestOptions: options, statusCode: 201, data: {'id': 0}),
          );
        },
      ),
    );

    final repository = RequestPhotoRepository(client);
    final photo = await createPhoto('problem.webp');

    await expectLater(
      repository.uploadPhoto(photo),
      throwsA(isA<FormatException>()),
    );
  });

  test('يمنع رفع الصورة بدون تسجيل دخول', () async {
    final client = ApiClient(FakeTokenStorage(null));
    final repository = RequestPhotoRepository(client);

    final photo = await createPhoto('problem.jpg');

    await expectLater(
      repository.uploadPhoto(photo),
      throwsA(isA<DioException>()),
    );
  });
}
