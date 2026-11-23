import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'session_gate.dart';
import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'splash_screen.dart';
import 'onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();
  final tokenStorage = TokenStorage();
  final apiClient = ApiClient(tokenStorage);

  final authRepository = AuthRepositoryImpl(
    remoteDataSource: AuthRemoteDataSource(apiClient),
    tokenStorage: tokenStorage,
  );

  runApp(
    RepositoryProvider<ApiClient>(
      create: (_) => apiClient,
      child: BlocProvider<AuthCubit>(
        create: (_) => AuthCubit(authRepository),
        child: KhademApp(preferences: preferences),
      ),
    ),
  );
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
          ? const SessionGate()
          : OnboardingScreen(preferences: preferences),
    ),
  );
}
