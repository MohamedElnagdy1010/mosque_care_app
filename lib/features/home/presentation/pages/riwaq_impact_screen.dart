import 'package:flutter/material.dart';

import '../widgets/home_stats_section.dart';
import '../widgets/impact_intro_card.dart';
import '../widgets/impact_services_section.dart';
import '../models/user_role.dart';
import 'all_needs_screen.dart';
import '../widgets/impact_detailed_stats_section.dart';

class RiwaqImpactScreen extends StatelessWidget {
  const RiwaqImpactScreen({super.key, required this.role});

  final UserRole role;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أثر رِواق'), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              ImpactIntroCard(),
              SizedBox(height: 20),
              HomeStatsSection(),
              SizedBox(height: 24),
              ImpactServicesSection(
                onViewAll: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AllNeedsScreen(role: role),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const ImpactDetailedStatsSection(),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
