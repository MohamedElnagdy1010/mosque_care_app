import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/mosque_needs/mosque_needs_cubit.dart';
import '../cubit/mosque_needs/mosque_needs_state.dart';

class MosqueNeedsCard extends StatelessWidget {
  const MosqueNeedsCard({super.key, required this.mosqueId});

  final String mosqueId;

  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);
  static const _muted = Color(0xFF9B8B7A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.build_outlined, color: _gold),
              SizedBox(width: 10),
              Text(
                'احتياجات المسجد',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _brown,
                ),
              ),
            ],
          ),
          const Divider(height: 28),

          BlocBuilder<MosqueNeedsCubit, MosqueNeedsState>(
            builder: (context, state) {
              if (state is MosqueNeedsInitial || state is MosqueNeedsLoading) {
                return const _NeedsLoading();
              }

              if (state is MosqueNeedsError) {
                return Column(
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      color: _muted,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: _muted),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.read<MosqueNeedsCubit>().loadNeeds(mosqueId);
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                );
              }

              if (state is MosqueNeedsLoaded) {
                if (state.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _gold,
                            size: 36,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'لا توجد احتياجات مسجلة لهذا المسجد',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _brown, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إجمالي الاحتياجات المسجلة: ${state.total}',
                      style: const TextStyle(
                        color: _brown,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'تم تحميل ${state.items.length} من '
                      '${state.total} احتياجًا.',
                      style: const TextStyle(color: _muted, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'سيتم عرض تفاصيل البنود بعد اعتماد '
                      'حقول الاستجابة من السيرفر.',
                      style: TextStyle(color: _muted, fontSize: 12),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class _NeedsLoading extends StatefulWidget {
  const _NeedsLoading();

  @override
  State<_NeedsLoading> createState() => _NeedsLoadingState();
}

class _NeedsLoadingState extends State<_NeedsLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final position = _controller.value * 3 - 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _line(position, width: 160, height: 15),
            const SizedBox(height: 14),
            _line(position, height: 12),
            const SizedBox(height: 10),
            _line(position, width: 190, height: 12),
          ],
        );
      },
    );
  }

  Widget _line(double position, {double? width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment(position - 1, 0),
          end: Alignment(position + 1, 0),
          colors: const [
            Color(0xFFEDE3D6),
            Color(0xFFFFFBF5),
            Color(0xFFEDE3D6),
          ],
        ),
      ),
    );
  }
}
