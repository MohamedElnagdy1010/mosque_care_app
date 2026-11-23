import 'features/home/presentation/models/user_role.dart';
import 'features/home/presentation/pages/main_navigation_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/cubit/auth_cubit.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const darkBrown = Color(0xFF4A2A16);
  static const gold = Color(0xFFD6A343);

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'تعذر تسجيل الدخول')),
          );
        }

        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) =>
                  const MainNavigationScreen(role: UserRole.authenticatedUser),
            ),
          );
        }
      },
      child: Scaffold(
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
                    child: SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.only(bottom: 16),
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
                              child: SizedBox(
                                height: constraints.maxHeight * 0.34,
                                child: Image.asset(
                                  'assets/images/role_mosque.png',
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF5E7)
                                  .withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: gold, width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x26795735),
                                  blurRadius: 18,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                  'سجّل دخولك للاستفادة من خدمات خادم',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF795735),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _usernameController,
                                        textDirection: TextDirection.ltr,
                                        decoration: InputDecoration(
                                          labelText: 'اسم المستخدم',
                                          prefixIcon: const Icon(
                                            Icons.person_outline,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        textDirection: TextDirection.ltr,
                                        decoration: InputDecoration(
                                          labelText: 'كلمة المرور',
                                          prefixIcon: const Icon(
                                            Icons.lock_outline,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 52,

                                        child: BlocBuilder<AuthCubit, AuthState>(
                                          builder: (context, state) {
                                            final isLoading =
                                                state.status ==
                                                AuthStatus.loading;

                                            return FilledButton(
                                              onPressed: isLoading
                                                  ? null
                                                  : () {
                                                      final username =
                                                          _usernameController
                                                              .text
                                                              .trim();
                                                      final password =
                                                          _passwordController
                                                              .text;
                                                      debugPrint(
                                                        'LOGIN CHECK: '
                                                        'usernameEmpty=${username.isEmpty}, '
                                                        'passwordEmpty=${password.isEmpty}',
                                                      );

                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      if (username.isEmpty ||
                                                          password.isEmpty) {
                                                        debugPrint(
                                                          'VALIDATION FAILED: '
                                                          'usernameLength=${username.length}, '
                                                          'passwordLength=${password.length}',
                                                        );
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'من فضلك أدخل اسم المستخدم وكلمة المرور',
                                                            ),
                                                          ),
                                                        );
                                                        return;
                                                      }

                                                      context
                                                          .read<AuthCubit>()
                                                          .login(
                                                            username: username,
                                                            password: password,
                                                          );
                                                    },
                                              style: FilledButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF795735,
                                                ),
                                                disabledBackgroundColor:
                                                    const Color(0xFF795735),
                                                foregroundColor: Colors.white,
                                                disabledForegroundColor:
                                                    Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                ),
                                              ),
                                              child: isLoading
                                                  ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2.5,
                                                            color: Colors.white,
                                                          ),
                                                    )
                                                  : const Text(
                                                      'تسجيل الدخول',
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                            );
                                          },
                                        ),
                                      ),

                                      const SizedBox(height: 8),
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder<void>(
                                              transitionDuration:
                                                  const Duration(
                                                    milliseconds: 950,
                                                  ),
                                              reverseTransitionDuration:
                                                  const Duration(
                                                    milliseconds: 400,
                                                  ),
                                              pageBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                  ) {
                                                    return const MainNavigationScreen(
                                                      role: UserRole.visitor,
                                                    );
                                                  },
                                              transitionsBuilder:
                                                  (
                                                    context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child,
                                                  ) {
                                                    final fadeAnimation =
                                                        CurvedAnimation(
                                                          parent: animation,
                                                          curve: const Interval(
                                                            0.0,
                                                            0.85,
                                                            curve: Curves
                                                                .easeInOut,
                                                          ),
                                                        );

                                                    final slideAnimation =
                                                        CurvedAnimation(
                                                          parent: animation,
                                                          curve: Curves
                                                              .easeOutCubic,
                                                        );

                                                    return FadeTransition(
                                                      opacity: fadeAnimation,
                                                      child: SlideTransition(
                                                        position:
                                                            Tween<Offset>(
                                                              begin:
                                                                  const Offset(
                                                                    0,
                                                                    0.10,
                                                                  ),
                                                              end: Offset.zero,
                                                            ).animate(
                                                              slideAnimation,
                                                            ),
                                                        child: child,
                                                      ),
                                                    );
                                                  },
                                            ),
                                          );
                                        },

                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: const Color(
                                            0xFF4A2A16,
                                          ),
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Color(0xFFD6A343),
                                            width: 1.5,
                                          ),
                                          minimumSize: const Size(
                                            double.infinity,
                                            52,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'الدخول كزائر',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
