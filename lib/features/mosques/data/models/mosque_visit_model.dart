import '../../domain/entities/mosque_visit.dart';

class MosqueVisitModel extends MosqueVisit {
  const MosqueVisitModel({
    required super.id,
    required super.mosqueId,
    required super.visitDate,
    required super.serviceType,
    required super.status,
  });
}
