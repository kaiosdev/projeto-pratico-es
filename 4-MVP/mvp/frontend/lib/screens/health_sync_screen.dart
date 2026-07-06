import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelo ──────────────────────────────────────────────────────────────────
//
// O projeto ainda não tem o pacote `health` (nem `permission_handler`) no
// pubspec.yaml, então esta tela por enquanto guarda só o ESTADO de conexão
// (conectado/desconectado, última sincronização) via SharedPreferences,
// igual ao padrão de OfflineSettings/PetStatus.
//
// Pra ligar de verdade ao HealthKit (iOS) e Google Fit (Android), o caminho
// mais direto hoje é o pacote `health` (https://pub.dev/packages/health),
// que fala com os dois com a mesma API:
//   1. adicionar `health: ^X.Y.Z` e `permission_handler` no pubspec.yaml
//   2. iOS: habilitar o capability HealthKit no Xcode + Info.plist com
//      NSHealthShareUsageDescription / NSHealthUpdateUsageDescription
//   3. Android: declarar as permissões do Health Connect no
//      AndroidManifest.xml
//   4. trocar `_connectAppleHealth`/`_connectGoogleFit` abaixo pela chamada
//      real: `Health().requestAuthorization([...tipos de dados...])`
//
// A UI e o fluxo de estado não precisam mudar quando isso for plugado.

enum HealthProvider { appleHealth, googleFit }

class HealthSyncSettings {
  bool appleHealthConnected;
  bool googleFitConnected;
  DateTime? lastSyncedAt;
  int stepsToday;
  int activeMinutesToday;

  HealthSyncSettings({
    this.appleHealthConnected = false,
    this.googleFitConnected = false,
    this.lastSyncedAt,
    this.stepsToday = 0,
    this.activeMinutesToday = 0,
  });

  bool get anyConnected => appleHealthConnected || googleFitConnected;

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_apple_connected', appleHealthConnected);
    await prefs.setBool('health_googlefit_connected', googleFitConnected);
    await prefs.setString(
        'health_last_sync', lastSyncedAt?.toIso8601String() ?? '');
    await prefs.setInt('health_steps_today', stepsToday);
    await prefs.setInt('health_active_minutes', activeMinutesToday);
  }

  static Future<HealthSyncSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString('health_last_sync') ?? '';
    return HealthSyncSettings(
      appleHealthConnected: prefs.getBool('health_apple_connected') ?? false,
      googleFitConnected:
          prefs.getBool('health_googlefit_connected') ?? false,
      lastSyncedAt: lastSyncStr.isEmpty ? null : DateTime.tryParse(lastSyncStr),
      stepsToday: prefs.getInt('health_steps_today') ?? 0,
      activeMinutesToday: prefs.getInt('health_active_minutes') ?? 0,
    );
  }
}

// ─── Tela Principal ─────────────────────────────────────────────────────────

class HealthSyncScreen extends StatefulWidget {
  const HealthSyncScreen({super.key});

  @override
  State<HealthSyncScreen> createState() => _HealthSyncScreenState();
}

class _HealthSyncScreenState extends State<HealthSyncScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late HealthSyncSettings _settings;
  bool _isLoading = true;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = await HealthSyncSettings.load();
    setState(() {
      _settings = settings;
      _isLoading = false;
    });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: kDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Simula o fluxo de permissão do HealthKit. Trocar pelo
  /// `Health().requestAuthorization(...)` real do pacote `health`.
  Future<void> _connectAppleHealth() async {
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _settings.appleHealthConnected = true;
      _settings.lastSyncedAt = DateTime.now();
      _isConnecting = false;
    });
    await _settings.save();
    _showSnack('Apple HealthKit conectado');
  }

  /// Simula o fluxo de permissão do Google Fit / Health Connect.
  Future<void> _connectGoogleFit() async {
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _settings.googleFitConnected = true;
      _settings.lastSyncedAt = DateTime.now();
      _isConnecting = false;
    });
    await _settings.save();
    _showSnack('Google Fit conectado');
  }

  Future<void> _disconnect(HealthProvider provider) async {
    setState(() {
      if (provider == HealthProvider.appleHealth) {
        _settings.appleHealthConnected = false;
      } else {
        _settings.googleFitConnected = false;
      }
    });
    await _settings.save();
    _showSnack('Desconectado.');
  }

  Future<void> _syncNow() async {
    if (!_settings.anyConnected) return;
    setState(() => _isConnecting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _settings.lastSyncedAt = DateTime.now();
      _isConnecting = false;
    });
    await _settings.save();
    _showSnack('Dados de saúde sincronizados');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBgTop,
        body: Center(child: CircularProgressIndicator(color: kYellow)),
      );
    }

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
                    const _SlowDownLogo(size: 28),
                    const SizedBox(width: 40),
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
                padding: const EdgeInsets.all(20),
                children: [
                  if (_settings.anyConnected) ...[
                    _buildSummaryCard(),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    'CONEXÕES',
                    style: TextStyle(
                      color: kDark.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProviderTile(
                    title: 'Apple HealthKit',
                    subtitle: _settings.appleHealthConnected
                        ? 'Conectado'
                        : 'Passos, sono e frequência cardíaca',
                    icon: Icons.favorite_rounded,
                    color: const Color(0xFFE24B4A),
                    connected: _settings.appleHealthConnected,
                    isBusy: _isConnecting,
                    onConnect: _connectAppleHealth,
                    onDisconnect: () => _disconnect(HealthProvider.appleHealth),
                  ),
                  const SizedBox(height: 10),
                  _ProviderTile(
                    title: 'Google Fit',
                    subtitle: _settings.googleFitConnected
                        ? 'Conectado'
                        : 'Atividade física e passos',
                    icon: Icons.directions_run_rounded,
                    color: const Color(0xFF639922),
                    connected: _settings.googleFitConnected,
                    isBusy: _isConnecting,
                    onConnect: _connectGoogleFit,
                    onDisconnect: () => _disconnect(HealthProvider.googleFit),
                  ),
                  const SizedBox(height: 20),
                  if (_settings.anyConnected)
                    _SettingsRow(
                      icon: Icons.sync_rounded,
                      title: 'Sincronizar agora',
                      subtitle: _settings.lastSyncedAt != null
                          ? 'Última vez: ${_formatDate(_settings.lastSyncedAt!)}'
                          : 'Ainda não sincronizado',
                      isBusy: _isConnecting,
                      onTap: _isConnecting ? null : _syncNow,
                    ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: kDark.withOpacity(0.5), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Os dados de saúde continuam salvos no aparelho '
                            'quando você está offline e são enviados assim '
                            'que a conexão voltar.',
                            style: TextStyle(
                              color: kDark.withOpacity(0.6),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryStat(
              icon: Icons.directions_walk_rounded,
              value: '${_settings.stepsToday}',
              label: 'passos hoje',
            ),
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          Expanded(
            child: _SummaryStat(
              icon: Icons.timer_outlined,
              value: '${_settings.activeMinutesToday} min',
              label: 'ativos hoje',
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 1) return 'agora mesmo';
    if (diff.inMinutes < 60) return 'há ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'há ${diff.inHours}h';
    return '${date.day}/${date.month}/${date.year}';
  }
}

// ─── Widget: Estatística resumida ─────────────────────────────────────────────

class _SummaryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryStat(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFFF5B800), size: 22),
        const SizedBox(height: 6),
        Text(value,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 11)),
      ],
    );
  }
}

// ─── Widget: Card de provedor (Apple Health / Google Fit) ─────────────────────

class _ProviderTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool connected;
  final bool isBusy;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  static const Color kDark = Color(0xFF1C1C1C);

  const _ProviderTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.connected,
    required this.isBusy,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.35),
        borderRadius: BorderRadius.circular(12),
        border: connected ? Border.all(color: color, width: 1.4) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: kDark, fontSize: 13, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(
                        color: connected ? color : kDark.withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          if (isBusy)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: kDark),
            )
          else
            TextButton(
              onPressed: connected ? onDisconnect : onConnect,
              style: TextButton.styleFrom(
                foregroundColor: connected ? Colors.redAccent : kDark,
              ),
              child: Text(
                connected ? 'Desconectar' : 'Conectar',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Widget: Linha de ação simples ─────────────────────────────────────────────

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isBusy;
  final VoidCallback? onTap;

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isBusy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            isBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: kYellow),
                  )
                : Icon(icon, color: kYellow),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: kDark, fontSize: 13, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: kDark.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ],
              ),
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
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'SLOW',
            style: TextStyle(
              color: const Color(0xFFF5B800),
              fontSize: size * 0.45,
              fontWeight: FontWeight.w900,
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
            height: 1,
          ),
        ),
      ],
    );
  }
}
