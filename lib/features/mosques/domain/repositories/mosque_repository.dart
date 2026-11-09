import '../entities/mosque.dart';

import '../entities/mosque_request.dart';
import '../entities/mosque_visit.dart';

abstract class MosqueRepository {
  Future<List<Mosque>> getMosques();

  Future<Mosque?> getMosqueById(String mosqueId);

  Future<MosqueVisit?> getLastCompletedVisit(String mosqueId);
  Future<List<MosqueRequest>> getRecentRequests(String mosqueId);
}
