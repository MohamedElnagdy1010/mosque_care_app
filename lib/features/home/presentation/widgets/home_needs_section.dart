import 'package:flutter/material.dart';

import 'home_need_card.dart';
import '../models/user_role.dart';

class HomeNeedsSection extends StatelessWidget {
  const HomeNeedsSection({super.key, required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    const needs = [
      ('فرش المساجد', 'assets/images/home/need_carpet.png', 0.75, 'carpets'),
      ('المكيفات', 'assets/images/home/need_ac.png', 0.30, 'air_conditioning'),
      ('الإضاءة', 'assets/images/home/need_lighting.png', 0.65, 'electrical'),
      ('سقيا الماء', 'assets/images/home/need_water.png', 0.40, 'water'),
      ('السباكة', '', 0.0, 'plumbing'),
      ('الصوتيات', '', 0.0, 'audio'),
      ('الأبواب والنوافذ', '', 0.0, 'doors_windows'),
      ('الترميم والعزل', '', 0.0, 'renovation'),
      ('النظافة والتعطير', '', 0.0, 'cleaning'),
      ('المرافق الخارجية', '', 0.0, 'outdoor'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'احتياجات ذات أولوية',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 130,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: false,
              itemCount: needs.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final need = needs[index];

                return SizedBox(
                  width: 145,
                  child: HomeNeedCard(
                    title: need.$1,
                    image: need.$2,
                    progress: need.$3,
                    openBuilder: null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
