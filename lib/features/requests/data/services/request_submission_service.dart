import 'package:image_picker/image_picker.dart';

import '../../domain/entities/request_draft.dart';
import '../repositories/request_photo_repository.dart';
import '../repositories/request_repository.dart';

class RequestSubmissionService {
  RequestSubmissionService({
    required this.photoRepository,
    required this.requestRepository,
  });

  final RequestPhotoRepository photoRepository;
  final RequestRepository requestRepository;

  bool _isSubmitting = false;

  bool get isSubmitting => _isSubmitting;

  Future<int> submit({
    required RequestDraft draft,
    required Map<String, XFile> needPhotos,
  }) async {
    if (_isSubmitting) {
      throw StateError('جارٍ إرسال الطلب بالفعل.');
    }

    final error = draft.validate();

    if (error != null) {
      throw FormatException(error);
    }

    _isSubmitting = true;

    try {
      final updatedNeeds = <RequestNeedDraft>[];

      for (final need in draft.needs) {
        final photo = needPhotos[need.selectionKey];

        int photoId = need.photoId;

        if (photo != null) {
          photoId = await photoRepository.uploadPhoto(photo);
        }

        updatedNeeds.add(need.copyWith(photoId: photoId));
      }

      final updatedDraft = RequestDraft(
        supervisorName: draft.supervisorName,
        supervisorPhone: draft.supervisorPhone,
        supervisorRole: draft.supervisorRole,
        mosqueId: draft.mosqueId,
        needs: updatedNeeds,
        generalNotes: draft.generalNotes,
      );

      return await requestRepository.submitRequest(updatedDraft);
    } finally {
      _isSubmitting = false;
    }
  }
}
