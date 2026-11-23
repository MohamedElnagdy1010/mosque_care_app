import 'package:flutter/material.dart';

class MosqueServiceStatusCard extends StatelessWidget {
  const MosqueServiceStatusCard({
    super.key,
    required this.serviceStatus,
    required this.openNeedsCount,
  });

  final String? serviceStatus;
  final int? openNeedsCount;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  String get _statusText {
    switch (serviceStatus) {
      case 'under_review':
        return 'قيد المراجعة';
      case 'in_progress':
        return 'قيد التنفيذ';
      case 'completed':
        return 'مكتملة';
      case 'none':
        return 'غير محددة';
      default:
        return 'غير متاحة';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.handyman_outlined, color: _gold),
              SizedBox(width: 10),
              Text(
                'حالة المسجد واحتياجاته',
                style: TextStyle(
                  color: _brown,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: _info(
                  Icons.fact_check_outlined,
                  'حالة الخدمة',
                  _statusText,
                ),
              ),
              Container(height: 65, width: 1, color: const Color(0xFFE8D9C3)),
              Expanded(
                child: _info(
                  Icons.build_circle_outlined,
                  'الاحتياجات المفتوحة',
                  openNeedsCount?.toString() ?? 'غير متاح',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, color: _gold, size: 26),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9B8B7A)),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _brown,
          ),
        ),
      ],
    );
  }
}
