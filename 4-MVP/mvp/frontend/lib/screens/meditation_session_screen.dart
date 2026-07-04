import 'dart:async';
import 'package:flutter/material.dart';

class MeditationSessionScreen extends StatefulWidget {
  final String title;
  final String duration;
  final Color color;
  final IconData icon;

  const MeditationSessionScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.color,
    required this.icon,
  });

  @override
  State<MeditationSessionScreen> createState() =>
      _MeditationSessionScreenState();
}

class _MeditationSessionScreenState extends State<MeditationSessionScreen>
    with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  late int _totalSeconds;
  late int _remaining;
  Timer? _timer;
  bool _running = false;
  bool _finished = false;

  late AnimationController _breathController;
  late Animation<double> _breathAnimation;

  static const List<String> _steps = [
    'Feche os olhos e respire fundo.',
    'Inspire pelo nariz por 4 segundos.',
    'Segure o ar por 4 segundos.',
    'Expire lentamente pela boca.',
    'Repita e foque no presente.',
  ];

  @override
  void initState() {
    super.initState();
    final mins = int.tryParse(widget.duration.split(' ').first) ?? 5;
    _totalSeconds = mins * 60;
    _remaining = _totalSeconds;

    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _breathAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breathController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_finished) {
      setState(() {
        _remaining = _totalSeconds;
        _finished = false;
        _running = false;
      });
      _breathController.stop();
      _breathController.reset();
      return;
    }

    if (_running) {
      _timer?.cancel();
      _breathController.stop();
    } else {
      _breathController.repeat(reverse: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (_remaining <= 0) {
          _timer?.cancel();
          _breathController.stop();
          setState(() {
            _finished = true;
            _running = false;
          });
        } else {
          setState(() => _remaining--);
        }
      });
    }

    setState(() => _running = !_running);
  }

  String get _timeString {
    final m = (_remaining ~/ 60).toString().padLeft(2, '0');
    final s = (_remaining % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  double get _progress =>
      _totalSeconds > 0 ? 1 - (_remaining / _totalSeconds) : 0;

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
                    _SlowDownLogo(size: 28),
                    const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
          ),

          // ── Corpo ────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.color.withOpacity(0.25),
                    widget.color.withOpacity(0.05),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // Título
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: kDark,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Círculo de respiração animado ────────────────
                    AnimatedBuilder(
                      animation: _breathAnimation,
                      builder: (_, __) => Transform.scale(
                        scale: _running ? _breathAnimation.value : 1.0,
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.color.withOpacity(0.2),
                            border: Border.all(
                                color: widget.color, width: 3),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(widget.icon,
                                  color: widget.color, size: 48),
                              const SizedBox(height: 8),
                              Text(
                                _finished ? '✓' : _timeString,
                                style: TextStyle(
                                  color: widget.color,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Barra de progresso
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 8,
                        backgroundColor:
                            widget.color.withOpacity(0.15),
                        valueColor:
                            AlwaysStoppedAnimation<Color>(widget.color),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Botão Play/Pause ─────────────────────────────
                    GestureDetector(
                      onTap: _toggleTimer,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: widget.color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _finished
                              ? Icons.replay_rounded
                              : _running
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ── Passos da meditação ──────────────────────────
                    ...List.generate(_steps.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 26,
                              height: 26,
                              margin: const EdgeInsets.only(right: 10, top: 1),
                              decoration: BoxDecoration(
                                color: widget.color,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _steps[i],
                                style: TextStyle(
                                  color: kDark.withOpacity(0.75),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
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

class _SlowDownLogo extends StatelessWidget {
  final double size;
  const _SlowDownLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: size * 0.14, vertical: size * 0.08),
          decoration: BoxDecoration(
              color: const Color(0xFF1C1C1C),
              borderRadius: BorderRadius.circular(4)),
          child: Text('SLOW',
              style: TextStyle(
                  color: const Color(0xFFF5B800),
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN',
            style: TextStyle(
                color: const Color(0xFF1C1C1C),
                fontSize: size * 0.72,
                fontWeight: FontWeight.w900,
                height: 1)),
      ],
    );
  }
}
