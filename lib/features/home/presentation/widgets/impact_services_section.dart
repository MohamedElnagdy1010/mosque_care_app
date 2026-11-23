import 'package:flutter/material.dart';

import 'impact_service_card.dart';

class ImpactServicesSection extends StatelessWidget {
  const ImpactServicesSection({super.key, required this.onViewAll});

  final VoidCallback onViewAll;
  @override
  Widget build(BuildContext context) {
    const services = [
      (Icons.cleaning_services_outlined, 'النظافة والتعطير'),
      (Icons.build_outlined, 'صيانة المرافق'),
      (Icons.water_drop_outlined, 'سقيا الماء'),
      (Icons.handyman_outlined, 'الترميم والتأهيل'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مجالات الأثر',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF604326),
                ),
              ),
              TextButton.icon(
                onPressed: onViewAll,
                icon: const Icon(Icons.arrow_back_ios_new, size: 14),
                label: const Text('عرض الكل'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF79532E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final service = services[index];

              return ImpactServiceCard(icon: service.$1, title: service.$2);
            },
          ),
        ],
      ),
    );
  }
}
