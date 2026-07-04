import 'dart:async';
import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  static const Color kYellow = Color(0xFFF5B800);
  static const Color kDark = Color(0xFF1C1C1C);
  static const Color kCorrect = Color(0xFF43A047);
  static const Color kWrong = Color(0xFFE53935);

  final List<_Question> _questions = [
    _Question(
      text: 'Quantas horas de sono por noite são recomendadas para adultos?',
      options: ['5–6 horas', '7–9 horas', '10–12 horas', '4–5 horas'],
      correct: 1,
      explanation: 'Adultos precisam de 7–9 horas de sono para boa saúde mental e física.',
    ),
    _Question(
      text: 'Qual técnica de respiração ajuda a reduzir a ansiedade rapidamente?',
      options: ['Respirar rápido', 'Prender a respiração', 'Respirar fundo pelo nariz e soltar lentamente', 'Respirar pela boca'],
      correct: 2,
      explanation: 'Respirar fundo e lentamente ativa o sistema nervoso parassimpático, reduzindo o estresse.',
    ),
    _Question(
      text: 'Qual dessas atividades é considerada mindfulness?',
      options: ['Assistir TV enquanto come', 'Comer prestando atenção em cada mordida', 'Pensar no trabalho enquanto caminha', 'Checar o celular ao acordar'],
      correct: 1,
      explanation: 'Mindfulness é estar presente no momento. Comer com atenção plena é uma prática clássica.',
    ),
    _Question(
      text: 'Com que frequência é recomendado praticar meditação para sentir benefícios?',
      options: ['Uma vez por mês', 'Apenas quando estiver estressado', 'Diariamente, mesmo que por poucos minutos', 'Somente em retiros espirituais'],
      correct: 2,
      explanation: 'Meditações curtas e diárias são mais eficazes do que sessões longas e esporádicas.',
    ),
    _Question(
      text: 'O que é o "detox digital"?',
      options: ['Trocar de celular', 'Período intencional sem dispositivos eletrônicos', 'Apagar aplicativos desnecessários', 'Usar modo noturno'],
      correct: 1,
      explanation: 'Detox digital é afastar-se intencionalmente de telas para reduzir o estresse e melhorar o foco.',
    ),
    _Question(
      text: 'Qual hormônio é liberado durante exercícios físicos e melhora o humor?',
      options: ['Cortisol', 'Adrenalina', 'Endorfina', 'Insulina'],
      correct: 2,
      explanation: 'A endorfina é o "hormônio da felicidade", liberada durante atividades físicas.',
    ),
    _Question(
      text: 'Qual prática ajuda a desenvolver gratidão e bem-estar emocional?',
      options: ['Reclamar dos problemas', 'Escrever um diário de gratidão', 'Comparar-se com os outros', 'Evitar pensar nos sentimentos'],
      correct: 1,
      explanation: 'Escrever 3 coisas pelas quais você é grato por dia melhora significativamente o bem-estar.',
    ),
    _Question(
      text: 'O que acontece com o cérebro durante a meditação regular?',
      options: ['Nada muda', 'O cérebro para de funcionar', 'Aumenta a densidade da matéria cinzenta', 'Diminui a capacidade de memória'],
      correct: 2,
      explanation: 'Estudos mostram que a meditação regular aumenta a matéria cinzenta no cérebro, melhorando foco e memória.',
    ),
  ];

  int _current = 0;
  int _score = 0;
  int? _selected;
  bool _answered = false;
  bool _finished = false;
  int _timeLeft = 15;
  Timer? _timer;

  late AnimationController _barController;
  late AnimationController _feedbackController;
  late Animation<double> _feedbackScale;

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _feedbackController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _feedbackScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _feedbackController, curve: Curves.elasticOut),
    );
    _startTimer();
  }

  void _startTimer() {
    _timeLeft = 15;
    _barController.forward(from: 0);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _timeLeft--);
      if (_timeLeft <= 0) {
        t.cancel();
        _answer(-1); // tempo esgotado
      }
    });
  }

  void _answer(int index) {
    if (_answered) return;
    _timer?.cancel();
    _barController.stop();
    _feedbackController.forward(from: 0);
    setState(() {
      _selected = index;
      _answered = true;
      if (index == _questions[_current].correct) _score++;
    });
  }

  void _next() {
    if (_current + 1 >= _questions.length) {
      setState(() => _finished = true);
    } else {
      setState(() {
        _current++;
        _selected = null;
        _answered = false;
      });
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _barController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished) return _buildResult(context);

    final q = _questions[_current];

    return Scaffold(
      body: Column(
        children: [
          // AppBar
          Container(
            color: kYellow,
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
                    const Text('QUIZ', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
                      child: Text('${_current + 1}/${_questions.length}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Barra de tempo
          AnimatedBuilder(
            animation: _barController,
            builder: (_, __) => LinearProgressIndicator(
              value: 1 - _barController.value,
              minHeight: 6,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(
                _timeLeft <= 5 ? kWrong : kYellow,
              ),
            ),
          ),

          // Corpo
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFF5F0A0), Color(0xFFE8E4A0)],
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Timer
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.timer_rounded,
                            size: 16, color: _timeLeft <= 5 ? kWrong : kDark.withOpacity(0.5)),
                        const SizedBox(width: 4),
                        Text('${_timeLeft}s',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _timeLeft <= 5 ? kWrong : kDark.withOpacity(0.5),
                            )),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Pergunta
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
                      ),
                      child: Text(
                        q.text,
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kDark, height: 1.4),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Opções
                    ...List.generate(q.options.length, (i) {
                      Color bg = Colors.white.withOpacity(0.85);
                      Color border = Colors.transparent;
                      Color textColor = kDark;
                      IconData? trailingIcon;

                      if (_answered) {
                        if (i == q.correct) {
                          bg = kCorrect.withOpacity(0.15);
                          border = kCorrect;
                          textColor = kCorrect;
                          trailingIcon = Icons.check_circle_rounded;
                        } else if (i == _selected && _selected != q.correct) {
                          bg = kWrong.withOpacity(0.12);
                          border = kWrong;
                          textColor = kWrong;
                          trailingIcon = Icons.cancel_rounded;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () => _answer(i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: border, width: 2),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 30, height: 30,
                                  decoration: BoxDecoration(
                                    color: _answered && i == q.correct
                                        ? kCorrect
                                        : _answered && i == _selected
                                            ? kWrong
                                            : kYellow.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ['A', 'B', 'C', 'D'][i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: _answered && (i == q.correct || i == _selected)
                                            ? Colors.white
                                            : kDark,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(q.options[i],
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
                                ),
                                if (trailingIcon != null)
                                  Icon(trailingIcon, color: i == q.correct ? kCorrect : kWrong, size: 22),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    // Explicação
                    if (_answered) ...[
                      const SizedBox(height: 4),
                      ScaleTransition(
                        scale: _feedbackScale,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: (_selected == q.correct ? kCorrect : kWrong).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: (_selected == q.correct ? kCorrect : kWrong).withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                _selected == q.correct ? Icons.lightbulb_rounded : Icons.info_rounded,
                                color: _selected == q.correct ? kCorrect : kWrong,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  q.explanation,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _selected == q.correct ? kCorrect : kWrong,
                                    fontWeight: FontWeight.w600,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _next,
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            color: kDark,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              _current + 1 >= _questions.length ? 'VER RESULTADO' : 'PRÓXIMA',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(BuildContext context) {
    final pct = _score / _questions.length;
    String emoji, msg;
    if (pct >= 0.875) { emoji = '🏆'; msg = 'Incrível! Você é um expert em bem-estar!'; }
    else if (pct >= 0.625) { emoji = '🌟'; msg = 'Muito bem! Continue aprendendo sobre saúde mental!'; }
    else if (pct >= 0.375) { emoji = '💪'; msg = 'Bom esforço! Cada dia aprendemos mais!'; }
    else { emoji = '🌱'; msg = 'Continue praticando! O bem-estar é uma jornada!'; }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F0A0), Color(0xFFE8E4A0)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 72)),
                  const SizedBox(height: 16),
                  const Text('RESULTADO', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 3, color: kYellow)),
                  const SizedBox(height: 8),
                  Text(
                    '$_score/${_questions.length}',
                    style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w900, color: kDark, height: 1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    msg,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: kDark.withOpacity(0.7), fontWeight: FontWeight.w600, height: 1.4),
                  ),
                  const SizedBox(height: 32),
                  // Barra de progresso do resultado
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: pct,
                      minHeight: 14,
                      backgroundColor: Colors.black12,
                      valueColor: const AlwaysStoppedAnimation<Color>(kYellow),
                    ),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _current = 0; _score = 0; _selected = null;
                        _answered = false; _finished = false;
                      });
                      _startTimer();
                    },
                    child: Container(
                      width: double.infinity, height: 52,
                      decoration: BoxDecoration(color: kDark, borderRadius: BorderRadius.circular(50)),
                      child: const Center(
                        child: Text('JOGAR NOVAMENTE',
                            style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: double.infinity, height: 52,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: kDark, width: 2),
                      ),
                      child: const Center(
                        child: Text('VOLTAR',
                            style: TextStyle(color: kDark, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 2)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Question {
  final String text;
  final List<String> options;
  final int correct;
  final String explanation;

  const _Question({
    required this.text,
    required this.options,
    required this.correct,
    required this.explanation,
  });
}
