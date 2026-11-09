import 'package:flutter/material.dart';

class HomeStatItem extends StatelessWidget {
  const HomeStatItem({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    const darkBrown = Color(0xFF4A2A16);
    const gold = Color(0xFFD6A343);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: gold, size: 22),
        const SizedBox(height: 3),
        Text(
          value,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),
        Text(
          label,
          maxLines: 1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 9, color: darkBrown),
        ),
      ],
    );
  }
}
