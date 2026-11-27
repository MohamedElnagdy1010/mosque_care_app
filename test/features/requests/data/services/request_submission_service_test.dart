import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mosque_care_app/features/requests/data/repositories/request_photo_repository.dart';
import 'package:mosque_care_app/features/requests/data/repositories/request_repository.dart';
import 'package:mosque_care_app/features/requests/data/services/request_submission_service.dart';
import 'package:mosque_care_app/features/requests/domain/entities/request_draft.dart';
import 'package:mosque_care_app/features/requests/domain/entities/requests_page.dart';
import 'package:mosque_care_app/features/requests/domain/entities/request_details.dart';

class FakeRequestPhotoRepository implements RequestPhotoRepository {
  FakeRequestPhotoRepository(this.upload);

  final Future<int> Function(XFile photo) upload;
  final uploadedPhotos = <XFile>[];

  @override
  Future<int> uploadPhoto(XFile photo) {
    uploadedPhotos.add(photo);
    return upload(photo);
  }
}

class FakeRequestRepository implements RequestRepository {
  FakeRequestRepository(this.submit);

  final Future<int> Function(RequestDraft draft) submit;
  final submittedDrafts = <RequestDraft>[];
  @override
  Future<RequestDetails> getRequestDetails(int id) async {
    throw UnimplementedError(
      'getRequestDetails is not used in submission tests.',
    );
  }

  @override
  Future<int> submitRequest(RequestDraft draft) {
    submittedDrafts.add(draft);
    return submit(draft);
  }

  @override
  Future<RequestsPage> getMyRequests({int page = 1, int perPage = 20}) async {
    throw UnimplementedError('getMyRequests is not used in submission tests.');
  }
}

RequestDraft validDraft({List<RequestNeedDraft>? needs}) {
  return RequestDraft(
    supervisorName: 'محمد أحمد',
    supervisorPhone: '0501234567',
    supervisorRole: 'مشرف',
    mosqueId: 1486,
    generalNotes: 'ملاحظات عامة',
    needs:
        needs ??
        const [
          RequestNeedDraft(
            catalogCategory: 'cleaning',
            itemKey: 'mosqueCleaning',
            priority: 'high',
            notes: 'تنظيف المسجد',
          ),
          RequestNeedDraft(
            catalogCategory: 'maintenance_hvac',
            itemKey: 'airConditioning',
            priority: 'medium',
            notes: 'صيانة المكيف',
          ),
        ],
  );
}

void main() {
  group('RequestSubmissionService', () {
    test('يرفع الصور ويربط كل صورة بالاحتياج الصحيح', () async {
      var uploadIndex = 0;

      final photoRepository = FakeRequestPhotoRepository((photo) async {
        final photoIds = [101, 202];
        return photoIds[uploadIndex++];
      });

      final requestRepository = FakeRequestRepository((_) async => 1508);

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      final requestId = await service.submit(
        draft: validDraft(),
        needPhotos: {
          'cleaning::mosqueCleaning': XFile(
            '/tmp/cleaning.jpg',
            name: 'cleaning.jpg',
          ),
          'maintenance_hvac::airConditioning': XFile(
            '/tmp/ac.png',
            name: 'ac.png',
          ),
        },
      );

      expect(requestId, 1508);
      expect(photoRepository.uploadedPhotos.length, 2);
      expect(
        photoRepository.uploadedPhotos.map((photo) => photo.path).toList(),
        ['/tmp/cleaning.jpg', '/tmp/ac.png'],
      );
      final submittedDraft = requestRepository.submittedDrafts.single;

      expect(submittedDraft.needs.map((need) => need.photoId).toList(), [
        101,
        202,
      ]);

      expect(submittedDraft.mosqueId, 1486);
      expect(submittedDraft.supervisorName, 'محمد أحمد');
      expect(submittedDraft.generalNotes, 'ملاحظات عامة');
      expect(service.isSubmitting, isFalse);
    });

    test('يحافظ على معرّفات الصور عند عدم اختيار صور جديدة', () async {
      final photoRepository = FakeRequestPhotoRepository((_) async => 999);

      final requestRepository = FakeRequestRepository((_) async => 1509);

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      final draft = validDraft(
        needs: const [
          RequestNeedDraft(
            catalogCategory: 'cleaning',
            itemKey: 'mosqueCleaning',
            photoId: 77,
          ),
          RequestNeedDraft(
            catalogCategory: 'maintenance_hvac',
            itemKey: 'airConditioning',
          ),
        ],
      );

      await service.submit(draft: draft, needPhotos: {});

      final submittedNeeds = requestRepository.submittedDrafts.single.needs;

      expect(submittedNeeds[0].photoId, 77);
      expect(submittedNeeds[1].photoId, 0);
      expect(photoRepository.uploadedPhotos, isEmpty);
    });

    test('يوقف إرسال الطلب عند فشل رفع الصورة', () async {
      final photoRepository = FakeRequestPhotoRepository(
        (_) async => throw StateError('فشل رفع الصورة'),
      );

      final requestRepository = FakeRequestRepository((_) async => 1508);

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      await expectLater(
        service.submit(
          draft: validDraft(),
          needPhotos: {'cleaning::mosqueCleaning': XFile('/tmp/cleaning.jpg')},
        ),
        throwsA(isA<StateError>()),
      );

      expect(requestRepository.submittedDrafts, isEmpty);
      expect(service.isSubmitting, isFalse);
    });

    test('يعيد ضبط حالة الإرسال عند فشل إرسال الطلب', () async {
      final photoRepository = FakeRequestPhotoRepository((_) async => 101);

      final requestRepository = FakeRequestRepository(
        (_) async => throw StateError('فشل إرسال الطلب'),
      );

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      await expectLater(
        service.submit(draft: validDraft(), needPhotos: {}),
        throwsA(isA<StateError>()),
      );

      expect(service.isSubmitting, isFalse);
    });

    test('يمنع إرسال طلب آخر أثناء تنفيذ الطلب الأول', () async {
      final uploadCompleter = Completer<int>();

      final photoRepository = FakeRequestPhotoRepository(
        (_) => uploadCompleter.future,
      );

      final requestRepository = FakeRequestRepository((_) async => 1510);

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      final firstSubmission = service.submit(
        draft: validDraft(),
        needPhotos: {'cleaning::mosqueCleaning': XFile('/tmp/cleaning.jpg')},
      );

      expect(service.isSubmitting, isTrue);

      await expectLater(
        service.submit(draft: validDraft(), needPhotos: {}),
        throwsA(isA<StateError>()),
      );

      uploadCompleter.complete(101);

      final requestId = await firstSubmission;

      expect(requestId, 1510);
      expect(requestRepository.submittedDrafts.length, 1);
      expect(service.isSubmitting, isFalse);
    });

    test('يرفض الطلب غير الصحيح قبل رفع الصور أو إرساله', () async {
      final photoRepository = FakeRequestPhotoRepository((_) async => 101);

      final requestRepository = FakeRequestRepository((_) async => 1508);

      final service = RequestSubmissionService(
        photoRepository: photoRepository,
        requestRepository: requestRepository,
      );

      await expectLater(
        service.submit(
          draft: validDraft(needs: []),
          needPhotos: {'cleaning::mosqueCleaning': XFile('/tmp/cleaning.jpg')},
        ),
        throwsA(isA<FormatException>()),
      );

      expect(photoRepository.uploadedPhotos, isEmpty);
      expect(requestRepository.submittedDrafts, isEmpty);
      expect(service.isSubmitting, isFalse);
    });
  });
}
