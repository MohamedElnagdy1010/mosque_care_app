import '../../data/models/mosque_model.dart';
import '../../data/models/mosque_request_model.dart';
import '../../domain/repositories/mosque_repository.dart';
import '../models/mosque_visit_model.dart';

class LocalMosqueRepository implements MosqueRepository {
  final List<MosqueModel> _mosques = const [
    MosqueModel(
      id: 'mosque_001',
      name: 'جامع حسان بن ثابت',
      neighborhood: 'طويق',
    ),
    MosqueModel(
      id: 'mosque_002',
      name: 'مسجد أبو عبيدة',
      neighborhood: 'العليا',
    ),
    MosqueModel(id: 'mosque_003', name: 'جامع الطريف', neighborhood: 'الأندلس'),
    MosqueModel(
      id: 'mosque_004',
      name: 'مسجد ابن طالب',
      neighborhood: 'غرناطة',
    ),
  ];

  @override
  Future<List<MosqueModel>> getMosques() async {
    return List.unmodifiable(_mosques);
  }

  @override
  Future<MosqueModel?> getMosqueById(String mosqueId) async {
    for (final mosque in _mosques) {
      if (mosque.id == mosqueId) {
        return mosque;
      }
    }
    return null;
  }

  @override
  Future<MosqueVisitModel?> getLastCompletedVisit(String mosqueId) async {
    return null;
  }

  @override
  Future<List<MosqueRequestModel>> getRecentRequests(String mosqueId) async {
    return [];
  }
}
