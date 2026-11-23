import 'package:flutter/material.dart';

class MosqueDetailsSkeleton extends StatefulWidget {
  const MosqueDetailsSkeleton({super.key});

  @override
  State<MosqueDetailsSkeleton> createState() => _MosqueDetailsSkeletonState();
}

class _MosqueDetailsSkeletonState extends State<MosqueDetailsSkeleton>
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

  Widget _block({required double height, double? width, double radius = 10}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final position = _controller.value * 3 - 2;

        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment(position - 1, 0),
              end: Alignment(position + 1, 0),
              colors: const [_base, _highlight, _base],
            ),
          ),
        );
      },
    );
  }

  Widget _card(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: child,
    );
  }

  Widget _infoRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _block(height: 12, width: 75),
              const SizedBox(height: 10),
              _block(height: 20),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _block(height: 12, width: 75),
              const SizedBox(height: 10),
              _block(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: const Text('تفاصيل المسجد'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _card(
              Column(
                children: [
                  _block(height: 72, width: 72, radius: 16),
                  const SizedBox(height: 16),
                  _block(height: 20, width: 200),
                  const SizedBox(height: 12),
                  _block(height: 14, width: 150),
                  const SizedBox(height: 18),
                  _block(height: 32, width: 145),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(height: 20, width: 135),
                  const SizedBox(height: 22),
                  _infoRow(),
                  const SizedBox(height: 22),
                  _infoRow(),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _card(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _block(height: 20, width: 190),
                  const SizedBox(height: 22),
                  _infoRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
