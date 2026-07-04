import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Importe o validador que criamos para as regras de negócio
import '../src/utils/validador_registro_emocional.dart';

class RegistroEmocionalScreen extends StatefulWidget {
  const RegistroEmocionalScreen({super.key});

  @override
  State<RegistroEmocionalScreen> createState() => _RegistroEmocionalScreenState();
}

class _RegistroEmocionalScreenState extends State<RegistroEmocionalScreen> {
  // Paleta SlowDown
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  String? _selectedEmoji;
  int _escala = 5;
  String? _selectedCor;
  final TextEditingController _notaController = TextEditingController();

  final List<String> _emojis = [
    ':)', ':D', ':(', ':/', ':o', ':P', '<3', ';)', ':*'
  ];

  final Map<String, Color> _coresMap = {
    '#FF0000': const Color(0xFFE57373), // Raiva
    '#0000FF': const Color(0xFF64B5F6), // Tristeza
    '#FFD700': const Color(0xFFFFD54F), // Alegria
    '#808080': const Color(0xFFE0E0E0), // Neutro/Cansaço
    '#800080': const Color(0xFFBA68C8), // Ansiedade
    '#008000': const Color(0xFF81C784), // Calma
  };

  void _salvarRegistro() {
    // Valida as Regras de Negócio do TP3
    final validacao = ValidadorRegistroEmocional.registrarHumor(
      emoji: _selectedEmoji,
      escala: _escala,
      cor: _selectedCor,
    );

    final erroNota = ValidadorRegistroEmocional.validarNota(_notaController.text);

    if (!validacao.valido || erroNota != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(validacao.primeiroErro ?? erroNota!),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    // TODO: Aqui entrará a requisição HTTP POST para o Node.js (humorController.js) que criamos!

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro salvo com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _notaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kYellow,
        title: const Text('REGISTRO EMOCIONAL', style: TextStyle(color: kDark, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        iconTheme: const IconThemeData(color: kDark),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBgTop, kBgBottom],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // ─── Escolha do Emoji ───
            const Text('Como você está se sentindo hoje?', style: TextStyle(color: kDark, fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _emojis.map((emoji) {
                final isSelected = _selectedEmoji == emoji;
                return GestureDetector(
                  key: Key('emoji_$emoji'), // Key requerida pelo teste
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? kYellow : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? kDark : Colors.transparent, width: 2),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 26)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),

            // ─── Escala Emocional ───
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text('Intensidade do humor:', style: TextStyle(color: kDark, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
                Text('$_escala/10', style: const TextStyle(color: kDark, fontWeight: FontWeight.w900, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 8),
            Slider(
              value: _escala.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              activeColor: kDark,
              inactiveColor: kDark.withOpacity(0.2),
              onChanged: (val) => setState(() => _escala = val.toInt()),
            ),
            const SizedBox(height: 36),

            // ─── Cor do Humor ───
            const Text('Cor que representa seu estado:', style: TextStyle(color: kDark, fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: _coresMap.entries.map((entry) {
                final isSelected = _selectedCor == entry.key;
                return GestureDetector(
                  key: Key('cor_${entry.key}'), // Key requerida pelo teste
                  onTap: () => setState(() => _selectedCor = entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: entry.value,
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? kDark : Colors.transparent, width: 3),
                      boxShadow: isSelected ? [BoxShadow(color: kDark.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 4))] : [],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 36),

            // ─── Anotação Opcional ───
            const Text('Diário Emocional (Opcional):', style: TextStyle(color: kDark, fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 12),
            TextField(
              key: const Key('campo_nota'), // Key requerida pelo teste
              controller: _notaController,
              maxLength: 500,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              maxLines: 4,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withOpacity(0.5),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                hintText: 'Escreva sobre o que causou esse sentimento...',
                hintStyle: TextStyle(color: kDark.withOpacity(0.4)),
              ),
            ),
            const SizedBox(height: 32),

            // ─── Botão de Salvar ─── 
            SizedBox(
              height: 56,
              child: ElevatedButton(
                      key: const Key('btn_salvar'),
                      onPressed: _salvarRegistro,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDark,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Salvar registro', // Texto exato procurado pelo teste
                  style: TextStyle(color: kYellow, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 1),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}