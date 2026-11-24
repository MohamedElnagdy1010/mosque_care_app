import 'package:flutter/material.dart';

import '../../domain/entities/request_draft.dart';
import '../../data/models/service_catalog_model.dart';

class RequestReviewScreen extends StatelessWidget {
  const RequestReviewScreen({
    super.key,
    required this.draft,
    required this.mosqueName,
    required this.mosqueNeighborhood,
    required this.categories,
  });

  final RequestDraft draft;
  final String mosqueName;
  final String mosqueNeighborhood;
  final List<ServiceCatalogCategory> categories;
  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: const Text('مراجعة طلب الخدمة'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
        foregroundColor: _brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'راجع بيانات الطلب قبل الإرسال',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: _brown,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك الرجوع لتعديل البيانات أو الاحتياجات.',
            style: TextStyle(color: _brown),
          ),
          const SizedBox(height: 20),
          _sectionCard(
            title: 'بيانات مقدم الطلب',
            icon: Icons.person_outline,
            children: [
              _detailRow('الاسم', draft.supervisorName),
              _detailRow('رقم الجوال', draft.supervisorPhone),
              _detailRow('الصفة', draft.supervisorRole),
            ],
          ),
          const SizedBox(height: 14),
          _sectionCard(
            title: 'بيانات المسجد',
            icon: Icons.mosque_outlined,
            children: [
              _detailRow('اسم المسجد', mosqueName),
              _detailRow('الحي', mosqueNeighborhood),
            ],
          ),

          const SizedBox(height: 14),

          ...categories.map((category) {
            final needs = draft.needs
                .where((need) => need.catalogCategory == category.key)
                .toList();

            if (needs.isEmpty) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _sectionCard(
                title: category.name,
                icon: Icons.checklist_rounded,
                children: needs.map((need) {
                  final matchingItems = category.items.where(
                    (item) => item.key == need.itemKey,
                  );

                  final itemName = matchingItems.isNotEmpty
                      ? matchingItems.first.name
                      : need.itemKey;

                  final priorityLabel = switch (need.priority) {
                    'high' => 'عالية',
                    'low' => 'منخفضة',
                    _ => 'متوسطة',
                  };

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _detailRow('الاحتياج', itemName),
                      _detailRow('الأولوية', priorityLabel),
                      if (need.notes.trim().isNotEmpty)
                        _detailRow('الملاحظات', need.notes),
                      const Divider(height: 20),
                    ],
                  );
                }).toList(),
              ),
            );
          }),

          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('الرجوع لتعديل الطلب'),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _gold),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A7868)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _brown,
            ),
          ),
        ],
      ),
    );
  }
}
