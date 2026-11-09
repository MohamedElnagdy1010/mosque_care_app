import 'package:flutter/material.dart';

class MosqueInfoCard extends StatelessWidget {
  const MosqueInfoCard({
    super.key,
    required this.imamName,
    required this.muezzinName,
    required this.registrationSource,
    required this.mosqueType,
  });

  final String imamName;
  final String muezzinName;
  final String registrationSource;
  final String mosqueType;

  @override
  Widget build(BuildContext context) {
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
              Icon(Icons.people_outline, color: Color(0xFF8A5A2B)),
              SizedBox(width: 8),
              Text(
                'بيانات المسجد',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
            ],
          ),
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: _InfoItem(label: 'الإمام', value: imamName),
              ),
              Expanded(
                child: _InfoItem(label: 'المؤذن', value: muezzinName),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'جهة التسجيل',
                  value: registrationSource,
                ),
              ),
              Expanded(
                child: _InfoItem(label: 'نوع المسجد', value: mosqueType),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

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
          value.isEmpty ? 'غير محدد' : value,
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
