import 'package:flutter/material.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFFFF9C4);
  static const Color kBgBottom = Color(0xFFFFF176);

  static const List<Map<String, dynamic>> _upcomingGames = [
    {'title': 'XADREZ', 'icon': Icons.castle_rounded, 'color': Color(0xFF5C4F8A)},
    {'title': 'MEMÓRIA', 'icon': Icons.grid_view_rounded, 'color': Color(0xFF2E7D32)},
    {'title': 'SUDOKU', 'icon': Icons.calculate_rounded, 'color': Color(0xFF1565C0)},
  ];

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
                    _SlowDownLogo(size: 28),
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
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Ícone principal
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: kYellow,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: kDark.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.lock_clock_rounded, color: Colors.white, size: 52),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'EM BREVE',
                      style: TextStyle(
                        color: kDark,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Novos jogos estão chegando!\nFique ligado nas atualizações.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDark.withOpacity(0.6),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Cards dos próximos jogos
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _upcomingGames.map((game) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: (game['color'] as Color).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: (game['color'] as Color).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(game['icon'] as IconData,
                                        color: (game['color'] as Color).withOpacity(0.5), size: 30),
                                    const Icon(Icons.lock_rounded, color: Colors.white54, size: 18),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                game['title'] as String,
                                style: TextStyle(
                                  color: kDark.withOpacity(0.5),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 48),

                    // Botão voltar
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kDark,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text(
                          'VOLTAR AOS JOGOS',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2),
                        ),
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
          decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(4)),
          child: Text('SLOW',
              style: TextStyle(color: const Color(0xFFF5B800), fontSize: size * 0.45, fontWeight: FontWeight.w900, height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN',
            style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: size * 0.72, fontWeight: FontWeight.w900, height: 1)),
      ],
    );
  }
}
