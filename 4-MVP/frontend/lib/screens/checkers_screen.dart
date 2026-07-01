import 'dart:math';
import 'package:flutter/material.dart';

class CheckersScreen extends StatefulWidget {
  const CheckersScreen({super.key});

  @override
  State<CheckersScreen> createState() => _CheckersScreenState();
}

class _CheckersScreenState extends State<CheckersScreen> with TickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kBoard1 = Color(0xFFEECFA4);
  static const Color kBoard2 = Color(0xFF8B5E3C);
  static const Color kPlayer = Color(0xFF1565C0);
  static const Color kAI = Color(0xFFB71C1C);
  static const Color kSelected = Color(0xFF00E676);
  static const Color kValidMove = Color(0xFF69F0AE);

  // Tabuleiro 8x8. 0=vazio, 1=jogador, 2=IA, 3=dama jogador, 4=dama IA
  late List<List<int>> _board;
  int? _selRow, _selCol;
  List<List<int>> _validMoves = [];
  bool _playerTurn = true;
  String _status = 'Sua vez!';
  bool _gameOver = false;

  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _initBoard();
  }

  void _initBoard() {
    _board = List.generate(8, (r) => List.generate(8, (c) {
      if ((r + c) % 2 == 1) {
        if (r < 3) return 2; // IA no topo
        if (r > 4) return 1; // Jogador embaixo
      }
      return 0;
    }));
    _selRow = null;
    _selCol = null;
    _validMoves = [];
    _playerTurn = true;
    _status = 'Sua vez!';
    _gameOver = false;
  }

  bool _isPlayer(int v) => v == 1 || v == 3;
  bool _isAI(int v) => v == 2 || v == 4;
  bool _isKing(int v) => v == 3 || v == 4;

  // Retorna movimentos válidos para uma peça
  List<List<int>> _getMovesFor(int r, int c, {bool captureOnly = false}) {
    final piece = _board[r][c];
    if (piece == 0) return [];

    final moves = <List<int>>[];
    final dirs = <List<int>>[];

    if (_isPlayer(piece) || _isKing(piece)) {
      dirs.addAll([[-1, -1], [-1, 1]]); // cima
    }
    if (_isAI(piece) || _isKing(piece)) {
      dirs.addAll([[1, -1], [1, 1]]); // baixo
    }

    // Captura forçada
    final captures = <List<int>>[];
    for (final d in dirs) {
      final mr = r + d[0];
      final mc = c + d[1];
      final jr = r + 2 * d[0];
      final jc = c + 2 * d[1];
      if (_inBounds(mr, mc) && _inBounds(jr, jc)) {
        final mid = _board[mr][mc];
        final isEnemy = (_isPlayer(piece) && _isAI(mid)) || (_isAI(piece) && _isPlayer(mid));
        if (isEnemy && _board[jr][jc] == 0) {
          captures.add([jr, jc]);
        }
      }
    }
    if (captures.isNotEmpty) return captures;

    if (captureOnly) return [];

    // Movimento normal
    for (final d in dirs) {
      final nr = r + d[0];
      final nc = c + d[1];
      if (_inBounds(nr, nc) && _board[nr][nc] == 0) {
        moves.add([nr, nc]);
      }
    }
    return moves;
  }

  bool _inBounds(int r, int c) => r >= 0 && r < 8 && c >= 0 && c < 8;

  // Verifica se há capturas obrigatórias para o jogador atual
  bool _hasMandatoryCapture(bool forPlayer) {
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        final p = _board[r][c];
        if (forPlayer ? _isPlayer(p) : _isAI(p)) {
          if (_getMovesFor(r, c, captureOnly: true).isNotEmpty) return true;
        }
      }
    }
    return false;
  }

  void _onTap(int r, int c) {
    if (!_playerTurn || _gameOver) return;

    final piece = _board[r][c];

    // Selecionar peça
    if (_isPlayer(piece)) {
      final moves = _getMovesFor(r, c);
      final hasCapture = _hasMandatoryCapture(true);
      final pieceMoves = _getMovesFor(r, c, captureOnly: true);

      // Se há captura obrigatória e esta peça não pode capturar, bloquear
      if (hasCapture && pieceMoves.isEmpty) {
        _showSnack('Captura obrigatória! Selecione uma peça que pode capturar.');
        return;
      }

      setState(() {
        _selRow = r;
        _selCol = c;
        _validMoves = hasCapture ? pieceMoves : moves;
      });
      return;
    }

    // Mover peça selecionada
    if (_selRow != null && _validMoves.any((m) => m[0] == r && m[1] == c)) {
      _executeMove(_selRow!, _selCol!, r, c, true);
    } else {
      setState(() { _selRow = null; _selCol = null; _validMoves = []; });
    }
  }

  void _executeMove(int fr, int fc, int tr, int tc, bool isPlayer) {
    setState(() {
      final piece = _board[fr][fc];
      _board[tr][tc] = piece;
      _board[fr][fc] = 0;

      // Captura
      if ((tr - fr).abs() == 2) {
        final mr = (fr + tr) ~/ 2;
        final mc = (fc + tc) ~/ 2;
        _board[mr][mc] = 0;
      }

      // Promoção a dama
      if (isPlayer && tr == 0 && piece == 1) _board[tr][tc] = 3;
      if (!isPlayer && tr == 7 && piece == 2) _board[tr][tc] = 4;

      _selRow = null;
      _selCol = null;
      _validMoves = [];
    });

    _checkWin();
    if (!_gameOver) {
      if (isPlayer) {
        setState(() { _playerTurn = false; _status = 'IA pensando...'; });
        Future.delayed(const Duration(milliseconds: 600), _aiMove);
      } else {
        setState(() { _playerTurn = true; _status = 'Sua vez!'; });
      }
    }
  }

  void _aiMove() {
    if (_gameOver) return;

    // Encontra todos os movimentos da IA
    final allMoves = <List<int>>[];
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (_isAI(_board[r][c])) {
          for (final m in _getMovesFor(r, c)) {
            allMoves.add([r, c, m[0], m[1]]);
          }
        }
      }
    }

    if (allMoves.isEmpty) {
      setState(() { _status = 'Você venceu! 🎉'; _gameOver = true; });
      return;
    }

    // Prioriza capturas
    final captures = allMoves.where((m) => (m[2] - m[0]).abs() == 2).toList();
    final chosen = captures.isNotEmpty
        ? captures[Random().nextInt(captures.length)]
        : allMoves[Random().nextInt(allMoves.length)];

    _executeMove(chosen[0], chosen[1], chosen[2], chosen[3], false);
  }

  void _checkWin() {
    int playerPieces = 0, aiPieces = 0;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (_isPlayer(_board[r][c])) playerPieces++;
        if (_isAI(_board[r][c])) aiPieces++;
      }
    }
    if (aiPieces == 0) setState(() { _status = 'Você venceu! 🎉'; _gameOver = true; });
    if (playerPieces == 0) setState(() { _status = 'IA venceu! 😅'; _gameOver = true; });
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: kDark,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  void dispose() {
    _moveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int playerCount = 0, aiCount = 0;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (_isPlayer(_board[r][c])) playerCount++;
        if (_isAI(_board[r][c])) aiCount++;
      }
    }

    return Scaffold(
      body: Column(
        children: [
          // AppBar
          Container(
            color: const Color(0xFF5C4F8A),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.maybePop(context),
                      child: Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.reply_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                    const Spacer(),
                    const Text('DAMA', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(_initBoard),
                      child: Container(
                        width: 40, height: 40,
                        decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                        child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Placar
          Container(
            color: const Color(0xFF4A3F78),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScoreChip(label: 'VOCÊ', count: playerCount, color: kPlayer),
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: _gameOver ? kYellow : (_playerTurn ? kPlayer : kAI),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _status,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                _ScoreChip(label: 'IA', count: aiCount, color: kAI),
              ],
            ),
          ),

          // Tabuleiro
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kDark, width: 3),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                        itemCount: 64,
                        itemBuilder: (_, idx) {
                          final r = idx ~/ 8;
                          final c = idx % 8;
                          final isDark = (r + c) % 2 == 1;
                          final piece = _board[r][c];
                          final isSelected = _selRow == r && _selCol == c;
                          final isValid = _validMoves.any((m) => m[0] == r && m[1] == c);

                          Color cellColor = isDark ? kBoard2 : kBoard1;
                          if (isSelected) cellColor = kSelected.withOpacity(0.6);
                          if (isValid) cellColor = kValidMove.withOpacity(0.7);

                          return GestureDetector(
                            onTap: () => _onTap(r, c),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              color: cellColor,
                              child: piece != 0
                                  ? Center(child: _PieceWidget(type: piece))
                                  : isValid
                                      ? Center(
                                          child: Container(
                                            width: 14, height: 14,
                                            decoration: BoxDecoration(
                                              color: kValidMove.withOpacity(0.8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        )
                                      : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Game over
          if (_gameOver)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: GestureDetector(
                onTap: () => setState(_initBoard),
                child: Container(
                  width: double.infinity, height: 52,
                  decoration: BoxDecoration(color: kYellow, borderRadius: BorderRadius.circular(50)),
                  child: const Center(
                    child: Text('JOGAR NOVAMENTE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15, letterSpacing: 2)),
                  ),
                ),
              ),
            ),

          // Legenda
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendItem(color: kPlayer, label: 'Você'),
                const SizedBox(width: 20),
                _LegendItem(color: kAI, label: 'IA'),
                const SizedBox(width: 20),
                Row(children: [
                  Container(
                    width: 20, height: 20,
                    decoration: BoxDecoration(
                      color: kPlayer,
                      shape: BoxShape.circle,
                      border: Border.all(color: kYellow, width: 2.5),
                    ),
                    child: const Icon(Icons.star_rounded, color: kYellow, size: 12),
                  ),
                  const SizedBox(width: 4),
                  const Text('Dama', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PieceWidget extends StatelessWidget {
  final int type;
  const _PieceWidget({required this.type});

  @override
  Widget build(BuildContext context) {
    final isPlayer = type == 1 || type == 3;
    final isKing = type == 3 || type == 4;
    final color = isPlayer ? const Color(0xFF1565C0) : const Color(0xFFB71C1C);

    return Container(
      width: double.infinity, height: double.infinity,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isKing ? const Color(0xFFF5B800) : Colors.white.withOpacity(0.4),
          width: isKing ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: isKing
          ? const Icon(Icons.star_rounded, color: Color(0xFFF5B800), size: 14)
          : null,
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _ScoreChip({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle,
              border: Border.all(color: Colors.white30, width: 1.5)),
        ),
        const SizedBox(height: 2),
        Text('$label: $count', style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w700)),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 20, height: 20, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    ]);
  }
}
