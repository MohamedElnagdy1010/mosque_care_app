import 'package:flutter/material.dart';

import '../../data/catalog/need_categories.dart';
import '../../data/mock/mock_mosque_needs.dart';
import '../../domain/services/need_statistics.dart';
import '../models/user_role.dart';
import '../../domain/services/needs_by_mosque.dart';
import '../widgets/mosque_need_card.dart';
import '../../domain/entities/mosque_need.dart';
import '../widgets/active_needs_summary.dart';

class NeedDetailsScreen extends StatelessWidget {
  const NeedDetailsScreen({
    super.key,
    required this.title,
    required this.items,
    this.categoryId,
    required this.role,
    this.assignedMosqueId,
  });

  final String title;
  final List<String> items;
  final String? categoryId;
  final UserRole role;
  final String? assignedMosqueId;

  int _countMosquesForCategory() {
    final id = categoryId;
    if (id == null) return 0;

    return NeedStatistics.countMosquesByCategory(MockMosqueNeeds.all, id);
  }

  @override
  Widget build(BuildContext context) {
    final isImamWithoutMosque =
        role == UserRole.imam &&
        (assignedMosqueId == null || assignedMosqueId!.isEmpty);

    final category = NeedCategories.all.where(
      (category) => category.id == categoryId,
    );

    final itemNames = category.isEmpty
        ? <String, String>{}
        : {for (final item in category.first.items) item.id: item.name};

    final groupedNeeds = categoryId == null
        ? <String, List<MosqueNeed>>{}
        : NeedsByMosque.group(MockMosqueNeeds.all, categoryId!);

    final activeItemIds = groupedNeeds.values
        .expand((needs) => needs)
        .map((need) => need.itemId)
        .toSet()
        .toList();
    final itemCounts = <String, int>{
      for (final itemId in activeItemIds)
        itemNames[itemId] ?? itemId: NeedStatistics.countMosquesByItem(
          MockMosqueNeeds.all,
          categoryId!,
          itemId,
        ),
    };

    final mosqueIds = groupedNeeds.keys.toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
      ),
      bottomNavigationBar: isImamWithoutMosque || categoryId == null
          ? null
          : ActiveNeedsSummary(itemCounts: itemCounts),
      body: isImamWithoutMosque
          ? const Center(
              child: Text(
                'لم يتم ربط حسابك بمسجد بعد',
                textAlign: TextAlign.center,
              ),
            )
          : items.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'لا توجد بيانات احتياجات متاحة حاليًا',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Color(0xFF4A2A16)),
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: mosqueIds.length + 1,
              itemBuilder: (context, index) {
                // أول عنصر: إجمالي المساجد.
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Card(
                      color: const Color(0xFF8A5A2B),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'إجمالي المساجد المحتاجة',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${_countMosquesForCategory()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                // بطاقات المساجد.
                if (index <= mosqueIds.length) {
                  final mosqueId = mosqueIds[index - 1];
                  final mosqueNeeds = groupedNeeds[mosqueId]!;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MosqueNeedCard(
                      mosqueName: 'مسجد تجريبي ${mosqueId.split('_').last}',
                      needs: mosqueNeeds,
                      itemNames: itemNames,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
    );
  }
}
