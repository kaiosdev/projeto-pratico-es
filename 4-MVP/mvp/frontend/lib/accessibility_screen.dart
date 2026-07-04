import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen>
    with SingleTickerProviderStateMixin {
  bool _voiceEnabled = false;

  late AnimationController _iconController;
  late Animation<double> _pulseAnimation;

  // Paleta SlowDown
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  @override
  void initState() {
    super.initState();

    // Pulsa o ícone quando voz está ativa
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _iconController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void _toggleVoice(bool value) {
    setState(() => _voiceEnabled = value);
    _updateVoiceAnimation(value);
  }

  void _updateVoiceAnimation(bool isEnabled) {
    if (isEnabled) {
      _iconController.repeat(reverse: true);
    } else {
      _iconController.stop();
      _iconController.reset();
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  Widget _buildVoiceIcon() {
    return ScaleTransition(
      scale: _voiceEnabled ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: CustomPaint(
        size: const Size(220, 220),
        painter: _VoiceIconPainter(active: _voiceEnabled),
      ),
    );
  }

  Widget _buildVoiceToggle() {
    return GestureDetector(
      onTap: () => _toggleVoice(!_voiceEnabled),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 100,
        height: 52,
        decoration: BoxDecoration(
          color: kDark,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: _voiceEnabled
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ────────────────────────────────────────────────────
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
                        child: const Icon(
                          Icons.reply_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    _SlowDownLogo(size: 28),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.menu_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
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

                  // Ícone de voz com pulso
                  _buildVoiceIcon(),

                  const SizedBox(height: 48),

                  // Toggle
                  _buildVoiceToggle(),

                  const Spacer(),

                  // Botão continuar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 32),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _navigateToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'CONTINUAR',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.5,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

// ─── Painter: Ícone de voz grande ────────────────────────────────────────────

class _VoiceIconPainter extends CustomPainter {
  final bool active;
  const _VoiceIconPainter({required this.active});

  @override
  void paint(Canvas canvas, Size size) {
    final color = const Color(0xFF1C1C1C);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFF5C842)
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.38;
    final cy = size.height * 0.44;
    final r = size.width * 0.28;

    // ── Cabeça preenchida ──
    final headPath = Path();
    // Crânio (círculo)
    headPath.addOval(Rect.fromCenter(
      center: Offset(cx, cy - r * 0.18),
      width: r * 1.55,
      height: r * 1.55,
    ));
    canvas.drawPath(headPath, fillPaint);
    canvas.drawPath(headPath, paint);

    // ── Queixo / pescoço ──
    final neckPath = Path();
    neckPath.moveTo(cx - r * 0.32, cy + r * 0.58);
    neckPath.quadraticBezierTo(
      cx - r * 0.05, cy + r * 1.05,
      cx + r * 0.12, cy + r * 0.72,
    );
    neckPath.quadraticBezierTo(
      cx + r * 0.28, cy + r * 0.48,
      cx + r * 0.55, cy + r * 0.30,
    );
    canvas.drawPath(neckPath, paint);

    // ── Boca (linha) ──
    final mouthPath = Path();
    mouthPath.moveTo(cx + r * 0.22, cy + r * 0.20);
    mouthPath.quadraticBezierTo(
      cx + r * 0.50, cy + r * 0.38,
      cx + r * 0.52, cy + r * 0.15,
    );
    canvas.drawPath(mouthPath, paint);

    // ── Ondas de som ──
    final waveColor = active ? const Color(0xFF1C1C1C) : const Color(0xFF1C1C1C);
    final wavePaint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;

    final waveOriginX = cx + r * 0.72;
    final waveOriginY = cy + r * 0.22;

    // Onda 1
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveOriginX - r * 0.12, waveOriginY),
        width: r * 0.72,
        height: r * 1.0,
      ),
      -0.65, 1.3, false, wavePaint,
    );

    // Onda 2
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveOriginX - r * 0.12, waveOriginY),
        width: r * 1.18,
        height: r * 1.55,
      ),
      -0.65, 1.3, false, wavePaint,
    );

    // Onda 3
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(waveOriginX - r * 0.12, waveOriginY),
        width: r * 1.65,
        height: r * 2.1,
      ),
      -0.65, 1.3, false, wavePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _VoiceIconPainter old) =>
      old.active != active;
}
