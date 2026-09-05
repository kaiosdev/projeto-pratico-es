import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelos ───────────────────────────────────────────────────────────────
//
// Esta tela roda com um "motor" de respostas local baseado em regras
// simples (_LocalChatEngine), só para já entregar a experiência completa de
// chat (bolhas, histórico, estilo, encaminhamento para ajuda) funcionando
// de ponta a ponta sem depender de nenhuma chave de API.
//
// Ao integrar uma IA real (ex.: API da Anthropic/OpenAI):
//   • NUNCA coloque a API key direto no app — o `http`/`dio` já estão no
//     pubspec.yaml, então o app deve chamar um endpoint do SEU backend
//     (que guarda a chave em segredo), e o backend repassa para IA.
//   • troque apenas o método `_getBotReply()` por uma chamada assíncrona
//     a esse endpoint, mantendo o restante da tela igual.
//   • o histórico e o "estilo do chatbot" (prompt de sistema) continuam
//     sendo enviados junto no corpo da requisição.

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime sentAt;
  final bool isHelpReferral;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.sentAt,
    this.isHelpReferral = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'sentAt': sentAt.toIso8601String(),
        'isHelpReferral': isHelpReferral,
      };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        text: json['text'],
        isUser: json['isUser'],
        sentAt: DateTime.parse(json['sentAt']),
        isHelpReferral: json['isHelpReferral'] ?? false,
      );
}

enum ChatbotStyle { acolhedor, direto, motivacional }

extension ChatbotStyleX on ChatbotStyle {
  String get label {
    switch (this) {
      case ChatbotStyle.acolhedor:
        return 'Acolhedor';
      case ChatbotStyle.direto:
        return 'Direto';
      case ChatbotStyle.motivacional:
        return 'Motivacional';
    }
  }

  String get description {
    switch (this) {
      case ChatbotStyle.acolhedor:
        return 'Respostas calmas e empáticas';
      case ChatbotStyle.direto:
        return 'Respostas curtas e objetivas';
      case ChatbotStyle.motivacional:
        return 'Respostas com incentivo e energia';
    }
  }
}

// ─── Persistência local do histórico e estilo ─────────────────────────────

class ChatStorage {
  static Future<List<ChatMessage>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('chatbot_history');
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded.map((e) => ChatMessage.fromJson(e)).toList();
  }

  static Future<void> saveHistory(List<ChatMessage> history) async {
    final prefs = await SharedPreferences.getInstance();
    // Mantém só as últimas 200 mensagens para não crescer sem limite.
    final trimmed = history.length > 200
        ? history.sublist(history.length - 200)
        : history;
    await prefs.setString(
      'chatbot_history',
      jsonEncode(trimmed.map((m) => m.toJson()).toList()),
    );
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chatbot_history');
  }

  static Future<ChatbotStyle> loadStyle() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('chatbot_style') ?? ChatbotStyle.acolhedor.name;
    return ChatbotStyle.values.firstWhere((s) => s.name == name,
        orElse: () => ChatbotStyle.acolhedor);
  }

  static Future<void> saveStyle(ChatbotStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatbot_style', style.name);
  }
}

// ─── Motor de respostas local (placeholder) ────────────────────────────────
//
// Faz uma checagem simples de palavras-chave de risco antes de gerar
// qualquer resposta "normal". Se detectar sinais de crise, a tela sempre
// prioriza mostrar o cartão de encaminhamento para ajuda profissional —
// isso deve continuar valendo mesmo depois de ligar numa IA real.

class _LocalChatEngine {
  static const List<String> _crisisKeywords = [
    'quero morrer',
    'não aguento mais',
    'nao aguento mais',
    'suicíd',
    'suicid',
    'me machucar',
    'acabar com tudo',
    'sem saída',
    'sem saida',
  ];

  static bool isCrisisMessage(String text) {
    final lower = text.toLowerCase();
    return _crisisKeywords.any((k) => lower.contains(k));
  }

  static String reply(String userText, ChatbotStyle style) {
    final lower = userText.toLowerCase();

    if (lower.contains('ansios') || lower.contains('nervos')) {
      switch (style) {
        case ChatbotStyle.acolhedor:
          return 'Sinto que você está ansioso agora, e tudo bem sentir isso. '
              'Que tal respirarmos juntos por um minuto? Posso te levar até uma meditação curta de respiração.';
        case ChatbotStyle.direto:
          return 'Ansiedade detectada. Sugestão: meditação de respiração de 3 minutos na biblioteca.';
        case ChatbotStyle.motivacional:
          return 'Respira fundo! Você já passou por momentos difíceis antes e vai passar por esse também. Bora tentar uma meditação rápida?';
      }
    }

    if (lower.contains('triste') || lower.contains('desanimad')) {
      switch (style) {
        case ChatbotStyle.acolhedor:
          return 'Sinto muito que você esteja se sentindo assim. Quer me contar um pouco mais sobre o que está acontecendo?';
        case ChatbotStyle.direto:
          return 'Entendido. Registrar esse humor no diário emocional pode ajudar a identificar padrões.';
        case ChatbotStyle.motivacional:
          return 'Dias difíceis fazem parte da jornada. Você não está sozinho nisso — vamos registrar como você está se sentindo?';
      }
    }

    switch (style) {
      case ChatbotStyle.acolhedor:
        return 'Estou aqui com você. Me conta um pouco mais sobre como você está se sentindo hoje?';
      case ChatbotStyle.direto:
        return 'Certo. Quer registrar isso no seu diário emocional ou prefere uma meditação agora?';
      case ChatbotStyle.motivacional:
        return 'Toda conversa é um passo pra se conhecer melhor. Continue, estou ouvindo!';
    }
  }

  static const String helpReferralText =
      'Percebi que você pode estar passando por um momento muito difícil. '
      'Você não precisa lidar com isso sozinho(a) — conversar com alguém preparado pode ajudar bastante.\n\n'
      '🟡 CVV (Centro de Valorização da Vida): ligue 188 (24h, gratuito) ou acesse cvv.org.br para chat.\n'
      '🔴 Emergência: ligue 192 (SAMU) ou vá ao pronto-socorro mais próximo.\n\n'
      'Se puder, também procure alguém de confiança perto de você agora.';
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  ChatbotStyle _style = ChatbotStyle.acolhedor;
  bool _isLoading = true;
  bool _botIsTyping = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final history = await ChatStorage.loadHistory();
    final style = await ChatStorage.loadStyle();
    setState(() {
      _messages = history;
      _style = style;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      sentAt: DateTime.now(),
    );

    setState(() {
      _messages.add(userMsg);
      _botIsTyping = true;
    });
    _inputController.clear();
    _scrollToBottom();
    await ChatStorage.saveHistory(_messages);

    // Checa sinais de crise ANTES de gerar a resposta padrão — a ajuda
    // profissional sempre tem prioridade sobre a conversa comum.
    final isCrisis = _LocalChatEngine.isCrisisMessage(text);

    await Future.delayed(const Duration(milliseconds: 700));

    final botMsg = ChatMessage(
      id: '${DateTime.now().microsecondsSinceEpoch}_bot',
      text: isCrisis
          ? _LocalChatEngine.helpReferralText
          : _LocalChatEngine.reply(text, _style),
      isUser: false,
      sentAt: DateTime.now(),
      isHelpReferral: isCrisis,
    );

    if (!mounted) return;
    setState(() {
      _messages.add(botMsg);
      _botIsTyping = false;
    });
    _scrollToBottom();
    await ChatStorage.saveHistory(_messages);
  }

  Future<void> _changeStyle(ChatbotStyle style) async {
    setState(() => _style = style);
    await ChatStorage.saveStyle(style);
  }

  Future<void> _confirmClearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Limpar histórico'),
        content: const Text('Isso vai apagar todas as mensagens dessa conversa. Continuar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ChatStorage.clearHistory();
      setState(() => _messages = []);
    }
  }

  void _openStylePicker() {
    showModalBottomSheet(
      context: context,
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
              const Text('Estilo do chatbot',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: kDark)),
              const SizedBox(height: 12),
              ...ChatbotStyle.values.map((s) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(s.label, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text(s.description),
                    trailing: _style == s
                        ? const Icon(Icons.check_circle_rounded, color: kYellow)
                        : null,
                    onTap: () {
                      _changeStyle(s);
                      Navigator.pop(context);
                    },
                  )),
            ],
          ),
        ),
      ),
    );
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
                    Column(
                      children: [
                        const Text('Assistente SlowDown',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        Text('Estilo: ${_style.label}',
                            style: const TextStyle(color: Colors.white60, fontSize: 11)),
                      ],
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'style') _openStylePicker();
                        if (value == 'clear') _confirmClearHistory();
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'style', child: Text('Mudar estilo')),
                        PopupMenuItem(value: 'clear', child: Text('Limpar histórico')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Mensagens ───────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: _messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length + (_botIsTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= _messages.length) {
                          return const _TypingBubble();
                        }
                        return _ChatBubble(message: _messages[index]);
                      },
                    ),
            ),
          ),

          // ── Campo de mensagem ──────────────────────────────────────
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      textCapitalization: TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Escreva como você está se sentindo...',
                        filled: true,
                        fillColor: kBgTop.withOpacity(0.4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: kDark, size: 20),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: kDark, size: 40),
            const SizedBox(height: 12),
            const Text(
              'Oi! Sou o assistente do SlowDown.\nConte como você está se sentindo hoje.',
              textAlign: TextAlign.center,
              style: TextStyle(color: kDark, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Bolha de mensagem ──────────────────────────────────────────────

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const _ChatBubble({required this.message});

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kYellow = Color(0xFFF5B800);

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final isHelp = message.isHelpReferral;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        decoration: BoxDecoration(
          color: isHelp
              ? Colors.redAccent.withOpacity(0.12)
              : (isUser ? kYellow : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
          border: isHelp ? Border.all(color: Colors.redAccent.withOpacity(0.4)) : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isHelp)
              const Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(Icons.favorite_rounded, color: Colors.redAccent, size: 16),
                    SizedBox(width: 6),
                    Text('Rede de apoio',
                        style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w800, fontSize: 12)),
                  ],
                ),
              ),
            Text(
              message.text,
              style: TextStyle(
                color: kDark,
                fontWeight: isUser ? FontWeight.w600 : FontWeight.w500,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  static const Color kDark = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: const SizedBox(
          width: 32,
          height: 12,
          child: Center(
            child: Text('•••', style: TextStyle(color: kDark, fontWeight: FontWeight.w900, letterSpacing: 2)),
          ),
        ),
      ),
    );
  }
}
