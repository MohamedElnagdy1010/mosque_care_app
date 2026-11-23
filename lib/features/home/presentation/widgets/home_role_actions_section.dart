import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../models/role_action_item.dart';
import 'role_action_card.dart';
import '../../../requests/presentation/pages/service_request_screen.dart';

class HomeRoleActionsSection extends StatelessWidget {
  const HomeRoleActionsSection({
    super.key,
    required this.role,
    this.onTabSelected,
  });

  final UserRole role;
  final ValueChanged<int>? onTabSelected;
  static const Color darkBrown = Color(0xFF4A2A16);
  static const Color gold = Color(0xFFD6A343);

  String get sectionTitle {
    return role == UserRole.visitor ? 'خدمات الزائر' : 'خدمات المستخدم';
  }

  List<RoleActionItem> actions(BuildContext context) {
    if (role == UserRole.visitor) {
      return [
        RoleActionItem(
          title: 'استكشف المساجد',
          icon: Icons.mosque_outlined,
          onTap: () => onTabSelected?.call(1),
        ),
        RoleActionItem(
          title: 'الاحتياجات',
          icon: Icons.volunteer_activism_outlined,
          onTap: () {},
        ),
        RoleActionItem(
          title: 'الأخبار',
          icon: Icons.article_outlined,
          onTap: () {},
        ),
        RoleActionItem(
          title: 'تواصل معنا',
          icon: Icons.support_agent_outlined,
          onTap: () {},
        ),
      ];
    }

    return [
      RoleActionItem(
        title: 'المساجد',
        icon: Icons.mosque_outlined,
        onTap: () => onTabSelected?.call(1),
      ),

      RoleActionItem(
        title: 'طلب خدمة',
        icon: Icons.add_circle_outline,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const ServiceRequestScreen(),
            ),
          );
        },
      ),

      RoleActionItem(
        title: 'طلباتي',
        icon: Icons.assignment_outlined,
        onTap: () {},
      ),
      RoleActionItem(title: 'حسابي', icon: Icons.person_outline, onTap: () {}),
    ];
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HOME ROLE: ${role.name}');
    final items = actions(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.dashboard_customize_outlined,
                color: gold,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                sectionTitle,
                style: const TextStyle(
                  color: darkBrown,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              mainAxisExtent: 100,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return RoleActionCard(
                title: item.title,
                icon: item.icon,
                onTap: item.onTap,
              );
            },
          ),
        ],
      ),
    );
  }
}
