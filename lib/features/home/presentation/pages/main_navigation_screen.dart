import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../mosques/data/repositories/remote_mosque_repository.dart';

import '../../../mosques/presentation/cubit/mosques/mosques_cubit.dart';
import '../../../mosques/presentation/pages/mosques_screen.dart';
import '../models/user_role.dart';
import '../widgets/home_bottom_nav_bar.dart';
import 'home_screen.dart';

import 'package:mosque_care_app/login_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await context.read<AuthCubit>().logout();

    if (!mounted) return;

    _goToLogin();
  }

  void _goToLogin() {
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _selectTab(int index) {
    if (_currentIndex == index) return;

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final role = authState.user == null ? UserRole.visitor : widget.role;

    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          _selectTab(0);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4E2),
        body: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 24 * (1 - value)),
                child: child,
              ),
            );
          },
          child: [
            HomeScreen(
              role: role,
              onTabSelected: _selectTab,
              onLogin: _goToLogin,
              onLogout: authState.status == AuthStatus.loading
                  ? null
                  : _confirmLogout,
            ),
            BlocProvider(
              create: (context) => MosquesCubit(
                RemoteMosqueRepository(context.read<ApiClient>()),
              )..loadMosques(),
              child: MosquesScreen(role: role),
            ),
            const _TemporaryPage(title: 'تبرع'),
            const _TemporaryPage(title: 'الأخبار'),
            const _TemporaryPage(title: 'المزيد'),
          ][_currentIndex],
        ),
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentIndex,
          onItemSelected: _selectTab,
        ),
      ),
    );
  }
}

class _TemporaryPage extends StatelessWidget {
  const _TemporaryPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFFF4E2),
      ),
      body: Center(
        child: Text(
          'صفحة $title قيد التطوير',
          style: const TextStyle(fontSize: 20, color: Color(0xFF4A2A16)),
        ),
      ),
    );
  }
}
