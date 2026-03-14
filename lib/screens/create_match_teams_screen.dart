import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'matches_screen.dart';
import 'toss_screen.dart';

class CreateMatchTeamsScreen extends StatefulWidget {
  final String matchTitle;
  final int totalOvers;

  const CreateMatchTeamsScreen({
    super.key,
    required this.matchTitle,
    required this.totalOvers,
  });

  @override
  State<CreateMatchTeamsScreen> createState() => _CreateMatchTeamsScreenState();
}

class Player {
  String name;
  String role;
  bool isCaptain;
  bool isViceCaptain;

  Player({
    required this.name,
    this.role = 'Batsman',
    this.isCaptain = false,
    this.isViceCaptain = false,
  });
}

class _CreateMatchTeamsScreenState extends State<CreateMatchTeamsScreen> {
  final TextEditingController _teamAlphaNameController = TextEditingController();
  final TextEditingController _teamBravoNameController = TextEditingController();

  List<Player> _teamAlphaPlayers = [];
  List<Player> _teamBravoPlayers = [];

  @override
  void dispose() {
    _teamAlphaNameController.dispose();
    _teamBravoNameController.dispose();
    super.dispose();
  }

  void _showAddPlayerSheet(bool isTeamAlpha) {
    final controller = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
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
                  'Add Player',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                  style: const TextStyle(color: AppTheme.text),
                  decoration: const InputDecoration(
                    hintText: 'Enter player name',
                  ),
                  onSubmitted: (val) {
                    if (val.trim().isEmpty) return;
                    setState(() {
                      if (isTeamAlpha) {
                        _teamAlphaPlayers.add(Player(name: val.trim()));
                      } else {
                        _teamBravoPlayers.add(Player(name: val.trim()));
                      }
                    });
                    Navigator.pop(ctx);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isEmpty) return;
                      setState(() {
                        if (isTeamAlpha) {
                          _teamAlphaPlayers.add(Player(name: controller.text.trim()));
                        } else {
                          _teamBravoPlayers.add(Player(name: controller.text.trim()));
                        }
                      });
                      Navigator.pop(ctx);
                    },
                    child: const Text('ADD PLAYER'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _generateDummyPlayers() {
    setState(() {
      _teamAlphaNameController.text = 'Mumbai Warriors';
      _teamAlphaPlayers = [
        Player(name: 'Rohit Sharma', isCaptain: true),
        Player(
          name: 'Hardik Pandya',
          role: 'All-Rounder',
          isViceCaptain: true,
        ),
      ];

      _teamBravoNameController.text = 'Bangalore Titans';
      _teamBravoPlayers = [
        Player(name: 'Virat Kohli', isCaptain: true),
        Player(
          name: 'Glenn Maxwell',
          role: 'All-Rounder',
          isViceCaptain: true,
        ),
      ];
    });
  }

  void _nextStep() {
    if (_teamAlphaPlayers.isEmpty || _teamBravoPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Added demo players so you can continue quickly.'),
          backgroundColor: AppTheme.primaryDeep,
        ),
      );
      _generateDummyPlayers();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TossScreen(
          matchTitle: widget.matchTitle,
          teamAlphaName: _teamAlphaNameController.text.isEmpty
              ? 'Team Alpha'
              : _teamAlphaNameController.text,
          teamBravoName: _teamBravoNameController.text.isEmpty
              ? 'Team Bravo'
              : _teamBravoNameController.text,
          totalOvers: widget.totalOvers,
          teamAlphaPlayers: _teamAlphaPlayers.map((e) => e.name).toList(),
          teamBravoPlayers: _teamBravoPlayers.map((e) => e.name).toList(),
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
              _buildHeader(),
              _buildProgressTracker(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 130),
                  child: Column(
                    children: [
                      _buildTeamCard(
                        isTeamA: true,
                        nameController: _teamAlphaNameController,
                        players: _teamAlphaPlayers,
                      ),
                      const SizedBox(height: 18),
                      _buildVSSeparator(),
                      const SizedBox(height: 18),
                      _buildTeamCard(
                        isTeamA: false,
                        nameController: _teamBravoNameController,
                        players: _teamBravoPlayers,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildBottomBanner(),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Row(
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Match Teams',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Set both squads before the toss',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: AppTheme.text,
              size: 19,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressTracker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: AppTheme.softCardDecoration(radius: 24),
        child: Row(
          children: [
            _buildStep(1, 'Setup', true, true),
            Expanded(child: _buildLine(true)),
            _buildStep(2, 'Teams', true, false),
            Expanded(child: _buildLine(false)),
            _buildStep(3, 'Toss', false, false),
            Expanded(child: _buildLine(false)),
            _buildStep(4, 'Start', false, false),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int number, String label, bool isActive, bool isCompleted) {
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
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
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

  Widget _buildLine(bool isActive) {
    return Container(
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: isActive ? AppTheme.primaryDeep : AppTheme.border,
    );
  }

  Widget _buildTeamCard({
    required bool isTeamA,
    required TextEditingController nameController,
    required List<Player> players,
  }) {
    final accentColor =
        isTeamA ? const Color(0xFF2563EB) : AppTheme.primaryDeep;
    final teamLabel = isTeamA ? 'Team A Name' : 'Team B Name';
    final hintText =
        isTeamA ? 'e.g. Mumbai Warriors' : 'e.g. Bangalore Titans';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceMuted,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.shield_outlined,
                      color: accentColor,
                      size: 28,
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      teamLabel.toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: nameController,
                      style: const TextStyle(color: AppTheme.text, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: hintText,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: accentColor, width: 1.4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Players (${players.length}/11)',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () => _showAddPlayerSheet(isTeamA),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_add_alt_1, color: accentColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        'Add Player',
                        style: TextStyle(
                          color: accentColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (players.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Text(
                'No players added yet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ...players.map(
            (player) => _buildPlayerRow(
              player,
              accentColor,
              () {
                setState(() {
                  for (final p in players) {
                    p.isCaptain = false;
                  }
                  player.isCaptain = true;
                  if (player.isViceCaptain) player.isViceCaptain = false;
                });
              },
              () {
                setState(() {
                  for (final p in players) {
                    p.isViceCaptain = false;
                  }
                  player.isViceCaptain = true;
                  if (player.isCaptain) player.isCaptain = false;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(
    Player player,
    Color accentColor,
    VoidCallback onCapTap,
    VoidCallback onVcTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              player.name.isNotEmpty ? player.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
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
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  player.role,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          _buildBadge(
            label: 'C',
            selected: player.isCaptain,
            activeColor: const Color(0xFF2563EB),
            onTap: onCapTap,
          ),
          const SizedBox(width: 6),
          _buildBadge(
            label: 'VC',
            selected: player.isViceCaptain,
            activeColor: accentColor,
            onTap: onVcTap,
          ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required bool selected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? activeColor : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppTheme.textSoft,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildVSSeparator() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppTheme.border)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: AppTheme.heroGradient,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Text(
            'VS',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppTheme.border)),
      ],
    );
  }

  Widget _buildBottomBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 40,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.surfaceMuted,
                    child: Text(
                      (_teamAlphaNameController.text.isEmpty
                              ? 'A'
                              : _teamAlphaNameController.text[0])
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFEAF6D7),
                    child: Text(
                      (_teamBravoNameController.text.isEmpty
                              ? 'B'
                              : _teamBravoNameController.text[0])
                          .toUpperCase(),
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Match Ready',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${_teamAlphaPlayers.length} vs ${_teamBravoPlayers.length} players',
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'NEXT',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home_outlined,
            'Home',
            false,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
          ),
          _buildNavItem(
            Icons.sports_cricket_rounded,
            'Matches',
            false,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MatchesScreen()),
            ),
          ),
          _buildNavItem(Icons.groups_outlined, 'Teams', true),
          _buildNavItem(Icons.bar_chart_outlined, 'Stats', false),
          _buildNavItem(Icons.person_outline_rounded, 'Profile', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? AppTheme.primaryDeep : AppTheme.textMuted,
            size: 23,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? AppTheme.primaryDeep : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
