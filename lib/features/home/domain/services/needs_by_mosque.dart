import '../entities/mosque_need.dart';
import 'need_statistics.dart';

class NeedsByMosque {
  const NeedsByMosque._();

  static Map<String, List<MosqueNeed>> group(
    List<MosqueNeed> needs,
    String categoryId,
  ) {
    final result = <String, List<MosqueNeed>>{};

    for (final need in needs) {
      if (need.categoryId != categoryId ||
          !NeedStatistics.activeStatuses.contains(need.status)) {
        continue;
      }

      result.putIfAbsent(need.mosqueId, () => <MosqueNeed>[]).add(need);
    }

    return result;
  }
}
