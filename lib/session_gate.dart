import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/home/presentation/models/user_role.dart';
import 'features/home/presentation/pages/main_navigation_screen.dart';
import 'login_screen.dart';

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late Future<void> _restoreFuture;

  @override
  void initState() {
    super.initState();
    _restoreFuture = context.read<AuthCubit>().restoreSession();
  }

  void _retry() {
    setState(() {
      _restoreFuture = context.read<AuthCubit>().restoreSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _restoreFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final authState = context.read<AuthCubit>().state;

        if (authState.status == AuthStatus.authenticated &&
            authState.user != null) {
          return const MainNavigationScreen(role: UserRole.authenticatedUser);
        }

        if (authState.status == AuthStatus.failure || snapshot.hasError) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.wifi_off_rounded,
                        size: 54,
                        color: Color(0xFF795735),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'تعذر التحقق من جلسة الدخول',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _retry,
                        child: const Text('إعادة المحاولة'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text('الانتقال إلى تسجيل الدخول'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const LoginScreen();
      },
    );
  }
}
