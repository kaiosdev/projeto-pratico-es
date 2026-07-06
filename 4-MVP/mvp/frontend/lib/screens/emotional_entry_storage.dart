import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelo compartilhado de Registro Emocional ────────────────────────────
//
// Este arquivo existe porque, olhando `emotional_record_screen.dart` e
// `registro_emocional_screen.dart`, percebi que HOJE NENHUM dos dois
// realmente salva o registro em lugar nenhum — os dois têm um
// `// TODO: salvar no backend` e só mostram uma SnackBar de sucesso. O
// histórico (`EmotionalHistoryScreen`) também está 100% com dados mock
// (`_mockHistory`), por isso ele está como 🟡 parcial na checklist.
//
// Pra eu conseguir gerar o Termômetro Emocional (insights, evolução
// semanal/mensal) com dados de verdade, alguém precisa persistir o
// registro em algum lugar primeiro. Como o backend em Node.js ainda não
// está plugado no app Flutter, criei esse storage local (SharedPreferences)
// como uma ponte: os registros já ficam salvos de verdade no dispositivo
// HOJE, e quando o backend estiver pronto, é só trocar `EmotionalEntryStorage`
// por chamadas HTTP/Dio — os outros arquivos que o usam não precisam mudar.
//
// Escala usada: 1 a 10 (igual ao Slider dos dois arquivos originais).

class EmotionalEntry {
  final String id;
  final DateTime date;
  final String emoji;
  final String label;
  final int escala; // 1-10
  final String colorHex;
  final String nota;

  EmotionalEntry({
    required this.id,
    required this.date,
    required this.emoji,
    required this.label,
    required this.escala,
    required this.colorHex,
    required this.nota,
  });

  Color get color => Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date.toIso8601String(),
        'emoji': emoji,
        'label': label,
        'escala': escala,
        'colorHex': colorHex,
        'nota': nota,
      };

  static EmotionalEntry fromJson(Map<String, dynamic> json) => EmotionalEntry(
        id: json['id'],
        date: DateTime.parse(json['date']),
        emoji: json['emoji'],
        label: json['label'],
        escala: json['escala'],
        colorHex: json['colorHex'],
        nota: json['nota'] ?? '',
      );

  /// Formata a data de forma amigável, igual ao estilo usado no
  /// `_mockHistory` original ('Hoje', 'Ontem', '2 dias atrás'...).
  String get relativeDateLabel {
    final now = DateTime.now();
    final diff = DateTime(now.year, now.month, now.day)
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    if (diff > 1) return '$diff dias atrás';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
  }
}

class EmotionalEntryStorage {
  static const _key = 'emotional_entries_v1';

  static Future<List<EmotionalEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    final entries = decoded.map((e) => EmotionalEntry.fromJson(e)).toList();
    entries.sort((a, b) => b.date.compareTo(a.date)); // mais recente primeiro
    return entries;
  }

  static Future<void> add(EmotionalEntry entry) async {
    final entries = await loadAll();
    entries.add(entry);
    await _saveAll(entries);
  }

  static Future<void> _saveAll(List<EmotionalEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(entries.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
