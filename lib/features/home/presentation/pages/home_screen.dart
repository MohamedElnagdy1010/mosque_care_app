import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mosque_care_app/features/home/presentation/widgets/home_app_bar.dart';

import '../models/user_role.dart';

import '../widgets/home_hero_banner.dart';
import '../widgets/home_needs_section.dart';
import '../widgets/home_news_section.dart';
import '../widgets/home_role_actions_section.dart';
import '../widgets/home_services_section.dart';
import '../widgets/home_stats_section.dart';

//import '../widgets/home_header.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.role, this.onTabSelected});

  final UserRole role;
  final ValueChanged<int>? onTabSelected;

  static const Color darkBrown = Color(0xFF4A2A16);
  static const Color gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),

      appBar: HomeAppbar(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HomeHeroBanner(),
              Gap(12),
              HomeStatsSection(),
              Gap(20),

              HomeServicesSection(onTabSelected: onTabSelected, role: role),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 10,
                ),
                child: Image.asset("assets/images/home/banner_4.png"),
              ),
              Gap(15),

              HomeNeedsSection(role: role),

              Gap(20),
              HomeNewsSection(),
              const Gap(20),

              HomeRoleActionsSection(role: role, onTabSelected: onTabSelected),
              const Gap(25),
            ],
          ),
        ),
      ),
    );
  }
}
