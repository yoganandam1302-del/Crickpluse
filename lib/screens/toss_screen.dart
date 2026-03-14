import 'dart:math';

import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'scoring_screen.dart';

class TossScreen extends StatefulWidget {
  final String matchTitle;
  final String teamAlphaName;
  final String teamBravoName;
  final int totalOvers;
  final List<String> teamAlphaPlayers;
  final List<String> teamBravoPlayers;

  const TossScreen({
    super.key,
    required this.matchTitle,
    required this.teamAlphaName,
    required this.teamBravoName,
    required this.totalOvers,
    required this.teamAlphaPlayers,
    required this.teamBravoPlayers,
  });

  @override
  State<TossScreen> createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen> with TickerProviderStateMixin {
  int _step = 0;
  String _callingTeam = '';
  String _otherTeam = '';
  String _call = '';
  String _result = '';
  String _tossWinner = '';
  String _electedTo = '';

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeOutCubic),
    );
    _flipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _step = 3;
          _tossWinner = (_call == _result) ? _callingTeam : _otherTeam;
        });
      }
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _selectCaller(String team) {
    setState(() {
      _callingTeam = team;
      _otherTeam =
          team == widget.teamAlphaName ? widget.teamBravoName : widget.teamAlphaName;
      _step = 1;
    });
  }

  void _makeCall(String call) {
    setState(() {
      _call = call;
      _step = 2;
      _result = Random().nextBool() ? 'HEADS' : 'TAILS';
    });
    _flipController
      ..reset()
      ..forward();
  }

  void _chooseElection(String choice) {
    setState(() {
      _electedTo = choice;
      _step = 5;
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ScoringScreen(
            matchTitle: widget.matchTitle,
            teamAlphaName: widget.teamAlphaName,
            teamBravoName: widget.teamBravoName,
            totalOvers: widget.totalOvers,
            teamAlphaPlayers: widget.teamAlphaPlayers,
            teamBravoPlayers: widget.teamBravoPlayers,
            tossWinner: _tossWinner,
            electedTo: choice,
          ),
        ),
      );
    });
  }

  String _stepHint() {
    switch (_step) {
      case 0:
        return 'Select which team calls the toss';
      case 1:
        return '$_callingTeam, make your call';
      case 2:
        return 'Flipping the coin';
      case 3:
        return '$_tossWinner won the toss';
      case 4:
        return '$_tossWinner, choose to bat or bowl';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            child: Column(
              children: [
                _buildTopBar(),
                const SizedBox(height: 18),
                _buildProgressTracker(),
                const Spacer(),
                _buildContent(),
                const Spacer(),
                if (_step < 5)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _stepHint(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: AppTheme.text,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Coin Toss',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.matchTitle.isEmpty ? 'Match setup' : widget.matchTitle,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressTracker() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Row(
        children: [
          _buildTrackerStep(1, 'Setup', true, true),
          Expanded(child: _buildTrackerLine(true)),
          _buildTrackerStep(2, 'Teams', true, true),
          Expanded(child: _buildTrackerLine(true)),
          _buildTrackerStep(3, 'Toss', true, false),
          Expanded(child: _buildTrackerLine(false)),
          _buildTrackerStep(4, 'Start', false, false),
        ],
      ),
    );
  }

  Widget _buildTrackerStep(
    int number,
    String label,
    bool isActive,
    bool isCompleted,
  ) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primary : AppTheme.surfaceMuted,
            border: Border.all(
              color: isActive ? AppTheme.primaryDeep : AppTheme.border,
            ),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: AppTheme.text, size: 16)
              : Text(
                  '$number',
                  style: TextStyle(
                    color: isActive ? AppTheme.text : AppTheme.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppTheme.text : AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackerLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: isActive ? AppTheme.primaryDeep : AppTheme.border,
    );
  }

  Widget _buildContent() {
    switch (_step) {
      case 0:
        return _buildCallerSelection();
      case 1:
        return _buildCoinCall();
      case 2:
        return _buildCoinFlip();
      case 3:
        return _buildTossResult();
      case 4:
        return _buildElectionChoice();
      case 5:
        return _buildProceedingToMatch();
      default:
        return const SizedBox();
    }
  }

  Widget _buildCallerSelection() {
    return Column(
      children: [
        const Text(
          'Who Calls?',
          style: TextStyle(
            color: AppTheme.textSoft,
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 28),
        _buildTeamButton(
          widget.teamAlphaName,
          const Color(0xFF2563EB),
          () => _selectCaller(widget.teamAlphaName),
        ),
        const SizedBox(height: 14),
        const Text(
          'VS',
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 16,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 14),
        _buildTeamButton(
          widget.teamBravoName,
          AppTheme.primaryDeep,
          () => _selectCaller(widget.teamBravoName),
        ),
      ],
    );
  }

  Widget _buildTeamButton(String name, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: AppTheme.softCardDecoration(radius: 28),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.22)),
              ),
              alignment: Alignment.center,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              name.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinCall() {
    return Column(
      children: [
        Text(
          _callingTeam.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.primaryDeep,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Make Your Call',
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildCoinSideButton(
                'HEADS',
                Icons.brightness_high_rounded,
                const Color(0xFFF5B700),
                () => _makeCall('HEADS'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildCoinSideButton(
                'TAILS',
                Icons.brightness_3_rounded,
                const Color(0xFF94A3B8),
                () => _makeCall('TAILS'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCoinSideButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: AppTheme.softCardDecoration(radius: 28),
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color, color.withOpacity(0.45)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: AppTheme.text, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinFlip() {
    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * 10 * pi;
        var showHeads = (angle / pi).floor() % 2 == 0;
        if (_flipAnimation.value > 0.85) {
          showHeads = _result == 'HEADS';
        }

        final color =
            showHeads ? const Color(0xFFF5B700) : const Color(0xFF94A3B8);

        return Column(
          children: [
            Text(
              '${_callingTeam.toUpperCase()} CALLED $_call',
              style: const TextStyle(
                color: AppTheme.textSoft,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 34),
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(angle),
              child: Container(
                width: 156,
                height: 156,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [color, color.withOpacity(0.5)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.26),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      showHeads
                          ? Icons.brightness_high_rounded
                          : Icons.brightness_3_rounded,
                      color: AppTheme.text,
                      size: 42,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      showHeads ? 'H' : 'T',
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 34),
            const Text(
              'FLIPPING...',
              style: TextStyle(
                color: AppTheme.primaryDeep,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTossResult() {
    final callerWon = _call == _result;
    final resultColor =
        _result == 'HEADS' ? const Color(0xFFF5B700) : const Color(0xFF94A3B8);

    return Column(
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [resultColor, resultColor.withOpacity(0.5)],
            ),
            boxShadow: [
              BoxShadow(
                color: resultColor.withOpacity(0.26),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _result == 'HEADS'
                    ? Icons.brightness_high_rounded
                    : Icons.brightness_3_rounded,
                color: AppTheme.text,
                size: 38,
              ),
              const SizedBox(height: 4),
              Text(
                _result,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        Text(
          "It's $_result!",
          style: TextStyle(
            color: resultColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: (callerWon ? AppTheme.primary : AppTheme.danger)
                .withOpacity(0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: (callerWon ? AppTheme.primaryDeep : AppTheme.danger)
                  .withOpacity(0.22),
            ),
          ),
          child: Text(
            callerWon
                ? '$_callingTeam wins the toss'
                : '$_otherTeam wins the toss',
            style: TextStyle(
              color: callerWon ? AppTheme.primaryDeep : AppTheme.danger,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = 4),
            child: const Text('CHOOSE BAT OR BOWL'),
          ),
        ),
      ],
    );
  }

  Widget _buildElectionChoice() {
    return Column(
      children: [
        Text(
          _tossWinner.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.primaryDeep,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Choose To',
          style: TextStyle(
            color: AppTheme.text,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildElectionButton(
                'BAT FIRST',
                Icons.sports_cricket_rounded,
                const Color(0xFF2563EB),
                () => _chooseElection('BAT FIRST'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildElectionButton(
                'BOWL FIRST',
                Icons.sports_baseball_rounded,
                AppTheme.primaryDeep,
                () => _chooseElection('BOWL FIRST'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildElectionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        decoration: AppTheme.softCardDecoration(radius: 28),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(icon, color: color, size: 34),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedingToMatch() {
    return Column(
      children: [
        Container(
          width: 84,
          height: 84,
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
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          '$_tossWinner elected to ${_electedTo.toLowerCase()}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 20),
        const SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryDeep),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'STARTING MATCH...',
          style: TextStyle(
            color: AppTheme.primaryDeep,
            fontSize: 12,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}
