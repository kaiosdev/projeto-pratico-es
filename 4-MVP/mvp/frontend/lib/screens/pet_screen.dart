import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pet_skin_screen.dart';

// ─── Modelo de Status do Pet ──────────────────────────────────────────────────

class PetStatus {
  double hunger;    // 0–100 (100 = cheio)
  double happiness; // 0–100
  double energy;    // 0–100

  PetStatus({
    this.hunger = 80,
    this.happiness = 80,
    this.energy = 80,
  });

  // Humor geral do pet (usado para mudar expressão)
  String get mood {
    final avg = (hunger + happiness + energy) / 3;
    if (avg >= 70) return 'happy';
    if (avg >= 40) return 'neutral';
    return 'sad';
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('pet_hunger', hunger);
    await prefs.setDouble('pet_happiness', happiness);
    await prefs.setDouble('pet_energy', energy);
  }

  static Future<PetStatus> load() async {
    final prefs = await SharedPreferences.getInstance();
    return PetStatus(
      hunger: prefs.getDouble('pet_hunger') ?? 80,
      happiness: prefs.getDouble('pet_happiness') ?? 80,
      energy: prefs.getDouble('pet_energy') ?? 80,
    );
  }
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> with TickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;
  late AnimationController _fireworkController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool _isShowingFireworks = false;
  String _currentSkin = 'default';
  String _currentRace = 'cat';
  String? _hat;
  String? _glasses;

  late PetStatus _status;
  bool _isLoading = true;
  Timer? _decayTimer;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fireworkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _loadData();
    _startDecayTimer();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await PetStatus.load();
    setState(() {
      _status = status;
      _currentRace = prefs.getString('pet_race') ?? 'cat';
      _hat = prefs.getString('pet_hat');
      _glasses = prefs.getString('pet_glasses');
      _isLoading = false;
    });
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_race', _currentRace);
    await prefs.setString('pet_hat', _hat ?? '');
    await prefs.setString('pet_glasses', _glasses ?? '');
    await _status.save();
  }

  /// Decai os status do pet a cada 30 segundos (simula necessidades)
  void _startDecayTimer() {
    _decayTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (!mounted) return;
      setState(() {
        _status.hunger = (_status.hunger - 3).clamp(0, 100);
        _status.happiness = (_status.happiness - 2).clamp(0, 100);
        _status.energy = (_status.energy - 1.5).clamp(0, 100);
      });
      _status.save();
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fireworkController.dispose();
    _shakeController.dispose();
    _decayTimer?.cancel();
    super.dispose();
  }

  void _onStart() async {
    if (_status.energy < 10) {
      // Pet cansado demais para jogar
      _shakeController.forward(from: 0);
      _showSnack('Seu pet está cansado! Deixe ele descansar. 😴');
      return;
    }

    final result = await Navigator.push<Map<String, double>>(
      context,
      MaterialPageRoute(
        builder: (_) => _PetGameScreen(race: _currentRace, hat: _hat, glasses: _glasses),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _status.happiness = (_status.happiness + result['happiness']!).clamp(0, 100);
        _status.energy = (_status.energy - result['energyCost']!).clamp(0, 100);
        _status.hunger = (_status.hunger - result['hungerCost']!).clamp(0, 100);
      });
      await _saveAll();

      _showFireworks();
      _showSnack('Seu pet ficou mais feliz! 🎉');
    }
  }

  void _showFireworks() {
    setState(() => _isShowingFireworks = true);
    _fireworkController.forward(from: 0).then((_) {
      if (mounted) setState(() => _isShowingFireworks = false);
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: kDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Alimentar o pet
  void _feedPet() {
    if (_status.hunger >= 100) {
      _showSnack('Seu pet já está cheio! 🍽️');
      return;
    }
    setState(() {
      _status.hunger = (_status.hunger + 20).clamp(0, 100);
      _status.happiness = (_status.happiness + 5).clamp(0, 100);
    });
    _saveAll();
    _showSnack('Nhom nhom! Seu pet comeu! 🍖');
  }

  /// Descansar o pet
  void _restPet() {
    if (_status.energy >= 100) {
      _showSnack('Seu pet está cheio de energia! ⚡');
      return;
    }
    setState(() {
      _status.energy = (_status.energy + 25).clamp(0, 100);
    });
    _saveAll();
    _showSnack('Zzz... Seu pet descansou! 💤');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBgTop,
        body: Center(child: CircularProgressIndicator(color: kYellow)),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ───────────────────────────────────────────────────
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
                    GestureDetector(
                      onTap: _openSkins,
                      child: const Icon(Icons.style_rounded, color: Colors.white, size: 28),
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
              child: Stack(
                children: [
                  // Grama
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 120,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFB8E88A), Color(0xFF8BC34A)],
                        ),
                      ),
                    ),
                  ),

                  // Fogos
                  if (_isShowingFireworks)
                    AnimatedBuilder(
                      animation: _fireworkController,
                      builder: (_, __) => _FireworksOverlay(
                        progress: _fireworkController.value,
                      ),
                    ),

                  // Conteúdo
                  Column(
                    children: [
                      // ── Barras de Status ─────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: _StatusBars(status: _status),
                      ),

                      const Spacer(),

                      // ── Pet animado ──────────────────────────────
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (_, child) => AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (_, __) => Transform.translate(
                            offset: Offset(
                              _shakeController.isAnimating ? _shakeAnimation.value : 0,
                              _floatAnimation.value,
                            ),
                            child: child,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(200, 200),
                              painter: _PetPainter(
                                race: _currentRace,
                                mood: _status.mood,
                              ),
                            ),
                            if (_hat != null)
                              Positioned(
                                top: 10,
                                child: _HatWidget(hat: _hat!),
                              ),
                            if (_glasses != null)
                              Positioned(
                                top: 72,
                                child: _GlassesWidget(glasses: _glasses!),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Ações rápidas (alimentar / descansar) ────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ActionButton(
                            icon: Icons.restaurant_rounded,
                            label: 'Alimentar',
                            color: const Color(0xFFFF7043),
                            onTap: _feedPet,
                          ),
                          const SizedBox(width: 16),
                          _ActionButton(
                            icon: Icons.bedtime_rounded,
                            label: 'Descansar',
                            color: const Color(0xFF5C6BC0),
                            onTap: _restPet,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Botão START ──────────────────────────────
                      GestureDetector(
                        onTap: _onStart,
                        child: Container(
                          width: 140,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kDark,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: kDark.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              'START',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 3,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Botão Skins ──────────────────────────────
                      GestureDetector(
                        onTap: _openSkins,
                        child: Container(
                          width: 140,
                          height: 44,
                          decoration: BoxDecoration(
                            color: kYellow,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              'SKINS',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openSkins() async {
    final result = await Navigator.push<Map<String, String?>>(
      context,
      MaterialPageRoute(
        builder: (_) => PetSkinScreen(
          currentHat: _hat,
          currentGlasses: _glasses,
          currentRace: _currentRace,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _hat = result['hat'];
        _glasses = result['glasses'];
        _currentRace = result['race'] ?? 'cat';
      });
      _saveAll();
    }
  }
}

// ─── Barras de Status ─────────────────────────────────────────────────────────

class _StatusBars extends StatelessWidget {
  final PetStatus status;
  const _StatusBars({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _StatusBar(
            icon: Icons.restaurant_rounded,
            label: 'Fome',
            value: status.hunger,
            color: const Color(0xFFFF7043),
          ),
          const SizedBox(height: 8),
          _StatusBar(
            icon: Icons.favorite_rounded,
            label: 'Felicidade',
            value: status.happiness,
            color: const Color(0xFFEC407A),
          ),
          const SizedBox(height: 8),
          _StatusBar(
            icon: Icons.bolt_rounded,
            label: 'Energia',
            value: status.energy,
            color: const Color(0xFF42A5F5),
          ),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;
  final Color color;

  const _StatusBar({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        SizedBox(
          width: 68,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1C),
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 10,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                value > 50 ? color : color.withOpacity(0.6),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '${value.toInt()}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}

// ─── Botão de ação rápida ─────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Minijogo: Pegue as Estrelas ──────────────────────────────────────────────

class _PetGameScreen extends StatefulWidget {
  final String race;
  final String? hat;
  final String? glasses;

  const _PetGameScreen({required this.race, this.hat, this.glasses});

  @override
  State<_PetGameScreen> createState() => _PetGameScreenState();
}

class _PetGameScreenState extends State<_PetGameScreen>
    with TickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  final Random _rng = Random();
  final List<_Star> _stars = [];
  int _score = 0;
  int _timeLeft = 20;
  Timer? _gameTimer;
  Timer? _spawnTimer;
  bool _gameOver = false;

  late AnimationController _petController;
  late Animation<double> _petFloat;
  double _petX = 0.5; // posição horizontal do pet (0–1)

  @override
  void initState() {
    super.initState();

    _petController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _petFloat = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _petController, curve: Curves.easeInOut),
    );

    _startGame();
  }

  void _startGame() {
    // Timer principal (contagem regressiva)
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _spawnTimer?.cancel();
        setState(() => _gameOver = true);
      }
    });

    // Spawn de estrelas
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 800), (_) {
      if (!mounted || _gameOver) return;
      setState(() {
        _stars.add(_Star(
          x: _rng.nextDouble() * 0.85 + 0.07,
          y: 0,
          speed: 0.008 + _rng.nextDouble() * 0.006,
          color: [kYellow, Colors.pinkAccent, Colors.lightBlueAccent, Colors.greenAccent][_rng.nextInt(4)],
        ));
      });
    });

    // Loop de física (move as estrelas)
    Timer.periodic(const Duration(milliseconds: 16), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_gameOver) { t.cancel(); return; }
      setState(() {
        for (final star in _stars) {
          star.y += star.speed;
        }
        // Verificar colisão com pet
        _stars.removeWhere((star) {
          final dist = (star.x - _petX).abs();
          if (star.y > 0.72 && star.y < 0.88 && dist < 0.12) {
            _score++;
            return true;
          }
          return star.y > 1.1;
        });
      });
    });
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _spawnTimer?.cancel();
    _petController.dispose();
    super.dispose();
  }

  void _movePet(DragUpdateDetails d, BoxConstraints constraints) {
    setState(() {
      _petX = (_petX + d.delta.dx / constraints.maxWidth).clamp(0.08, 0.92);
    });
  }

  void _finishGame() {
    // Calcula recompensas baseadas no score
    final happiness = (_score * 3.0).clamp(5.0, 40.0);
    final energyCost = 15.0;
    final hungerCost = 10.0;

    Navigator.pop(context, {
      'happiness': happiness,
      'energyCost': energyCost,
      'hungerCost': hungerCost,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;

            return Stack(
              children: [
                // ── Fundo estrelado ──────────────────────────────
                ...List.generate(20, (i) => Positioned(
                  left: (i * 47.3) % w,
                  top: (i * 83.7) % (h * 0.7),
                  child: Container(
                    width: 2,
                    height: 2,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3 + (i % 3) * 0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                )),

                // ── HUD (score + timer) ──────────────────────────
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Score
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: kYellow,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('$_score',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                      // Timer
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _timeLeft <= 5 ? Colors.red : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer_rounded, color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text('${_timeLeft}s',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Estrelas caindo ──────────────────────────────
                for (final star in _stars)
                  Positioned(
                    left: star.x * w - 14,
                    top: star.y * h - 14,
                    child: Icon(
                      Icons.star_rounded,
                      color: star.color,
                      size: 28,
                    ),
                  ),

                // ── Pet controlável ──────────────────────────────
                GestureDetector(
                  onHorizontalDragUpdate: (d) => _movePet(d, constraints),
                  onPanUpdate: (d) => _movePet(d, constraints),
                  child: Container(
                    color: Colors.transparent,
                    width: w,
                    height: h,
                    child: AnimatedBuilder(
                      animation: _petFloat,
                      builder: (_, child) => Stack(
                        children: [
                          Positioned(
                            left: _petX * w - 55,
                            top: h * 0.73 + _petFloat.value,
                            child: child!,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(110, 110),
                            painter: _PetPainter(race: widget.race, mood: 'happy'),
                          ),
                          if (widget.hat != null)
                            Positioned(top: 5, child: _HatWidget(hat: widget.hat!)),
                          if (widget.glasses != null)
                            Positioned(top: 38, child: _GlassesWidget(glasses: widget.glasses!)),
                        ],
                      ),
                    ),
                  ),
                ),

                // Instrução de arraste
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      'Arraste para mover o pet! ← →',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // ── Game Over ────────────────────────────────────
                if (_gameOver)
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(32),
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1C),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: kYellow, width: 2),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('⭐ FIM DE JOGO!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                )),
                            const SizedBox(height: 12),
                            Text('Você pegou $_score estrelas!',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                )),
                            const SizedBox(height: 8),
                            Text(
                              _score >= 10
                                  ? 'Incrível! Seu pet adorou! 🥳'
                                  : _score >= 5
                                      ? 'Bom jogo! Seu pet ficou feliz! 😄'
                                      : 'Continue tentando! Seu pet ainda te ama 💛',
                              style: const TextStyle(color: Colors.white60, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '+${(_score * 3).clamp(5, 40)} Felicidade',
                              style: const TextStyle(
                                color: Color(0xFFEC407A),
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _finishGame,
                              child: Container(
                                width: double.infinity,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: kYellow,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text('VOLTAR',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                        letterSpacing: 2,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Modelo de estrela ────────────────────────────────────────────────────────

class _Star {
  double x;
  double y;
  final double speed;
  final Color color;

  _Star({required this.x, required this.y, required this.speed, required this.color});
}

// ─── Painter: Pet ─────────────────────────────────────────────────────────────

class _PetPainter extends CustomPainter {
  final String race;
  final String mood; // 'happy', 'neutral', 'sad'

  const _PetPainter({required this.race, this.mood = 'happy'});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Color bodyColor;
    switch (race) {
      case 'dog':
        bodyColor = const Color(0xFFD4A96A);
        break;
      case 'robot':
        bodyColor = const Color(0xFFB0BEC5);
        break;
      case 'monk':
        bodyColor = const Color(0xFFF5C842);
        break;
      case 'aviator':
        bodyColor = const Color(0xFFE8C49A);
        break;
      default:
        bodyColor = const Color(0xFFF5C842);
    }

    final bodyPaint = Paint()
      ..color = bodyColor
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

    if (race == 'robot') {
      final body = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.65), width: w * 0.55, height: h * 0.45),
        const Radius.circular(10),
      );
      canvas.drawRRect(body, bodyPaint);
      canvas.drawRRect(body, outlinePaint);

      final head = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(w * 0.5, h * 0.34), width: w * 0.52, height: h * 0.44),
        const Radius.circular(10),
      );
      canvas.drawRRect(head, bodyPaint);
      canvas.drawRRect(head, outlinePaint);

      // Olhos LED — cor muda com humor
      final ledColor = mood == 'happy'
          ? const Color(0xFF00E5FF)
          : mood == 'sad'
              ? const Color(0xFFFF5252)
              : const Color(0xFFFFFF00);

      canvas.drawRect(
        Rect.fromCenter(center: Offset(w * 0.38, h * 0.31), width: w * 0.10, height: h * 0.08),
        Paint()..color = ledColor..style = PaintingStyle.fill,
      );
      canvas.drawRect(
        Rect.fromCenter(center: Offset(w * 0.62, h * 0.31), width: w * 0.10, height: h * 0.08),
        Paint()..color = ledColor..style = PaintingStyle.fill,
      );
    } else {
      // Corpo padrão
      final bodyPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.65),
          width: w * 0.62,
          height: h * 0.52,
        ));
      canvas.drawPath(bodyPath, bodyPaint);
      canvas.drawPath(bodyPath, outlinePaint);

      final headPath = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(w * 0.5, h * 0.36),
          width: w * 0.58,
          height: h * 0.50,
        ));
      canvas.drawPath(headPath, bodyPaint);
      canvas.drawPath(headPath, outlinePaint);

      if (race == 'dog') {
        final leftEar = Path()
          ..moveTo(w * 0.22, h * 0.18)
          ..cubicTo(w * 0.08, h * 0.22, w * 0.10, h * 0.40, w * 0.22, h * 0.44)
          ..lineTo(w * 0.28, h * 0.22)
          ..close();
        canvas.drawPath(leftEar, bodyPaint);
        canvas.drawPath(leftEar, outlinePaint);

        final rightEar = Path()
          ..moveTo(w * 0.78, h * 0.18)
          ..cubicTo(w * 0.92, h * 0.22, w * 0.90, h * 0.40, w * 0.78, h * 0.44)
          ..lineTo(w * 0.72, h * 0.22)
          ..close();
        canvas.drawPath(rightEar, bodyPaint);
        canvas.drawPath(rightEar, outlinePaint);
      } else {
        final leftEar = Path()
          ..moveTo(w * 0.24, h * 0.22)
          ..lineTo(w * 0.16, h * 0.06)
          ..lineTo(w * 0.36, h * 0.14)
          ..close();
        canvas.drawPath(leftEar, bodyPaint);
        canvas.drawPath(leftEar, outlinePaint);

        final rightEar = Path()
          ..moveTo(w * 0.76, h * 0.22)
          ..lineTo(w * 0.84, h * 0.06)
          ..lineTo(w * 0.64, h * 0.14)
          ..close();
        canvas.drawPath(rightEar, bodyPaint);
        canvas.drawPath(rightEar, outlinePaint);
      }

      // Olhos
      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.38, h * 0.33), width: w * 0.10, height: h * 0.10),
        darkFill,
      );
      canvas.drawCircle(Offset(w * 0.40, h * 0.31), w * 0.02, whiteFill);

      canvas.drawOval(
        Rect.fromCenter(center: Offset(w * 0.62, h * 0.33), width: w * 0.10, height: h * 0.10),
        darkFill,
      );
      canvas.drawCircle(Offset(w * 0.64, h * 0.31), w * 0.02, whiteFill);

      // Nariz
      final nosePath = Path()
        ..moveTo(w * 0.5, h * 0.40)
        ..lineTo(w * 0.46, h * 0.44)
        ..lineTo(w * 0.54, h * 0.44)
        ..close();
      canvas.drawPath(nosePath, darkFill);

      // Boca — muda com o humor
      final mouthPaint = Paint()
        ..color = const Color(0xFF1C1C1C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;

      if (mood == 'happy') {
        // Sorriso
        canvas.drawLine(Offset(w * 0.5, h * 0.44), Offset(w * 0.44, h * 0.49), mouthPaint);
        canvas.drawLine(Offset(w * 0.5, h * 0.44), Offset(w * 0.56, h * 0.49), mouthPaint);
      } else if (mood == 'neutral') {
        // Linha reta
        canvas.drawLine(Offset(w * 0.43, h * 0.47), Offset(w * 0.57, h * 0.47), mouthPaint);
      } else {
        // Tristeza
        canvas.drawLine(Offset(w * 0.44, h * 0.49), Offset(w * 0.5, h * 0.45), mouthPaint);
        canvas.drawLine(Offset(w * 0.56, h * 0.49), Offset(w * 0.5, h * 0.45), mouthPaint);
      }

      // Lágrimas se triste
      if (mood == 'sad') {
        final tearPaint = Paint()
          ..color = Colors.lightBlueAccent.withOpacity(0.8)
          ..style = PaintingStyle.fill;
        canvas.drawOval(
          Rect.fromCenter(center: Offset(w * 0.38, h * 0.42), width: w * 0.04, height: h * 0.05),
          tearPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(w * 0.62, h * 0.42), width: w * 0.04, height: h * 0.05),
          tearPaint,
        );
      }

      // Bigodes
      if (race != 'dog') {
        final whiskerPaint = Paint()
          ..color = const Color(0xFF1C1C1C)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(w * 0.18, h * 0.40), Offset(w * 0.42, h * 0.43), whiskerPaint);
        canvas.drawLine(Offset(w * 0.18, h * 0.44), Offset(w * 0.42, h * 0.45), whiskerPaint);
        canvas.drawLine(Offset(w * 0.82, h * 0.40), Offset(w * 0.58, h * 0.43), whiskerPaint);
        canvas.drawLine(Offset(w * 0.82, h * 0.44), Offset(w * 0.58, h * 0.45), whiskerPaint);
      }

      // Rabo
      final tailPath = Path()
        ..moveTo(w * 0.72, h * 0.82)
        ..cubicTo(w * 0.90, h * 0.78, w * 0.95, h * 0.60, w * 0.80, h * 0.55);
      canvas.drawPath(tailPath, outlinePaint);

      // Patas
      for (final cx in [w * 0.38, w * 0.62]) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, h * 0.88), width: w * 0.18, height: h * 0.10),
          bodyPaint,
        );
        canvas.drawOval(
          Rect.fromCenter(center: Offset(cx, h * 0.88), width: w * 0.18, height: h * 0.10),
          outlinePaint,
        );
      }

      // Toga do monge
      if (race == 'monk') {
        final togaPaint = Paint()
          ..color = const Color(0xFFE57C1A)
          ..style = PaintingStyle.fill;
        final toga = Path()
          ..moveTo(w * 0.25, h * 0.55)
          ..lineTo(w * 0.20, h * 0.80)
          ..lineTo(w * 0.80, h * 0.80)
          ..lineTo(w * 0.75, h * 0.55)
          ..close();
        canvas.drawPath(toga, togaPaint);
        canvas.drawPath(toga, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PetPainter old) =>
      old.race != race || old.mood != mood;
}

// ─── Widget: Chapéu ───────────────────────────────────────────────────────────

class _HatWidget extends StatelessWidget {
  final String hat;
  const _HatWidget({required this.hat});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;

    switch (hat) {
      case 'noel':
        icon = Icons.hotel_class_rounded;
        color = Colors.red;
        break;
      case 'bucket':
        icon = Icons.inbox_rounded;
        color = Colors.blue;
        break;
      case 'mafioso':
        icon = Icons.shield_rounded;
        color = Colors.black;
        break;
      case 'cartola':
        icon = Icons.looks_one_rounded;
        color = Colors.black;
        break;
      default:
        icon = Icons.hardware_rounded;
        color = const Color(0xFF8B4513);
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}

// ─── Widget: Óculos ───────────────────────────────────────────────────────────

class _GlassesWidget extends StatelessWidget {
  final String glasses;
  const _GlassesWidget({required this.glasses});

  @override
  Widget build(BuildContext context) {
    Color frameColor;
    switch (glasses) {
      case 'aviador':
        frameColor = const Color(0xFFDAA520);
        break;
      case 'de_grau':
        frameColor = Colors.black87;
        break;
      default:
        frameColor = Colors.black87;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 22,
          decoration: BoxDecoration(
            border: Border.all(color: frameColor, width: 2.5),
            borderRadius: BorderRadius.circular(glasses == 'aviador' ? 50 : 4),
            color: frameColor.withOpacity(0.15),
          ),
        ),
        Container(width: 10, height: 2, color: frameColor),
        Container(
          width: 32,
          height: 22,
          decoration: BoxDecoration(
            border: Border.all(color: frameColor, width: 2.5),
            borderRadius: BorderRadius.circular(glasses == 'aviador' ? 50 : 4),
            color: frameColor.withOpacity(0.15),
          ),
        ),
      ],
    );
  }
}

// ─── Fogos de artifício ───────────────────────────────────────────────────────

class _FireworksOverlay extends StatelessWidget {
  final double progress;
  const _FireworksOverlay({required this.progress});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: _FireworksPainter(progress: progress),
    );
  }
}

class _FireworksPainter extends CustomPainter {
  final double progress;
  const _FireworksPainter({required this.progress});

  static const List<Color> _colors = [
    Color(0xFFF5B800),
    Color(0xFFFF4444),
    Color(0xFF44FF44),
    Color(0xFF4444FF),
    Color(0xFFFF44FF),
  ];

  static const List<Offset> _centers = [
    Offset(0.2, 0.3),
    Offset(0.8, 0.25),
    Offset(0.5, 0.2),
    Offset(0.15, 0.5),
    Offset(0.85, 0.45),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;

    for (int f = 0; f < _centers.length; f++) {
      final delay = f * 0.15;
      final localProgress = ((progress - delay) / 0.6).clamp(0.0, 1.0);
      if (localProgress <= 0) continue;

      final cx = _centers[f].dx * size.width;
      final cy = _centers[f].dy * size.height;
      final color = _colors[f % _colors.length];
      final maxR = size.width * 0.15;

      for (int i = 0; i < 12; i++) {
        final angle = (i / 12) * 2 * pi;
        final r = maxR * localProgress;
        final x = cx + r * cos(angle);
        final y = cy + r * sin(angle);
        final opacity = (1 - localProgress).clamp(0.0, 1.0);

        canvas.drawCircle(
          Offset(x, y),
          4,
          Paint()..color = color.withOpacity(opacity),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter old) => old.progress != progress;
}

// ─── Logo ─────────────────────────────────────────────────────────────────────

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
          child: Text('SLOW',
              style: TextStyle(
                color: const Color(0xFFF5B800),
                fontSize: size * 0.45,
                fontWeight: FontWeight.w900,
                height: 1,
              )),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN',
            style: TextStyle(
              color: const Color(0xFF1C1C1C),
              fontSize: size * 0.72,
              fontWeight: FontWeight.w900,
              height: 1,
            )),
      ],
    );
  }
}