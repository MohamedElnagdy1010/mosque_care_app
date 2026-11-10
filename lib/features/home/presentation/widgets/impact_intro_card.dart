import 'package:flutter/material.dart';

class ImpactIntroCard extends StatelessWidget {
  const ImpactIntroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF79532E), Color(0xFFB58A4A)],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 30),
          SizedBox(height: 12),
          Text(
            'عطاء مستمر وأثر مستدام',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'نستعرض أثر خدمات رِواق في العناية ببيوت الله، '
            'من أعمال النظافة والصيانة إلى تلبية احتياجات المساجد.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.7),
          ),
        ],
      ),
    );
  }
}
