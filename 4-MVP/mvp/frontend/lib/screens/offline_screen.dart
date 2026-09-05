import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────
//
// O projeto ainda não baixa nada de verdade (não há `path_provider` nem
// `dio`/`http` sendo usados para salvar arquivos em disco, e não existe
// nenhum service de download). Este modelo guarda a LISTA de itens já
// baixados e as preferências de sincronização localmente via
// SharedPreferences (mesmo padrão do PetStatus/PremiumStatus).
//
// Ao implementar downloads reais (meditações, músicas,
// sleepcasts), a ideia é:
//   • usar `path_provider` para salvar os arquivos em
//     getApplicationDocumentsDirectory();
//   • ao concluir o download real, chamar `addItem(...)` aqui;
//   • ao remover, apagar o arquivo físico e depois chamar `removeItem(id)`.
// A tela e a UI de gerenciamento não precisam mudar.

enum OfflineContentType { meditacao, musica, sleepcast }

extension OfflineContentTypeX on OfflineContentType {
  String get label {
    switch (this) {
      case OfflineContentType.meditacao:
        return 'Meditação';
      case OfflineContentType.musica:
        return 'Música';
      case OfflineContentType.sleepcast:
        return 'Sleepcast';
    }
  }

  IconData get icon {
    switch (this) {
      case OfflineContentType.meditacao:
        return Icons.self_improvement_rounded;
      case OfflineContentType.musica:
        return Icons.music_note_rounded;
      case OfflineContentType.sleepcast:
        return Icons.nightlight_round;
    }
  }
}

class DownloadedItem {
  final String id;
  final String title;
  final OfflineContentType type;
  final double sizeMb;
  final DateTime downloadedAt;

  DownloadedItem({
    required this.id,
    required this.title,
    required this.type,
    required this.sizeMb,
    required this.downloadedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'type': type.name,
        'sizeMb': sizeMb,
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  static DownloadedItem fromJson(Map<String, dynamic> json) => DownloadedItem(
        id: json['id'],
        title: json['title'],
        type: OfflineContentType.values.firstWhere((t) => t.name == json['type']),
        sizeMb: (json['sizeMb'] as num).toDouble(),
        downloadedAt: DateTime.parse(json['downloadedAt']),
      );
}

class OfflineSettings {
  bool autoSyncEnabled;
  bool wifiOnly;
  DateTime? lastSyncedAt;
  List<DownloadedItem> items;

  OfflineSettings({
    this.autoSyncEnabled = true,
    this.wifiOnly = true,
    this.lastSyncedAt,
    List<DownloadedItem>? items,
  }) : items = items ?? [];

  double get totalSizeMb => items.fold(0, (sum, i) => sum + i.sizeMb);

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_auto_sync', autoSyncEnabled);
    await prefs.setBool('offline_wifi_only', wifiOnly);
    await prefs.setString('offline_last_sync', lastSyncedAt?.toIso8601String() ?? '');
    await prefs.setString(
      'offline_items',
      jsonEncode(items.map((i) => i.toJson()).toList()),
    );
  }

  static Future<OfflineSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final lastSyncStr = prefs.getString('offline_last_sync') ?? '';
    final itemsStr = prefs.getString('offline_items');

    List<DownloadedItem> items = [];
    if (itemsStr != null && itemsStr.isNotEmpty) {
      final decoded = jsonDecode(itemsStr) as List;
      items = decoded.map((e) => DownloadedItem.fromJson(e)).toList();
    } else {
      // Conteúdo de exemplo, só para ilustrar o gerenciamento (remover
      // depois que o download real estiver implementado).
      items = [
        DownloadedItem(
          id: 'med_respiracao',
          title: 'Respiração Consciente',
          type: OfflineContentType.meditacao,
          sizeMb: 12.4,
          downloadedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        DownloadedItem(
          id: 'musica_chuva',
          title: 'Chuva Suave',
          type: OfflineContentType.musica,
          sizeMb: 8.1,
          downloadedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];
    }

    return OfflineSettings(
      autoSyncEnabled: prefs.getBool('offline_auto_sync') ?? true,
      wifiOnly: prefs.getBool('offline_wifi_only') ?? true,
      lastSyncedAt: lastSyncStr.isEmpty ? null : DateTime.tryParse(lastSyncStr),
      items: items,
    );
  }

  void removeItem(String id) => items.removeWhere((i) => i.id == id);
  void clearAll() => items.clear();
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class OfflineScreen extends StatefulWidget {
  const OfflineScreen({super.key});

  @override
  State<OfflineScreen> createState() => _OfflineScreenState();
}

class _OfflineScreenState extends State<OfflineScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late OfflineSettings _settings;
  bool _isLoading = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = await OfflineSettings.load();
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

  Future<void> _toggleAutoSync(bool value) async {
    setState(() => _settings.autoSyncEnabled = value);
    await _settings.save();
  }

  Future<void> _toggleWifiOnly(bool value) async {
    setState(() => _settings.wifiOnly = value);
    await _settings.save();
  }

  /// Simula a sincronização. Trocar por uma chamada real (ex: comparar
  /// itens salvos localmente vs. o backend) quando houver persistência
  /// em nuvem (cloud_firestore ainda não está no pubspec.yaml).
  Future<void> _syncNow() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(seconds: 1, milliseconds: 200));
    setState(() {
      _settings.lastSyncedAt = DateTime.now();
      _isSyncing = false;
    });
    await _settings.save();
    _showSnack('Sincronizado com sucesso! ✅');
  }

  Future<void> _removeItem(DownloadedItem item) async {
    setState(() => _settings.removeItem(item.id));
    await _settings.save();
    _showSnack('${item.title} removido do dispositivo.');
  }

  Future<void> _confirmClearAll() async {
    if (_settings.items.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remover todos os downloads'),
        content: Text(
          'Isso vai liberar ${_settings.totalSizeMb.toStringAsFixed(1)} MB. '
          'Você poderá baixar o conteúdo novamente quando quiser.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover tudo'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _settings.clearAll());
      await _settings.save();
      _showSnack('Todos os downloads foram removidos.');
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} às '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

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
          // ── AppBar ───────────────────────────────────────────────────
          Container(
            color: kDark,
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
                    const Text(
                      'Modo Offline',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18),
                    ),
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
                  _buildStorageSummary(),
                  const SizedBox(height: 20),

                  const Text(
                    'Sincronização',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: kYellow,
                          title: const Text('Sincronização automática',
                              style: TextStyle(fontWeight: FontWeight.w700, color: kDark)),
                          subtitle: const Text('Atualiza seu conteúdo offline sozinho'),
                          value: _settings.autoSyncEnabled,
                          onChanged: _toggleAutoSync,
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: kYellow,
                          title: const Text('Somente via Wi-Fi',
                              style: TextStyle(fontWeight: FontWeight.w700, color: kDark)),
                          subtitle: const Text('Evita gastar seus dados móveis'),
                          value: _settings.wifiOnly,
                          onChanged: _toggleWifiOnly,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: _isSyncing
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: kYellow),
                                )
                              : const Icon(Icons.sync_rounded, color: kYellow),
                          title: const Text('Sincronizar agora',
                              style: TextStyle(fontWeight: FontWeight.w700, color: kDark)),
                          subtitle: Text(
                            _settings.lastSyncedAt != null
                                ? 'Última vez: ${_formatDate(_settings.lastSyncedAt!)}'
                                : 'Ainda não sincronizado',
                          ),
                          onTap: _isSyncing ? null : _syncNow,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Conteúdo baixado',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark),
                      ),
                      if (_settings.items.isNotEmpty)
                        TextButton(
                          onPressed: _confirmClearAll,
                          child: const Text('Remover tudo', style: TextStyle(color: Colors.redAccent)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  if (_settings.items.isEmpty)
                    _buildEmptyState()
                  else
                    ..._settings.items.map((item) => _DownloadTile(
                          item: item,
                          onRemove: () => _removeItem(item),
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.sd_storage_rounded, color: kYellow, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_settings.totalSizeMb.toStringAsFixed(1)} MB usados',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_settings.items.length} ${_settings.items.length == 1 ? "item baixado" : "itens baixados"}',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.cloud_off_rounded, color: Colors.black26, size: 40),
          SizedBox(height: 8),
          Text('Nenhum conteúdo baixado ainda', style: TextStyle(color: Colors.black45)),
        ],
      ),
    );
  }
}

// ─── Widget: Item baixado ───────────────────────────────────────────────────

class _DownloadTile extends StatelessWidget {
  final DownloadedItem item;
  final VoidCallback onRemove;

  const _DownloadTile({required this.item, required this.onRemove});

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kYellow.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.type.icon, color: kYellow, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w700, color: kDark)),
                Text(
                  '${item.type.label} • ${item.sizeMb.toStringAsFixed(1)} MB',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Card de seção ──────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      // Material transparente: necessário para ListTile/SwitchListTile
      // desenharem corretamente o splash/highlight do toque quando estão
      // dentro de um Container com cor de fundo própria.
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
