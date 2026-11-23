import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, required this.preferences});
  final SharedPreferences preferences;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;
  static const Color brown = Color(0xFF795735);
  static const Color gold = Color(0xFFB99455);
  static const pages = [
    (
      'العناية ببيوت الله',
      'جمعية العناية بالمساجد بمحافظة المزاحمية، تعمل على خدمة المساجد والعناية بمرافقها، وتهيئة بيئة مناسبة للمصلين.',
      'assets/images/onboarding_1.jpg',
    ),
    (
      'خدمات النظافة والعناية',
      'نهتم بنظافة المساجد وتعطيرها، وغسيل الفرش والسجاد، وسقيا الماء؛ للمحافظة على نظافة بيوت الله وراحة المصلين.',
      'assets/images/onboarding_2.jpg',
    ),
    (
      'الصيانة وخدمة المساجد',
      'نساهم في صيانة المكيفات والكهرباء والسباكة والصوتيات ومرافق المساجد، مع إتاحة طلبات الخدمة للأئمة والمؤذنين المعتمدين.',
      'assets/images/onboarding_3.jpg',
    ),
  ];

  Future<void> _finish() async {
    await widget.preferences.setBool('onboarding_complete', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (value) => setState(() => _page = value),
              itemBuilder: (context, index) {
                final item = pages[index];
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.asset(
                                item.$3,
                                width: double.infinity,
                                height: constraints.maxHeight * .55,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                Text(
                                  item.$1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: brown,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: 56,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: gold,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                Text(
                                  item.$2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    height: 1.8,
                                    color: Color(0xFF574C41),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _page == i ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _page == i ? brown : const Color(0xFFD8D0C4),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: brown),
                    onPressed: _page == 2
                        ? _finish
                        : () => _controller.nextPage(
                            duration: const Duration(milliseconds: 320),
                            curve: Curves.easeInOut,
                          ),
                    child: Text(
                      _page == 2 ? 'ابدأ باستخدام التطبيق' : 'التالي',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (_page != 2)
                  TextButton(
                    onPressed: _finish,
                    child: const Text('تخطي', style: TextStyle(color: brown)),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
