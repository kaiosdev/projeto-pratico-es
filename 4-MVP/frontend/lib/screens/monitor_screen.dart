import 'dart:math';
import 'package:flutter/material.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({super.key});

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen>
    with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  // BPM simulado — substituir por sensor real
  int _bpm = 80;
  bool _monitoring = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Histórico de BPM por dia (simulado)
  final List<Map<String, dynamic>> _history = [
    {'day': 'Segunda', 'min': 70, 'max': 78},
    {'day': 'Terça', 'min': 70, 'max': 75},
    {'day': 'Quarta', 'min': 72, 'max': 76},
    {'day': 'Quinta', 'min': 70, 'max': 78},
    {'day': 'Sexta', 'min': 70, 'max': 80},
    {'day': 'Sábado', 'min': 70, 'max': 80},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMonitor() {
    setState(() => _monitoring = !_monitoring);
    if (_monitoring) {
      _pulseController.repeat(reverse: true);
      // Simula variação de BPM
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _monitoring) {
          setState(() {
            _bpm = 72 + Random().nextInt(16);
          });
        }
      });
    } else {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  // Faixa saudável padrão alinhada ao defeito corrigido (Ambiguidade/Omissão,
  // item 10 do relatório de inspeção) e ao ValidadorBpm: 60 a 100 BPM.
  Color get _bpmColor {
    if (_bpm < 60) return const Color(0xFF5C7AAA);
    if (_bpm < 100) return const Color(0xFF6AAA7C);
    return const Color(0xFFAA5C5C);
  }

  String get _bpmLabel {
    if (_bpm < 60) return 'ABAIXO DO NORMAL';
    if (_bpm < 100) return 'NORMAL';
    return 'ELEVADO';
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const _SlowDownLogo(size: 28),
                    const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // ── Velocímetro BPM ──────────────────────────────
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (_, child) => Transform.scale(
                        scale: _monitoring ? _pulseAnimation.value : 1.0,
                        child: child,
                      ),
                      child: CustomPaint(
                        size: const Size(220, 220),
                        painter: _SpeedometerPainter(
                          bpm: _bpm,
                          color: _bpmColor,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // BPM e status
                    Text(
                      '$_bpm BPM',
                      style: TextStyle(
                        color: _bpmColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      _bpmLabel,
                      style: TextStyle(
                        color: _bpmColor.withOpacity(0.7),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botão START/STOP
                    GestureDetector(
                      onTap: _toggleMonitor,
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: _monitoring ? kDark : kYellow,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Text(
                            _monitoring ? 'PARAR' : 'START',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Histórico semanal ────────────────────────────
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'HISTÓRICO SEMANAL',
                        style: TextStyle(
                          color: kDark.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ..._history.map((h) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _HistoryRow(
                            day: h['day'],
                            min: h['min'],
                            max: h['max'],
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Painter: Velocímetro ─────────────────────────────────────────────────────

class _SpeedometerPainter extends CustomPainter {
  final int bpm;
  final Color color;

  const _SpeedometerPainter({required this.bpm, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    const startAngle = pi * 0.75;
    const sweepAngle = pi * 1.5;

    // Trilha cinza
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2),
      startAngle,
      sweepAngle,
      false,
      Paint()
        ..color = Colors.grey.withOpacity(0.2)
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Arco colorido — escala visual do velocímetro (40 a 180 BPM), usada
    // apenas para posicionar o preenchimento do arco proporcionalmente.
    // Esta escala é puramente decorativa e não define a classificação
    // Normal/Alerta, que é feita por _bpmColor/_bpmLabel (60–100 BPM),
    // alinhada ao ValidadorBpm.
    final pct = ((bpm - 40) / 140).clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2),
      startAngle,
      sweepAngle * pct,
      false,
      Paint()
        ..color = color
        ..strokeWidth = 14
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Ícone de coração
    final iconPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(cx - 18, cy - 14);
    final heart = Path()
      ..moveTo(18, 30)
      ..cubicTo(4, 20, 0, 14, 0, 10)
      ..cubicTo(0, 4, 6, 0, 12, 0)
      ..cubicTo(15, 0, 18, 2, 18, 4)
      ..cubicTo(18, 2, 21, 0, 24, 0)
      ..cubicTo(30, 0, 36, 4, 36, 10)
      ..cubicTo(36, 14, 32, 20, 18, 30)
      ..close();
    canvas.scale(0.5);
    canvas.drawPath(heart, iconPaint);
    canvas.restore();

    // Marcas de escala
    for (int i = 0; i <= 6; i++) {
      final angle = startAngle + (sweepAngle / 6) * i;
      final x1 = cx + (r - 20) * cos(angle);
      final y1 = cy + (r - 20) * sin(angle);
      final x2 = cx + (r - 8) * cos(angle);
      final y2 = cy + (r - 8) * sin(angle);
      canvas.drawLine(
        Offset(x1, y1),
        Offset(x2, y2),
        Paint()
          ..color = Colors.grey.withOpacity(0.4)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter old) =>
      old.bpm != bpm || old.color != color;
}

// ─── Widget: Linha do histórico ───────────────────────────────────────────────

class _HistoryRow extends StatelessWidget {
  final String day;
  final int min;
  final int max;

  static const Color kDark = Color(0xFF1C1C1C);

  const _HistoryRow({required this.day, required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              day,
              style: const TextStyle(
                color: kDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Média: $min a $max BPM',
              style: TextStyle(
                color: kDark.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.favorite_rounded, color: Color(0xFF6AAA7C), size: 16),
        ],
      ),
    );
  }
}

class _SlowDownLogo extends StatelessWidget {
  final double size;
  const _SlowDownLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: size * 0.14, vertical: size * 0.08),
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
            height: 1,
          ),
        ),
      ],
    );
  }
}