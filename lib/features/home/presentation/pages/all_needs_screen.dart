import 'package:flutter/material.dart';

import '../../data/catalog/need_categories.dart';
import '../widgets/need_category_card.dart';
import '../models/user_role.dart';
import 'need_details_screen.dart';

class AllNeedsScreen extends StatelessWidget {
  const AllNeedsScreen({super.key, required this.role});

  final UserRole role;
  @override
  Widget build(BuildContext context) {
    final categories = NeedCategories.all;
    const categoryIcons = <String, IconData>{
      'air_conditioning': Icons.ac_unit_rounded,
      'electrical': Icons.electrical_services_rounded,
      'plumbing': Icons.plumbing_rounded,
      'audio': Icons.speaker_rounded,
      'carpets': Icons.layers_rounded,
      'doors_windows': Icons.door_front_door_rounded,
      'renovation': Icons.construction_rounded,
      'cleaning': Icons.cleaning_services_rounded,
      'water': Icons.water_drop_rounded,
      'outdoor': Icons.park_rounded,
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاحتياجات والخدمات'),
        centerTitle: true,
        foregroundColor: const Color(0xFF4A2A16),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'خدمات العناية ببيوت الله',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A2A16),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'استكشف أقسام الصيانة والنظافة والعناية بمرافق المساجد.',
              style: TextStyle(fontSize: 14, color: Color(0xFF75685F)),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                mainAxisExtent: 135,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];

                return NeedCategoryCard(
                  title: category.name,
                  icon: categoryIcons[category.id] ?? Icons.handyman_rounded,
                  itemsCount: category.items.length,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => NeedDetailsScreen(
                          title: category.name,
                          categoryId: category.id,
                          items: category.items
                              .map((item) => item.name)
                              .toList(),
                          role: role,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
