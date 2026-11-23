import 'package:flutter/material.dart';

import '../../domain/entities/request_draft.dart';

class RequestNeedDetailsCard extends StatelessWidget {
  const RequestNeedDetailsCard({
    super.key,
    required this.title,
    required this.need,
    required this.onChanged,
  });

  final String title;
  final RequestNeedDraft need;
  final ValueChanged<RequestNeedDraft> onChanged;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _brown,
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: need.priority,
            decoration: InputDecoration(
              labelText: 'الأولوية',
              prefixIcon: const Icon(Icons.flag_outlined, color: _gold),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'low', child: Text('منخفضة')),
              DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
              DropdownMenuItem(value: 'high', child: Text('عالية')),
            ],
            onChanged: (value) {
              if (value == null) return;
              onChanged(need.copyWith(priority: value));
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: need.notes,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: need.itemKey == 'other'
                  ? 'وصف الاحتياج (مطلوب)'
                  : 'ملاحظات الاحتياج (اختياري)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              onChanged(need.copyWith(notes: value));
            },
          ),
        ],
      ),
    );
  }
}
