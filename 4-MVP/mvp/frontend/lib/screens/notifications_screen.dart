import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelo de Configurações de Notificação ───────────────────────────────────
//
// O projeto ainda não tem `flutter_local_notifications` nem
// `permission_handler` no pubspec.yaml. Este modelo guarda as preferências
// do usuário localmente (SharedPreferences), no mesmo padrão do
// PetStatus/PremiumStatus. Quando vocês adicionarem essas dependências,
// a ideia é:
//   • trocar `_requestSystemPermission()` por uma chamada real do
//     permission_handler (Permission.notification.request());
//   • no ponto onde salvamos os horários/categorias, também
//     agendar/cancelar as notificações locais via flutter_local_notifications.
// A tela e o fluxo de UI não precisam mudar.

class NotificationCategory {
  final String id;
  final String label;
  final IconData icon;
  bool enabled;

  NotificationCategory({
    required this.id,
    required this.label,
    required this.icon,
    this.enabled = true,
  });
}

class NotificationSettings {
  bool masterEnabled;
  bool systemPermissionGranted;
  TimeOfDay reminderTime;
  Map<String, bool> categories;

  NotificationSettings({
    this.masterEnabled = true,
    this.systemPermissionGranted = false,
    this.reminderTime = const TimeOfDay(hour: 20, minute: 0),
    Map<String, bool>? categories,
  }) : categories = categories ??
            {
              'meditacao': true,
              'registro_emocional': true,
              'missoes': true,
              'social': false,
              'premium': true,
            };

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_master_enabled', masterEnabled);
    await prefs.setBool('notif_system_permission', systemPermissionGranted);
    await prefs.setInt('notif_reminder_hour', reminderTime.hour);
    await prefs.setInt('notif_reminder_minute', reminderTime.minute);
    for (final entry in categories.entries) {
      await prefs.setBool('notif_cat_${entry.key}', entry.value);
    }
  }

  static Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final defaults = NotificationSettings();
    final loadedCategories = <String, bool>{};
    for (final key in defaults.categories.keys) {
      loadedCategories[key] =
          prefs.getBool('notif_cat_$key') ?? defaults.categories[key]!;
    }

    return NotificationSettings(
      masterEnabled: prefs.getBool('notif_master_enabled') ?? true,
      systemPermissionGranted: prefs.getBool('notif_system_permission') ?? false,
      reminderTime: TimeOfDay(
        hour: prefs.getInt('notif_reminder_hour') ?? 20,
        minute: prefs.getInt('notif_reminder_minute') ?? 0,
      ),
      categories: loadedCategories,
    );
  }
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late NotificationSettings _settings;
  bool _isLoading = true;

  final List<NotificationCategory> _categoryDefs = [
    NotificationCategory(
        id: 'meditacao', label: 'Lembretes de meditação', icon: Icons.self_improvement_rounded),
    NotificationCategory(
        id: 'registro_emocional', label: 'Registro emocional diário', icon: Icons.favorite_rounded),
    NotificationCategory(
        id: 'missoes', label: 'Missões e recompensas', icon: Icons.emoji_events_rounded),
    NotificationCategory(
        id: 'social', label: 'Atividade social', icon: Icons.people_alt_rounded),
    NotificationCategory(
        id: 'premium', label: 'Novidades Premium', icon: Icons.workspace_premium_rounded),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final settings = await NotificationSettings.load();
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

  Future<void> _toggleMaster(bool value) async {
    if (value && !_settings.systemPermissionGranted) {
      final granted = await _requestSystemPermission();
      if (!granted) return;
    }
    setState(() => _settings.masterEnabled = value);
    await _settings.save();
    _showSnack(value ? 'Notificações ativadas 🔔' : 'Notificações desativadas');
  }

  /// Simula o pedido de permissão do sistema. Trocar por
  /// `Permission.notification.request()` (permission_handler) quando a
  /// dependência for adicionada.
  Future<bool> _requestSystemPermission() async {
    final granted = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Permitir notificações'),
        content: const Text(
          'O SlowDown gostaria de enviar notificações para lembretes de '
          'meditação, missões e registro emocional.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não permitir'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kYellow),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Permitir'),
          ),
        ],
      ),
    );

    final result = granted ?? false;
    setState(() => _settings.systemPermissionGranted = result);
    await _settings.save();
    if (!result) {
      _showSnack('Permissão negada. Ative pelas configurações do celular.');
    }
    return result;
  }

  Future<void> _toggleCategory(String id, bool value) async {
    setState(() => _settings.categories[id] = value);
    await _settings.save();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _settings.reminderTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: kYellow),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _settings.reminderTime = picked);
      await _settings.save();
      _showSnack('Horário atualizado para ${picked.format(context)}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: kBgTop,
        body: Center(child: CircularProgressIndicator(color: kYellow)),
      );
    }

    final categoriesDisabled = !_settings.masterEnabled;

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
                      'Notificações',
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
                  // Permissão do sistema
                  if (!_settings.systemPermissionGranted) _buildPermissionBanner(),

                  // Toggle geral
                  _SectionCard(
                    child: SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: kYellow,
                      title: const Text('Ativar notificações',
                          style: TextStyle(fontWeight: FontWeight.w800, color: kDark)),
                      subtitle: const Text('Liga ou desliga tudo de uma vez'),
                      value: _settings.masterEnabled,
                      onChanged: _toggleMaster,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Horário personalizado',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      enabled: !categoriesDisabled,
                      leading: const Icon(Icons.schedule_rounded, color: kYellow),
                      title: const Text('Lembrete diário',
                          style: TextStyle(fontWeight: FontWeight.w600, color: kDark)),
                      subtitle: Text(_settings.reminderTime.format(context)),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: categoriesDisabled ? null : _pickTime,
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text(
                    'Categorias',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kDark),
                  ),
                  const SizedBox(height: 8),
                  _SectionCard(
                    child: Column(
                      children: _categoryDefs.map((cat) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          activeThumbColor: kYellow,
                          secondary: Icon(cat.icon,
                              color: categoriesDisabled ? Colors.black26 : kDark),
                          title: Text(
                            cat.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: categoriesDisabled ? Colors.black38 : kDark,
                            ),
                          ),
                          value: categoriesDisabled ? false : (_settings.categories[cat.id] ?? true),
                          onChanged: categoriesDisabled
                              ? null
                              : (value) => _toggleCategory(cat.id, value),
                        );
                      }).toList(),
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

  Widget _buildPermissionBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_off_rounded, color: Colors.redAccent),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Permissão de notificação não concedida.',
              style: TextStyle(fontWeight: FontWeight.w600, color: kDark, fontSize: 13),
            ),
          ),
          TextButton(
            onPressed: _requestSystemPermission,
            child: const Text('Permitir'),
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
      // Material transparente: o Container acima já pinta o fundo branco
      // arredondado, mas ListTile/SwitchListTile precisam de um Material
      // ancestral pra desenhar corretamente o splash/highlight do toque.
      // Sem isso, o Flutter lança o erro "ListTile background color or
      // ink splashes may be invisible" em tempo de execução.
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
