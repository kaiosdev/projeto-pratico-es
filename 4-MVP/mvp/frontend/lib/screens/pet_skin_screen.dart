import 'package:flutter/material.dart';

class PetSkinScreen extends StatefulWidget {
  final String? currentHat;
  final String? currentGlasses;
  final String currentRace;

  const PetSkinScreen({
    super.key,
    this.currentHat,
    this.currentGlasses,
    this.currentRace = 'cat',
  });

  @override
  State<PetSkinScreen> createState() => _PetSkinScreenState();
}

class _PetSkinScreenState extends State<PetSkinScreen>
    with SingleTickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBgTop = Color(0xFFF5F0A0);
  static const Color kBgBottom = Color(0xFFE8E4A0);

  late TabController _tabController;
  String? _selectedHat;
  String? _selectedGlasses;
  late String _selectedRace;

  // Chapéus disponíveis
  final List<Map<String, dynamic>> _hats = [
    {'id': 'chapeu', 'label': 'Chapéu', 'icon': Icons.hardware_rounded, 'color': Color(0xFF8B4513)},
    {'id': 'noel', 'label': 'Noel', 'icon': Icons.hotel_class_rounded, 'color': Colors.red},
    {'id': 'bucket', 'label': 'Bucket', 'icon': Icons.inbox_rounded, 'color': Colors.blue},
    {'id': 'mafioso', 'label': 'Mafioso', 'icon': Icons.shield_rounded, 'color': Colors.black87},
    {'id': 'cartola', 'label': 'Cartola', 'icon': Icons.looks_one_rounded, 'color': Colors.black87},
  ];

  // Óculos disponíveis
  final List<Map<String, dynamic>> _glasses = [
    {'id': 'oculos', 'label': 'Óculos', 'icon': Icons.remove_red_eye_rounded, 'color': Colors.black87},
    {'id': 'de_grau', 'label': 'De Grau', 'icon': Icons.remove_red_eye_outlined, 'color': Colors.brown},
    {'id': 'aviador', 'label': 'Aviador', 'icon': Icons.lens_rounded, 'color': Color(0xFFDAA520)},
  ];

  // Raças disponíveis
  final List<Map<String, dynamic>> _races = [
    {'id': 'cat', 'label': 'Gato', 'color': Color(0xFFF5C842)},
    {'id': 'dog', 'label': 'Cachorro', 'color': Color(0xFFD4A96A)},
    {'id': 'robot', 'label': 'Robô', 'color': Color(0xFFB0BEC5)},
    {'id': 'monk', 'label': 'Monge', 'color': Color(0xFFF5C842)},
    {'id': 'aviator', 'label': 'Aviador', 'color': Color(0xFFE8C49A)},
  ];

  @override
  void initState() {
    super.initState();
    _selectedHat = widget.currentHat;
    _selectedGlasses = widget.currentGlasses;
    _selectedRace = widget.currentRace;
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    Navigator.of(context).pop<Map<String, String?>>({
      'hat': _selectedHat,
      'glasses': _selectedGlasses,
      'race': _selectedRace,
    });
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
                    GestureDetector(
                      onTap: _onConfirm,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Preview do pet ───────────────────────────────────────────
          Container(
            color: kBgTop,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(140, 140),
                    painter: _PreviewPetPainter(race: _selectedRace),
                  ),
                  if (_selectedHat != null)
                    Positioned(
                      top: 6,
                      child: _PreviewHat(hat: _selectedHat!),
                    ),
                  if (_selectedGlasses != null)
                    Positioned(
                      top: 50,
                      child: _PreviewGlasses(glasses: _selectedGlasses!),
                    ),
                ],
              ),
            ),
          ),

          // ── Tabs ─────────────────────────────────────────────────────
          Container(
            color: kBgTop,
            child: TabBar(
              controller: _tabController,
              labelColor: kDark,
              unselectedLabelColor: kDark.withOpacity(0.4),
              indicatorColor: kYellow,
              indicatorWeight: 3,
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
              tabs: const [
                Tab(text: 'CHAPÉU'),
                Tab(text: 'ÓCULOS'),
                Tab(text: 'RAÇA'),
              ],
            ),
          ),

          // ── Conteúdo das tabs ─────────────────────────────────────────
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
                  // Tab: Chapéus
                  _SkinGrid(
                    items: _hats,
                    selectedId: _selectedHat,
                    onSelect: (id) =>
                        setState(() => _selectedHat = _selectedHat == id ? null : id),
                    canDeselect: true,
                  ),

                  // Tab: Óculos
                  _SkinGrid(
                    items: _glasses,
                    selectedId: _selectedGlasses,
                    onSelect: (id) =>
                        setState(() => _selectedGlasses = _selectedGlasses == id ? null : id),
                    canDeselect: true,
                  ),

                  // Tab: Raças
                  _SkinGrid(
                    items: _races,
                    selectedId: _selectedRace,
                    onSelect: (id) => setState(() => _selectedRace = id),
                    canDeselect: false,
                  ),
                ],
              ),
            ),
          ),

          // ── Botão confirmar ───────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'CONFIRMAR',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Widget: Grid de skins ────────────────────────────────────────────────────

class _SkinGrid extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? selectedId;
  final void Function(String id) onSelect;
  final bool canDeselect;

  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);

  const _SkinGrid({
    required this.items,
    required this.selectedId,
    required this.onSelect,
    required this.canDeselect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        final isSelected = selectedId == item['id'];

        return GestureDetector(
          onTap: () => onSelect(item['id']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? kYellow.withOpacity(0.3)
                  : Colors.white.withOpacity(0.4),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? kYellow : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: item.containsKey('icon')
                      ? Icon(item['icon'] as IconData,
                          color: Colors.white, size: 28)
                      : Center(
                          child: Text(
                            item['label'][0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  item['label'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kDark,
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: kYellow, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Painter: Preview pet ─────────────────────────────────────────────────────

class _PreviewPetPainter extends CustomPainter {
  final String race;
  const _PreviewPetPainter({required this.race});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    Color bodyColor;
    switch (race) {
      case 'dog':
        bodyColor = const Color(0xFFD4A96A);
        break;
      case 'robot':
        bodyColor = const Color(0xFFB0BEC5);
        break;
      case 'monk':
      case 'aviator':
      default:
        bodyColor = const Color(0xFFF5C842);
    }

    final bodyPaint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final darkFill = Paint()
      ..color = const Color(0xFF1C1C1C)
      ..style = PaintingStyle.fill;

    // Corpo
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.68), width: w * 0.60, height: h * 0.48),
      bodyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.68), width: w * 0.60, height: h * 0.48),
      outlinePaint,
    );

    // Cabeça
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.35), width: w * 0.56, height: h * 0.48),
      bodyPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.35), width: w * 0.56, height: h * 0.48),
      outlinePaint,
    );

    // Orelhas
    if (race == 'dog') {
      final leftEar = Path()
        ..moveTo(w * 0.22, h * 0.18)
        ..cubicTo(w * 0.08, h * 0.22, w * 0.10, h * 0.38, w * 0.22, h * 0.42)
        ..lineTo(w * 0.28, h * 0.20)
        ..close();
      canvas.drawPath(leftEar, bodyPaint);
      canvas.drawPath(leftEar, outlinePaint);
      final rightEar = Path()
        ..moveTo(w * 0.78, h * 0.18)
        ..cubicTo(w * 0.92, h * 0.22, w * 0.90, h * 0.38, w * 0.78, h * 0.42)
        ..lineTo(w * 0.72, h * 0.20)
        ..close();
      canvas.drawPath(rightEar, bodyPaint);
      canvas.drawPath(rightEar, outlinePaint);
    } else {
      final leftEar = Path()
        ..moveTo(w * 0.24, h * 0.20)
        ..lineTo(w * 0.16, h * 0.06)
        ..lineTo(w * 0.36, h * 0.14)
        ..close();
      canvas.drawPath(leftEar, bodyPaint);
      canvas.drawPath(leftEar, outlinePaint);
      final rightEar = Path()
        ..moveTo(w * 0.76, h * 0.20)
        ..lineTo(w * 0.84, h * 0.06)
        ..lineTo(w * 0.64, h * 0.14)
        ..close();
      canvas.drawPath(rightEar, bodyPaint);
      canvas.drawPath(rightEar, outlinePaint);
    }

    // Olhos
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.38, h * 0.32), width: w * 0.10, height: h * 0.10),
      darkFill,
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.62, h * 0.32), width: w * 0.10, height: h * 0.10),
      darkFill,
    );

    // Nariz
    final nosePath = Path()
      ..moveTo(w * 0.5, h * 0.40)
      ..lineTo(w * 0.46, h * 0.44)
      ..lineTo(w * 0.54, h * 0.44)
      ..close();
    canvas.drawPath(nosePath, darkFill);
  }

  @override
  bool shouldRepaint(covariant _PreviewPetPainter old) => old.race != race;
}

// ─── Widget: Preview chapéu ───────────────────────────────────────────────────

class _PreviewHat extends StatelessWidget {
  final String hat;
  const _PreviewHat({required this.hat});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    switch (hat) {
      case 'noel':
        color = Colors.red;
        icon = Icons.hotel_class_rounded;
        break;
      case 'bucket':
        color = Colors.blue;
        icon = Icons.inbox_rounded;
        break;
      case 'mafioso':
        color = Colors.black87;
        icon = Icons.shield_rounded;
        break;
      case 'cartola':
        color = Colors.black87;
        icon = Icons.looks_one_rounded;
        break;
      default:
        color = const Color(0xFF8B4513);
        icon = Icons.hardware_rounded;
    }
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(icon, color: Colors.white, size: 22),
    );
  }
}

// ─── Widget: Preview óculos ───────────────────────────────────────────────────

class _PreviewGlasses extends StatelessWidget {
  final String glasses;
  const _PreviewGlasses({required this.glasses});

  @override
  Widget build(BuildContext context) {
    Color frameColor;
    switch (glasses) {
      case 'aviador':
        frameColor = const Color(0xFFDAA520);
        break;
      default:
        frameColor = Colors.black87;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: frameColor, width: 2),
            borderRadius: BorderRadius.circular(glasses == 'aviador' ? 50 : 3),
            color: frameColor.withOpacity(0.1),
          ),
        ),
        Container(width: 8, height: 1.5, color: frameColor),
        Container(
          width: 24,
          height: 16,
          decoration: BoxDecoration(
            border: Border.all(color: frameColor, width: 2),
            borderRadius: BorderRadius.circular(glasses == 'aviador' ? 50 : 3),
            color: frameColor.withOpacity(0.1),
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
