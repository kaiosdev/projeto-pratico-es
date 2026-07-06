import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Modelo de Assinatura Premium ─────────────────────────────────────────────
//
// Hoje o projeto não tem `in_app_purchase` nem um backend de assinaturas
// (não há cloud_firestore no pubspec.yaml), então este modelo persiste o
// status localmente via SharedPreferences — igual ao PetStatus do
// pet_screen.dart. Quando vocês integrarem um gateway de pagamento de
// verdade (in_app_purchase / RevenueCat / Stripe), é só trocar o conteúdo
// de `subscribe()` e `cancel()` por chamadas reais e manter a mesma
// interface, para não precisar mexer na tela.

enum PremiumPlan { none, monthly, yearly }

class PremiumStatus {
  bool isPremium;
  PremiumPlan plan;
  DateTime? subscribedAt;
  DateTime? expiresAt;

  PremiumStatus({
    this.isPremium = false,
    this.plan = PremiumPlan.none,
    this.subscribedAt,
    this.expiresAt,
  });

  int get daysLeft {
    if (expiresAt == null) return 0;
    final diff = expiresAt!.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('premium_is_active', isPremium);
    await prefs.setString('premium_plan', plan.name);
    await prefs.setString(
        'premium_subscribed_at', subscribedAt?.toIso8601String() ?? '');
    await prefs.setString(
        'premium_expires_at', expiresAt?.toIso8601String() ?? '');
  }

  static Future<PremiumStatus> load() async {
    final prefs = await SharedPreferences.getInstance();
    final planStr = prefs.getString('premium_plan') ?? 'none';
    final subStr = prefs.getString('premium_subscribed_at') ?? '';
    final expStr = prefs.getString('premium_expires_at') ?? '';

    return PremiumStatus(
      isPremium: prefs.getBool('premium_is_active') ?? false,
      plan: PremiumPlan.values.firstWhere(
        (p) => p.name == planStr,
        orElse: () => PremiumPlan.none,
      ),
      subscribedAt: subStr.isEmpty ? null : DateTime.tryParse(subStr),
      expiresAt: expStr.isEmpty ? null : DateTime.tryParse(expStr),
    );
  }

  /// Simula a confirmação de compra. Trocar pela chamada real do
  /// gateway de pagamento quando estiver configurado.
  void subscribe(PremiumPlan chosenPlan) {
    final now = DateTime.now();
    isPremium = true;
    plan = chosenPlan;
    subscribedAt = now;
    expiresAt = chosenPlan == PremiumPlan.yearly
        ? now.add(const Duration(days: 365))
        : now.add(const Duration(days: 30));
  }

  void cancel() {
    isPremium = false;
    plan = PremiumPlan.none;
    expiresAt = null;
  }
}

// ─── Tela Principal ───────────────────────────────────────────────────────────

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);
  static const Color kGold = Color(0xFFD4A017);

  late PremiumStatus _status;
  bool _isLoading = true;
  PremiumPlan _selectedPlan = PremiumPlan.yearly;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final status = await PremiumStatus.load();
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

  Future<void> _confirmSubscribe() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Confirmar assinatura'),
        content: Text(
          _selectedPlan == PremiumPlan.yearly
              ? 'Assinar o plano Anual por R\$ 89,90/ano?'
              : 'Assinar o plano Mensal por R\$ 14,90/mês?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: kGold),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _status.subscribe(_selectedPlan));
      await _status.save();
      _showSnack('Bem-vindo ao Premium! 👑');
    }
  }

  Future<void> _confirmCancel() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Cancelar assinatura'),
        content: Text(
          'Você continuará com os benefícios Premium até '
          '${_status.expiresAt != null ? _formatDate(_status.expiresAt!) : ''}. '
          'Deseja mesmo cancelar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Manter Premium'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancelar assinatura'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _status.cancel());
      await _status.save();
      _showSnack('Assinatura cancelada.');
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

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
                      'SlowDown Premium',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: _status.isPremium ? _buildActiveView() : _buildOfferView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Estado: já é Premium ──────────────────────────────────────────────────
  Widget _buildActiveView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kGold,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: kGold.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            children: [
              const Icon(Icons.workspace_premium_rounded, color: Colors.white, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Você é Premium!',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                'Plano ${_status.plan == PremiumPlan.yearly ? "Anual" : "Mensal"} • '
                'Renova em ${_status.expiresAt != null ? _formatDate(_status.expiresAt!) : "-"}'
                ' (${_status.daysLeft} dias restantes)',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Seus benefícios ativos',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kDark),
        ),
        const SizedBox(height: 12),
        ..._premiumBenefits.map((b) => _BenefitTile(icon: b.$1, label: b.$2, unlocked: true)),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: _confirmCancel,
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.redAccent,
            side: const BorderSide(color: Colors.redAccent),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: const Text('Cancelar assinatura'),
        ),
      ],
    );
  }

  // ── Estado: ainda não é Premium ───────────────────────────────────────────
  Widget _buildOfferView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.workspace_premium_rounded, color: kGold, size: 56),
        const SizedBox(height: 12),
        const Text(
          'Desbloqueie todo o SlowDown',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: kDark),
        ),
        const SizedBox(height: 6),
        const Text(
          'Mais meditações, relatórios, sincronização e emblemas exclusivos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: kDark, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 24),

        // Comparação de planos
        Row(
          children: [
            Expanded(child: _PlanCard(
              title: 'Mensal',
              price: 'R\$ 14,90',
              suffix: '/mês',
              selected: _selectedPlan == PremiumPlan.monthly,
              onTap: () => setState(() => _selectedPlan = PremiumPlan.monthly),
            )),
            const SizedBox(width: 12),
            Expanded(child: _PlanCard(
              title: 'Anual',
              price: 'R\$ 89,90',
              suffix: '/ano',
              badge: 'Economize 50%',
              selected: _selectedPlan == PremiumPlan.yearly,
              onTap: () => setState(() => _selectedPlan = PremiumPlan.yearly),
            )),
          ],
        ),

        const SizedBox(height: 28),
        const Text(
          'Free vs Premium',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kDark),
        ),
        const SizedBox(height: 12),
        ..._premiumBenefits.map((b) => _BenefitTile(icon: b.$1, label: b.$2, unlocked: false)),

        const SizedBox(height: 28),
        FilledButton(
          onPressed: _confirmSubscribe,
          style: FilledButton.styleFrom(
            backgroundColor: kGold,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: Text(
            'Assinar plano ${_selectedPlan == PremiumPlan.yearly ? "Anual" : "Mensal"}',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Cancele quando quiser, direto por aqui.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black54, fontSize: 12),
        ),
      ],
    );
  }

  static const List<(IconData, String)> _premiumBenefits = [
    (Icons.cloud_sync_rounded, 'Sincronização do registro emocional'),
    (Icons.bar_chart_rounded, 'Relatórios semanais e mensais (PDF)'),
    (Icons.nightlight_round, 'Biblioteca completa de Sleepcasts'),
    (Icons.emoji_events_rounded, 'Emblemas exclusivos Premium'),
    (Icons.download_rounded, 'Downloads offline ilimitados'),
  ];
}

// ─── Widget: Card de plano ─────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String suffix;
  final String? badge;
  final bool selected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.suffix,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kGold = Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? kGold : Colors.black12, width: selected ? 2.5 : 1),
          boxShadow: selected
              ? [BoxShadow(color: kGold.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, color: kDark)),
                Icon(
                  selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                  color: selected ? kGold : Colors.black26,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: kDark)),
                Text(suffix, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
            if (badge != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: kGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(badge!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: kGold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Widget: Linha de benefício ─────────────────────────────────────────────

class _BenefitTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool unlocked;

  const _BenefitTile({required this.icon, required this.label, required this.unlocked});

  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kGold = Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (unlocked ? kGold : Colors.black12).withOpacity(unlocked ? 0.15 : 1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: unlocked ? kGold : Colors.black45),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: kDark,
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
          Icon(
            unlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded,
            color: unlocked ? Colors.green : Colors.black26,
            size: 18,
          ),
        ],
      ),
    );
  }
}
