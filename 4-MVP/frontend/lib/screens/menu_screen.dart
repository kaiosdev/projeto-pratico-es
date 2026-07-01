import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),

                    // Botão PERFIL
                    _MenuButton(
                      label: 'PERFIL',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão CONFIGURAÇÕES
                    _MenuButton(
                      label: 'CONFIGURAÇÕES',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Botão SAIR
                    _MenuButton(
                      label: 'SAIR',
                      onTap: () {
                        // TODO: Firebase Auth signOut
                        // FirebaseAuth.instance.signOut();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),

                    const Spacer(),

                    // Botão modo escuro
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 40),
                        child: GestureDetector(
                          onTap: () {
                            // TODO: implementar dark mode
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: kYellow,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.dark_mode_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
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

// ─── Widget: Botão de menu ────────────────────────────────────────────────────

class _MenuButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  static const Color kYellow = Color(0xFFF5B800);

  const _MenuButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: kYellow,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}

// ─── Widget: Logo SlowDown ────────────────────────────────────────────────────

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
            horizontal: size * 0.14,
            vertical: size * 0.08,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1C),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'SLOW',
            style: TextStyle(
              color: const Color(0xFFF5B800),
              fontSize: size * 0.45,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        ),
        SizedBox(width: size * 0.08),
        Text(
          'DOWN',
          style: TextStyle(
            color: const Color(0xFF1C1C1C),
            fontSize: size * 0.72,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
            height: 1,
          ),
        ),
      ],
    );
  }
}
