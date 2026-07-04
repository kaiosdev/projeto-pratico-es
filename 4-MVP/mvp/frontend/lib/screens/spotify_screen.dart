import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spotify_sdk/spotify_sdk.dart';
// 👉 ADICIONE ESTA LINHA ABAIXO:
import 'package:spotify_sdk/models/player_state.dart';

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({super.key});

  @override
  State<SpotifyScreen> createState() => _SpotifyScreenState();
}

class _SpotifyScreenState extends State<SpotifyScreen>
    with SingleTickerProviderStateMixin {
  // ─── Paleta SlowDown ────────────────────────────────────────────────────────
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kGreen = Color(0xFF1DB954); // Verde Spotify

  // ─── Configuração Spotify ────────────────────────────────────────────────────
  // TODO: substitua pelos seus dados do Spotify Developer Dashboard
  static const String _clientId = 'SEU_CLIENT_ID_AQUI';
  static const String _redirectUrl = 'slowdown://spotify-callback';

  // ─── Estado ──────────────────────────────────────────────────────────────────
  bool _isConnected = false;
  bool _isLoading = false;
  String _authToken = '';
  int _selectedTab = 0; // 0 = Playlists, 1 = Curtidas

  List<Map<String, dynamic>> _playlists = [];
  List<Map<String, dynamic>> _likedTracks = [];
  List<Map<String, dynamic>> _currentTracks = [];
  String? _currentPlaylistName;
  String? _playingUri;
  bool _isPaused = true;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── Conexão com o Spotify ───────────────────────────────────────────────────

  Future<void> _connectToSpotify() async {
    setState(() => _isLoading = true);
    try {
      final token = await SpotifySdk.getAuthenticationToken(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
        scope:
            'app-remote-control,playlist-read-private,user-library-read,user-modify-playback-state',
      );

      await SpotifySdk.connectToSpotifyRemote(
        clientId: _clientId,
        redirectUrl: _redirectUrl,
      );

      setState(() {
        _authToken = token;
        _isConnected = true;
      });

      // Carrega playlists e músicas curtidas logo após conectar
      await Future.wait([_fetchPlaylists(), _fetchLikedTracks()]);
    } catch (e) {
      _showSnackBar('Erro ao conectar ao Spotify: ${e.toString()}',
          isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── Busca playlists do usuário ──────────────────────────────────────────────

  Future<void> _fetchPlaylists() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/playlists?limit=20'),
        headers: {'Authorization': 'Bearer $_authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _playlists = List<Map<String, dynamic>>.from(data['items']);
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao buscar playlists.', isError: true);
    }
  }

  // ─── Busca músicas curtidas ──────────────────────────────────────────────────

  Future<void> _fetchLikedTracks() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks?limit=20'),
        headers: {'Authorization': 'Bearer $_authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _likedTracks = List<Map<String, dynamic>>.from(data['items']);
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao buscar músicas curtidas.', isError: true);
    }
  }

  // ─── Busca tracks de uma playlist ───────────────────────────────────────────

  Future<void> _fetchPlaylistTracks(String playlistId, String name) async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.spotify.com/v1/playlists/$playlistId/tracks?limit=20'),
        headers: {'Authorization': 'Bearer $_authToken'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _currentTracks =
              List<Map<String, dynamic>>.from(data['items']);
          _currentPlaylistName = name;
        });
      }
    } catch (e) {
      _showSnackBar('Erro ao carregar playlist.', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ─── Controles de reprodução ─────────────────────────────────────────────────

  Future<void> _playTrack(String uri) async {
    try {
      await SpotifySdk.play(spotifyUri: uri);
      setState(() {
        _playingUri = uri;
        _isPaused = false;
      });
    } catch (e) {
      _showSnackBar('Erro ao reproduzir. O Spotify está aberto?', isError: true);
    }
  }

  Future<void> _togglePause() async {
    try {
      if (_isPaused) {
        await SpotifySdk.resume();
      } else {
        await SpotifySdk.pause();
      }
      setState(() => _isPaused = !_isPaused);
    } catch (e) {
      _showSnackBar('Erro ao controlar reprodução.', isError: true);
    }
  }

  Future<void> _skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } catch (_) {}
  }

  Future<void> _skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } catch (_) {}
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: isError ? Colors.red.shade700 : kDark,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ─── UI ──────────────────────────────────────────────────────────────────────

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
              child: _isConnected ? _buildPlayer() : _buildLogin(),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Tela de Login ───────────────────────────────────────────────────────────

  Widget _buildLogin() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Spotify
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.music_note_rounded,
                  color: Colors.white, size: 54),
            ),

            const SizedBox(height: 28),

            const Text(
              'Spotify',
              style: TextStyle(
                color: kDark,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Conecte sua conta para acessar\nsuas playlists e músicas curtidas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDark.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 36),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _connectToSpotify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: kGreen.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: Colors.white),
                      )
                    : const Text(
                        'ENTRAR COM SPOTIFY',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '⚠️ O app do Spotify precisa estar instalado no dispositivo.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kDark.withOpacity(0.4),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Player principal ────────────────────────────────────────────────────────

  Widget _buildPlayer() {
    return Column(
      children: [
        // Tabs
        Container(
          color: kBgTop,
          child: TabBar(
            controller: _tabController,
            labelColor: kDark,
            unselectedLabelColor: kDark.withOpacity(0.4),
            indicatorColor: kGreen,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5),
            tabs: const [
              Tab(text: 'PLAYLISTS'),
              Tab(text: 'CURTIDAS'),
            ],
          ),
        ),

        // Conteúdo das tabs
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPlaylistsTab(),
              _buildLikedTab(),
            ],
          ),
        ),

        // Mini player fixo no rodapé
        if (_playingUri != null) _buildMiniPlayer(),
      ],
    );
  }

  // ─── Tab: Playlists ──────────────────────────────────────────────────────────

  Widget _buildPlaylistsTab() {
    if (_currentPlaylistName != null && _currentTracks.isNotEmpty) {
      return _buildTrackList(
        title: _currentPlaylistName!,
        tracks: _currentTracks,
        onBack: () => setState(() {
          _currentPlaylistName = null;
          _currentTracks = [];
        }),
      );
    }

    if (_playlists.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _playlists.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final pl = _playlists[i];
        final imageUrl = (pl['images'] as List?)?.isNotEmpty == true
            ? pl['images'][0]['url']
            : null;
        return _PlaylistCard(
          name: pl['name'] ?? 'Playlist',
          trackCount: pl['tracks']?['total'] ?? 0,
          imageUrl: imageUrl,
          onTap: () => _fetchPlaylistTracks(pl['id'], pl['name']),
        );
      },
    );
  }

  // ─── Tab: Curtidas ───────────────────────────────────────────────────────────

  Widget _buildLikedTab() {
    if (_likedTracks.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: Color(0xFF1DB954)));
    }

    return _buildTrackList(
      title: 'Músicas Curtidas',
      tracks: _likedTracks,
      onBack: null,
    );
  }

  // ─── Lista de tracks ─────────────────────────────────────────────────────────

  Widget _buildTrackList({
    required String title,
    required List<Map<String, dynamic>> tracks,
    VoidCallback? onBack,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              if (onBack != null)
                GestureDetector(
                  onTap: onBack,
                  child: const Icon(Icons.arrow_back_rounded,
                      color: kDark, size: 22),
                ),
              if (onBack != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: kDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tracks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final item = tracks[i];
              final track =
                  item.containsKey('track') ? item['track'] : item;
              if (track == null) return const SizedBox.shrink();

              final imageUrl =
                  (track['album']?['images'] as List?)?.isNotEmpty == true
                      ? track['album']['images'][0]['url']
                      : null;
              final artist =
                  (track['artists'] as List?)?.isNotEmpty == true
                      ? track['artists'][0]['name']
                      : '';
              final uri = track['uri'] as String?;
              final isPlaying = _playingUri == uri;

              return _TrackCard(
                name: track['name'] ?? 'Sem título',
                artist: artist,
                imageUrl: imageUrl,
                isPlaying: isPlaying,
                onTap: uri != null ? () => _playTrack(uri) : null,
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Mini player ─────────────────────────────────────────────────────────────

  Widget _buildMiniPlayer() {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final track = playerState?.track;

        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: kGreen,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.music_note_rounded,
                  color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      track?.name ?? 'Reproduzindo...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (track?.artist.name != null)
                      Text(
                        track!.artist.name ?? 'Artista Desconhecido', // ✅ A correção
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _skipPrevious,
                child: const Icon(Icons.skip_previous_rounded,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _togglePause,
                child: Icon(
                  (playerState?.isPaused ?? _isPaused)
                      ? Icons.play_circle_filled_rounded
                      : Icons.pause_circle_filled_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _skipNext,
                child: const Icon(Icons.skip_next_rounded,
                    color: Colors.white, size: 26),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Widget: Card de playlist ─────────────────────────────────────────────────

class _PlaylistCard extends StatelessWidget {
  final String name;
  final int trackCount;
  final String? imageUrl;
  final VoidCallback onTap;

  static const Color kGreen = Color(0xFF1DB954);
  static const Color kDark = Color(0xFF1C1C1C);

  const _PlaylistCard({
    required this.name,
    required this.trackCount,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? Image.network(imageUrl!,
                      width: 52, height: 52, fit: BoxFit.cover)
                  : Container(
                      width: 52,
                      height: 52,
                      color: kGreen.withOpacity(0.2),
                      child: const Icon(Icons.queue_music_rounded,
                          color: kGreen, size: 28),
                    ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          color: kDark,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                  Text('$trackCount músicas',
                      style: TextStyle(
                          color: kDark.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: kGreen, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Card de track ────────────────────────────────────────────────────

class _TrackCard extends StatelessWidget {
  final String name;
  final String artist;
  final String? imageUrl;
  final bool isPlaying;
  final VoidCallback? onTap;

  static const Color kGreen = Color(0xFF1DB954);
  static const Color kDark = Color(0xFF1C1C1C);

  const _TrackCard({
    required this.name,
    required this.artist,
    required this.imageUrl,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPlaying
              ? kGreen.withOpacity(0.15)
              : Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? kGreen : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: imageUrl != null
                  ? Image.network(imageUrl!,
                      width: 44, height: 44, fit: BoxFit.cover)
                  : Container(
                      width: 44,
                      height: 44,
                      color: kGreen.withOpacity(0.2),
                      child: const Icon(Icons.music_note_rounded,
                          color: kGreen, size: 22),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          color: kDark,
                          fontSize: 12,
                          fontWeight: isPlaying
                              ? FontWeight.w800
                              : FontWeight.w600),
                      overflow: TextOverflow.ellipsis),
                  Text(artist,
                      style: TextStyle(
                          color: kDark.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(
              isPlaying
                  ? Icons.equalizer_rounded
                  : Icons.play_circle_outline_rounded,
              color: kGreen,
              size: 26,
            ),
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
