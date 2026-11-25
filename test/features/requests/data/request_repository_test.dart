import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_care_app/core/network/api_client.dart';
import 'package:mosque_care_app/core/storage/token_storage.dart';
import 'package:mosque_care_app/features/requests/data/repositories/request_repository.dart';
import 'package:mosque_care_app/features/requests/domain/entities/request_draft.dart';

class FakeTokenStorage extends TokenStorage {
  FakeTokenStorage(this.token);

  final String? token;

  @override
  Future<String?> readToken() async => token;
}

void main() {
  RequestDraft validDraft() {
    return const RequestDraft(
      supervisorName: 'محمد أحمد',
      supervisorPhone: '0501234567',
      supervisorRole: 'مشرف',
      mosqueId: 1486,
      needs: [
        RequestNeedDraft(
          catalogCategory: 'cleaning',
          itemKey: 'mosqueCleaning',
          priority: 'medium',
          notes: 'تنظيف المسجد',
        ),
      ],
    );
  }

  test('يرسل طلبًا صحيحًا ويعيد رقم الطلب', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));

    client.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          expect(options.path, 'khadim/v1/requests');
          expect(options.headers['Authorization'], 'Bearer test-token');

          final body = options.data as Map<String, dynamic>;

          expect(body['supervisor_name'], 'محمد أحمد');
          expect(body['mosque_id'], 1486);
          expect((body['needs'] as List).length, 1);
          expect(body['inventory'], isEmpty);

          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 201,
              data: {'id': 1508},
            ),
          );
        },
      ),
    );

    final repository = RequestRepository(client);

    final requestId = await repository.submitRequest(validDraft());

    expect(requestId, 1508);
  });

  test('يرفض طلبًا بدون احتياجات', () async {
    final client = ApiClient(FakeTokenStorage('test-token'));
    final repository = RequestRepository(client);

    const draft = RequestDraft(
      supervisorName: 'محمد أحمد',
      supervisorPhone: '0501234567',
      supervisorRole: 'مشرف',
      mosqueId: 1486,
      needs: [],
    );

    await expectLater(
      repository.submitRequest(draft),
      throwsA(isA<FormatException>()),
    );
  });

  test('يرفض استجابة لا تحتوي على رقم طلب صالح', () async {
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

    final repository = RequestRepository(client);

    await expectLater(
      repository.submitRequest(validDraft()),
      throwsA(isA<FormatException>()),
    );
  });

  test('يمنع إرسال الطلب بدون تسجيل دخول', () async {
    final client = ApiClient(FakeTokenStorage(null));
    final repository = RequestRepository(client);

    await expectLater(
      repository.submitRequest(validDraft()),
      throwsA(isA<DioException>()),
    );
  });
}
