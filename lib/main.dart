import 'package:flutter/material.dart';

import 'package:mosque_care_app/role_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';
import 'onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final preferences = await SharedPreferences.getInstance();
  runApp(KhademApp(preferences: preferences));
}

class KhademApp extends StatelessWidget {
  const KhademApp({super.key, required this.preferences});
  final SharedPreferences preferences;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'خادم | العناية بالمساجد',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFAF8F3),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF795735)),
      fontFamily: null,
    ),
    builder: (context, child) => Directionality(
      textDirection: TextDirection.rtl,
      child: child ?? const SizedBox.shrink(),
    ),
    home: SplashScreen(
      nextBuilder: (_) => preferences.getBool('onboarding_complete') == true
          ? RoleSelectionScreen()
          : OnboardingScreen(preferences: preferences),
    ),
  );
}
