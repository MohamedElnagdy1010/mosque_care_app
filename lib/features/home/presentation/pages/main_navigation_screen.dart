import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_role.dart';
import '../../../mosques/data/repositories/local_mosque_repository.dart';
import '../../../mosques/presentation/cubit/mosques_cubit.dart';
import '../../../mosques/presentation/pages/mosques_screen.dart';
import 'home_screen.dart';
import '../widgets/home_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _goToHome() {
    if (_currentIndex == 0) return;

    setState(() {
      _currentIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          _goToHome();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4E2),

        body: [
          HomeScreen(
            role: widget.role,
            onTabSelected: (index) {
              if (_currentIndex == index) return;

              setState(() {
                _currentIndex = index;
              });
            },
          ),

          BlocProvider(
            create: (context) =>
                MosquesCubit(LocalMosqueRepository())..loadMosques(),
            child: MosquesScreen(role: widget.role),
          ),

          const _TemporaryPage(title: 'تبرع'),
          const _TemporaryPage(title: 'الأخبار'),
          const _TemporaryPage(title: 'المزيد'),
        ][_currentIndex],

        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentIndex,
          onItemSelected: (index) {
            if (_currentIndex == index) return;

            setState(() {
              _currentIndex = index;
            });
          },
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
