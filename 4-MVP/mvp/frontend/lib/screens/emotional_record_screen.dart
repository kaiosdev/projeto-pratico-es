import 'package:flutter/material.dart';
import '../src/utils/validador_registro_emocional.dart';

class EmotionalRecordScreen extends StatefulWidget {
  const EmotionalRecordScreen({super.key});

  @override
  State<EmotionalRecordScreen> createState() => _EmotionalRecordScreenState();
}

class _EmotionalRecordScreenState extends State<EmotionalRecordScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  // ─── Estado do formulário ────────────────────────────────────────────────────
  String? _selectedEmoji;
  String? _selectedColor;
  int _escala = 5;
  final TextEditingController _notaController = TextEditingController();
  bool _saved = false;

  // ─── Dados disponíveis ───────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _emojis = [
    {'emoji': ':)', 'label': 'Feliz', 'color': Color(0xFFFFD700)},
    {'emoji': ':D', 'label': 'Animado', 'color': Color(0xFFFFA500)},
    {'emoji': ':(', 'label': 'Triste', 'color': Color(0xFF5C7AAA)},
    {'emoji': ':/', 'label': 'Incerto', 'color': Color(0xFF9B8EC4)},
    {'emoji': ':o', 'label': 'Surpreso', 'color': Color(0xFF6AAA7C)},
    {'emoji': ':P', 'label': 'Brincalhão', 'color': Color(0xFFF5B800)},
    {'emoji': '<3', 'label': 'Amoroso', 'color': Color(0xFFFF6B8A)},
    {'emoji': ';)', 'label': 'Piscadela', 'color': Color(0xFF8BC34A)},
    {'emoji': ':*', 'label': 'Carinhoso', 'color': Color(0xFFFF8A65)},
  ];

  static const List<Map<String, dynamic>> _colors = [
    {'hex': '#FFD700', 'label': 'Alegria', 'color': Color(0xFFFFD700)},
    {'hex': '#0000FF', 'label': 'Tristeza', 'color': Color(0xFF5C7AAA)},
    {'hex': '#FF0000', 'label': 'Raiva', 'color': Color(0xFFE53935)},
    {'hex': '#800080', 'label': 'Ansiedade', 'color': Color(0xFF9B8EC4)},
    {'hex': '#008000', 'label': 'Calma', 'color': Color(0xFF6AAA7C)},
    {'hex': '#808080', 'label': 'Neutro', 'color': Color(0xFF9E9E9E)},
  ];

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final resultado = ValidadorRegistroEmocional.registrarHumor(
      emoji: _selectedEmoji,
      escala: _escala,
      cor: _selectedColor,
    );

    if (!resultado.valido) {
      _showSnackBar(resultado.primeiroErro ?? 'Preencha todos os campos.',
          isError: true);
      return;
    }

    final notaErro =
        ValidadorRegistroEmocional.validarNota(_notaController.text);
    if (notaErro != null) {
      _showSnackBar(notaErro, isError: true);
      return;
    }

    // TODO: salvar no backend via Dio
    setState(() => _saved = true);
    _showSnackBar('Humor registrado com sucesso! 🎉');
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade700 : kDark,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Color get _currentColor {
    if (_selectedColor == null) return kYellow;
    return _colors.firstWhere(
      (c) => c['hex'] == _selectedColor,
      orElse: () => {'color': kYellow},
    )['color'] as Color;
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
              child: _saved ? _buildSuccess() : _buildForm(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Formulário ──────────────────────────────────────────────────────────────

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _currentColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: _currentColor, width: 2),
                ),
                child: Center(
                  child: Text(
                    _selectedEmoji ?? '?',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'COMO VOCÊ ESTÁ?',
                    style: TextStyle(
                      color: kDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'Registre seu humor de hoje',
                    style: TextStyle(
                      color: kDark.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ── Seção: Emoji ─────────────────────────────────────────────
          _SectionLabel(label: 'HUMOR', icon: Icons.tag_faces_rounded),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6,
            children: _emojis.map((e) {
              final isSelected = _selectedEmoji == e['emoji'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedEmoji = e['emoji']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (e['color'] as Color).withOpacity(0.2)
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? e['color'] as Color
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e['emoji'],
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        e['label'],
                        style: TextStyle(
                          color: kDark.withOpacity(0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Seção: Escala emocional ──────────────────────────────────
          _SectionLabel(
              label: 'ESCALA EMOCIONAL', icon: Icons.bar_chart_rounded),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Muito mal',
                        style: TextStyle(
                            color: kDark.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '$_escala / 10',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text('Ótimo',
                        style: TextStyle(
                            color: kDark.withOpacity(0.5),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _currentColor,
                    inactiveTrackColor:
                        _currentColor.withOpacity(0.2),
                    thumbColor: _currentColor,
                    overlayColor: _currentColor.withOpacity(0.15),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _escala.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) =>
                        setState(() => _escala = v.round()),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Seção: Cor ───────────────────────────────────────────────
          _SectionLabel(
              label: 'COR DO HUMOR', icon: Icons.palette_rounded),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _colors.map((c) {
              final isSelected = _selectedColor == c['hex'];
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedColor = c['hex']),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: c['color'] as Color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? kDark
                              : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (c['color'] as Color)
                                      .withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 18)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c['label'],
                      style: TextStyle(
                        color: kDark.withOpacity(0.6),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Seção: Nota textual ──────────────────────────────────────
          _SectionLabel(
              label: 'NOTA (OPCIONAL)',
              icon: Icons.edit_note_rounded),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _notaController,
              maxLines: 4,
              maxLength: 500,
              style: const TextStyle(
                  color: kDark, fontSize: 14, height: 1.5),
              decoration: InputDecoration(
                hintText:
                    'Como foi o seu dia? Descreva como está se sentindo...',
                hintStyle: TextStyle(
                    color: kDark.withOpacity(0.35), fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                counterStyle: TextStyle(
                    color: kDark.withOpacity(0.4), fontSize: 10),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Botão salvar ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text(
                'REGISTRAR HUMOR',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Link para histórico
          Center(
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmotionalHistoryScreen()),
              ),
              child: Text(
                'Ver histórico emocional →',
                style: TextStyle(
                  color: kDark.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ─── Tela de sucesso ─────────────────────────────────────────────────────────

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _currentColor.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _currentColor, width: 3),
              ),
              child: Center(
                child: Text(_selectedEmoji ?? ':)',
                    style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'HUMOR REGISTRADO!',
              style: TextStyle(
                color: kDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seu estado emocional foi salvo com sucesso.\nContinue cuidando da sua saúde mental!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDark.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EmotionalHistoryScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text(
                  'VER HISTÓRICO',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => setState(() {
                _saved = false;
                _selectedEmoji = null;
                _selectedColor = null;
                _escala = 5;
                _notaController.clear();
              }),
              child: Text(
                'Registrar novamente',
                style: TextStyle(
                  color: kDark.withOpacity(0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tela de Histórico Emocional ─────────────────────────────────────────────

class EmotionalHistoryScreen extends StatelessWidget {
  const EmotionalHistoryScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  // TODO: substituir por dados reais do backend
  static final List<Map<String, dynamic>> _mockHistory = [
    {
      'date': 'Hoje',
      'emoji': ':)',
      'label': 'Feliz',
      'escala': 8,
      'color': Color(0xFFFFD700),
      'nota': 'Tive um ótimo dia no trabalho!',
    },
    {
      'date': 'Ontem',
      'emoji': ':/',
      'label': 'Incerto',
      'escala': 5,
      'color': Color(0xFF9B8EC4),
      'nota': '',
    },
    {
      'date': '2 dias atrás',
      'emoji': ':D',
      'label': 'Animado',
      'escala': 9,
      'color': Color(0xFFFFA500),
      'nota': 'Ótima sessão de meditação pela manhã.',
    },
    {
      'date': '3 dias atrás',
      'emoji': ':(',
      'label': 'Triste',
      'escala': 3,
      'color': Color(0xFF5C7AAA),
      'nota': 'Dia difícil, mas consegui meditar.',
    },
    {
      'date': '4 dias atrás',
      'emoji': '<3',
      'label': 'Amoroso',
      'escala': 7,
      'color': Color(0xFFFF6B8A),
      'nota': '',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // AppBar
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

          // Corpo
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
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HISTÓRICO EMOCIONAL',
                          style: TextStyle(
                            color: kDark,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Seus últimos registros de humor',
                          style: TextStyle(
                            color: kDark.withOpacity(0.5),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Resumo semanal
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
                                  label: 'Média',
                                  value: '6.4',
                                  color: kYellow),
                              _StatBox(
                                  label: 'Melhor',
                                  value: '9',
                                  color: const Color(0xFF6AAA7C)),
                              _StatBox(
                                  label: 'Pior',
                                  value: '3',
                                  color: const Color(0xFF5C7AAA)),
                              _StatBox(
                                  label: 'Registros',
                                  value: '5',
                                  color: const Color(0xFF9B8EC4)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _mockHistory.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final h = _mockHistory[i];
                        return _HistoryCard(
                          date: h['date'],
                          emoji: h['emoji'],
                          label: h['label'],
                          escala: h['escala'],
                          color: h['color'],
                          nota: h['nota'],
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

class _SectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  static const Color kDark = Color(0xFF1C1C1C);

  const _SectionLabel({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: kDark.withOpacity(0.5), size: 16),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: kDark.withOpacity(0.5),
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
      ],
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
                color: color, fontSize: 22, fontWeight: FontWeight.w900)),
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
  final String date;
  final String emoji;
  final String label;
  final int escala;
  final Color color;
  final String nota;

  static const Color kDark = Color(0xFF1C1C1C);

  const _HistoryCard({
    required this.date,
    required this.emoji,
    required this.label,
    required this.escala,
    required this.color,
    required this.nota,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label,
                        style: const TextStyle(
                            color: kDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                    Text(date,
                        style: TextStyle(
                            color: kDark.withOpacity(0.4),
                            fontSize: 11,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        '$escala/10',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    if (nota.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nota,
                          style: TextStyle(
                              color: kDark.withOpacity(0.5),
                              fontSize: 11,
                              fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
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
