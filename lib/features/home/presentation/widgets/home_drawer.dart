import 'package:flutter/material.dart';

import '../models/user_role.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({
    super.key,
    required this.role,
    this.onTabSelected,
    this.onLogin,
    this.onLogout,
  });

  final UserRole role;
  final ValueChanged<int>? onTabSelected;
  final VoidCallback? onLogin;
  final VoidCallback? onLogout;

  static const Color darkBrown = Color(0xFF4A2A16);
  static const Color background = Color(0xFFFFF4E2);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: background,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Image.asset('assets/images/home/logo.png', height: 90),
                  const SizedBox(height: 12),
                  const Text(
                    'رِواق',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                  const Text(
                    'منصة العناية ببيوت الله',
                    style: TextStyle(fontSize: 12, color: darkBrown),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('الرئيسية'),
              onTap: () {
                Navigator.of(context).pop();
                onTabSelected?.call(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mosque_outlined),
              title: const Text('المساجد'),
              onTap: () {
                Navigator.of(context).pop();
                onTabSelected?.call(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.volunteer_activism_outlined),
              title: const Text('الخدمات'),
              onTap: () {
                Navigator.of(context).pop();
                onTabSelected?.call(0);
              },
            ),
            const Spacer(),
            const Divider(),
            if (role == UserRole.authenticatedUser)
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.red),
                title: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: onLogout == null
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        onLogout?.call();
                      },
              )
            else
              ListTile(
                leading: const Icon(Icons.login_rounded),
                title: const Text('تسجيل الدخول'),
                onTap: onLogin == null
                    ? null
                    : () {
                        Navigator.of(context).pop();
                        onLogin!.call();
                      },
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
