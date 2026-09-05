import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────
//
// Mesmo padrão do PetStatus/OfflineSettings: persistência local via
// SharedPreferences. Quando o backend (Firestore) tiver uma coleção de
// progresso do usuário, trocar load()/save() por leitura/escrita remota
// sem precisar mudar a tela.

class Mission {
  final String id;
  final String title;
  final IconData icon;
  final int xpReward;
  bool completed;

  Mission({
    required this.id,
    required this.title,
    required this.icon,
    required this.xpReward,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'completed': completed,
      };
}

class BadgeInfo {
  final String id;
  final String title;
  final IconData icon;
  final bool Function(GamificationStatus status) unlockCondition;

  const BadgeInfo({
    required this.id,
    required this.title,
    required this.icon,
    required this.unlockCondition,
  });
}

// Catálogo fixo de emblemas possíveis. Cada um define sua própria condição
// de desbloqueio a partir do status atual (nível, XP, sequência de dias).
final List<BadgeInfo> kBadgeCatalog = [
  BadgeInfo(
    id: 'streak_3',
    title: 'Sequência de 3 dias',
    icon: Icons.local_fire_department_rounded,
    unlockCondition: (s) => s.streakDays >= 3,
  ),
  BadgeInfo(
    id: 'streak_7',
    title: 'Sequência de 7 dias',
    icon: Icons.whatshot_rounded,
    unlockCondition: (s) => s.streakDays >= 7,
  ),
  BadgeInfo(
    id: 'level_5',
    title: 'Nível 5 alcançado',
    icon: Icons.military_tech_rounded,
    unlockCondition: (s) => s.level >= 5,
  ),
  BadgeInfo(
    id: 'first_mission',
    title: 'Primeira missão',
    icon: Icons.flag_rounded,
    unlockCondition: (s) => s.totalMissionsCompleted >= 1,
  ),
  BadgeInfo(
    id: 'ten_missions',
    title: '10 missões cumpridas',
    icon: Icons.emoji_events_rounded,
    unlockCondition: (s) => s.totalMissionsCompleted >= 10,
  ),
];

class GamificationStatus {
  int xp;
  int streakDays;
  int totalMissionsCompleted;
  DateTime? lastCompletionDate;
  List<Mission> missions;
  Set<String> unlockedBadgeIds;

  GamificationStatus({
    this.xp = 0,
    this.streakDays = 0,
    this.totalMissionsCompleted = 0,
    this.lastCompletionDate,
    List<Mission>? missions,
    Set<String>? unlockedBadgeIds,
  })  : missions = missions ?? _defaultMissions(),
        unlockedBadgeIds = unlockedBadgeIds ?? {};

  // 100 XP por nível, crescendo de forma simples (ajustar depois se quiser
  // uma curva de progressão diferente).
  int get level => (xp / 100).floor() + 1;
  int get xpIntoLevel => xp % 100;
  int get xpForNextLevel => 100;

  static List<Mission> _defaultMissions() => [
        Mission(
          id: 'caminhada',
          title: 'Caminhar 20 minutos',
          icon: Icons.directions_walk_rounded,
          xpReward: 20,
        ),
        Mission(
          id: 'agua',
          title: 'Beber 2 litros de água',
          icon: Icons.water_drop_rounded,
          xpReward: 15,
        ),
        Mission(
          id: 'sono',
          title: 'Dormir 8 horas',
          icon: Icons.bedtime_rounded,
          xpReward: 25,
        ),
        Mission(
          id: 'meditar',
          title: 'Meditar 5 minutos',
          icon: Icons.self_improvement_rounded,
          xpReward: 20,
        ),
      ];

  void _checkNewBadges() {
    for (final badge in kBadgeCatalog) {
      if (badge.unlockCondition(this)) {
        unlockedBadgeIds.add(badge.id);
      }
    }
  }

  /// Marca uma missão como concluída, soma XP e atualiza sequência/emblemas.
  /// Retorna a lista de ids de emblemas desbloqueados nesta chamada (para
  /// a tela poder exibir um destaque, se quiser).
  Set<String> completeMission(String missionId) {
    final mission = missions.firstWhere((m) => m.id == missionId);
    if (mission.completed) return {};

    final before = Set<String>.from(unlockedBadgeIds);

    mission.completed = true;
    xp += mission.xpReward;
    totalMissionsCompleted += 1;

    final today = DateTime.now();
    final lastDay = lastCompletionDate;
    if (lastDay == null || !_isSameDay(lastDay, today)) {
      if (lastDay != null && _isYesterday(lastDay, today)) {
        streakDays += 1;
      } else {
        streakDays = 1;
      }
      lastCompletionDate = today;
    }

    _checkNewBadges();
    return unlockedBadgeIds.difference(before);
  }

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static bool _isYesterday(DateTime a, DateTime b) {
    final diff = DateTime(b.year, b.month, b.day)
        .difference(DateTime(a.year, a.month, a.day))
        .inDays;
    return diff == 1;
  }

  /// Reseta as missões diárias (chamar isso uma vez por dia, ex: ao abrir
  /// o app e detectar virada de dia — hoje é feito de forma simples
  /// comparando lastCompletionDate; melhorar com um scheduler se precisar).
  void resetDailyMissionsIfNeeded() {
    final last = lastCompletionDate;
    if (last != null && !_isSameDay(last, DateTime.now())) {
      for (final m in missions) {
        m.completed = false;
      }
    }
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('gami_xp', xp);
    await prefs.setInt('gami_streak', streakDays);
    await prefs.setInt('gami_total_missions', totalMissionsCompleted);
    await prefs.setString(
        'gami_last_completion', lastCompletionDate?.toIso8601String() ?? '');
    await prefs.setString(
      'gami_missions',
      jsonEncode(missions.map((m) => m.toJson()).toList()),
    );
    await prefs.setStringList('gami_badges', unlockedBadgeIds.toList());
  }

  static Future<GamificationStatus> load() async {
    final prefs = await SharedPreferences.getInstance();
    final missionsStr = prefs.getString('gami_missions');
    final missions = _defaultMissions();

    if (missionsStr != null && missionsStr.isNotEmpty) {
      final decoded = jsonDecode(missionsStr) as List;
      for (final entry in decoded) {
        final match = missions.where((m) => m.id == entry['id']);
        if (match.isNotEmpty) {
          match.first.completed = entry['completed'] ?? false;
        }
      }
    }

    final lastStr = prefs.getString('gami_last_completion') ?? '';

    final status = GamificationStatus(
      xp: prefs.getInt('gami_xp') ?? 0,
      streakDays: prefs.getInt('gami_streak') ?? 0,
      totalMissionsCompleted: prefs.getInt('gami_total_missions') ?? 0,
      lastCompletionDate: lastStr.isEmpty ? null : DateTime.tryParse(lastStr),
      missions: missions,
      unlockedBadgeIds: (prefs.getStringList('gami_badges') ?? []).toSet(),
    );

    status.resetDailyMissionsIfNeeded();
    return status;
  }
}

// ─── Tela Principal ─────────────────────────────────────────────────────────

class MissionsScreen extends StatefulWidget {
  const MissionsScreen({super.key});

  @override
  State<MissionsScreen> createState() => _MissionsScreenState();
}

class _MissionsScreenState extends State<MissionsScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late GamificationStatus _status;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final status = await GamificationStatus.load();
    setState(() {
      _status = status;
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

  Future<void> _completeMission(Mission mission) async {
    if (mission.completed) return;
    final newBadges = _status.completeMission(mission.id);
    setState(() {});
    await _status.save();

    _showSnack('+${mission.xpReward} XP! 🎉');

    if (newBadges.isNotEmpty) {
      final badge = kBadgeCatalog.firstWhere((b) => b.id == newBadges.first);
      // Pequeno delay para não competir com o snackbar de XP.
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) _showSnack('Novo emblema: ${badge.title} 🏅');
      });
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
                  _buildXpCard(),
                  const SizedBox(height: 24),
                  _buildSectionLabel('MISSÕES DE HOJE'),
                  const SizedBox(height: 12),
                  ..._status.missions.map(
                    (m) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _MissionTile(
                        mission: m,
                        onComplete: () => _completeMission(m),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel('EMBLEMAS'),
                  const SizedBox(height: 12),
                  _buildBadgeGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: kDark.withOpacity(0.5),
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildXpCard() {
    final progress = _status.xpIntoLevel / _status.xpForNextLevel;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kDark,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: kYellow,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'Nv${_status.level}',
                style: const TextStyle(
                  color: kDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_status.xp} XP total',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    if (_status.streakDays > 0)
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded,
                              color: kYellow, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            '${_status.streakDays}d',
                            style: const TextStyle(
                                color: kYellow,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    minHeight: 6,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(kYellow),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_status.xpForNextLevel - _status.xpIntoLevel} XP para o nível ${_status.level + 1}',
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kBadgeCatalog.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        final badge = kBadgeCatalog[index];
        final unlocked = _status.unlockedBadgeIds.contains(badge.id);
        return _BadgeTile(badge: badge, unlocked: unlocked);
      },
    );
  }
}

// ─── Widget: Item de missão ───────────────────────────────────────────────────

class _MissionTile extends StatelessWidget {
  final Mission mission;
  final VoidCallback onComplete;

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  const _MissionTile({required this.mission, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onComplete,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: mission.completed ? Colors.green.shade600 : kDark,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                mission.completed ? Icons.check_rounded : mission.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                mission.title,
                style: TextStyle(
                  color: kDark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  decoration:
                      mission.completed ? TextDecoration.lineThrough : null,
                  decorationColor: kDark.withOpacity(0.5),
                ),
              ),
            ),
            Text(
              '+${mission.xpReward} XP',
              style: TextStyle(
                color: mission.completed ? Colors.green.shade700 : kDark.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Emblema ───────────────────────────────────────────────────────────

class _BadgeTile extends StatelessWidget {
  final BadgeInfo badge;
  final bool unlocked;

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  const _BadgeTile({required this.badge, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: unlocked ? kYellow : Colors.white.withOpacity(0.4),
            shape: BoxShape.circle,
            border: unlocked
                ? null
                : Border.all(
                    color: kDark.withOpacity(0.2),
                    width: 1.4,
                  ),
          ),
          child: Icon(
            unlocked ? badge.icon : Icons.lock_outline_rounded,
            color: unlocked ? kDark : kDark.withOpacity(0.35),
            size: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          badge.title,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: unlocked ? kDark : kDark.withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
