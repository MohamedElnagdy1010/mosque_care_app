import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../models/role_action_item.dart';
import 'role_action_card.dart';

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
    switch (role) {
      case UserRole.visitor:
        return 'خدمات الزائر';
      case UserRole.imam:
        return 'خدمات الإمام والمؤذن';
      case UserRole.supervisor:
        return 'خدمات مشرف الجمعية';
      case UserRole.ministry:
        return 'خدمات ممثل الوزارة';
    }
  }

  List<RoleActionItem> get actions {
    switch (role) {
      case UserRole.visitor:
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

      case UserRole.imam:
        return [
          RoleActionItem(
            title: 'طلب خدمة',
            icon: Icons.add_circle_outline,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'طلباتي',
            icon: Icons.assignment_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'بيانات المسجد',
            icon: Icons.mosque_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'متابعة الصيانة',
            icon: Icons.build_outlined,
            onTap: () {},
          ),
        ];

      case UserRole.supervisor:
        return [
          RoleActionItem(
            title: 'جميع المساجد',
            icon: Icons.mosque_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'إنشاء بلاغ',
            icon: Icons.note_add_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'متابعة البلاغات',
            icon: Icons.fact_check_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'التوثيق الميداني',
            icon: Icons.camera_alt_outlined,
            onTap: () {},
          ),
        ];

      case UserRole.ministry:
        return [
          RoleActionItem(
            title: 'رفع دفعة مساجد',
            icon: Icons.upload_file_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'متابعة الدفعات',
            icon: Icons.folder_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'البلاغات',
            icon: Icons.report_outlined,
            onTap: () {},
          ),
          RoleActionItem(
            title: 'الملاحظات',
            icon: Icons.edit_note_outlined,
            onTap: () {},
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = actions;

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
