import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';

class MeditationScreen extends StatelessWidget {
  const MeditationScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kPurple = Color(0xFF9B8EC4);

  static final List<Map<String, dynamic>> _sessions = [
    {
      'title': 'FOCO MENTAL',
      'duration': '10 min',
      'icon': Icons.center_focus_strong_rounded,
      'color': const Color(0xFF7C6FAA),
    },
    {
      'title': 'SONO PROFUNDO',
      'duration': '15 min',
      'icon': Icons.bedtime_rounded,
      'color': const Color(0xFF5C7AAA),
    },
    {
      'title': 'REDUZIR ANSIEDADE',
      'duration': '8 min',
      'icon': Icons.spa_rounded,
      'color': const Color(0xFF6AAA7C),
    },
    {
      'title': 'ENERGIA MATINAL',
      'duration': '5 min',
      'icon': Icons.wb_sunny_rounded,
      'color': const Color(0xFFAA8A5C),
    },
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
              child: Column(
                children: [
                  // Gatinho + título
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 24),
                    child: Row(
                      children: [
                        // Gatinho meditando
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: kYellow.withOpacity(0.4),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.self_improvement_rounded,
                            size: 46,
                            color: Color(0xFF7C6FAA),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MEDITAÇÃO',
                              style: TextStyle(
                                color: kDark,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                            Text(
                              'Escolha sua sessão',
                              style: TextStyle(
                                color: kDark.withOpacity(0.55),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Lista de sessões
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _sessions.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final s = _sessions[i];
                        return _SessionCard(
                          title: s['title'],
                          duration: s['duration'],
                          icon: s['icon'],
                          color: s['color'],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MeditationSessionScreen(
                                title: s['title'],
                                duration: s['duration'],
                                color: s['color'],
                                icon: s['icon'],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Um pequeno espaçamento no final para a lista não colar no rodapé da tela
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final String title;
  final String duration;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SessionCard({
    required this.title,
    required this.duration,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.18),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.35), width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1C1C1C),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    duration,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.play_circle_filled_rounded, color: color, size: 32),
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