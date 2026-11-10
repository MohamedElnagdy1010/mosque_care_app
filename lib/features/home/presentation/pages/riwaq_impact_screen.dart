import 'package:flutter/material.dart';

import '../widgets/home_stats_section.dart';
import '../widgets/impact_intro_card.dart';
import '../widgets/impact_services_section.dart';

class RiwaqImpactScreen extends StatelessWidget {
  const RiwaqImpactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أثر رِواق'), centerTitle: true),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ImpactIntroCard(),
              SizedBox(height: 20),
              HomeStatsSection(),
              SizedBox(height: 24),
              ImpactServicesSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
