import 'features/home/presentation/models/user_role.dart';
import 'features/home/presentation/pages/main_navigation_screen.dart';

import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  static const darkBrown = Color(0xFF4A2A16);
  static const gold = Color(0xFFD6A343);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // الخلفية الأساسية

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.35, 0.70, 1.0],
                colors: [
                  Color(0xFFFFF4E2),
                  Color(0xFFFBE8C9),
                  Color(0xFFF8DFB4),
                  Color(0xFFFFF4E2),
                ],
              ),
            ),
          ),

          // الزخرفة السفلية
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.30, 1.0],
                    colors: [Colors.transparent, Colors.white, Colors.white],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/role_bottom_decoration.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),

          // محتوى الشاشة
          SafeArea(
            top: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Column(
                    //  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 0.65, 1.0],
                              colors: [
                                Colors.white,
                                Colors.white,
                                Colors.transparent,
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.dstIn,
                          child: Image.asset(
                            'assets/images/role_mosque.png',
                            width: double.infinity,

                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                      const Text(
                        'مرحبًا بك في خادم',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: darkBrown,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'اختر طريقة استخدام التطبيق للمتابعة',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF795735),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // بطاقة الزائر
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.45,
                          children: [
                            _RoleCard(
                              title: 'زائر',
                              subtitle: 'استعراض الخدمات',
                              icon: Icons.person_outline_rounded,
                              image: 'assets/images/role_mosque.png',
                              startColor: const Color(0xFF986326),
                              endColor: const Color(0xFF4E2C13),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                      role: UserRole.visitor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            _RoleCard(
                              title: 'إمام أو مؤذن',
                              subtitle: 'طلبات الخدمات',
                              icon: Icons.account_circle_outlined,
                              image: 'assets/images/role_mosque.png',
                              startColor: const Color(0xFF744625),
                              endColor: const Color(0xFF351D10),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                      role: UserRole.imam,
                                    ),
                                  ),
                                );
                              },
                            ),
                            _RoleCard(
                              title: 'مشرف الجمعية',
                              subtitle: 'متابعة المساجد',
                              icon: Icons.assignment_ind_outlined,
                              image: 'assets/images/role_mosque.png',
                              startColor: const Color(0xFF986326),
                              endColor: const Color(0xFF4E2C13),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                      role: UserRole.supervisor,
                                    ),
                                  ),
                                );
                              },
                            ),
                            _RoleCard(
                              title: 'ممثل الوزارة',
                              subtitle: 'البلاغات الجماعية',
                              icon: Icons.account_balance_outlined,
                              image: 'assets/images/role_mosque.png',
                              startColor: const Color(0xFF744625),
                              endColor: const Color(0xFF351D10),

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const MainNavigationScreen(
                                      role: UserRole.ministry,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// بطاقة اختيار المستخدم
class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.image,
    required this.startColor,
    required this.endColor,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String image;
  final Color startColor;
  final Color endColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(25),
        child: Ink(
          height: 145,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: RoleSelectionScreen.gold, width: 1.5),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40795735),
                blurRadius: 14,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // صورة خلفية البطاقة
                Positioned.fill(child: Image.asset(image, fit: BoxFit.cover)),

                // تدرج بني فوق الصورة
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          endColor,
                          startColor.withValues(alpha: 0.98),
                          startColor.withValues(alpha: 0.85),
                          endColor.withValues(alpha: 0.15),
                        ],
                      ),
                    ),
                  ),
                ),

                // محتوى البطاقة
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Container(
                        width: 55,
                        height: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: RoleSelectionScreen.gold,
                            width: 2,
                          ),
                          color: const Color(0x44351D10),
                        ),
                        child: Icon(icon, color: Colors.white, size: 32),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              subtitle,
                              style: const TextStyle(
                                color: Color(0xFFFFE8C7),
                                fontSize: 11,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 5),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
