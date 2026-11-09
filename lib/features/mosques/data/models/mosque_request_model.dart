import '../../domain/entities/mosque_request.dart';

class MosqueRequestModel extends MosqueRequest {
  const MosqueRequestModel({
    required super.id,
    required super.mosqueId,
    required super.title,
    required super.source,
    required super.status,
    required super.createdAt,
  });
}
