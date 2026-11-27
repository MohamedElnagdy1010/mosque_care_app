import 'package:flutter/material.dart';

import '../../domain/entities/inventory_draft.dart';
import '../cubit/inventory_cubit.dart';
import '../widgets/inventory_photo_grid.dart';

class InventoryReviewScreen extends StatelessWidget {
  const InventoryReviewScreen({
    super.key,
    required this.draft,
    required this.mosqueName,
    required this.entries,
  });

  final InventoryDraft draft;
  final String mosqueName;
  final List<InventoryEntry> entries;

  static const _brown = Color(0xFF4A2A16);
  static const _background = Color(0xFFFFF4E2);

  int get totalPhotos =>
      entries.fold<int>(0, (sum, entry) => sum + entry.photos.length);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('مراجعة التوثيق'),
        centerTitle: true,
        backgroundColor: _background,
        foregroundColor: _brown,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('بيانات المسجد والمشرف', [
            Text('المسجد: $mosqueName'),
            Text('المشرف: ${draft.supervisorName}'),
            Text('الجوال: ${draft.supervisorPhone}'),
            Text('الصفة: ${draft.supervisorRole}'),
          ]),
          const SizedBox(height: 14),
          _section('ملخص الموجودات', [
            Row(
              children: [
                _stat('الإجمالي', draft.totalQuantity, _brown),
                _stat('السليم', draft.healthyQuantity, const Color(0xFF27864A)),
                _stat('التالف', draft.damagedQuantity, Colors.red),
              ],
            ),
            const Divider(),
            Text('عدد العناصر: ${draft.items.length}'),
            Text('إجمالي الصور: $totalPhotos'),
          ]),
          const SizedBox(height: 14),
          for (final entry in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _section(entry.item.title, [
                Text(
                  'القسم: ${entry.item.categoryName}',
                  style: const TextStyle(
                    color: Color(0xFF8A7868),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Divider(),
                Text('الإجمالي: ${entry.item.qtyTotal}'),
                Text('السليم: ${entry.item.qtyHealthy}'),
                Text('التالف: ${entry.item.qtyDamaged}'),
                if (entry.item.notes.trim().isNotEmpty)
                  Text('الملاحظات: ${entry.item.notes}'),
                if (entry.photos.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'صور التوثيق (${entry.photos.length})',
                    style: const TextStyle(
                      color: _brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InventoryPhotoGrid(photos: entry.photos),
                ],
              ]),
            ),
          if (draft.generalNotes.trim().isNotEmpty)
            _section('الملاحظات العامة', [Text(draft.generalNotes)]),
          const SizedBox(height: 16),
          const Text(
            'التوثيق لم يُرسل بعد. '
            'لم يتم ربط خدمة الإرسال المستقل حتى الآن.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF8A7868)),
          ),
          const SizedBox(height: 12),
          const ElevatedButton(onPressed: null, child: Text('إرسال التوثيق')),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('العودة للتعديل'),
          ),
        ],
      ),
    );
  }

  Widget _stat(String title, int value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
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
          Text(
            title,
            style: const TextStyle(
              color: _brown,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          for (final child in children)
            Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
        ],
      ),
    );
  }
}
