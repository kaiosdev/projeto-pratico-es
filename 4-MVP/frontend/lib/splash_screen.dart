import 'package:flutter/material.dart';
import 'accessibility_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  static const Color kYellow = Color(0xFFF5C842);
  static const Color kDark = Color(0xFF1C1C1C);

  @override
  void initState() {
    super.initState();

    // Animação de entrada do logo e ícone
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    // Navega para a tela de acessibilidade após 2.5 segundos
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const AccessibilityScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kYellow,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Logo centralizada ──────────────────────────────────────
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _SlowDownLogo(size: 52),
                ),
              ),
            ),

            // ── Ícone de voz na parte inferior ────────────────────────
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const Center(
                  child: _VoiceIcon(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Logo SlowDown ────────────────────────────────────────────────────

class _SlowDownLogo extends StatelessWidget {
  final double size;
  const _SlowDownLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: size * 0.14,
            vertical: size * 0.08,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'SLOW',
            style: TextStyle(
              color: const Color(0xFFF5B800),
              fontSize: size * 0.45,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: size * 0.08),
        Text(
          'DOWN',
          style: TextStyle(
            color: const Color(0xFF1C1C1C),
            fontSize: size * 0.72,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
      ],
    );
  }
}

// ─── Widget: Ícone de voz (SVG manual) ───────────────────────────────────────

class _VoiceIcon extends StatelessWidget {
  const _VoiceIcon();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(56, 56),
      painter: _VoiceIconPainter(),
    );
  }
}

class _VoiceIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final cx = size.width * 0.38;
    final cy = size.height * 0.50;
    final r = size.width * 0.22;

    // Cabeça (círculo)
    canvas.drawCircle(Offset(cx, cy - r * 0.3), r * 0.72, paint);

    // Pescoço / corpo
    final path = Path();
    path.moveTo(cx - r * 0.45, cy + r * 0.42);
    path.quadraticBezierTo(cx, cy + r * 1.1, cx + r * 0.45, cy + r * 0.42);
    canvas.drawPath(path, paint);

    // Ondas de som (3 arcos à direita)
    final wavePaint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final waveX = cx + r * 0.95;
    final waveY = cy;

    // Onda 1 (menor)
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveX - r * 0.1, waveY),
        width: r * 0.7,
        height: r * 1.0,
      ),
      -0.6,
      1.2,
      false,
      wavePaint,
    );

    // Onda 2 (média)
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveX - r * 0.1, waveY),
        width: r * 1.15,
        height: r * 1.5,
      ),
      -0.6,
      1.2,
      false,
      wavePaint,
    );

    // Onda 3 (maior)
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveX - r * 0.1, waveY),
        width: r * 1.6,
        height: r * 2.0,
      ),
      -0.6,
      1.2,
      false,
      wavePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}