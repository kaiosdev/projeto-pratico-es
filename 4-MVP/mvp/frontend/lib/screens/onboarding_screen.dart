import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_setup_screen.dart';

// ─── Controle de "já viu o onboarding" ──────────────────────────────────────
//
// Guarda uma flag simples no SharedPreferences pra essa tela só aparecer
// uma vez na vida do usuário (primeiro cadastro). Chame
// `OnboardingGate.shouldShow()` no ponto de entrada do app (ex: depois do
// cadastro, ou na Splash) pra decidir se mostra o onboarding ou vai direto
// pra Home/Login.

class OnboardingGate {
  static const _key = 'onboarding_completed';

  static Future<bool> shouldShow() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_key) ?? false);
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingSlide({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}

const List<_OnboardingSlide> _slides = [
  _OnboardingSlide(
    icon: Icons.self_improvement_rounded,
    title: 'Encontre seu equilíbrio',
    description:
        'Meditações guiadas, sons relaxantes e exercícios de respiração pra desacelerar quando o dia pedir.',
    color: Color(0xFF7C6FAA),
  ),
  _OnboardingSlide(
    icon: Icons.favorite_rounded,
    title: 'Cuide da sua saúde emocional',
    description:
        'Registre seu humor, acompanhe sua frequência cardíaca e receba insights sobre como você está de verdade.',
    color: Color(0xFFAA5C5C),
  ),
  _OnboardingSlide(
    icon: Icons.pets_rounded,
    title: 'Evolua com seu pet virtual',
    description:
        'Cada hábito saudável alimenta seu companheiro. Jogue, relaxe e cresça junto com ele.',
    color: Color(0xFF6AAA7C),
  ),
];

// ─── Tela Principal ───────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentPage == _slides.length - 1;

  Future<void> _finishOnboarding() async {
    await OnboardingGate.markCompleted();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
    );
  }

  void _nextPage() {
    if (_isLastPage) {
      _finishOnboarding();
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kBgTop, kBgBottom],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Botão Pular ──────────────────────────────────────────
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: TextButton(
                    onPressed: _finishOnboarding,
                    child: Text(
                      'PULAR',
                      style: TextStyle(
                        color: kDark.withOpacity(0.5),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Slides ───────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (context, i) => _SlideContent(slide: _slides[i]),
                ),
              ),

              // ── Indicadores de página ────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_slides.length, (i) {
                    final active = i == _currentPage;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: active ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: active ? _slides[_currentPage].color : kDark.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    );
                  }),
                ),
              ),

              // ── Botão avançar / começar ───────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      _isLastPage ? 'COMEÇAR' : 'PRÓXIMO',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideContent extends StatelessWidget {
  final _OnboardingSlide slide;
  const _SlideContent({required this.slide});

  static const Color kDark = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(slide.icon, color: slide.color, size: 64),
          ),
          const SizedBox(height: 40),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kDark,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            slide.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: kDark.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
