import 'package:flutter/material.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppbar({super.key});

  static const Color darkBrown = Color(0xFF4A2A16);

  @override
  Size get preferredSize => const Size.fromHeight(85);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFF4E2),
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 85,
      titleSpacing: 12,
      title: Row(
        children: [
          // القائمة
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded, color: darkBrown),
          ),

          // اسم التطبيق
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/home/name.png',
                height: 42,
                fit: BoxFit.contain,
              ),
              const Text(
                'منصة العناية ببيوت الله',
                style: TextStyle(fontSize: 10, color: darkBrown),
              ),
            ],
          ),

          const Spacer(),

          // شعار الجمعية
          Image.asset(
            'assets/images/home/logo.png',
            height: 80,
            width: 95,
            fit: BoxFit.contain,
          ),

          const Spacer(),

          // الإشعارات
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: darkBrown,
            ),
          ),

          // الحساب
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_rounded, color: darkBrown),
          ),
        ],
      ),
    );
  }
}
