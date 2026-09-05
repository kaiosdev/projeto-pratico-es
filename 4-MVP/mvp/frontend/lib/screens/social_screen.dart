import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'emotional_entry_storage.dart' as emotional;

// ─── Status da funcionalidade Social ────────────────────────────────────────
//
// Uma rede social real (perfis de outros usuários, amigos, mensagens em
// tempo real) exige um backend com contas de usuário. Hoje o projeto conta
// apenas com `firebase_auth` (login), sem `cloud_firestore` nem servidor de
// mensagens. Esta tela por isso funciona com dados locais/simulados,
// permitindo validar toda a experiência de UI (perfil, feed, mensagens)
// antes da integração com um backend real:
//   • Perfil — salvo apenas no dispositivo (SharedPreferences). Para se
//     tornar social de fato, precisa ir para o Firestore vinculado ao uid
//     do Firebase Auth.
//   • Feed ("compartilhar humor") — hoje são apenas posts locais e 2
//     "amigos" fictícios. Para funcionar entre usuários reais, é necessária
//     uma coleção compartilhada (Firestore) ou um endpoint no backend Node.js.
//   • Mensagens — hoje é uma conversa simulada por contato, sem
//     WebSocket/tempo real. Para mensagens reais, as opções mais comuns são
//     Firestore com streams ou um servidor de socket dedicado.

class SocialProfile {
  String username;
  String bio;
  String avatarEmoji;

  SocialProfile({this.username = '', this.bio = '', this.avatarEmoji = '🙂'});

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('social_username', username);
    await prefs.setString('social_bio', bio);
    await prefs.setString('social_avatar', avatarEmoji);
  }

  static Future<SocialProfile> load() async {
    final prefs = await SharedPreferences.getInstance();
    return SocialProfile(
      username: prefs.getString('social_username') ?? '',
      bio: prefs.getString('social_bio') ?? '',
      avatarEmoji: prefs.getString('social_avatar') ?? '🙂',
    );
  }

  bool get isCreated => username.trim().isNotEmpty;
}

class SocialPost {
  final String id;
  final String username;
  final String avatarEmoji;
  final String moodEmoji;
  final int escala;
  final String nota;
  final DateTime postedAt;
  final bool isMine;

  SocialPost({
    required this.id,
    required this.username,
    required this.avatarEmoji,
    required this.moodEmoji,
    required this.escala,
    required this.nota,
    required this.postedAt,
    this.isMine = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'avatarEmoji': avatarEmoji,
        'moodEmoji': moodEmoji,
        'escala': escala,
        'nota': nota,
        'postedAt': postedAt.toIso8601String(),
        'isMine': isMine,
      };

  static SocialPost fromJson(Map<String, dynamic> json) => SocialPost(
        id: json['id'],
        username: json['username'],
        avatarEmoji: json['avatarEmoji'],
        moodEmoji: json['moodEmoji'],
        escala: json['escala'],
        nota: json['nota'] ?? '',
        postedAt: DateTime.parse(json['postedAt']),
        isMine: json['isMine'] ?? false,
      );
}

class SocialFeedStorage {
  static const _key = 'social_feed_posts';

  static Future<List<SocialPost>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    List<SocialPost> posts = [];
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List;
      posts = decoded.map((e) => SocialPost.fromJson(e)).toList();
    }

    // "Amigos" de exemplo, só para o feed não ficar vazio antes de existir
    // um backend com usuários reais.
    if (posts.where((p) => !p.isMine).isEmpty) {
      posts.addAll([
        SocialPost(
          id: 'mock_1',
          username: 'Marina',
          avatarEmoji: '🌸',
          moodEmoji: ':)',
          escala: 8,
          nota: 'Consegui meditar todos os dias essa semana!',
          postedAt: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        SocialPost(
          id: 'mock_2',
          username: 'Diego',
          avatarEmoji: '🌊',
          moodEmoji: ':/',
          escala: 5,
          nota: '',
          postedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ]);
    }

    posts.sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return posts;
  }

  static Future<void> add(SocialPost post) async {
    final posts = await load();
    posts.insert(0, post);
    await _saveAll(posts);
  }

  static Future<void> _saveAll(List<SocialPost> posts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(posts.map((p) => p.toJson()).toList()));
  }
}

// ─── Mensagens (simuladas, sem backend real-time) ──────────────────────────

class SocialConversation {
  final String friendName;
  final String friendAvatar;
  final List<_ChatLine> lines;

  SocialConversation({required this.friendName, required this.friendAvatar, required this.lines});
}

class _ChatLine {
  final String text;
  final bool fromMe;
  _ChatLine(this.text, this.fromMe);
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late TabController _tabController;
  bool _isLoading = true;

  SocialProfile _profile = SocialProfile();
  List<SocialPost> _feed = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await SocialProfile.load();
    final feed = await SocialFeedStorage.load();
    setState(() {
      _profile = profile;
      _feed = feed;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  Future<void> _shareLatestMood() async {
    final entries = await emotional.EmotionalEntryStorage.loadAll();
    if (entries.isEmpty) {
      _showSnack('Registre seu humor primeiro para poder compartilhar.');
      return;
    }
    if (!_profile.isCreated) {
      _showSnack('Crie seu perfil antes de compartilhar.');
      _tabController.animateTo(0);
      return;
    }

    final latest = entries.first;
    final post = SocialPost(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      username: _profile.username,
      avatarEmoji: _profile.avatarEmoji,
      moodEmoji: latest.emoji,
      escala: latest.escala,
      nota: latest.nota,
      postedAt: DateTime.now(),
      isMine: true,
    );

    await SocialFeedStorage.add(post);
    final feed = await SocialFeedStorage.load();
    setState(() => _feed = feed);
    _showSnack('Humor compartilhado! 🎉');
    _tabController.animateTo(1);
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
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Text('Social',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: kDark,
            child: TabBar(
              controller: _tabController,
              indicatorColor: kYellow,
              labelColor: kYellow,
              unselectedLabelColor: Colors.white54,
              tabs: const [
                Tab(text: 'Perfil'),
                Tab(text: 'Feed'),
                Tab(text: 'Mensagens'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ProfileTab(
                    profile: _profile,
                    onSaved: (p) => setState(() => _profile = p),
                  ),
                  _FeedTab(posts: _feed, onShare: _shareLatestMood),
                  const _MessagesTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Aba: Perfil ─────────────────────────────────────────────────────────────

class _ProfileTab extends StatefulWidget {
  final SocialProfile profile;
  final ValueChanged<SocialProfile> onSaved;
  const _ProfileTab({required this.profile, required this.onSaved});

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  static const List<String> _avatars = ['🙂', '🌸', '🌊', '🐱', '🐶', '🦊', '🌙', '🔥'];

  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  late String _selectedAvatar;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.profile.username);
    _bioController = TextEditingController(text: widget.profile.bio);
    _selectedAvatar = widget.profile.avatarEmoji;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha um nome de usuário.'), backgroundColor: Colors.redAccent),
      );
      return;
    }
    final profile = SocialProfile(
      username: _usernameController.text.trim(),
      bio: _bioController.text.trim(),
      avatarEmoji: _selectedAvatar,
    );
    await profile.save();
    widget.onSaved(profile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perfil salvo! ✅'), backgroundColor: kDark),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Center(
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(color: kYellow.withOpacity(0.2), shape: BoxShape.circle),
            child: Center(child: Text(_selectedAvatar, style: const TextStyle(fontSize: 44))),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Escolha um avatar', style: TextStyle(fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: _avatars.map((a) {
            final selected = a == _selectedAvatar;
            return GestureDetector(
              onTap: () => setState(() => _selectedAvatar = a),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: selected ? kYellow : Colors.white,
                  shape: BoxShape.circle,
                  border: selected ? Border.all(color: kDark, width: 2) : null,
                ),
                child: Center(child: Text(a, style: const TextStyle(fontSize: 20))),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Nome de usuário', style: TextStyle(fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 8),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'Como quer ser chamado(a)?',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Bio (opcional)', style: TextStyle(fontWeight: FontWeight.w800, color: kDark)),
        const SizedBox(height: 8),
        TextField(
          controller: _bioController,
          maxLines: 3,
          maxLength: 120,
          decoration: InputDecoration(
            hintText: 'Conte um pouco sobre você...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(
            backgroundColor: kDark,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(widget.profile.isCreated ? 'Salvar alterações' : 'Criar perfil',
              style: const TextStyle(color: kYellow, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}

// ─── Aba: Feed ───────────────────────────────────────────────────────────────

class _FeedTab extends StatelessWidget {
  final List<SocialPost> posts;
  final VoidCallback onShare;
  const _FeedTab({required this.posts, required this.onShare});

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${diff.inDays}d';
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 90),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(color: kYellow.withOpacity(0.15), shape: BoxShape.circle),
                        child: Center(child: Text(post.avatarEmoji, style: const TextStyle(fontSize: 18))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Text(post.username, style: const TextStyle(fontWeight: FontWeight.w800, color: kDark)),
                            if (post.isMine) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(color: kYellow.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                                child: const Text('você', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(_timeAgo(post.postedAt), style: const TextStyle(fontSize: 11, color: Colors.black38)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(post.moodEmoji, style: const TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(20)),
                        child: Text('${post.escala}/10',
                            style: const TextStyle(color: kYellow, fontSize: 11, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  if (post.nota.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(post.nota, style: const TextStyle(color: kDark, fontSize: 13, height: 1.3)),
                  ],
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: onShare,
            backgroundColor: kYellow,
            icon: const Icon(Icons.share_rounded, color: kDark),
            label: const Text('Compartilhar humor', style: TextStyle(color: kDark, fontWeight: FontWeight.w800)),
          ),
        ),
      ],
    );
  }
}

// ─── Aba: Mensagens ─────────────────────────────────────────────────────────

class _MessagesTab extends StatefulWidget {
  const _MessagesTab();

  @override
  State<_MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<_MessagesTab> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  final List<SocialConversation> _conversations = [
    SocialConversation(friendName: 'Marina', friendAvatar: '🌸', lines: [
      _ChatLine('Oi! Vi que você meditou 5 dias seguidos, arrasou! 🎉', false),
    ]),
    SocialConversation(friendName: 'Diego', friendAvatar: '🌊', lines: [
      _ChatLine('Bora fazer a meditação de hoje junto?', false),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: _conversations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final conv = _conversations[index];
        final lastLine = conv.lines.last;
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => _ConversationScreen(conversation: conv)),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: kYellow.withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(child: Text(conv.friendAvatar, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(conv.friendName, style: const TextStyle(fontWeight: FontWeight.w800, color: kDark)),
                      Text(lastLine.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.black45, fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.black26),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConversationScreen extends StatefulWidget {
  final SocialConversation conversation;
  const _ConversationScreen({required this.conversation});

  @override
  State<_ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<_ConversationScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      widget.conversation.lines.add(_ChatLine(text, true));
      // Resposta simulada, só para ilustrar a UI — sem backend real-time.
      widget.conversation.lines.add(_ChatLine('👍', false));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kDark,
        title: Text(widget.conversation.friendName, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: widget.conversation.lines.map((line) {
                return Align(
                  alignment: line.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: line.fromMe ? kYellow : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(line.text, style: const TextStyle(color: kDark)),
                  ),
                );
              }).toList(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Escreva uma mensagem...',
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.05),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: kYellow, shape: BoxShape.circle),
                      child: const Icon(Icons.send_rounded, color: kDark, size: 18),
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
}
