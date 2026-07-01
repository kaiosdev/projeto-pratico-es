import 'package:flutter/material.dart';
import 'meditation_screen.dart';

class AboutMeditationScreen extends StatelessWidget {
  const AboutMeditationScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kPurple = Color(0xFFB8A9D9);
  static const Color kPurpleDark = Color(0xFF7C6FAA);
  static const Color kPurpleLight = Color(0xFFD4C9F0);

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

          // ── Corpo roxo ───────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPurpleLight, kPurple],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // ── Porquinho / ícone de bem-estar ──────────────
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.self_improvement_rounded,
                          size: 56,
                          color: Color(0xFF5C4F8A),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Título ──────────────────────────────────────
                    const Text(
                      'SOBRE A\nMEDITAÇÃO',
                      style: TextStyle(
                        color: Color(0xFF3D3060),
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Texto descritivo ────────────────────────────
                    _InfoBlock(
                      title: 'O que é meditação?',
                      text:
                          'Meditação é uma prática que envolve treinar a atenção e a consciência para alcançar um estado mentalmente claro e emocionalmente calmo.',
                    ),

                    const SizedBox(height: 14),

                    _InfoBlock(
                      title: 'Benefícios',
                      text:
                          '• Redução do estresse e ansiedade\n• Melhora do foco e concentração\n• Sono mais profundo e reparador\n• Maior equilíbrio emocional\n• Aumento da criatividade',
                    ),

                    const SizedBox(height: 14),

                    _InfoBlock(
                      title: 'Como começar?',
                      text:
                          'Comece com sessões curtas de 5 a 10 minutos. Escolha um ambiente tranquilo, sente-se confortavelmente e foque na sua respiração.',
                    ),

                    const SizedBox(height: 32),

                    // ── Botão começar ────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MeditationScreen()),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5C4F8A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: const Text(
                          'COMEÇAR A MEDITAR',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
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

class _InfoBlock extends StatelessWidget {
  final String title;
  final String text;

  const _InfoBlock({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF3D3060),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFF4A3D7A),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.5,
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: size * 0.14, vertical: size * 0.08),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(4),
          ),
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
