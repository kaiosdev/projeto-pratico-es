import 'package:flutter/material.dart';
import 'spotify_screen.dart'; // Import da tela do Spotify

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kSpotifyGreen = Color(0xFF1DB954);

  int _selectedTab = 0; // 0 = Sons, 1 = Músicas
  int? _playingIndex;

  final List<Map<String, dynamic>> _sounds = [
    {
      'title': 'SONS ACÚSTICOS',
      'subtitle': 'Guitarra & violão',
      'icon': Icons.music_note_rounded,
      'color': const Color(0xFF8B7355),
    },
    {
      'title': 'SONS DE CHUVA',
      'subtitle': 'Chuva suave',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xFF5C7AAA),
    },
    {
      'title': 'SONS DA NATUREZA',
      'subtitle': 'Pássaros & vento',
      'icon': Icons.park_rounded,
      'color': const Color(0xFF6AAA7C),
    },
    {
      'title': 'RUÍDO BRANCO',
      'subtitle': 'Concentração',
      'icon': Icons.waves_rounded,
      'color': const Color(0xFF9B8EC4),
    },
  ];

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
              child: Column(
                children: [
                  // ── Tabs ─────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _Tab(
                            label: 'SONS AMBIENTE',
                            selected: _selectedTab == 0,
                            onTap: () => setState(() => _selectedTab = 0),
                          ),
                          _Tab(
                            label: 'MÚSICAS',
                            selected: _selectedTab == 1,
                            onTap: () => setState(() => _selectedTab = 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Área de Conteúdo Dinâmica ──────────────────────────
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _selectedTab == 0
                          ? _buildAmbientSoundsList()
                          : _buildSpotifyIntegrationCard(context),
                    ),
                  ),

                  // ── Mini player Local (Apenas visível se tocando som ambiente) ─
                  if (_playingIndex != null && _selectedTab == 0)
                    _MiniPlayer(
                      title: _sounds[_playingIndex!]['title'],
                      color: _sounds[_playingIndex!]['color'],
                      onStop: () => setState(() => _playingIndex = null),
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

  // ─── Lista de Sons Ambiente (Tab 0) ───
  Widget _buildAmbientSoundsList() {
    return ListView.separated(
      key: const ValueKey('AmbientTab'),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _sounds.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final s = _sounds[i];
        final isPlaying = _playingIndex == i;
        return _SoundCard(
          title: s['title'],
          subtitle: s['subtitle'],
          icon: s['icon'],
          color: s['color'],
          isPlaying: isPlaying,
          onTap: () => setState(() {
            _playingIndex = isPlaying ? null : i;
          }),
        );
      },
    );
  }

  // ─── Card do Spotify (Tab 1) ───
  Widget _buildSpotifyIntegrationCard(BuildContext context) {
    return Center(
      key: const ValueKey('SpotifyTab'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: kSpotifyGreen,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: kSpotifyGreen.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(Icons.library_music_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 24),
            const Text(
              'Integração Spotify',
              style: TextStyle(
                color: kDark,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Conecte o seu SlowDown ao Spotify para gerenciar suas playlists e músicas curtidas em tempo real.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDark.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Navega para a tela do Spotify que você criou
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SpotifyScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kSpotifyGreen,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'ABRIR SPOTIFY',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 60), // Margem inferior para balancear com o topo
          ],
        ),
      ),
    );
  }
}

// ─── Componentes Visuais (Tabs, Cards, MiniPlayer, Logo) ─────────────

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  const _Tab({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? kYellow : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : kDark.withOpacity(0.5),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _SoundCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isPlaying;
  final VoidCallback onTap;

  const _SoundCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isPlaying ? color.withOpacity(0.25) : Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPlaying ? color : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        color: Color(0xFF1C1C1C),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      )),
                  Text(subtitle,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            ),
            Icon(
              isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
              color: color,
              size: 34,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onStop;

  const _MiniPlayer({required this.title, required this.color, required this.onStop});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: onStop,
            child: const Icon(Icons.stop_circle_rounded, color: Colors.white, size: 28),
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
          padding: EdgeInsets.symmetric(horizontal: size * 0.14, vertical: size * 0.08),
          decoration: BoxDecoration(color: const Color(0xFF1C1C1C), borderRadius: BorderRadius.circular(4)),
          child: Text('SLOW',
              style: TextStyle(
                  color: const Color(0xFFF5B800), fontSize: size * 0.45, fontWeight: FontWeight.w900, height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN',
            style: TextStyle(
                color: const Color(0xFF1C1C1C), fontSize: size * 0.72, fontWeight: FontWeight.w900, height: 1)),
      ],
    );
  }
}