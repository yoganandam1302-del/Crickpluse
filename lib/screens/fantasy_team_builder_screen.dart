import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'contest_lobby_screen.dart';

class FantasyPlayer {
  final String id;
  final String name;
  final String team;
  final String role;
  final double credits;
  final int points;

  FantasyPlayer({
    required this.id,
    required this.name,
    required this.team,
    required this.role,
    required this.credits,
    required this.points,
  });
}

class FantasyTeamBuilderScreen extends StatefulWidget {
  final String matchTitle;
  final String team1;
  final String team2;

  const FantasyTeamBuilderScreen({
    super.key,
    required this.matchTitle,
    required this.team1,
    required this.team2,
  });

  @override
  State<FantasyTeamBuilderScreen> createState() =>
      _FantasyTeamBuilderScreenState();
}

class _FantasyTeamBuilderScreenState extends State<FantasyTeamBuilderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<FantasyPlayer> _allPlayers;

  final List<FantasyPlayer> _selectedPlayers = [];
  FantasyPlayer? _captain;
  FantasyPlayer? _viceCaptain;
  bool _isSelectingCaptain = false;

  final Map<String, List<Alignment>> _rolePositions = {
    'WK': [const Alignment(0, -0.9)],
    'BAT': [
      const Alignment(-0.65, -0.35),
      const Alignment(0, -0.45),
      const Alignment(0.65, -0.35),
      const Alignment(-0.3, -0.1),
      const Alignment(0.3, -0.1),
    ],
    'AR': [
      const Alignment(-0.5, 0.25),
      const Alignment(0, 0.15),
      const Alignment(0.5, 0.25),
    ],
    'BOWL': [
      const Alignment(-0.65, 0.72),
      const Alignment(-0.2, 0.58),
      const Alignment(0.2, 0.58),
      const Alignment(0.65, 0.72),
    ],
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    _allPlayers = [
      FantasyPlayer(id: '1', name: 'Player 1', team: widget.team1, role: 'WK', credits: 8.5, points: 300),
      FantasyPlayer(id: '2', name: 'Player 2', team: widget.team2, role: 'WK', credits: 9.0, points: 450),
      FantasyPlayer(id: '3', name: 'Player 3', team: widget.team1, role: 'BAT', credits: 9.0, points: 420),
      FantasyPlayer(id: '4', name: 'Player 4', team: widget.team2, role: 'BAT', credits: 8.5, points: 380),
      FantasyPlayer(id: '5', name: 'Player 5', team: widget.team2, role: 'BAT', credits: 8.0, points: 290),
      FantasyPlayer(id: '6', name: 'Player 6', team: widget.team1, role: 'BAT', credits: 8.5, points: 340),
      FantasyPlayer(id: '7', name: 'Player 7', team: widget.team1, role: 'BAT', credits: 8.0, points: 210),
      FantasyPlayer(id: '8', name: 'Player 8', team: widget.team1, role: 'AR', credits: 9.0, points: 410),
      FantasyPlayer(id: '9', name: 'Player 9', team: widget.team2, role: 'AR', credits: 9.5, points: 520),
      FantasyPlayer(id: '10', name: 'Player 10', team: widget.team2, role: 'AR', credits: 9.5, points: 480),
      FantasyPlayer(id: '11', name: 'Player 11', team: widget.team2, role: 'BOWL', credits: 9.0, points: 350),
      FantasyPlayer(id: '12', name: 'Player 12', team: widget.team1, role: 'BOWL', credits: 8.5, points: 390),
      FantasyPlayer(id: '13', name: 'Player 13', team: widget.team1, role: 'BOWL', credits: 8.0, points: 280),
      FantasyPlayer(id: '14', name: 'Player 14', team: widget.team2, role: 'BOWL', credits: 8.5, points: 410),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              _buildBudgetBar(),
              _buildFieldLayout(),
              if (_isSelectingCaptain)
                _buildCaptainSelectionHeader()
              else
                _buildPlayerCategories(),
              Expanded(
                child: _isSelectingCaptain
                    ? _buildCaptainSelectionList()
                    : _buildPlayerSelectionPanel(),
              ),
              _buildContinueButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (_isSelectingCaptain) {
                setState(() {
                  _isSelectingCaptain = false;
                });
              } else {
                Navigator.pop(context);
              }
            },
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(Icons.arrow_back, color: AppTheme.text, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isSelectingCaptain ? 'Select C & VC' : widget.matchTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.text,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '04h 15m left',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.primaryDeep,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Guru Teams',
              style: TextStyle(
                color: AppTheme.primaryDeep,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetBar() {
    final playersSelected = _selectedPlayers.length;
    final creditsUsed = _selectedPlayers.fold<double>(0, (sum, p) => sum + p.credits);
    final team1Count = _selectedPlayers.where((p) => p.team == widget.team1).length;
    final team2Count = _selectedPlayers.where((p) => p.team == widget.team2).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _budgetItem('Players', '$playersSelected/11'),
              _teamCount(widget.team1, team1Count),
              _teamCount(widget.team2, team2Count),
              _budgetItem('Credits Left', (100.0 - creditsUsed).toStringAsFixed(1)),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: playersSelected / 11,
              minHeight: 8,
              backgroundColor: AppTheme.surfaceMuted,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryDeep),
            ),
          ),
        ],
      ),
    );
  }

  Widget _budgetItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _teamCount(String team, int count) {
    return Column(
      children: [
        Text(
          team,
          style: const TextStyle(
            color: AppTheme.primaryDeep,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceMuted,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFieldLayout() {
    final roleCounts = {'WK': 0, 'BAT': 0, 'AR': 0, 'BOWL': 0};

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF89C95D), Color(0xFF4E9F3D)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 130,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.35)),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          ..._selectedPlayers.map((player) {
            final idx = roleCounts[player.role]!;
            final positions = _rolePositions[player.role]!;
            final alignment = positions[idx % positions.length];
            roleCounts[player.role] = idx + 1;
            return Align(
              alignment: alignment,
              child: _buildFieldPlayer(
                player.name,
                isCaptain: _captain == player,
                isViceCaptain: _viceCaptain == player,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFieldPlayer(
    String name, {
    bool isCaptain = false,
    bool isViceCaptain = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppTheme.primaryDeep, width: 2),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person, color: AppTheme.text, size: 22),
            ),
            if (isCaptain || isViceCaptain)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFACC15),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    isCaptain ? 'C' : 'VC',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCategories() {
    final wkCount = _selectedPlayers.where((p) => p.role == 'WK').length;
    final batCount = _selectedPlayers.where((p) => p.role == 'BAT').length;
    final arCount = _selectedPlayers.where((p) => p.role == 'AR').length;
    final bowlCount = _selectedPlayers.where((p) => p.role == 'BOWL').length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          gradient: AppTheme.heroGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.text,
        unselectedLabelColor: AppTheme.textSoft,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
        tabs: [
          Tab(text: 'WK ($wkCount)'),
          Tab(text: 'BAT ($batCount)'),
          Tab(text: 'AR ($arCount)'),
          Tab(text: 'BOWL ($bowlCount)'),
        ],
      ),
    );
  }

  Widget _buildPlayerSelectionPanel() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPlayerList('WK'),
        _buildPlayerList('BAT'),
        _buildPlayerList('AR'),
        _buildPlayerList('BOWL'),
      ],
    );
  }

  Widget _buildPlayerList(String role) {
    final rolePlayers = _allPlayers.where((p) => p.role == role).toList();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: rolePlayers.length,
      itemBuilder: (context, index) {
        final player = rolePlayers[index];
        final isSelected = _selectedPlayers.contains(player);
        return _buildPlayerCard(player, isSelected);
      },
    );
  }

  Widget _buildPlayerCard(FantasyPlayer player, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.surfaceMuted : AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? AppTheme.primaryDeep : AppTheme.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.surfaceMuted,
            ),
            child: const Icon(Icons.person, color: AppTheme.text),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      player.team,
                      style: const TextStyle(
                        color: AppTheme.primaryDeep,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Sel by 85.2%',
                      style: TextStyle(color: AppTheme.textSoft, fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${player.points} pts',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${player.credits} Cr',
                style: const TextStyle(
                  color: AppTheme.primaryDeep,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _selectedPlayers.remove(player);
                  if (_captain == player) _captain = null;
                  if (_viceCaptain == player) _viceCaptain = null;
                } else if (_selectedPlayers.length < 11) {
                  _selectedPlayers.add(player);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('You can only select 11 players'),
                    ),
                  );
                }
              });
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isSelected ? AppTheme.heroGradient : null,
                color: isSelected ? null : AppTheme.surfaceMuted,
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppTheme.border,
                ),
              ),
              child: Icon(
                isSelected ? Icons.check : Icons.add,
                color: AppTheme.text,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainSelectionHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Choose your Captain and Vice Captain',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            'C 2x • VC 1.5x',
            style: TextStyle(
              color: AppTheme.textSoft,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainSelectionList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      itemCount: _selectedPlayers.length,
      itemBuilder: (context, index) {
        final player = _selectedPlayers[index];
        final isCap = _captain == player;
        final isVCap = _viceCaptain == player;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: AppTheme.softCardDecoration(radius: 18),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.surfaceMuted,
                ),
                child: const Icon(Icons.person, color: AppTheme.text),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${player.team} | ${player.role}',
                      style: const TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildCapVcButton('C', player, isCap, isConflicting: isVCap),
                  const SizedBox(width: 10),
                  _buildCapVcButton('VC', player, isVCap, isConflicting: isCap),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCapVcButton(
    String label,
    FantasyPlayer player,
    bool isSelected, {
    required bool isConflicting,
  }) {
    return GestureDetector(
      onTap: () {
        if (isConflicting) return;
        setState(() {
          if (label == 'C') {
            _captain = isSelected ? null : player;
          } else {
            _viceCaptain = isSelected ? null : player;
          }
        });
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: isSelected ? AppTheme.heroGradient : null,
          color: isSelected ? null : AppTheme.surfaceMuted,
          border: Border.all(
            color: isConflicting
                ? AppTheme.border
                : isSelected
                ? Colors.transparent
                : AppTheme.border,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isConflicting ? AppTheme.textMuted : AppTheme.text,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    var btnText = 'CONTINUE';
    if (!_isSelectingCaptain && _selectedPlayers.length == 11) {
      btnText = 'NEXT';
    } else if (_isSelectingCaptain) {
      btnText = 'SAVE TEAM';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primary.withOpacity(0.25),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {
              if (!_isSelectingCaptain) {
                if (_selectedPlayers.length == 11) {
                  setState(() {
                    _isSelectingCaptain = true;
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select 11 players. (${11 - _selectedPlayers.length} more needed)',
                      ),
                    ),
                  );
                }
              } else if (_captain != null && _viceCaptain != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ContestLobbyScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please select a Captain and Vice Captain'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(btnText),
          ),
        ),
      ),
    );
  }
}
