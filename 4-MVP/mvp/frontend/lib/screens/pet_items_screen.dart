import 'package:flutter/material.dart';

class PetItemsScreen extends StatefulWidget {
  const PetItemsScreen({super.key});

  @override
  State<PetItemsScreen> createState() => _PetItemsScreenState();
}

class _PetItemsScreenState extends State<PetItemsScreen> {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  final List<Map<String, dynamic>> _items = [
    {
      'id': 'chapeu',
      'label': 'Chapéu',
      'category': 'Acessório',
      'icon': Icons.hardware_rounded,
      'color': Color(0xFF8B4513),
      'owned': true,
    },
    {
      'id': 'noel',
      'label': 'Gorro Noel',
      'category': 'Acessório',
      'icon': Icons.hotel_class_rounded,
      'color': Colors.red,
      'owned': true,
    },
    {
      'id': 'bucket',
      'label': 'Bucket Hat',
      'category': 'Acessório',
      'icon': Icons.inbox_rounded,
      'color': Colors.blue,
      'owned': false,
    },
    {
      'id': 'mafioso',
      'label': 'Chapéu Mafioso',
      'category': 'Acessório',
      'icon': Icons.shield_rounded,
      'color': Colors.black87,
      'owned': false,
    },
    {
      'id': 'cartola',
      'label': 'Cartola',
      'category': 'Acessório',
      'icon': Icons.looks_one_rounded,
      'color': Colors.black87,
      'owned': false,
    },
    {
      'id': 'oculos',
      'label': 'Óculos',
      'category': 'Acessório',
      'icon': Icons.remove_red_eye_rounded,
      'color': Colors.black87,
      'owned': true,
    },
    {
      'id': 'de_grau',
      'label': 'Óculos de Grau',
      'category': 'Acessório',
      'icon': Icons.remove_red_eye_outlined,
      'color': Colors.brown,
      'owned': false,
    },
    {
      'id': 'aviador_glasses',
      'label': 'Óculos Aviador',
      'category': 'Acessório',
      'icon': Icons.lens_rounded,
      'color': Color(0xFFDAA520),
      'owned': false,
    },
    {
      'id': 'dog',
      'label': 'Cachorro',
      'category': 'Raça',
      'icon': Icons.pets_rounded,
      'color': Color(0xFFD4A96A),
      'owned': true,
    },
    {
      'id': 'robot',
      'label': 'Robô',
      'category': 'Raça',
      'icon': Icons.smart_toy_rounded,
      'color': Color(0xFFB0BEC5),
      'owned': false,
    },
    {
      'id': 'monk',
      'label': 'Monge',
      'category': 'Raça',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFE57C1A),
      'owned': false,
    },
    {
      'id': 'aviator',
      'label': 'Aviador',
      'category': 'Raça',
      'icon': Icons.flight_rounded,
      'color': Color(0xFFE8C49A),
      'owned': false,
    },
  ];

  String _filter = 'Todos';
  final List<String> _filters = ['Todos', 'Acessório', 'Raça'];

  List<Map<String, dynamic>> get _filtered => _filter == 'Todos'
      ? _items
      : _items.where((i) => i['category'] == _filter).toList();

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
                    _SlowDownLogo(size: 28),
                    const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 28),
                  ],
                ),
              ),
            ),
          ),

          // ── Corpo ─────────────────────────────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kBgTop, kBgBottom],
                ),
              ),
              child: Column(
                children: [
                  // ── Header ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Row(
                      children: [
                        const Text(
                          'ITENS DO PET',
                          style: TextStyle(
                            color: Color(0xFF1C1C1C),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Spacer(),
                        // Moedas
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.star_rounded,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                '250',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Filtros ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: _filters.map((f) {
                        final selected = _filter == f;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => setState(() => _filter = f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? kDark : Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                f,
                                style: TextStyle(
                                  color: selected ? Colors.white : kDark.withOpacity(0.6),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // ── Grid de itens ─────────────────────────────────────
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.82,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final item = _filtered[i];
                        final owned = item['owned'] as bool;
                        return _ItemCard(
                          label: item['label'],
                          category: item['category'],
                          icon: item['icon'],
                          color: item['color'],
                          owned: owned,
                          onTap: () {
                            if (!owned) {
                              // TODO: lógica de compra
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Comprar ${item['label']}?'),
                                  backgroundColor: kDark,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  action: SnackBarAction(
                                    label: 'COMPRAR',
                                    textColor: kYellow,
                                    onPressed: () {
                                      setState(() => item['owned'] = true);
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Card de item ─────────────────────────────────────────────────────

class _ItemCard extends StatelessWidget {
  final String label;
  final String category;
  final IconData icon;
  final Color color;
  final bool owned;
  final VoidCallback onTap;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  const _ItemCard({
    required this.label,
    required this.category,
    required this.icon,
    required this.color,
    required this.owned,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: owned
              ? Colors.white.withOpacity(0.5)
              : Colors.white.withOpacity(0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: owned ? color.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: owned
                        ? color.withOpacity(0.9)
                        : Colors.grey.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon,
                      color: owned ? Colors.white : Colors.grey.shade500,
                      size: 26),
                ),
                if (!owned)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: kDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded,
                        color: Colors.white, size: 10),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: owned ? kDark : kDark.withOpacity(0.4),
                fontSize: 10,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            if (!owned)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.star_rounded,
                      color: kYellow, size: 12),
                  const SizedBox(width: 2),
                  Text(
                    'MAIS',
                    style: TextStyle(
                      color: kDark.withOpacity(0.5),
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            if (owned)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF6AAA7C), size: 14),
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
              borderRadius: BorderRadius.circular(4)),
          child: Text('SLOW',
              style: TextStyle(
                  color: const Color(0xFFF5B800),
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.w900,
                  height: 1)),
        ),
        SizedBox(width: size * 0.08),
        Text('DOWN',
            style: TextStyle(
                color: const Color(0xFF1C1C1C),
                fontSize: size * 0.72,
                fontWeight: FontWeight.w900,
                height: 1)),
      ],
    );
  }
}
