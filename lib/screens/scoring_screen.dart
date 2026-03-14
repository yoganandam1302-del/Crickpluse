import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

class BallEvent {
  final int runs;
  final bool isWicket;
  final bool isWide;
  final bool isNoBall;
  final bool isBye;
  final bool isLegBye;
  final String? wicketType;

  BallEvent({
    this.runs = 0,
    this.isWicket = false,
    this.isWide = false,
    this.isNoBall = false,
    this.isBye = false,
    this.isLegBye = false,
    this.wicketType,
  });

  String get display {
    if (isWicket) return 'W';
    if (isWide) return 'Wd${runs > 0 ? "+$runs" : ""}';
    if (isNoBall) return 'Nb${runs > 0 ? "+$runs" : ""}';
    if (isBye) return 'B$runs';
    if (isLegBye) return 'Lb$runs';
    return '$runs';
  }

  Color get color {
    if (isWicket) return AppTheme.danger;
    if (runs == 4) return const Color(0xFF2563EB);
    if (runs == 6) return AppTheme.primaryDeep;
    if (isWide || isNoBall) return const Color(0xFFF59E0B);
    return AppTheme.textSoft;
  }
}

class ScoringScreen extends StatefulWidget {
  final String matchTitle;
  final String teamAlphaName;
  final String teamBravoName;
  final int totalOvers;
  final List<String> teamAlphaPlayers;
  final List<String> teamBravoPlayers;
  final String tossWinner;
  final String electedTo;

  const ScoringScreen({
    super.key,
    required this.matchTitle,
    required this.teamAlphaName,
    required this.teamBravoName,
    required this.totalOvers,
    required this.teamAlphaPlayers,
    required this.teamBravoPlayers,
    required this.tossWinner,
    required this.electedTo,
  });

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen> {
  int _innings = 1;
  int _totalRuns = 0;
  int _wickets = 0;
  int _ballsInOver = 0;
  int _completedOvers = 0;
  final List<BallEvent> _currentOverBalls = [];
  final List<List<BallEvent>> _allOvers = [];
  int _target = 0;

  int _strikerIndex = 0;
  int _nonStrikerIndex = 1;
  final Map<int, int> _batsmanRuns = {};
  final Map<int, int> _batsmanBalls = {};

  String get _battingTeam {
    if (_innings == 1) {
      return (widget.tossWinner == widget.teamAlphaName &&
                  widget.electedTo == 'BAT FIRST') ||
              (widget.tossWinner == widget.teamBravoName &&
                  widget.electedTo == 'BOWL FIRST')
          ? widget.teamAlphaName
          : widget.teamBravoName;
    }
    return (widget.tossWinner == widget.teamAlphaName &&
                widget.electedTo == 'BAT FIRST') ||
            (widget.tossWinner == widget.teamBravoName &&
                widget.electedTo == 'BOWL FIRST')
        ? widget.teamBravoName
        : widget.teamAlphaName;
  }

  String get _bowlingTeam {
    return _battingTeam == widget.teamAlphaName
        ? widget.teamBravoName
        : widget.teamAlphaName;
  }

  List<String> get _battingPlayers {
    return _battingTeam == widget.teamAlphaName
        ? widget.teamAlphaPlayers
        : widget.teamBravoPlayers;
  }

  String get _oversDisplay => '$_completedOvers.$_ballsInOver';

  double get _currentRunRate {
    final totalBalls = (_completedOvers * 6 + _ballsInOver).toDouble();
    if (totalBalls == 0) return 0.0;
    return (_totalRuns / totalBalls) * 6;
  }

  bool get _isInningsOver {
    return _completedOvers >= widget.totalOvers ||
        _wickets >= (_battingPlayers.length - 1);
  }

  void _addRuns(int runs) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(runs: runs);
      _totalRuns += runs;
      _batsmanRuns[_strikerIndex] = (_batsmanRuns[_strikerIndex] ?? 0) + runs;
      _batsmanBalls[_strikerIndex] = (_batsmanBalls[_strikerIndex] ?? 0) + 1;
      _currentOverBalls.add(event);
      _ballsInOver++;
      if (runs % 2 == 1) _swapStrike();
      _checkOverComplete();
    });
  }

  void _addWide({int extraRuns = 0}) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(isWide: true, runs: extraRuns);
      _totalRuns += 1 + extraRuns;
      _currentOverBalls.add(event);
    });
  }

  void _addNoBall({int extraRuns = 0}) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(isNoBall: true, runs: extraRuns);
      _totalRuns += 1 + extraRuns;
      _batsmanRuns[_strikerIndex] =
          (_batsmanRuns[_strikerIndex] ?? 0) + extraRuns;
      _currentOverBalls.add(event);
    });
  }

  void _addBye(int runs) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(isBye: true, runs: runs);
      _totalRuns += runs;
      _batsmanBalls[_strikerIndex] = (_batsmanBalls[_strikerIndex] ?? 0) + 1;
      _currentOverBalls.add(event);
      _ballsInOver++;
      if (runs % 2 == 1) _swapStrike();
      _checkOverComplete();
    });
  }

  void _addLegBye(int runs) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(isLegBye: true, runs: runs);
      _totalRuns += runs;
      _batsmanBalls[_strikerIndex] = (_batsmanBalls[_strikerIndex] ?? 0) + 1;
      _currentOverBalls.add(event);
      _ballsInOver++;
      if (runs % 2 == 1) _swapStrike();
      _checkOverComplete();
    });
  }

  void _addWicket(String type) {
    if (_isInningsOver) return;
    setState(() {
      final event = BallEvent(isWicket: true, wicketType: type);
      _wickets++;
      _batsmanBalls[_strikerIndex] = (_batsmanBalls[_strikerIndex] ?? 0) + 1;
      _currentOverBalls.add(event);
      _ballsInOver++;

      var nextBatsman = 0;
      for (var i = 0; i < _battingPlayers.length; i++) {
        if (i != _strikerIndex &&
            i != _nonStrikerIndex &&
            !_batsmanBalls.containsKey(i)) {
          nextBatsman = i;
          break;
        }
      }
      _strikerIndex = nextBatsman;
      _checkOverComplete();
    });
  }

  void _undo() {
    if (_currentOverBalls.isEmpty && _allOvers.isEmpty) return;
    setState(() {
      if (_currentOverBalls.isNotEmpty) {
        final last = _currentOverBalls.removeLast();
        if (last.isWicket) {
          _wickets--;
          _batsmanBalls[_strikerIndex] =
              (_batsmanBalls[_strikerIndex] ?? 1) - 1;
        } else if (last.isWide) {
          _totalRuns -= (1 + last.runs);
        } else if (last.isNoBall) {
          _totalRuns -= (1 + last.runs);
          _batsmanRuns[_strikerIndex] =
              (_batsmanRuns[_strikerIndex] ?? last.runs) - last.runs;
        } else {
          _totalRuns -= last.runs;
          _batsmanRuns[_strikerIndex] =
              (_batsmanRuns[_strikerIndex] ?? last.runs) - last.runs;
          _batsmanBalls[_strikerIndex] =
              (_batsmanBalls[_strikerIndex] ?? 1) - 1;
          if (!last.isWide && !last.isNoBall) {
            _ballsInOver--;
          }
        }
      }
    });
  }

  void _swapStrike() {
    final temp = _strikerIndex;
    _strikerIndex = _nonStrikerIndex;
    _nonStrikerIndex = temp;
  }

  void _checkOverComplete() {
    if (_ballsInOver >= 6) {
      _allOvers.add(List.from(_currentOverBalls));
      _currentOverBalls.clear();
      _completedOvers++;
      _ballsInOver = 0;
      _swapStrike();
      if (_isInningsOver) {
        _showInningsSummary();
      }
    } else if (_isInningsOver) {
      _showInningsSummary();
    }
  }

  void _startSecondInnings() {
    setState(() {
      _target = _totalRuns + 1;
      _innings = 2;
      _totalRuns = 0;
      _wickets = 0;
      _ballsInOver = 0;
      _completedOvers = 0;
      _currentOverBalls.clear();
      _allOvers.clear();
      _strikerIndex = 0;
      _nonStrikerIndex = 1;
      _batsmanRuns.clear();
      _batsmanBalls.clear();
    });
  }

  void _showInningsSummary() {
    if (_innings == 1) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Innings Complete',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w900),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _battingTeam,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$_totalRuns/$_wickets',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Overs $_oversDisplay',
                style: const TextStyle(color: AppTheme.textSoft, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Text(
                '$_bowlingTeam needs ${_totalRuns + 1} to win',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _startSecondInnings();
                },
                child: const Text('START 2ND INNINGS'),
              ),
            ),
          ],
        ),
      );
    } else {
      String result;
      if (_totalRuns >= _target) {
        final wicketsLeft = (_battingPlayers.length - 1) - _wickets;
        result = '$_battingTeam won by $wicketsLeft wickets';
      } else if (_totalRuns == _target - 1) {
        result = 'Match tied';
      } else {
        result = '$_bowlingTeam won by ${_target - 1 - _totalRuns} runs';
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            'Match Over',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w900),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$_totalRuns/$_wickets',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Overs $_oversDisplay',
                style: const TextStyle(color: AppTheme.textSoft, fontSize: 13),
              ),
              const SizedBox(height: 14),
              Text(
                result,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: const Text('DONE'),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showWicketSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final types = [
          'Bowled',
          'Caught',
          'LBW',
          'Run Out',
          'Stumped',
          'Hit Wicket',
        ];

        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Select Wicket Type',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: types.map((type) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      _addWicket(type);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.danger.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.danger.withOpacity(0.18),
                        ),
                      ),
                      child: Text(
                        type.toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.danger,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showExtrasSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.border,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Add Extras',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _buildExtraButton('WIDE', () {
                      Navigator.pop(ctx);
                      _addWide();
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildExtraButton('NO BALL', () {
                      Navigator.pop(ctx);
                      _addNoBall();
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildExtraButton('BYE (1)', () {
                      Navigator.pop(ctx);
                      _addBye(1);
                    }),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildExtraButton('LEG BYE (1)', () {
                      Navigator.pop(ctx);
                      _addLegBye(1);
                    }),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildExtraButton(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFF59E0B).withOpacity(0.22),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFF59E0B),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                  child: Column(
                    children: [
                      _buildScoreHeader(),
                      if (_innings == 2) ...[
                        const SizedBox(height: 12),
                        _buildTargetBar(),
                      ],
                      const SizedBox(height: 12),
                      _buildCurrentOver(),
                      const SizedBox(height: 12),
                      _buildBatsmanInfo(),
                      const SizedBox(height: 18),
                      _buildQuickRunsLabel(),
                      const SizedBox(height: 12),
                      _buildRunButtons(),
                      const SizedBox(height: 14),
                      _buildActionRow(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
        children: [
          _actionIcon(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.pop(context),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.matchTitle.isEmpty ? 'Live Scoring' : widget.matchTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'INNINGS $_innings',
                    style: const TextStyle(
                      color: AppTheme.primaryDeep,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _actionIcon(
            icon: Icons.undo_rounded,
            onTap: _undo,
          ),
        ],
      ),
    );
  }

  Widget _actionIcon({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: AppTheme.text, size: 18),
      ),
    );
  }

  Widget _buildScoreHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _teamBadge(_battingTeam, 'Batting', const Color(0xFF2563EB)),
              Column(
                children: [
                  Text(
                    '$_totalRuns/$_wickets',
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Overs $_oversDisplay',
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              _metricBadge(
                'CRR',
                _currentRunRate.toStringAsFixed(1),
                _currentRunRate >= 8 ? AppTheme.primaryDeep : AppTheme.textSoft,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                Expanded(child: _miniInfo('Bowling', _bowlingTeam)),
                Container(width: 1, height: 28, color: AppTheme.border),
                Expanded(
                  child: _miniInfo('Overs Limit', '${widget.totalOvers}.0'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamBadge(String team, String label, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            team.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _metricBadge(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _miniInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildTargetBar() {
    final remaining = _target - _totalRuns;
    final totalBalls =
        (widget.totalOvers * 6 - (_completedOvers * 6 + _ballsInOver)).toDouble();
    final rrr = totalBalls > 0 ? (remaining / totalBalls) * 6 : 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF6D7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _smallMetric('Target', '$_target'),
          _smallMetric('Need', '$remaining / ${totalBalls.toInt()}'),
          _smallMetric(
            'RRR',
            rrr.toStringAsFixed(1),
            color: rrr > _currentRunRate ? AppTheme.danger : AppTheme.primaryDeep,
          ),
        ],
      ),
    );
  }

  Widget _smallMetric(String label, String value, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppTheme.text,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentOver() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Current Over',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  'OVER ${_completedOvers + 1}',
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  reverse: true,
                  child: Row(
                    children: _currentOverBalls.map((ball) {
                      final fill = ball.isWicket
                          ? AppTheme.danger.withOpacity(0.1)
                          : ball.runs == 4
                              ? const Color(0xFF2563EB).withOpacity(0.1)
                              : ball.runs == 6
                                  ? AppTheme.primary.withOpacity(0.16)
                                  : AppTheme.surfaceMuted;

                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: fill,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ball.color.withOpacity(0.35),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          ball.display,
                          style: TextStyle(
                            color: ball.color,
                            fontSize: ball.display.length > 2 ? 8 : 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatsmanInfo() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Row(
        children: [
          Expanded(
            child: _buildBatsmanRow(
              _battingPlayers.length > _strikerIndex
                  ? _battingPlayers[_strikerIndex]
                  : 'Batsman 1',
              _batsmanRuns[_strikerIndex] ?? 0,
              _batsmanBalls[_strikerIndex] ?? 0,
              true,
            ),
          ),
          Container(width: 1, height: 44, color: AppTheme.border),
          Expanded(
            child: _buildBatsmanRow(
              _battingPlayers.length > _nonStrikerIndex
                  ? _battingPlayers[_nonStrikerIndex]
                  : 'Batsman 2',
              _batsmanRuns[_nonStrikerIndex] ?? 0,
              _batsmanBalls[_nonStrikerIndex] ?? 0,
              false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatsmanRow(String name, int runs, int balls, bool isStriker) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isStriker)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryDeep,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    color: isStriker ? AppTheme.text : AppTheme.textSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$runs($balls)',
            style: TextStyle(
              color: isStriker ? AppTheme.primaryDeep : AppTheme.text,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickRunsLabel() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Quick Runs',
        style: TextStyle(
          color: AppTheme.text,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildRunButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRunButton('0', 0),
        _buildRunButton('1', 1),
        _buildRunButton('2', 2),
        _buildRunButton('3', 3),
        _buildRunButton('4', 4, accent: const Color(0xFF2563EB)),
        _buildRunButton('6', 6, accent: AppTheme.primaryDeep),
      ],
    );
  }

  Widget _buildRunButton(String label, int runs, {Color? accent}) {
    final bgColor = accent != null ? accent.withOpacity(0.12) : AppTheme.surface;
    final borderColor = accent ?? AppTheme.border;
    final textColor = accent ?? AppTheme.text;

    return GestureDetector(
      onTap: () => _addRuns(runs),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor.withOpacity(0.35), width: 1.5),
          boxShadow: accent != null
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.14),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _showWicketSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.danger.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.danger.withOpacity(0.16)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sports_cricket, color: AppTheme.danger, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'WICKET',
                    style: TextStyle(
                      color: AppTheme.danger,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: _showExtrasSheet,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFFF59E0B).withOpacity(0.18),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFFF59E0B),
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'EXTRAS',
                    style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
