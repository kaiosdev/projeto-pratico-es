import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────
//
// O pubspec.yaml ainda não tem um player de áudio (ex: `just_audio` +
// `audio_service`, que juntos são o combo padrão para tocar em segundo
// plano no Flutter) nem arquivos de áudio reais. Este arquivo simula a
// reprodução com um Timer, só para já entregar toda a experiência de UI
// (biblioteca, player, temporizador) funcionando.
//
// Ao integrar áudio real:
//   • adicionar `just_audio` + `audio_service` ao pubspec.yaml;
//   • trocar `_SimulatedPlayer` por um AudioPlayer real apontando para URL
//     ou asset de cada Sleepcast;
//   • configurar o `audio_service` para permitir tocar com o app
//     minimizado/tela bloqueada — hoje o Timer simulado é cancelado se
//     o app for encerrado, então essa parte da funcionalidade de
//     "segundo plano" só fica completa com essas libs.
// A tela, a biblioteca e o temporizador não precisam mudar.

class Sleepcast {
  final String id;
  final String title;
  final String narrator;
  final int durationMinutes;
  final String category;
  final IconData icon;

  const Sleepcast({
    required this.id,
    required this.title,
    required this.narrator,
    required this.durationMinutes,
    required this.category,
    required this.icon,
  });
}

const List<Sleepcast> kSleepcastLibrary = [
  Sleepcast(
      id: 'floresta_chuva',
      title: 'Chuva na Floresta',
      narrator: 'Camila',
      durationMinutes: 35,
      category: 'Natureza',
      icon: Icons.forest_rounded),
  Sleepcast(
      id: 'trem_noturno',
      title: 'Trem Noturno',
      narrator: 'Pedro',
      durationMinutes: 40,
      category: 'Viagem',
      icon: Icons.train_rounded),
  Sleepcast(
      id: 'ondas_do_mar',
      title: 'Ondas do Mar',
      narrator: 'Camila',
      durationMinutes: 45,
      category: 'Natureza',
      icon: Icons.waves_rounded),
  Sleepcast(
      id: 'biblioteca_antiga',
      title: 'Biblioteca Antiga',
      narrator: 'Lucas',
      durationMinutes: 30,
      category: 'Relaxamento',
      icon: Icons.menu_book_rounded),
  Sleepcast(
      id: 'cabana_na_neve',
      title: 'Cabana na Neve',
      narrator: 'Pedro',
      durationMinutes: 50,
      category: 'Viagem',
      icon: Icons.cabin_rounded),
];

enum SleepTimerOption { off, min15, min30, min45, min60 }

extension SleepTimerOptionX on SleepTimerOption {
  String get label {
    switch (this) {
      case SleepTimerOption.off:
        return 'Desligado';
      case SleepTimerOption.min15:
        return '15 min';
      case SleepTimerOption.min30:
        return '30 min';
      case SleepTimerOption.min45:
        return '45 min';
      case SleepTimerOption.min60:
        return '60 min';
    }
  }

  int? get minutes {
    switch (this) {
      case SleepTimerOption.off:
        return null;
      case SleepTimerOption.min15:
        return 15;
      case SleepTimerOption.min30:
        return 30;
      case SleepTimerOption.min45:
        return 45;
      case SleepTimerOption.min60:
        return 60;
    }
  }
}

// ─── Tela: Biblioteca de Sleepcasts ────────────────────────────────────────

class SleepcastsScreen extends StatefulWidget {
  const SleepcastsScreen({super.key});

  @override
  State<SleepcastsScreen> createState() => _SleepcastsScreenState();
}

class _SleepcastsScreenState extends State<SleepcastsScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFF2B2B45);
  static const Color kBgBottom = Color(0xFF14141F);

  String _selectedCategory = 'Todos';

  List<String> get _categories =>
      ['Todos', ...{for (final s in kSleepcastLibrary) s.category}];

  List<Sleepcast> get _filtered => _selectedCategory == 'Todos'
      ? kSleepcastLibrary
      : kSleepcastLibrary.where((s) => s.category == _selectedCategory).toList();

  void _openPlayer(Sleepcast sleepcast) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SleepcastPlayerScreen(sleepcast: sleepcast)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgBottom,
      body: Column(
        children: [
          // ── AppBar ───────────────────────────────────────────────────
          SafeArea(
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
                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                      child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                  const Text('Sleepcasts',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                  const SizedBox(width: 40),
                ],
              ),
            ),
          ),

          // ── Filtro de categorias ────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final selected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? kYellow : Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? kDark : Colors.white70,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // ── Lista ────────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filtered.length,
              itemBuilder: (context, index) {
                final sleepcast = _filtered[index];
                return _SleepcastTile(
                  sleepcast: sleepcast,
                  onTap: () => _openPlayer(sleepcast),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SleepcastTile extends StatelessWidget {
  final Sleepcast sleepcast;
  final VoidCallback onTap;

  const _SleepcastTile({required this.sleepcast, required this.onTap});

  static const Color kYellow = Color(0xFFF5B800);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: kYellow.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(sleepcast.icon, color: kYellow, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sleepcast.title,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('Narrado por ${sleepcast.narrator} • ${sleepcast.durationMinutes} min',
                      style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.play_circle_fill_rounded, color: kYellow, size: 32),
          ],
        ),
      ),
    );
  }
}

// ─── Tela: Player de Sleepcast ──────────────────────────────────────────────

class SleepcastPlayerScreen extends StatefulWidget {
  final Sleepcast sleepcast;
  const SleepcastPlayerScreen({super.key, required this.sleepcast});

  @override
  State<SleepcastPlayerScreen> createState() => _SleepcastPlayerScreenState();
}

class _SleepcastPlayerScreenState extends State<SleepcastPlayerScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kBg = Color(0xFF14141F);

  bool _isPlaying = false;
  Duration _elapsed = Duration.zero;
  Timer? _playbackTicker;

  SleepTimerOption _timerOption = SleepTimerOption.off;
  Timer? _sleepTimer;
  Duration? _timerRemaining;

  @override
  void initState() {
    super.initState();
    _restoreLastTimerChoice();
  }

  Future<void> _restoreLastTimerChoice() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('sleepcast_last_timer') ?? SleepTimerOption.off.name;
    setState(() {
      _timerOption = SleepTimerOption.values.firstWhere((t) => t.name == saved,
          orElse: () => SleepTimerOption.off);
    });
  }

  @override
  void dispose() {
    _playbackTicker?.cancel();
    _sleepTimer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _playbackTicker = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _elapsed += const Duration(seconds: 1));
      });
      // Reinicia o temporizador de soneca se um estiver ativo.
      if (_timerOption != SleepTimerOption.off && _timerRemaining == null) {
        _startSleepTimer(_timerOption.minutes!);
      }
    } else {
      _playbackTicker?.cancel();
    }
  }

  void _startSleepTimer(int minutes) {
    _sleepTimer?.cancel();
    setState(() => _timerRemaining = Duration(minutes: minutes));

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerRemaining == null || _timerRemaining!.inSeconds <= 1) {
        timer.cancel();
        setState(() {
          _timerRemaining = null;
          _isPlaying = false;
        });
        _playbackTicker?.cancel();
        return;
      }
      setState(() => _timerRemaining = _timerRemaining! - const Duration(seconds: 1));
    });
  }

  Future<void> _openTimerPicker() async {
    final chosen = await showModalBottomSheet<SleepTimerOption>(
      context: context,
      backgroundColor: kBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Temporizador de soneca',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 12),
              ...SleepTimerOption.values.map((opt) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(opt.label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    trailing: _timerOption == opt
                        ? const Icon(Icons.check_circle_rounded, color: kYellow)
                        : null,
                    onTap: () => Navigator.pop(context, opt),
                  )),
            ],
          ),
        ),
      ),
    );

    if (chosen != null) {
      setState(() {
        _timerOption = chosen;
        _timerRemaining = null;
      });
      _sleepTimer?.cancel();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sleepcast_last_timer', chosen.name);

      if (chosen != SleepTimerOption.off && _isPlaying) {
        _startSleepTimer(chosen.minutes!);
      }
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final total = Duration(minutes: widget.sleepcast.durationMinutes);
    final progress = (_elapsed.inSeconds / total.inSeconds).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 32),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.bedtime_rounded, color: Colors.white54, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Toca em segundo plano',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: kYellow.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(widget.sleepcast.icon, color: kYellow, size: 90),
              ),
              const SizedBox(height: 32),
              Text(widget.sleepcast.title,
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Narrado por ${widget.sleepcast.narrator}',
                  style: const TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 28),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(kYellow),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_elapsed), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  Text(_formatDuration(total), style: const TextStyle(color: Colors.white54, fontSize: 12)),
                ],
              ),

              const SizedBox(height: 24),
              GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: const Color(0xFF1C1C1C),
                    size: 38,
                  ),
                ),
              ),

              const Spacer(),

              // Temporizador de soneca
              GestureDetector(
                onTap: _openTimerPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.timer_rounded, color: Colors.white70, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _timerRemaining != null
                            ? 'Para em ${_formatDuration(_timerRemaining!)}'
                            : 'Temporizador: ${_timerOption.label}',
                        style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
