import 'package:flutter/material.dart';

import 'home_stat_item.dart';

class HomeStatsSection extends StatelessWidget {
  const HomeStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const stats = [
      (Icons.favorite_border, '300+', 'مسجد ضمن الخدمة'),
      (Icons.list, '350+', 'احتياج مسجل'),
      (Icons.mosque_outlined, '85+', 'خدمة منفذة'),
      (Icons.person_outline_outlined, '4', 'برامج رئيسية'),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD6A343).withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: List.generate(stats.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Container(
              width: 1,
              height: 48,
              color: const Color(0xFFE5C99B),
            );
          }

          final stat = stats[index ~/ 2];

          return Expanded(
            child: HomeStatItem(icon: stat.$1, value: stat.$2, label: stat.$3),
          );
        }),
      ),
    );
  }
}
