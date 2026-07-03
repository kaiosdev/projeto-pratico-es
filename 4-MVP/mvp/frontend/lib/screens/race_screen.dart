import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class RaceScreen extends StatefulWidget {
  const RaceScreen({super.key});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> with TickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  // Pistas (3 faixas)
  static const int kLanes = 3;
  int _playerLane = 1; // 0, 1, 2

  // Estado do jogo
  bool _playing = false;
  bool _gameOver = false;
  int _score = 0;
  double _speed = 1.0;

  final Random _rng = Random();
  final List<_Obstacle> _obstacles = [];
  final List<_Coin> _coins = [];

  Timer? _gameLoop;
  Timer? _spawnTimer;
  Timer? _scoreTimer;

  late AnimationController _carController;
  late Animation<double> _carBounce;
  late AnimationController _laneController;
  late Animation<double> _laneAnim;
  int _targetLane = 1;

  // Posição Y dos obstáculos (0 = topo, 1 = baixo)
  double _roadOffset = 0;

  @override
  void initState() {
    super.initState();

    _carController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat(reverse: true);
    _carBounce = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeInOut),
    );

    _laneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _laneAnim = Tween<double>(begin: 1.0, end: 1.0).animate(_laneController);
  }

  void _startGame() {
    setState(() {
      _playing = true;
      _gameOver = false;
      _score = 0;
      _speed = 1.0;
      _playerLane = 1;
      _targetLane = 1;
      _obstacles.clear();
      _coins.clear();
      _roadOffset = 0;
    });

    // Loop de física ~60fps
    _gameLoop = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted || !_playing) return;
      _tick();
    });

    // Spawn de obstáculos e moedas
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1200), (_) {
      if (!_playing) return;
      _spawnObjects();
    });

    // Score e dificuldade
    _scoreTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_playing) return;
      setState(() {
        _score++;
        _speed = 1.0 + (_score / 20).clamp(0, 2.5);
      });
    });
  }

  void _tick() {
    setState(() {
      // Atualiza posição da estrada (efeito de movimento)
      _roadOffset = (_roadOffset + 0.02 * _speed) % 1.0;

      // Move obstáculos
      for (final o in _obstacles) {
        o.y += 0.018 * _speed;
      }
      // Move moedas
      for (final c in _coins) {
        c.y += 0.018 * _speed;
      }

      // Remove que saiu da tela
      _obstacles.removeWhere((o) => o.y > 1.2);
      _coins.removeWhere((c) => c.y > 1.2);

      // Colisão com obstáculos
      for (final o in _obstacles) {
        if (o.y > 0.72 && o.y < 0.88 && o.lane == _playerLane) {
          _endGame();
          return;
        }
      }

      // Coleta de moedas
      _coins.removeWhere((c) {
        if (c.y > 0.72 && c.y < 0.88 && c.lane == _playerLane) {
          _score += 3;
          return true;
        }
        return false;
      });
    });
  }

  void _spawnObjects() {
    if (!_playing) return;
    // Spawna 1–2 obstáculos em lanes aleatórias (mas sempre deixa pelo menos 1 livre)
    final blockedLanes = <int>{};
    final numObs = _rng.nextInt(2) + 1;
    for (int i = 0; i < numObs && blockedLanes.length < 2; i++) {
      int lane;
      do { lane = _rng.nextInt(kLanes); } while (blockedLanes.contains(lane));
      blockedLanes.add(lane);
      setState(() => _obstacles.add(_Obstacle(lane: lane, y: -0.15)));
    }

    // Moeda na lane livre
    if (_rng.nextDouble() < 0.5) {
      final freeLanes = List.generate(kLanes, (i) => i).where((l) => !blockedLanes.contains(l)).toList();
      if (freeLanes.isNotEmpty) {
        final lane = freeLanes[_rng.nextInt(freeLanes.length)];
        setState(() => _coins.add(_Coin(lane: lane, y: -0.15)));
      }
    }
  }

  void _endGame() {
    _gameLoop?.cancel();
    _spawnTimer?.cancel();
    _scoreTimer?.cancel();
    setState(() {
      _playing = false;
      _gameOver = true;
    });
  }

  void _changeLane(int delta) {
    if (!_playing) return;
    final next = (_playerLane + delta).clamp(0, kLanes - 1);
    if (next == _playerLane) return;

    final from = _laneAnim.value;
    _targetLane = next;
    _laneAnim = Tween<double>(begin: from.toDouble(), end: next.toDouble()).animate(
      CurvedAnimation(parent: _laneController, curve: Curves.easeOut),
    );
    _laneController.forward(from: 0);
    setState(() => _playerLane = next);
  }

  @override
  void dispose() {
    _gameLoop?.cancel();
    _spawnTimer?.cancel();
    _scoreTimer?.cancel();
    _carController.dispose();
    _laneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar
          Container(
            color: const Color(0xFF2E7D32),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () { _endGame(); Navigator.maybePop(context); },
                      child: Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Spacer(),
                    const Text('CORRIDA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: kYellow, size: 16),
                          const SizedBox(width: 4),
                          Text('$_score', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Área do jogo
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final laneW = w / kLanes;

              return GestureDetector(
                onHorizontalDragEnd: (d) {
                  if (d.primaryVelocity == null) return;
                  if (d.primaryVelocity! < -200) _changeLane(-1);
                  if (d.primaryVelocity! > 200) _changeLane(1);
                },
                child: Stack(
                  children: [
                    // Estrada
                    Container(color: const Color(0xFF388E3C)),

                    // Faixas da estrada
                    Positioned(
                      left: laneW - 3,
                      top: 0, bottom: 0,
                      child: Container(width: 3, color: Colors.white.withOpacity(0.3)),
                    ),
                    Positioned(
                      left: laneW * 2 - 3,
                      top: 0, bottom: 0,
                      child: Container(width: 3, color: Colors.white.withOpacity(0.3)),
                    ),

                    // Linhas de estrada animadas (tracejadas)
                    ...List.generate(10, (i) {
                      final y = ((i / 10 + _roadOffset) % 1.0) * h;
                      return Positioned(
                        left: laneW - 4,
                        top: y,
                        child: Container(width: 4, height: 30, color: Colors.white.withOpacity(0.6)),
                      );
                    }),
                    ...List.generate(10, (i) {
                      final y = ((i / 10 + _roadOffset) % 1.0) * h;
                      return Positioned(
                        left: laneW * 2 - 4,
                        top: y,
                        child: Container(width: 4, height: 30, color: Colors.white.withOpacity(0.6)),
                      );
                    }),

                    // Moedas
                    for (final c in _coins)
                      Positioned(
                        left: c.lane * laneW + laneW / 2 - 14,
                        top: c.y * h - 14,
                        child: Container(
                          width: 28, height: 28,
                          decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
                          child: const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                        ),
                      ),

                    // Obstáculos
                    for (final o in _obstacles)
                      Positioned(
                        left: o.lane * laneW + laneW / 2 - 22,
                        top: o.y * h - 22,
                        child: _ObstacleWidget(size: 44),
                      ),

                    // Carro do jogador
                    AnimatedBuilder(
                      animation: _laneAnim,
                      builder: (_, __) {
                        final laneX = _laneAnim.value * laneW + laneW / 2;
                        return AnimatedBuilder(
                          animation: _carBounce,
                          builder: (_, __) => Positioned(
                            left: laneX - 24,
                            top: h * 0.76 + _carBounce.value,
                            child: _CarWidget(playing: _playing),
                          ),
                        );
                      },
                    ),

                    // Botões de mudança de faixa
                    if (_playing)
                      Positioned(
                        bottom: 24,
                        left: 0, right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _LaneButton(icon: Icons.arrow_back_rounded, onTap: () => _changeLane(-1)),
                            _LaneButton(icon: Icons.arrow_forward_rounded, onTap: () => _changeLane(1)),
                          ],
                        ),
                      ),

                    // Tela inicial
                    if (!_playing && !_gameOver)
                      _buildOverlay(
                        context,
                        emoji: '🏎️',
                        title: 'CORRIDA',
                        subtitle: 'Desvie dos obstáculos e colete estrelas!\nArraste ou use os botões para mudar de faixa.',
                        buttonText: 'JOGAR',
                        onTap: _startGame,
                      ),

                    // Game Over
                    if (_gameOver)
                      _buildOverlay(
                        context,
                        emoji: '💥',
                        title: 'FIM DE JOGO',
                        subtitle: 'Você sobreviveu por $_score segundos!',
                        buttonText: 'JOGAR NOVAMENTE',
                        onTap: _startGame,
                        score: _score,
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, {
    required String emoji,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
    int? score,
  }) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(32),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: kDark,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kYellow, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 56)),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 14, height: 1.5), textAlign: TextAlign.center),
              if (score != null) ...[
                const SizedBox(height: 12),
                Text('⭐ $score pontos', style: const TextStyle(color: kYellow, fontSize: 20, fontWeight: FontWeight.w900)),
              ],
              const SizedBox(height: 20),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  width: double.infinity, height: 48,
                  decoration: BoxDecoration(color: kYellow, borderRadius: BorderRadius.circular(50)),
                  child: Center(child: Text(buttonText,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 2))),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: double.infinity, height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(color: Colors.white30, width: 1.5),
                  ),
                  child: const Center(child: Text('VOLTAR',
                      style: TextStyle(color: Colors.white60, fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 2))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Modelos ──────────────────────────────────────────────────────────────────

class _Obstacle { int lane; double y; _Obstacle({required this.lane, required this.y}); }
class _Coin { int lane; double y; _Coin({required this.lane, required this.y}); }

// ─── Widgets ──────────────────────────────────────────────────────────────────

class _CarWidget extends StatelessWidget {
  final bool playing;
  const _CarWidget({required this.playing});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(48, 80), painter: _CarPainter());
  }
}

class _CarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Corpo
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.15, w * 0.8, h * 0.65),
      const Radius.circular(8),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFF1565C0)..style = PaintingStyle.fill);

    // Janela
    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.22, w * 0.6, h * 0.28),
      const Radius.circular(4),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFF90CAF9)..style = PaintingStyle.fill);

    // Rodas
    for (final pos in [
      Offset(w * 0.08, h * 0.20),
      Offset(w * 0.92, h * 0.20),
      Offset(w * 0.08, h * 0.72),
      Offset(w * 0.92, h * 0.72),
    ]) {
      canvas.drawCircle(pos, w * 0.14,
          Paint()..color = const Color(0xFF212121)..style = PaintingStyle.fill);
      canvas.drawCircle(pos, w * 0.07,
          Paint()..color = const Color(0xFF616161)..style = PaintingStyle.fill);
    }

    // Faróis
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.15, h * 0.05, w * 0.28, h * 0.10), const Radius.circular(3)),
      Paint()..color = const Color(0xFFFFF9C4)..style = PaintingStyle.fill,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(w * 0.57, h * 0.05, w * 0.28, h * 0.10), const Radius.circular(3)),
      Paint()..color = const Color(0xFFFFF9C4)..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _ObstacleWidget extends StatelessWidget {
  final double size;
  const _ObstacleWidget({required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size(size, size * 1.5), painter: _ObstaclePainter());
  }
}

class _ObstaclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Carro obstáculo (vermelho)
    final body = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.1, h * 0.15, w * 0.8, h * 0.65),
      const Radius.circular(8),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFFB71C1C)..style = PaintingStyle.fill);

    final window = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.2, h * 0.40, w * 0.6, h * 0.28),
      const Radius.circular(4),
    );
    canvas.drawRRect(window, Paint()..color = const Color(0xFFEF9A9A)..style = PaintingStyle.fill);

    for (final pos in [
      Offset(w * 0.08, h * 0.20),
      Offset(w * 0.92, h * 0.20),
      Offset(w * 0.08, h * 0.72),
      Offset(w * 0.92, h * 0.72),
    ]) {
      canvas.drawCircle(pos, w * 0.14,
          Paint()..color = const Color(0xFF212121)..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

class _LaneButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _LaneButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64, height: 64,
        decoration: BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white30, width: 2),
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
