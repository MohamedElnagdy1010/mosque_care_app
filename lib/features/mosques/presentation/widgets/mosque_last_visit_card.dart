import 'package:flutter/material.dart';

class MosqueLastVisitCard extends StatelessWidget {
  const MosqueLastVisitCard({
    super.key,
    this.visitDate,
    this.serviceType,
    this.visitStatus,
  });

  final String? visitDate;
  final String? serviceType;
  final String? visitStatus;

  @override
  Widget build(BuildContext context) {
    final hasVisit = visitDate != null && visitDate!.isNotEmpty;

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
          const Row(
            children: [
              Icon(Icons.calendar_month_outlined, color: Color(0xFF8A5A2B)),
              SizedBox(width: 8),
              Text(
                'آخر زيارة للمسجد',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
            ],
          ),
          const Divider(height: 28),

          if (!hasVisit)
            const Text(
              'لا توجد زيارات مسجلة حتى الآن',
              style: TextStyle(color: Color(0xFF9B8B7A), fontSize: 14),
            )
          else ...[
            Row(
              children: [
                Expanded(
                  child: _VisitInfo(label: 'تاريخ الزيارة', value: visitDate!),
                ),
                Expanded(
                  child: _VisitInfo(
                    label: 'نوع الخدمة',
                    value: serviceType ?? 'غير محدد',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _VisitInfo(label: 'حالة الزيارة', value: visitStatus ?? 'غير محدد'),
          ],
        ],
      ),
    );
  }
}

class _VisitInfo extends StatelessWidget {
  const _VisitInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF9B8B7A)),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A2A16),
          ),
        ),
      ],
    );
  }
}
