import 'package:flutter/material.dart';

class NeedCategoryCard extends StatelessWidget {
  const NeedCategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.itemsCount,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final int itemsCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF8F4EE),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE7D9C8)),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28, color: const Color(0xFF9C7443)),
              const Spacer(),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A2A16),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$itemsCount خدمة',
                style: const TextStyle(fontSize: 12, color: Color(0xFF75685F)),
              ),
              const SizedBox(height: 4),
              const Align(
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 13,
                  color: Color(0xFF9C7443),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
