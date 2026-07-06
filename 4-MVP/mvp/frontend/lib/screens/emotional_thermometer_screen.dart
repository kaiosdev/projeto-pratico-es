import 'dart:math';
import 'package:flutter/material.dart';
import 'emotional_entry_storage.dart' as record;

// ─── Ponte com o registro emocional real ───────────────────────────────────
//
// Depois de ver `emotional_record_screen.dart`, ajustei esta tela pra usar
// o MESMO storage compartilhado (`emotional_entry_storage.dart`) que agora
// o registro emocional usa pra salvar de verdade — e não mais uma chave
// própria com dados fake. A escala usada lá é 1 a 10 (não 1 a 5), então
// todo o cálculo abaixo foi ajustado para essa faixa.
//
// Se ainda não houver nenhum registro salvo (app recém-instalado, ou vocês
// ainda não tiverem rodado a versão atualizada do `emotional_record_screen`),
// mostramos 30 dias de exemplo só pra os gráficos não ficarem vazios —
// isso é substituído automaticamente assim que a pessoa registrar seu
// primeiro humor de verdade.

typedef EmotionalEntry = record.EmotionalEntry;

class EmotionalEntryStorage {
  static Future<List<EmotionalEntry>> load() async {
    final real = await record.EmotionalEntryStorage.loadAll();
    if (real.isNotEmpty) return real;

    // Dados de exemplo (últimos 30 dias, escala 1-10), só pra ilustrar os
    // gráficos antes do primeiro registro real existir.
    final random = Random(42);
    final now = DateTime.now();
    return List.generate(30, (i) {
      final day = now.subtract(Duration(days: 29 - i));
      final base = 6 + sin(i / 4) * 2.4;
      final score = (base + (random.nextDouble() - 0.5) * 2).clamp(1, 10).round();
      return EmotionalEntry(
        id: 'demo_$i',
        date: day,
        emoji: ':)',
        label: 'Exemplo',
        escala: score,
        colorHex: '#F5B800',
        nota: '',
      );
    });
  }
}

// ─── Insights (cálculos locais, sem IA) ─────────────────────────────────────

class EmotionalInsights {
  final List<EmotionalEntry> entries;
  EmotionalInsights(this.entries);

  List<EmotionalEntry> get last7Days {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return entries.where((e) => e.date.isAfter(cutoff)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<EmotionalEntry> get last30Days {
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    return entries.where((e) => e.date.isAfter(cutoff)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  double get weeklyAverage {
    final days = last7Days;
    if (days.isEmpty) return 0;
    return days.map((e) => e.escala).reduce((a, b) => a + b) / days.length;
  }

  /// Compara a média dos últimos 7 dias com os 7 dias anteriores.
  double get weeklyTrend {
    final now = DateTime.now();
    final thisWeek = entries.where((e) =>
        e.date.isAfter(now.subtract(const Duration(days: 7))));
    final lastWeek = entries.where((e) =>
        e.date.isAfter(now.subtract(const Duration(days: 14))) &&
        e.date.isBefore(now.subtract(const Duration(days: 7))));

    if (thisWeek.isEmpty || lastWeek.isEmpty) return 0;
    final avgThis = thisWeek.map((e) => e.escala).reduce((a, b) => a + b) / thisWeek.length;
    final avgLast = lastWeek.map((e) => e.escala).reduce((a, b) => a + b) / lastWeek.length;
    return avgThis - avgLast;
  }

  /// Agrupa os últimos 30 dias em 4 semanas (evolução mensal).
  List<double> get monthlyWeeklyAverages {
    final days = last30Days;
    final weeks = List.generate(4, (i) => <int>[]);
    final now = DateTime.now();

    for (final entry in days) {
      final diff = now.difference(entry.date).inDays;
      final weekIndex = (diff / 7).floor().clamp(0, 3);
      weeks[3 - weekIndex].add(entry.escala);
    }

    return weeks.map((w) => w.isEmpty ? 0.0 : w.reduce((a, b) => a + b) / w.length).toList();
  }

  List<String> get suggestions {
    final suggestions = <String>[];
    final avg = weeklyAverage;
    final trend = weeklyTrend;

    if (avg == 0) {
      suggestions.add('Registre seu humor por alguns dias para receber sugestões personalizadas.');
      return suggestions;
    }

    if (trend <= -0.5) {
      suggestions.add('Seu humor caiu um pouco essa semana. Que tal uma meditação guiada de 5 minutos hoje?');
    } else if (trend >= 0.5) {
      suggestions.add('Seu humor melhorou essa semana! Continue com o que está funcionando pra você.');
    }

    if (avg <= 4) {
      suggestions.add('Notei que os últimos dias foram difíceis. Conversar com o assistente do app pode ajudar a organizar os pensamentos.');
    } else if (avg >= 8) {
      suggestions.add('Você está com um humor ótimo! Bom momento para registrar o que tem feito diferente.');
    } else {
      suggestions.add('Seu humor está estável essa semana. Experimente uma sessão de respiração antes de dormir.');
    }

    suggestions.add('Manter o registro emocional em dia ajuda a identificar padrões com mais precisão.');
    return suggestions;
  }
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class EmotionalThermometerScreen extends StatefulWidget {
  const EmotionalThermometerScreen({super.key});

  @override
  State<EmotionalThermometerScreen> createState() => _EmotionalThermometerScreenState();
}

class _EmotionalThermometerScreenState extends State<EmotionalThermometerScreen>
    with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late TabController _tabController;
  bool _isLoading = true;
  EmotionalInsights? _insights;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await EmotionalEntryStorage.load();
    setState(() {
      _insights = EmotionalInsights(entries);
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Escala real do app é 1-10 (igual ao Slider do registro emocional).
  // Índice 0 fica sem uso (placeholder pra "sem dados").
  static const List<String> _moodLabels = [
    '', 'Péssimo', 'Péssimo', 'Ruim', 'Ruim', 'Neutro',
    'Neutro', 'Bom', 'Bom', 'Ótimo', 'Ótimo',
  ];
  static const List<Color> _moodColors = [
    Colors.transparent,
    Color(0xFFE05252), Color(0xFFE05252),
    Color(0xFFE0A052), Color(0xFFE0A052),
    Color(0xFFE0D052), Color(0xFFE0D052),
    Color(0xFF8FCB6E), Color(0xFF8FCB6E),
    Color(0xFF52B788), Color(0xFF52B788),
  ];

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBgTop,
        body: Center(child: CircularProgressIndicator(color: kYellow)),
      );
    }

    final insights = _insights!;
    final avg = insights.weeklyAverage;
    final avgRounded = avg.round().clamp(1, 10);

    return Scaffold(
      body: Column(
        children: [
          // ── AppBar ───────────────────────────────────────────────────
          Container(
            color: kDark,
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
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Text('Termômetro Emocional',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

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
                  _buildWeeklyTab(insights, avgRounded),
                  _buildMonthlyTab(insights),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTab(EmotionalInsights insights, int avgRounded) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Termômetro visual
        Center(
          child: Column(
            children: [
              Text(
                avgRounded == 0 ? '—' : _moodLabels[avgRounded],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: avgRounded == 0 ? kDark : _moodColors[avgRounded],
                ),
              ),
              const SizedBox(height: 12),
              _ThermometerGauge(value: insights.weeklyAverage, colors: _moodColors),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    insights.weeklyTrend > 0.2
                        ? Icons.trending_up_rounded
                        : (insights.weeklyTrend < -0.2 ? Icons.trending_down_rounded : Icons.trending_flat_rounded),
                    size: 18,
                    color: insights.weeklyTrend > 0.2
                        ? Colors.green
                        : (insights.weeklyTrend < -0.2 ? Colors.redAccent : Colors.black45),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    insights.weeklyTrend > 0.2
                        ? 'Melhorou em relação à semana passada'
                        : (insights.weeklyTrend < -0.2
                            ? 'Piorou em relação à semana passada'
                            : 'Estável em relação à semana passada'),
                    style: const TextStyle(color: kDark, fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 28),
        const Text('Últimos 7 dias', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 12),
        _WeeklyBarChart(entries: insights.last7Days, colors: _moodColors),

        const SizedBox(height: 28),
        const Text('Sugestões personalizadas',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 12),
        ...insights.suggestions.map((s) => _SuggestionCard(text: s)),
      ],
    );
  }

  Widget _buildMonthlyTab(EmotionalInsights insights) {
    final weeklyAverages = insights.monthlyWeeklyAverages;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('Evolução mensal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 4),
        const Text('Média de humor por semana, nos últimos 30 dias',
            style: TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 16),
        _MonthlyLineChart(weeklyAverages: weeklyAverages),
        const SizedBox(height: 24),
        ...List.generate(4, (i) {
          final avg = weeklyAverages[i];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Semana ${i + 1}', style: const TextStyle(fontWeight: FontWeight.w700, color: kDark)),
                Text(
                  avg == 0 ? 'Sem dados' : avg.toStringAsFixed(1),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: avg == 0 ? Colors.black38 : _moodColors[avg.round().clamp(1, 10)],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

// ─── Widget: Gauge do termômetro ────────────────────────────────────────────

class _ThermometerGauge extends StatelessWidget {
  final double value; // 0-5
  final List<Color> colors;
  const _ThermometerGauge({required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(240, 28),
      painter: _ThermometerPainter(value: value, colors: colors),
    );
  }
}

class _ThermometerPainter extends CustomPainter {
  final double value;
  final List<Color> colors;
  _ThermometerPainter({required this.value, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(trackRect, Paint()..color = Colors.black.withOpacity(0.08));

    final gradient = LinearGradient(colors: [colors[1], colors[5], colors[9]]);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final fillWidth = size.width * (value / 10).clamp(0.0, 1.0);

    canvas.save();
    canvas.clipRRect(trackRect);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, fillWidth, size.height),
      Paint()..shader = gradient.createShader(rect),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ThermometerPainter old) => old.value != value;
}

// ─── Widget: Gráfico de barras semanal ──────────────────────────────────────

class _WeeklyBarChart extends StatelessWidget {
  final List<EmotionalEntry> entries;
  final List<Color> colors;
  const _WeeklyBarChart({required this.entries, required this.colors});

  static const List<String> _weekdayLabels = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: Text('Sem registros nos últimos 7 dias', style: TextStyle(color: Colors.black45))),
      );
    }

    return SizedBox(
      height: 130,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: entries.map((entry) {
          final heightFactor = entry.escala / 10;
          final color = colors[entry.escala.clamp(1, 10)];
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 90 * heightFactor,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _weekdayLabels[entry.date.weekday % 7],
                    style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─── Widget: Gráfico de linha mensal ────────────────────────────────────────

class _MonthlyLineChart extends StatelessWidget {
  final List<double> weeklyAverages;
  const _MonthlyLineChart({required this.weeklyAverages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: CustomPaint(
        size: Size.infinite,
        painter: _LineChartPainter(values: weeklyAverages),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> values;
  _LineChartPainter({required this.values});

  static const Color kYellow = Color(0xFFF5B800);

  @override
  void paint(Canvas canvas, Size size) {
    final validValues = values.where((v) => v > 0).toList();
    if (validValues.isEmpty) return;

    final linePaint = Paint()
      ..color = kYellow
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final dotPaint = Paint()..color = kYellow;

    final path = Path();
    final stepX = size.width / (values.length - 1);

    for (int i = 0; i < values.length; i++) {
      final v = values[i] == 0 ? 5.5 : values[i];
      final x = stepX * i;
      final y = size.height - (v / 10) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, linePaint);

    for (int i = 0; i < values.length; i++) {
      if (values[i] == 0) continue;
      final x = stepX * i;
      final y = size.height - (values[i] / 10) * size.height;
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) => old.values != values;
}

// ─── Widget: Card de sugestão ────────────────────────────────────────────────

class _SuggestionCard extends StatelessWidget {
  final String text;
  const _SuggestionCard({required this.text});

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_rounded, color: kYellow, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: kDark, fontWeight: FontWeight.w500, height: 1.3, fontSize: 13.5)),
          ),
        ],
      ),
    );
  }
}
