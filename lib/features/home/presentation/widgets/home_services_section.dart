import 'package:flutter/material.dart';

import '../../../mosques/presentation/pages/mosque_map_screen.dart';

import 'home_service_card.dart';
import '../models/user_role.dart';
import '../pages/all_needs_screen.dart';
import '../pages/riwaq_impact_screen.dart';

class HomeServicesSection extends StatelessWidget {
  const HomeServicesSection({
    super.key,
    this.onTabSelected,
    required this.role,
  });

  final ValueChanged<int>? onTabSelected;
  final UserRole role;
  @override
  Widget build(BuildContext context) {
    const services = [
      ('استكشف المساجد', 'المساجد وبياناتها', Icons.mosque_outlined),
      ('الاحتياجات والخدمات', 'الصيانة والعناية', Icons.handyman_outlined),
      ('خريطة المساجد', 'المواقع الجغرافية', Icons.location_on_outlined),
      ('أثر رِواق', 'الإنجازات والإحصائيات', Icons.bar_chart_rounded),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'استكشف خدمات رِواق',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2A16),
            ),
          ),

          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 2,
              mainAxisSpacing: 4,
              mainAxisExtent: 130,
            ),
            itemBuilder: (context, index) {
              final service = services[index];

              return HomeServiceCard(
                title: service.$1,
                subtitle: service.$2,
                icon: service.$3,

                onTap: () {
                  if (index == 0) {
                    onTabSelected?.call(1);
                  } else if (index == 1) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AllNeedsScreen(role: role),
                      ),
                    );
                  } else if (index == 2) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const MosqueMapScreen(),
                      ),
                    );
                  } else if (index == 3) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RiwaqImpactScreen(role: role),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
