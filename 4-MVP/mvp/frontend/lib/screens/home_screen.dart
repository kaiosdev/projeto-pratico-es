import 'package:flutter/material.dart';
import 'about_meditation_screen.dart';
import 'pet_screen.dart';
import 'monitor_screen.dart';
import 'menu_screen.dart';
import 'music_screen.dart'; // 👉 Novo import para a tela de Música

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ──────────────────────────────────────────────────
          Container(
            color: kYellow,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Colors.white24,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.reply_rounded,
                            color: Colors.white, size: 22),
                      ),
                    ),
                    const _SlowDownLogo(size: 28),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const MenuScreen()),
                      ),
                      child: const Icon(Icons.menu_rounded,
                          color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Corpo ────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // ── Gatinho central ───────────────────────────────
                  _CatWidget(),

                  const Spacer(),

                  // ── Botões de navegação ───────────────────────────
                  Padding(
                    padding: const EdgeInsets.only(bottom: 52),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Melhor distribuição para 4 botões
                      children: [
                        // Botão Meditação
                        _NavButton(
                          icon: Icons.self_improvement_rounded,
                          label: 'Meditação',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const AboutMeditationScreen()),
                          ),
                        ),

                        // 👉 NOVO: Botão Sons/Música
                        _NavButton(
                          icon: Icons.music_note_rounded,
                          label: 'Sons',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MusicScreen()),
                          ),
                        ),

                        // Botão Pet
                        _NavButton(
                          icon: Icons.pets_rounded,
                          label: 'Pet',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const PetScreen()),
                          ),
                        ),

                        // Botão Saúde/Monitor
                        _NavButton(
                          icon: Icons.favorite_rounded,
                          label: 'Saúde',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const MonitorScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Gatinho ──────────────────────────────────────────────────────────

class _CatWidget extends StatefulWidget {
  @override
  State<_CatWidget> createState() => _CatWidgetState();
}

class _CatWidgetState extends State<_CatWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, _floatAnimation.value),
        child: child,
      ),
      child: CustomPaint(
        size: const Size(180, 180),
        painter: _CatPainter(),
      ),
    );
  }
}

// ─── Painter: Gatinho fofo ────────────────────────────────────────────────────

class _CatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bodyPaint = Paint()
      ..color = const Color(0xFFF5C842)
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final darkFill = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.fill;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // ── Corpo ──
    final bodyPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.65),
        width: w * 0.62,
        height: h * 0.52,
      ));
    canvas.drawPath(bodyPath, bodyPaint);
    canvas.drawPath(bodyPath, outlinePaint);

    // ── Cabeça ──
    final headPath = Path()
      ..addOval(Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.36),
        width: w * 0.58,
        height: h * 0.50,
      ));
    canvas.drawPath(headPath, bodyPaint);
    canvas.drawPath(headPath, outlinePaint);

    // ── Orelha esquerda ──
    final leftEar = Path()
      ..moveTo(w * 0.24, h * 0.22)
      ..lineTo(w * 0.16, h * 0.06)
      ..lineTo(w * 0.36, h * 0.14)
      ..close();
    canvas.drawPath(leftEar, bodyPaint);
    canvas.drawPath(leftEar, outlinePaint);

    // ── Orelha direita ──
    final rightEar = Path()
      ..moveTo(w * 0.76, h * 0.22)
      ..lineTo(w * 0.84, h * 0.06)
      ..lineTo(w * 0.64, h * 0.14)
      ..close();
    canvas.drawPath(rightEar, bodyPaint);
    canvas.drawPath(rightEar, outlinePaint);

    // ── Olho esquerdo ──
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.33),
          width: w * 0.1,
          height: h * 0.1),
      darkFill,
    );
    canvas.drawCircle(Offset(w * 0.40, h * 0.31), w * 0.02, whiteFill);

    // ── Olho direito ──
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.62, h * 0.33),
          width: w * 0.1,
          height: h * 0.1),
      darkFill,
    );
    canvas.drawCircle(Offset(w * 0.64, h * 0.31), w * 0.02, whiteFill);

    // ── Nariz ──
    final nosePath = Path()
      ..moveTo(w * 0.5, h * 0.40)
      ..lineTo(w * 0.46, h * 0.44)
      ..lineTo(w * 0.54, h * 0.44)
      ..close();
    canvas.drawPath(nosePath, darkFill);

    // ── Boca ──
    final mouthPaint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(w * 0.5, h * 0.44), Offset(w * 0.44, h * 0.49), mouthPaint);
    canvas.drawLine(
        Offset(w * 0.5, h * 0.44), Offset(w * 0.56, h * 0.49), mouthPaint);

    // ── Bigodes ──
    final whiskerPaint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
        Offset(w * 0.18, h * 0.40), Offset(w * 0.42, h * 0.43), whiskerPaint);
    canvas.drawLine(
        Offset(w * 0.18, h * 0.44), Offset(w * 0.42, h * 0.45), whiskerPaint);
    canvas.drawLine(
        Offset(w * 0.82, h * 0.40), Offset(w * 0.58, h * 0.43), whiskerPaint);
    canvas.drawLine(
        Offset(w * 0.82, h * 0.44), Offset(w * 0.58, h * 0.45), whiskerPaint);

    // ── Rabo ──
    final tailPath = Path()
      ..moveTo(w * 0.72, h * 0.82)
      ..cubicTo(
        w * 0.90, h * 0.78,
        w * 0.95, h * 0.60,
        w * 0.80, h * 0.55,
      );
    canvas.drawPath(tailPath, outlinePaint);

    // ── Patas dianteiras ──
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.88),
          width: w * 0.18,
          height: h * 0.10),
      bodyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.38, h * 0.88),
          width: w * 0.18,
          height: h * 0.10),
      outlinePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.62, h * 0.88),
          width: w * 0.18,
          height: h * 0.10),
      bodyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(w * 0.62, h * 0.88),
          width: w * 0.18,
          height: h * 0.10),
      outlinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Widget: Botão de navegação ───────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: kYellow,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: kDark.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: kDark.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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