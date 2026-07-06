import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

// ─── Modelo simples de perfil inicial ───────────────────────────────────────
//
// Assim como no onboarding, isso salva localmente por enquanto
// (SharedPreferences). Quando o backend estiver plugado, o ideal é:
//   • trocar `_ProfileSetupData.save()` por uma chamada ao
//     `AuthRepository`/Dio, no mesmo padrão do `auth_provider.dart`
//     (ex: repo.atualizarPerfil(apelido: ..., objetivo: ...));
//   • manter o salvamento local como cache otimista, igual já é feito
//     no registro emocional.

class ProfileSetupData {
  static Future<void> save({
    required String apelido,
    required String objetivo,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perfil_apelido', apelido);
    await prefs.setString('perfil_objetivo', objetivo);
    await prefs.setBool('perfil_configurado', true);
  }

  static Future<bool> isConfigured() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('perfil_configurado') ?? false;
  }
}

class _Goal {
  final String id;
  final String label;
  final IconData icon;

  const _Goal({required this.id, required this.label, required this.icon});
}

const List<_Goal> _goals = [
  _Goal(id: 'ansiedade', label: 'Reduzir ansiedade', icon: Icons.spa_rounded),
  _Goal(id: 'sono', label: 'Dormir melhor', icon: Icons.bedtime_rounded),
  _Goal(id: 'foco', label: 'Melhorar o foco', icon: Icons.center_focus_strong_rounded),
  _Goal(id: 'humor', label: 'Entender meu humor', icon: Icons.mood_rounded),
];

// ─── Tela Principal ───────────────────────────────────────────────────────────

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  final TextEditingController _apelidoController = TextEditingController();
  String? _selectedGoal;
  bool _saving = false;

  @override
  void dispose() {
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _goToHome() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _saving = true);
    await ProfileSetupData.save(
      apelido: _apelidoController.text.trim(),
      objetivo: _selectedGoal ?? '',
    );
    if (!mounted) return;
    await _goToHome();
  }

  void _handleSkip() => _goToHome();

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _handleSkip,
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

                const SizedBox(height: 8),

                const Text(
                  'VAMOS NOS\nCONHECER?',
                  style: TextStyle(
                    color: kDark,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isso ajuda a personalizar sua experiência no SlowDown.',
                  style: TextStyle(
                    color: kDark.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Apelido ─────────────────────────────────────────────
                Text(
                  'COMO PODEMOS TE CHAMAR?',
                  style: TextStyle(
                    color: kDark.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextField(
                    controller: _apelidoController,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(color: kDark, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Seu apelido',
                      hintStyle: TextStyle(color: kDark.withOpacity(0.3)),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // ── Objetivo principal ──────────────────────────────────
                Text(
                  'QUAL É SEU OBJETIVO PRINCIPAL?',
                  style: TextStyle(
                    color: kDark.withOpacity(0.5),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: _goals.map((goal) {
                    final isSelected = _selectedGoal == goal.id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGoal = goal.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected ? kYellow.withOpacity(0.25) : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? kYellow : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(goal.icon,
                                color: isSelected ? kYellow : kDark.withOpacity(0.5), size: 26),
                            const SizedBox(height: 6),
                            Text(
                              goal.label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: kDark.withOpacity(0.75),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 36),

                // ── Botão salvar ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                          )
                        : const Text(
                            'CONCLUIR',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 2),
                          ),
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
