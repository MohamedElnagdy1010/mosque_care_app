import 'package:flutter/material.dart';

class RequestStatusBadge extends StatelessWidget {
  const RequestStatusBadge({super.key, required this.status});

  final String status;

  String get label => switch (status) {
    'under_review' => 'قيد المراجعة',
    'in_progress' => 'قيد التنفيذ',
    'completed' => 'مكتمل',
    _ => 'حالة غير معروفة',
  };

  Color get color => switch (status) {
    'under_review' => const Color(0xFFB7791F),
    'in_progress' => const Color(0xFF2563EB),
    'completed' => const Color(0xFF27864A),
    _ => Colors.grey,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
