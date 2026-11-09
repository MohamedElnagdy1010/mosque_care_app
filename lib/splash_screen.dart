import 'package:flutter/material.dart';

import 'khadem_logo_paths.dart';

/// شاشة البداية: الشعار يُبنى → الاسم يُكتب → زوم بسيط → الانتقال للصفحة التالية.
///
/// الاستخدام:
///   home: SplashScreen(nextBuilder: (_) => const OnboardingScreen()),
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.nextBuilder});

  /// الصفحة التي ننتقل لها بعد انتهاء الحركة (الـ Onboarding).
  final WidgetBuilder nextBuilder;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const _total = Duration(milliseconds: 4400);
  static const _hold = Duration(milliseconds: 250);
  static const _bg = Color(0xFFFAF8F3);

  late final AnimationController _c =
      AnimationController(vsync: this, duration: _total);

  // كل مرحلة = جزء من الزمن الكلي (0..1)
  late final Animation<double> _inner = _stage(0.00, 0.20);
  late final Animation<double> _middle = _stage(0.12, 0.34);
  late final Animation<double> _outer = _stage(0.24, 0.48);
  late final Animation<double> _arabic = _stage(0.50, 0.70);
  late final Animation<double> _english = _stage(0.68, 0.84);

  // زوم إن ثم زوم أوت بسيط
  late final Animation<double> _zoom = TweenSequence<double>([
    TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.07)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 55),
    TweenSequenceItem(
        tween: Tween(begin: 1.07, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45),
  ]).animate(CurvedAnimation(parent: _c, curve: const Interval(0.80, 1.0)));

  bool _started = false;

  Animation<double> _stage(double a, double b) => CurvedAnimation(
        parent: _c,
        curve: Interval(a, b, curve: Curves.easeOutCubic),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _run(reduceMotion: MediaQuery.of(context).disableAnimations);
  }

  Future<void> _run({required bool reduceMotion}) async {
    if (reduceMotion) {
      // من يفضّل تقليل الحركة: نعرض الشعار مكتملاً ثم ننتقل.
      _c.value = 1;
      await Future<void>.delayed(const Duration(milliseconds: 1200));
    } else {
      await _c.forward();
      await Future<void>.delayed(_hold);
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, _, _) => widget.nextBuilder(context),
        transitionsBuilder: (_, anim, _, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: Semantics(
          label: 'جمعية العناية بالمساجد بمحافظة المزاحمية',
          child: FractionallySizedBox(
            widthFactor: 0.68,
            child: AspectRatio(
              aspectRatio: kLogoWidth / kLogoHeight,
              child: AnimatedBuilder(
                animation: _c,
                builder: (context, _) => Transform.scale(
                  scale: _zoom.value,
                  child: CustomPaint(
                    painter: _LogoPainter(
                      inner: _inner.value,
                      middle: _middle.value,
                      outer: _outer.value,
                      arabic: _arabic.value,
                      english: _english.value,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({
    required this.inner,
    required this.middle,
    required this.outer,
    required this.arabic,
    required this.english,
  });

  final double inner, middle, outer, arabic, english;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / kLogoWidth;
    canvas.scale(s);

    // الأقواس: تُبنى من الأسفل إلى الأعلى، من الداخل للخارج.
    _reveal(canvas, innerArch, kInnerBounds, kLogoInner, inner, _Dir.up);
    _reveal(canvas, middleArch, kMiddleBounds, kLogoMiddle, middle, _Dir.up);
    _reveal(canvas, outerArch, kOuterBounds, kLogoOuter, outer, _Dir.up);

    // الاسم العربي: يُكتب من اليمين لليسار مع مؤشر كتابة ذهبي.
    _reveal(canvas, arabicName, kArabicNameBounds, kLogoText, arabic, _Dir.rtl);
    _caret(canvas, kArabicNameBounds, arabic, rtl: true);

    // الاسم الإنجليزي: من اليسار لليمين.
    _reveal(canvas, englishName, kEnglishNameBounds, kLogoText, english, _Dir.ltr);
  }

  void _reveal(Canvas canvas, Path path, Rect b, Color color, double t, _Dir dir) {
    if (t <= 0) return;
    const pad = 2.0;
    final Rect clip;
    switch (dir) {
      case _Dir.up:
        clip = Rect.fromLTRB(b.left - pad, b.bottom + pad - (b.height + 2 * pad) * t,
            b.right + pad, b.bottom + pad);
      case _Dir.rtl:
        clip = Rect.fromLTRB(b.right + pad - (b.width + 2 * pad) * t, b.top - pad,
            b.right + pad, b.bottom + pad);
      case _Dir.ltr:
        clip = Rect.fromLTRB(b.left - pad, b.top - pad,
            b.left - pad + (b.width + 2 * pad) * t, b.bottom + pad);
    }
    canvas.save();
    canvas.clipRect(clip);
    canvas.drawPath(
        path, Paint()..color = color..isAntiAlias = true);
    // خط رفيع بنفس اللون يخفي أي فواصل شعرية بين القطع.
    canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8
          ..strokeJoin = StrokeJoin.round
          ..isAntiAlias = true);
    canvas.restore();
  }

  void _caret(Canvas canvas, Rect b, double t, {required bool rtl}) {
    if (t <= 0 || t >= 1) return;
    final x = b.right - b.width * t;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(x - 1.5, b.top - 4, 3, b.height + 8), const Radius.circular(1.5)),
      Paint()..color = kLogoMiddle,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter o) =>
      o.inner != inner ||
      o.middle != middle ||
      o.outer != outer ||
      o.arabic != arabic ||
      o.english != english;
}

enum _Dir { up, rtl, ltr }
