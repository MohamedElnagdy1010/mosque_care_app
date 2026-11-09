import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const Color darkBrown = Color(0xFF4A2A16);
  static const Color gold = Color(0xFFD6A343);
  static const Color cream = Color(0xFFFFF4E2);

  static const List<IconData> icons = [
    Icons.home_outlined,
    Icons.mosque_outlined,
    Icons.volunteer_activism_outlined,
    Icons.article_outlined,
    Icons.menu_rounded,
  ];

  static const List<String> labels = [
    'الرئيسية',
    'المساجد',
    'تبرع',
    'الأخبار',
    'المزيد',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: const BoxDecoration(
          color: cream,
          border: Border(top: BorderSide(color: Color(0xFFEAD8BB))),
        ),
        child: Row(
          children: List.generate(labels.length, (index) {
            final isSelected = currentIndex == index;
            final isDonation = index == 2;

            return Expanded(
              child: InkWell(
                onTap: () => onItemSelected(index),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isDonation
                              ? gold
                              : isSelected
                              ? gold.withValues(alpha: 0.15)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[index],
                          size: 25,
                          color: isDonation ? Colors.white : darkBrown,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels[index],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color: darkBrown,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
