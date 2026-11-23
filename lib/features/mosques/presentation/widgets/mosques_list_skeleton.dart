import 'package:flutter/material.dart';

class MosquesListSkeleton extends StatefulWidget {
  const MosquesListSkeleton({super.key});

  @override
  State<MosquesListSkeleton> createState() => _MosquesListSkeletonState();
}

class _MosquesListSkeletonState extends State<MosquesListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const _base = Color(0xFFEDE3D6);
  static const _highlight = Color(0xFFFFFBF5);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _block({required double height, double? width, double radius = 8}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          begin: Alignment(-2 + _controller.value * 4, 0),
          end: Alignment(-1 + _controller.value * 4, 0),
          colors: const [_base, _highlight, _base],
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _block(height: 100, width: 90, radius: 12),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _block(height: 16),
                const SizedBox(height: 10),
                _block(height: 12, width: 110),
                const SizedBox(height: 12),
                _block(height: 12, width: 145),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _block(height: 24, width: 70),
                    const SizedBox(width: 6),
                    _block(height: 24, width: 58),
                  ],
                ),
                const SizedBox(height: 10),
                _block(height: 11, width: 120),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (_, _) => _card(),
        );
      },
    );
  }
}
