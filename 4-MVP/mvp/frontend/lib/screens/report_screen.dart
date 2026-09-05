import 'dart:math';
import 'package:flutter/material.dart';
import 'emotional_entry_storage.dart';

// ─── Dados de exemplo: Meditação e BPM ──────────────────────────────────────
//
// `meditation_history_screen.dart` e `monitor_screen.dart` guardam seus
// dados em listas fixas (`_mockHistory` / `_history`), sem persistência real
// e sem timestamps (usam strings como 'Ontem, 22:15'), o que impede filtrar
// por período real.
//
// Para o filtro Semana/Mês funcionar hoje, esta tela usa dados de exemplo
// com `DateTime` real, gerados por `_mockMeditationSessions()` e
// `_mockBpmReadings()`. Quando meditação e monitoramento de BPM passarem a
// persistir de verdade (ex.: um storage local nos moldes de
// `EmotionalEntryStorage`, ou via backend), basta substituir essas duas
// funções por uma leitura real — o restante da tela (filtros, cálculos,
// cards) não precisa mudar.

class _MeditationSession {
  final DateTime date;
  final int minutes;
  final bool completed;

  _MeditationSession({
    required this.date,
    required this.minutes,
    required this.completed,
  });
}

class _BpmReading {
  final DateTime date;
  final int min;
  final int max;

  _BpmReading({required this.date, required this.min, required this.max});
}

List<_MeditationSession> _mockMeditationSessions() {
  final random = Random(7);
  final now = DateTime.now();
  return List.generate(20, (i) {
    final day = now.subtract(Duration(days: random.nextInt(29)));
    final durations = [5, 8, 10, 15];
    return _MeditationSession(
      date: day,
      minutes: durations[random.nextInt(durations.length)],
      completed: random.nextDouble() > 0.15,
    );
  });
}

List<_BpmReading> _mockBpmReadings() {
  final random = Random(3);
  final now = DateTime.now();
  return List.generate(30, (i) {
    final day = now.subtract(Duration(days: 29 - i));
    final base = 68 + random.nextInt(8);
    return _BpmReading(date: day, min: base, max: base + 8 + random.nextInt(6));
  });
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kEmotionColor = Color(0xFFF5B800);
  static const Color kMeditationColor = Color(0xFF7C6FAA);
  static const Color kBpmColor = Color(0xFFAA5C5C);

  late TabController _tabController;
  bool _isLoading = true;

  List<EmotionalEntry> _emotionalEntries = [];
  final List<_MeditationSession> _meditationSessions = _mockMeditationSessions();
  final List<_BpmReading> _bpmReadings = _mockBpmReadings();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await EmotionalEntryStorage.loadAll();
    setState(() {
      _emotionalEntries = entries;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ── Filtros por período ──────────────────────────────────────────────────

  List<EmotionalEntry> _emotionalInPeriod(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _emotionalEntries.where((e) => e.date.isAfter(cutoff)).toList();
  }

  List<_MeditationSession> _meditationInPeriod(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _meditationSessions.where((m) => m.date.isAfter(cutoff)).toList();
  }

  List<_BpmReading> _bpmInPeriod(int days) {
    final cutoff = DateTime.now().subtract(Duration(days: days));
    return _bpmReadings.where((b) => b.date.isAfter(cutoff)).toList();
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
            color: kDark,
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
                    const Text(
                      'Relatório',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 17),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // ── Tabs de período ──────────────────────────────────────────
          Container(
            color: kDark,
            child: TabBar(
              controller: _tabController,
              indicatorColor: kYellow,
              labelColor: kYellow,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Semana'),
                Tab(text: 'Mês'),
              ],
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
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReportTab(7),
                  _buildReportTab(30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTab(int days) {
    final emotional = _emotionalInPeriod(days);
    final meditation = _meditationInPeriod(days);
    final bpm = _bpmInPeriod(days);

    final periodLabel = days == 7 ? 'nos últimos 7 dias' : 'nos últimos 30 dias';

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Resumo $periodLabel',
          style: TextStyle(
              color: kDark.withOpacity(0.5),
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // ── Seção emocional ──────────────────────────────────────────
        _ReportSection(
          icon: Icons.mood_rounded,
          color: kEmotionColor,
          title: 'REGISTRO EMOCIONAL',
          child: emotional.isEmpty
              ? const _EmptyNotice(text: 'Nenhum registro de humor no período.')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(
                      label: 'Média',
                      value: (emotional.map((e) => e.escala).reduce((a, b) => a + b) /
                              emotional.length)
                          .toStringAsFixed(1),
                      color: kEmotionColor,
                    ),
                    _StatBox(
                      label: 'Melhor dia',
                      value: '${emotional.map((e) => e.escala).reduce((a, b) => a > b ? a : b)}/10',
                      color: const Color(0xFF6AAA7C),
                    ),
                    _StatBox(
                      label: 'Pior dia',
                      value: '${emotional.map((e) => e.escala).reduce((a, b) => a < b ? a : b)}/10',
                      color: const Color(0xFF5C7AAA),
                    ),
                    _StatBox(
                      label: 'Registros',
                      value: '${emotional.length}',
                      color: kDark,
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 16),

        // ── Seção meditação ──────────────────────────────────────────
        _ReportSection(
          icon: Icons.self_improvement_rounded,
          color: kMeditationColor,
          title: 'MEDITAÇÃO',
          child: meditation.isEmpty
              ? const _EmptyNotice(text: 'Nenhuma sessão de meditação no período.')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(
                      label: 'Sessões',
                      value:
                          '${meditation.where((m) => m.completed).length}',
                      color: kMeditationColor,
                    ),
                    _StatBox(
                      label: 'Minutos',
                      value: '${meditation.where((m) => m.completed).fold<int>(0, (sum, m) => sum + m.minutes)}',
                      color: kMeditationColor,
                    ),
                    _StatBox(
                      label: 'Taxa concl.',
                      value:
                          '${((meditation.where((m) => m.completed).length / meditation.length) * 100).round()}%',
                      color: kMeditationColor,
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 16),

        // ── Seção BPM ─────────────────────────────────────────────────
        _ReportSection(
          icon: Icons.favorite_rounded,
          color: kBpmColor,
          title: 'FREQUÊNCIA CARDÍACA',
          child: bpm.isEmpty
              ? const _EmptyNotice(text: 'Nenhuma leitura de BPM no período.')
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatBox(
                      label: 'Média mín.',
                      value:
                          '${(bpm.map((b) => b.min).reduce((a, b) => a + b) / bpm.length).round()}',
                      color: kBpmColor,
                    ),
                    _StatBox(
                      label: 'Média máx.',
                      value:
                          '${(bpm.map((b) => b.max).reduce((a, b) => a + b) / bpm.length).round()}',
                      color: kBpmColor,
                    ),
                    _StatBox(
                      label: 'Leituras',
                      value: '${bpm.length}',
                      color: kDark,
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 24),

        // ── Nota sobre exportação ─────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: kDark.withOpacity(0.4), size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Exportação em PDF ainda não disponível nesta versão.',
                  style: TextStyle(
                      color: kDark.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Widgets auxiliares ───────────────────────────────────────────────────────

class _ReportSection extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final Widget child;

  static const Color kDark = Color(0xFF1C1C1C);

  const _ReportSection({
    required this.icon,
    required this.color,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: kDark.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  static const Color kDark = Color(0xFF1C1C1C);

  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(label,
            style: TextStyle(
                color: kDark.withOpacity(0.5),
                fontSize: 10,
                fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _EmptyNotice extends StatelessWidget {
  final String text;
  const _EmptyNotice({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: TextStyle(
            color: const Color(0xFF1C1C1C).withOpacity(0.4),
            fontSize: 12,
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
