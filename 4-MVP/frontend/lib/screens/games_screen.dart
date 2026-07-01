import 'package:flutter/material.dart';
import 'checkers_screen.dart';
import 'race_screen.dart';
import 'quiz_screen.dart';
import 'coming_soon_screen.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'JOGOS',
                      style: TextStyle(
                        color: kDark,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Relaxe e divirta-se',
                      style: TextStyle(
                        color: kDark.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Grid 2x2
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        children: [
                          _GameCard(
                            title: 'DAMA',
                            icon: Icons.grid_on_rounded,
                            color: const Color(0xFF5C4F8A),
                            bgColor: const Color(0xFFD4C9F0),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const CheckersScreen()),
                            ),
                          ),
                          _GameCard(
                            title: 'CORRIDA',
                            icon: Icons.directions_car_rounded,
                            color: const Color(0xFF2E7D32),
                            bgColor: const Color(0xFFC8E6C9),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RaceScreen()),
                            ),
                          ),
                          _GameCard(
                            title: 'QUIZ',
                            icon: Icons.quiz_rounded,
                            color: const Color(0xFF1565C0),
                            bgColor: const Color(0xFFBBDEFB),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const QuizScreen()),
                            ),
                          ),
                          _GameCard(
                            title: 'MAIS',
                            icon: Icons.lock_clock_rounded,
                            color: const Color(0xFFF5B800),
                            bgColor: const Color(0xFFFFF9C4),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const ComingSoonScreen()),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _GameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  static const Color kDark = Color(0xFF1C1C1C);

  const _GameCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
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
