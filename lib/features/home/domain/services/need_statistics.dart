import '../entities/mosque_need.dart';

class NeedStatistics {
  const NeedStatistics._();

  static const activeStatuses = {
    'new',
    'under_review',
    'approved',
    'in_progress',
  };

  static int countMosquesByCategory(List<MosqueNeed> needs, String categoryId) {
    return needs
        .where(
          (need) =>
              need.categoryId == categoryId &&
              activeStatuses.contains(need.status),
        )
        .map((need) => need.mosqueId)
        .toSet()
        .length;
  }

  static int countMosquesByItem(
    List<MosqueNeed> needs,
    String categoryId,
    String itemId,
  ) {
    return needs
        .where(
          (need) =>
              need.categoryId == categoryId &&
              need.itemId == itemId &&
              activeStatuses.contains(need.status),
        )
        .map((need) => need.mosqueId)
        .toSet()
        .length;
  }
}
