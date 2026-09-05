import 'package:flutter/material.dart';
import 'emotional_entry_storage.dart';

// ─── Tela de Histórico Emocional ────────────────────────────────────────────
//
// Lista os registros salvos em EmotionalEntryStorage (SharedPreferences),
// com resumo estatístico (média, melhor, pior) e opção de limpar o
// histórico local.

class EmotionalHistoryScreen extends StatefulWidget {
  const EmotionalHistoryScreen({super.key});

  @override
  State<EmotionalHistoryScreen> createState() => _EmotionalHistoryScreenState();
}

class _EmotionalHistoryScreenState extends State<EmotionalHistoryScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  List<EmotionalEntry> _entries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final entries = await EmotionalEntryStorage.loadAll();
    setState(() {
      _entries = entries;
      _isLoading = false;
    });
  }

  Future<void> _confirmClearAll() async {
    if (_entries.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Apagar histórico'),
        content: const Text(
          'Isso vai apagar todos os seus registros emocionais salvos '
          'neste aparelho. Essa ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apagar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await EmotionalEntryStorage.clearAll();
      _loadData();
    }
  }

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
                    const Text(
                      'HISTÓRICO EMOCIONAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    GestureDetector(
                      onTap: _confirmClearAll,
                      child: const Icon(Icons.delete_outline_rounded,
                          color: Colors.white, size: 24),
                    ),
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: kYellow))
                  : _entries.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _entries.length,
                          itemBuilder: (context, index) =>
                              _EntryTile(entry: _entries[index]),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.mood_rounded, color: kDark.withOpacity(0.25), size: 48),
            const SizedBox(height: 12),
            Text(
              'Nenhum registro ainda',
              style: TextStyle(
                color: kDark.withOpacity(0.5),
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Toque em "Registrar humor" pra começar seu histórico.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kDark.withOpacity(0.4), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Item de registro ───────────────────────────────────────────────

class _EntryTile extends StatelessWidget {
  final EmotionalEntry entry;
  const _EntryTile({required this.entry});

  static const Color kDark = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: entry.color.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(entry.emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(entry.label,
                        style: const TextStyle(fontWeight: FontWeight.w800, color: kDark, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: entry.color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${entry.escala}/10',
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kDark)),
                    ),
                  ],
                ),
                if (entry.nota.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.nota,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: kDark.withOpacity(0.6)),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            entry.relativeDateLabel,
            style: TextStyle(fontSize: 11, color: kDark.withOpacity(0.4), fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
