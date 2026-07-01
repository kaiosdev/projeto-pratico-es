import 'package:flutter/material.dart';
import 'meditation_session_screen.dart';

class MeditationHistoryScreen extends StatelessWidget {
  const MeditationHistoryScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  // TODO: substituir por dados reais do backend
  static final List<Map<String, dynamic>> _mockHistory = [
    {
      'title': 'FOCO MENTAL',
      'duration': '10 min',
      'date': 'Hoje, 08:30',
      'completed': true,
      'icon': Icons.center_focus_strong_rounded,
      'color': Color(0xFF7C6FAA),
    },
    {
      'title': 'SONO PROFUNDO',
      'duration': '15 min',
      'date': 'Ontem, 22:15',
      'completed': true,
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF5C7AAA),
    },
    {
      'title': 'REDUZIR ANSIEDADE',
      'duration': '8 min',
      'date': 'Ontem, 14:00',
      'completed': false,
      'icon': Icons.spa_rounded,
      'color': Color(0xFF6AAA7C),
    },
    {
      'title': 'ENERGIA MATINAL',
      'duration': '5 min',
      'date': '2 dias atrás, 07:00',
      'completed': true,
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFAA8A5C),
    },
    {
      'title': 'FOCO MENTAL',
      'duration': '10 min',
      'date': '3 dias atrás, 09:00',
      'completed': true,
      'icon': Icons.center_focus_strong_rounded,
      'color': Color(0xFF7C6FAA),
    },
    {
      'title': 'SONO PROFUNDO',
      'duration': '15 min',
      'date': '4 dias atrás, 21:45',
      'completed': true,
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF5C7AAA),
    },
  ];

  int get _totalMinutes => _mockHistory
      .where((h) => h['completed'] == true)
      .fold(0, (sum, h) {
        final mins = int.tryParse(
                (h['duration'] as String).split(' ').first) ??
            0;
        return sum + mins;
      });

  int get _completedCount =>
      _mockHistory.where((h) => h['completed'] == true).length;

  int get _streak => 3; // TODO: calcular sequência real

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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HISTÓRICO DE\nMEDITAÇÕES',
                          style: TextStyle(
                            color: kDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ── Resumo semanal ───────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                            children: [
                              _StatBox(
                                label: 'Sessões',
                                value: '$_completedCount',
                                icon: Icons.check_circle_rounded,
                                color: const Color(0xFF6AAA7C),
                              ),
                              _StatBox(
                                label: 'Minutos',
                                value: '$_totalMinutes',
                                icon: Icons.timer_rounded,
                                color: const Color(0xFF7C6FAA),
                              ),
                              _StatBox(
                                label: 'Sequência',
                                value: '$_streak dias',
                                icon: Icons.local_fire_department_rounded,
                                color: const Color(0xFFF5B800),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'SESSÕES RECENTES',
                          style: TextStyle(
                            color: kDark.withOpacity(0.45),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  // ── Lista ────────────────────────────────────────────
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _mockHistory.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final h = _mockHistory[i];
                        return _HistoryCard(
                          title: h['title'],
                          duration: h['duration'],
                          date: h['date'],
                          completed: h['completed'],
                          icon: h['icon'],
                          color: h['color'],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MeditationSessionScreen(
                                title: h['title'],
                                duration: h['duration'],
                                color: h['color'],
                                icon: h['icon'],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widgets auxiliares ───────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  static const Color kDark = Color(0xFF1C1C1C);

  const _StatBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: kDark,
                fontSize: 16,
                fontWeight: FontWeight.w900)),
        Text(label,
            style: TextStyle(
                color: kDark.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String title;
  final String duration;
  final String date;
  final bool completed;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  static const Color kDark = Color(0xFF1C1C1C);

  const _HistoryCard({
    required this.title,
    required this.duration,
    required this.date,
    required this.completed,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border:
              Border.all(color: color.withOpacity(0.25), width: 1.5),
        ),
        child: Row(
          children: [
            // Ícone
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),

            const SizedBox(width: 14),

            // Informações
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: kDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 11,
                          color: kDark.withOpacity(0.4)),
                      const SizedBox(width: 3),
                      Text(duration,
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Icon(Icons.access_time_rounded,
                          size: 11,
                          color: kDark.withOpacity(0.4)),
                      const SizedBox(width: 3),
                      Text(date,
                          style: TextStyle(
                              color: kDark.withOpacity(0.45),
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),

            // Status
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: completed
                    ? const Color(0xFF6AAA7C)
                    : Colors.grey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                completed
                    ? Icons.check_rounded
                    : Icons.close_rounded,
                color: Colors.white,
                size: 16,
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
