import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../src/utils/validador_registro_emocional.dart';
import 'emotional_entry_storage.dart'; // Persistência local dos registros de humor
import 'emotional_history_screen.dart'; // Tela que exibe o histórico salvo

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

  // ─── Lógica de Validação e Salvamento (US-06) ──────────────────────────────
  Future<void> _handleSave() async {
    final resultado = ValidadorRegistroEmocional.registrarHumor(
      emoji: _selectedEmoji,
      escala: _escala,
      cor: _selectedColor,
    );

    if (!resultado.valido) {
      _showSnackBar(resultado.primeiroErro ?? 'Preencha todos os campos.', isError: true);
      return;
    }

    final notaErro = ValidadorRegistroEmocional.validarNota(_notaController.text);
    if (notaErro != null) {
      _showSnackBar(notaErro, isError: true);
      return;
    }

    // SIMULAÇÃO: RN03 / AC5 - Verificar se já existe um registro hoje
    // TODO: Substituir pela checagem real na API via Dio no futuro
    bool jaExisteRegistroHoje = false; // Mude para true para testar o Alert

    if (jaExisteRegistroHoje) {
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Registro já existente', style: TextStyle(fontWeight: FontWeight.bold)),
          content: const Text('Você já possui um registro emocional salvo hoje. Deseja atualizá-lo com estas novas informações?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: kDark),
              child: const Text('Atualizar', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );

      // Se o usuário cancelou o dialog, interrompe o salvamento
      if (confirmar != true) return;
    }

    // Busca o label correto da cor selecionada para salvar no Storage
    String labelCor = 'Registro';
    if (_selectedColor != null) {
      final colorData = _colors.firstWhere((c) => c['hex'] == _selectedColor, orElse: () => {'label': 'Registro'});
      labelCor = colorData['label'] as String;
    }

    // Persiste localmente via EmotionalEntryStorage. Emoji e cor são opcionais
    // (ver ValidadorRegistroEmocional.registrarHumor): quando não selecionados,
    // usa-se uma string vazia e a cor neutra da paleta como valores padrão.
    await EmotionalEntryStorage.add(
      EmotionalEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateTime.now(),
        emoji: _selectedEmoji ?? '',
        label: labelCor,
        escala: _escala,
        colorHex: _selectedColor ?? '#808080',
        nota: _notaController.text,
      ),
    );

    setState(() => _saved = true);
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade700 : (isError == false && msg.contains('sucesso') ? Colors.green : kDark),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  border: Border.all(color: _currentColor, width: 2),
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
          const _SectionLabel(label: 'HUMOR', icon: Icons.tag_faces_rounded),
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
                key: Key('emoji_${e['emoji']}'), // Key para os testes automatizados
                onTap: () => setState(() => _selectedEmoji = e['emoji']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (e['color'] as Color).withOpacity(0.2)
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? e['color'] as Color : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        e['emoji'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
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
          const _SectionLabel(label: 'ESCALA EMOCIONAL', icon: Icons.bar_chart_rounded),
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
                        style: TextStyle(color: kDark.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
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
                        style: TextStyle(color: kDark.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: _currentColor,
                    inactiveTrackColor: _currentColor.withOpacity(0.2),
                    thumbColor: _currentColor,
                    overlayColor: _currentColor.withOpacity(0.15),
                    trackHeight: 6,
                  ),
                  child: Slider(
                    value: _escala.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    onChanged: (v) => setState(() => _escala = v.round()),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Seção: Cor ───────────────────────────────────────────────
          const _SectionLabel(label: 'COR DO HUMOR', icon: Icons.palette_rounded),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _colors.map((c) {
              final isSelected = _selectedColor == c['hex'];
              return GestureDetector(
                key: Key('cor_${c['hex']}'), // Key para os testes automatizados
                onTap: () => setState(() => _selectedColor = c['hex']),
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
                          color: isSelected ? kDark : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: (c['color'] as Color).withOpacity(0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                )
                              ]
                            : [],
                      ),
                      child: isSelected
                          ? const Icon(Icons.check_rounded, color: Colors.white, size: 18)
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
          const _SectionLabel(label: 'NOTA (OPCIONAL)', icon: Icons.edit_note_rounded),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              key: const Key('campo_nota'), // Key para os testes automatizados
              controller: _notaController,
              maxLines: 4,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              style: const TextStyle(color: kDark, fontSize: 14, height: 1.5),
              decoration: InputDecoration(
                hintText: 'Como foi o seu dia? Descreva como está se sentindo...',
                hintStyle: TextStyle(color: kDark.withOpacity(0.35), fontSize: 13),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                counterStyle: TextStyle(color: kDark.withOpacity(0.4), fontSize: 10),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Botão salvar ─────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              key: const Key('btn_salvar'), // Key para os testes automatizados
              onPressed: _handleSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: kDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              child: const Text(
                'Salvar registro', // Texto exato exigido pelos testes
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
                MaterialPageRoute(builder: (_) => const EmotionalHistoryScreen()),
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
                child: Text(_selectedEmoji ?? ':)', style: const TextStyle(fontSize: 36)),
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
                  MaterialPageRoute(builder: (_) => const EmotionalHistoryScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                child: const Text(
                  'VER HISTÓRICO',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 2),
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
          child: Text('SLOW', style: TextStyle(color: const Color(0xFFF5B800), fontSize: size * 0.45, fontWeight: FontWeight.w900, height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN', style: TextStyle(color: const Color(0xFF1C1C1C), fontSize: size * 0.72, fontWeight: FontWeight.w900, height: 1)),
      ],
    );
  }
}