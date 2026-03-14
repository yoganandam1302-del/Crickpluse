import 'dart:math';

import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

enum Difficulty { easy, medium, hard }

class MiniGameScreen extends StatefulWidget {
  const MiniGameScreen({super.key});

  @override
  State<MiniGameScreen> createState() => _MiniGameScreenState();
}

class _MiniGameScreenState extends State<MiniGameScreen>
    with SingleTickerProviderStateMixin {
  final Random _random = Random();

  static int highScore = 0;

  Difficulty? _selectedDifficulty;
  int _ballsBowled = 0;
  int _runsScored = 0;
  int _wickets = 0;
  List<String> _overHistory = [];

  bool _isBowling = false;
  String _currentResult = '';
  Color _resultColor = AppTheme.text;

  late AnimationController _ballController;
  late Animation<double> _ballAnimation;

  Duration get _ballSpeed {
    switch (_selectedDifficulty) {
      case Difficulty.easy:
        return const Duration(milliseconds: 1400);
      case Difficulty.hard:
        return const Duration(milliseconds: 500);
      default:
        return const Duration(milliseconds: 800);
    }
  }

  int get _wicketChanceOnMiss {
    switch (_selectedDifficulty) {
      case Difficulty.easy:
        return 1;
      case Difficulty.hard:
        return 4;
      default:
        return 2;
    }
  }

  @override
  void initState() {
    super.initState();
    _ballController = AnimationController(vsync: this, duration: _ballSpeed);
    _ballAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: _ballController, curve: Curves.easeInQuad),
    );
    _ballController.addStatusListener((status) {
      if (status == AnimationStatus.completed && _isBowling) {
        _calculateOutcome(missed: true);
      }
    });
  }

  @override
  void dispose() {
    _ballController.dispose();
    super.dispose();
  }

  void _bowlBall() {
    if (_ballsBowled >= 6 || _wickets >= 1) {
      _showGameOverDialog();
      return;
    }

    setState(() {
      _isBowling = true;
      _currentResult = '';
    });

    _ballController
      ..reset()
      ..forward();
  }

  void _hitBall() {
    if (!_isBowling) return;
    final ballPos = _ballAnimation.value;

    if (ballPos > 0.6 && ballPos < 0.9) {
      _calculateOutcome(perfectTiming: true);
    } else if (ballPos >= 0.9) {
      _calculateOutcome(perfectTiming: false);
    } else {
      _calculateOutcome(missed: true);
    }
  }

  void _calculateOutcome({bool missed = false, bool perfectTiming = false}) {
    _ballController.stop();
    setState(() {
      _isBowling = false;
      _ballsBowled++;
    });

    late String outcome;
    late Color color;

    if (missed) {
      final rand = _random.nextInt(10);
      if (rand < _wicketChanceOnMiss) {
        outcome = 'W';
        color = AppTheme.danger;
        _wickets++;
      } else {
        outcome = '0';
        color = AppTheme.textSoft;
      }
    } else if (perfectTiming) {
      final goodHits = ['4', '6', '2'];
      outcome = goodHits[_random.nextInt(goodHits.length)];
      color = outcome == '6' ? AppTheme.primaryDeep : const Color(0xFF2563EB);
      _runsScored += int.parse(outcome);
    } else {
      final avgHits = ['0', '1', '1', '2', 'W'];
      outcome = avgHits[_random.nextInt(avgHits.length)];
      if (outcome == 'W') {
        color = AppTheme.danger;
        _wickets++;
      } else {
        color = AppTheme.text;
        _runsScored += int.parse(outcome);
      }
    }

    setState(() {
      _currentResult =
          outcome == 'W' ? 'OUT!' : (outcome == '0' ? 'Dot Ball' : '$outcome Runs!');
      _resultColor = color;
      _overHistory.add(outcome);
    });

    if (_ballsBowled >= 6 || _wickets >= 1) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _showGameOverDialog();
      });
    }
  }

  void _showGameOverDialog() {
    if (_runsScored > highScore) {
      highScore = _runsScored;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Over Complete',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_runsScored',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Text(
                'Total Runs Scored',
                style: TextStyle(color: AppTheme.textSoft, fontSize: 15),
              ),
              const SizedBox(height: 8),
              Text(
                'Best: $highScore runs',
                style: const TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _overHistory.map(_buildScoreBubble).toList(),
              ),
              if (_wickets > 0) ...[
                const SizedBox(height: 16),
                const Text(
                  'You were bowled out!',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _runsScored = 0;
                  _ballsBowled = 0;
                  _wickets = 0;
                  _overHistory.clear();
                  _currentResult = '';
                  _selectedDifficulty = null;
                });
              },
              child: const Text(
                'PLAY AGAIN',
                style: TextStyle(color: Color(0xFF2563EB)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.text,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.pop(context);
              },
              child: const Text('EXIT'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedDifficulty == null) {
      return _buildDifficultyPicker(context);
    }
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(showHighScore: true),
              _buildScoreboard(),
              Expanded(child: _buildGameArea()),
              _buildControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyPicker(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTopBar(showHighScore: false),
                const SizedBox(height: 24),
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.22),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.sports_cricket_rounded,
                    color: AppTheme.text,
                    size: 42,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Choose Difficulty',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Best: $highScore runs',
                  style: const TextStyle(
                    color: Color(0xFFF59E0B),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 34),
                _buildDifficultyCard(
                  label: 'EASY',
                  subtitle: 'Slow ball | Low wicket risk',
                  icon: Icons.sentiment_satisfied_alt_rounded,
                  color: AppTheme.primaryDeep,
                  diff: Difficulty.easy,
                ),
                const SizedBox(height: 14),
                _buildDifficultyCard(
                  label: 'MEDIUM',
                  subtitle: 'Balanced speed | Classic mode',
                  icon: Icons.sports_cricket_rounded,
                  color: const Color(0xFF2563EB),
                  diff: Difficulty.medium,
                ),
                const SizedBox(height: 14),
                _buildDifficultyCard(
                  label: 'HARD',
                  subtitle: 'Fast ball | High wicket risk',
                  icon: Icons.local_fire_department_rounded,
                  color: AppTheme.danger,
                  diff: Difficulty.hard,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar({required bool showHighScore}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.text),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              'Playable Over',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          SizedBox(
            width: 70,
            child: showHighScore
                ? Center(
                    child: Text(
                      'Best $highScore',
                      style: const TextStyle(
                        color: Color(0xFFF59E0B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyCard({
    required String label,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Difficulty diff,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedDifficulty = diff);
        _ballController.duration = _ballSpeed;
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        decoration: AppTheme.softCardDecoration(radius: 24),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreboard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 22),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SCORE',
                    style: TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$_runsScored/$_wickets',
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'BALLS',
                    style: TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    '$_ballsBowled / 6',
                    style: const TextStyle(
                      color: Color(0xFF2563EB),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              if (index < _overHistory.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildScoreBubble(_overHistory[index]),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surfaceMuted,
                    border: Border.all(color: AppTheme.border),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBubble(String run) {
    Color bgColor;
    if (run == 'W') {
      bgColor = AppTheme.danger;
    } else if (run == '4' || run == '6') {
      bgColor = AppTheme.primaryDeep;
    } else if (run == '0') {
      bgColor = AppTheme.textMuted;
    } else {
      bgColor = const Color(0xFF2563EB);
    }

    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        run,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGameArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDBEBC7),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppTheme.border),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: CustomPaint(painter: PitchPainter()),
            ),
          ),
          if (!_isBowling && _currentResult.isNotEmpty)
            Positioned(
              top: 44,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  color: _resultColor,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  shadows: [
                    Shadow(
                      color: _resultColor.withOpacity(0.25),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Text(_currentResult),
              ),
            ),
          if (_isBowling || _currentResult.isNotEmpty)
            AnimatedBuilder(
              animation: _ballAnimation,
              builder: (context, child) {
                final yPos = _ballAnimation.value;
                final size = 10 + (yPos + 1) * 15;

                return Align(
                  alignment: Alignment(0, yPos),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: AppTheme.danger,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: size / 2,
                          offset: const Offset(0, 5),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.35),
                          blurRadius: 2,
                          offset: Offset(-size / 4, -size / 4),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          const Align(
            alignment: Alignment(0, 0.8),
            child: Opacity(
              opacity: 0.35,
              child: Icon(
                Icons.sports_cricket_rounded,
                size: 64,
                color: AppTheme.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: _isBowling
          ? GestureDetector(
              onTap: _hitBall,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.heroGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.28),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'HIT!',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
          : ElevatedButton(
              onPressed: _ballsBowled < 6 && _wickets < 1 ? _bowlBall : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: AppTheme.text,
                padding:
                    const EdgeInsets.symmetric(horizontal: 42, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                _ballsBowled < 6 ? 'BOWL NEXT BALL' : 'OVER COMPLETE',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
    );
  }
}

class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final centerRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: 100,
      height: size.height * 0.8,
    );

    canvas.drawRect(
      centerRect,
      Paint()
        ..color = const Color(0xFFC4A484).withOpacity(0.28)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRect(centerRect, paint);

    canvas.drawLine(
      Offset(size.width / 2 - 50, size.height * 0.15),
      Offset(size.width / 2 + 50, size.height * 0.15),
      paint,
    );
    canvas.drawLine(
      Offset(size.width / 2 - 50, size.height * 0.85),
      Offset(size.width / 2 + 50, size.height * 0.85),
      paint,
    );

    _drawWickets(canvas, Offset(size.width / 2, size.height * 0.1), paint, 15);
    _drawWickets(canvas, Offset(size.width / 2, size.height * 0.9), paint, 25);
  }

  void _drawWickets(Canvas canvas, Offset center, Paint paint, double height) {
    canvas.drawLine(
      Offset(center.dx - 10, center.dy),
      Offset(center.dx - 10, center.dy - height),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy),
      Offset(center.dx, center.dy - height),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + 10, center.dy),
      Offset(center.dx + 10, center.dy - height),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx - 10, center.dy - height),
      Offset(center.dx + 10, center.dy - height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
