import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _silentMode = false;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  // TODO: carregar dados reais do Firebase Auth / Firestore
  static const String _userName = 'Ken Takakura';
  static const String _userStatus = 'Online';

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
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 24),
                children: [
                  // ── Card do usuário ──────────────────────────────────
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade300,
                          border: Border.all(color: kDark, width: 2),
                        ),
                        child: Icon(Icons.person,
                            size: 28, color: Colors.grey.shade600),
                        // TODO: trocar por foto do usuário
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _userName,
                            style: const TextStyle(
                              color: kDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                _userStatus,
                                style: TextStyle(
                                  color: kDark.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Label SETTINGS ───────────────────────────────────
                  Text(
                    'SETTINGS',
                    style: TextStyle(
                      color: kDark.withOpacity(0.45),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Item: Language ───────────────────────────────────
                  _SettingsItem(
                    icon: Icons.language_rounded,
                    title: 'ENGLISH',
                    subtitle: 'LANGUAGE',
                    trailing: const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFF1C1C1C),
                      size: 22,
                    ),
                    onTap: () {
                      // TODO: tela de seleção de idioma
                    },
                  ),

                  const SizedBox(height: 10),

                  // ── Item: Silent Mode ────────────────────────────────
                  _SettingsItem(
                    icon: Icons.volume_off_rounded,
                    title: 'SILENT MODE',
                    subtitle: 'NOTIFICATIONS & MESSAGE',
                    trailing: Transform.scale(
                      scale: 0.85,
                      child: Switch(
                        value: _silentMode,
                        onChanged: (val) =>
                            setState(() => _silentMode = val),
                        activeColor: Colors.white,
                        activeTrackColor: kDark,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: kDark,
                      ),
                    ),
                    onTap: () =>
                        setState(() => _silentMode = !_silentMode),
                  ),

                  const SizedBox(height: 10),

                  // ── Item: Device Permissions ─────────────────────────
                  _SettingsItem(
                    icon: Icons.smartphone_rounded,
                    title: 'CAMERA, LOCATION, & MICROPHONE',
                    subtitle: 'DEVICE PERMISSIONS',
                    trailing: const SizedBox.shrink(),
                    onTap: () {
                      // TODO: abrir configurações do dispositivo
                    },
                  ),

                  const SizedBox(height: 10),

                  // ── Item: Mobile Data ────────────────────────────────
                  _SettingsItem(
                    icon: Icons.storage_rounded,
                    title: 'HIGHEST QUALITY',
                    subtitle: 'MOBILE DATA SETTINGS',
                    trailing: const SizedBox.shrink(),
                    onTap: () {
                      // TODO: tela de qualidade de dados
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Item de configuração ────────────────────────────────────────────

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  static const Color kDark = Color(0xFF1C1C1C);

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Ícone em fundo escuro
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: kDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),

            const SizedBox(width: 14),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: kDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: kDark.withOpacity(0.5),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            trailing,
          ],
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
