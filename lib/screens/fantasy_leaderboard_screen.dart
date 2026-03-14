import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class FantasyLeaderboardScreen extends StatelessWidget {
  const FantasyLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'rank': 1, 'name': 'Rahul Sharma', 'pts': '950.5'},
      {'rank': 2, 'name': 'Amit Verma', 'pts': '925.0'},
      {'rank': 3, 'name': 'Karthik N', 'pts': '910.5'},
      {'rank': 4, 'name': 'Priya Singh', 'pts': '895.0'},
      {'rank': 5, 'name': 'You', 'pts': '890.5'},
      {'rank': 6, 'name': 'Vikram D', 'pts': '885.0'},
      {'rank': 7, 'name': 'Sneha K', 'pts': '870.0'},
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: _buildHeader(context),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: _buildTeamPerformancePanel(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Leaderboard',
                        style: TextStyle(
                          color: AppTheme.text,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: AppTheme.primaryDeep,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Sort',
                              style: TextStyle(
                                color: AppTheme.textSoft,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final isCurrentUser = user['name'] == 'You';
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    child: _buildLeaderboardRow(
                      context: context,
                      rank: user['rank'] as int,
                      name: user['name'] as String,
                      points: user['pts'] as String,
                      isCurrentUser: isCurrentUser,
                    ),
                  );
                },
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mega Contest Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.text,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track your rank and compare teams.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamPerformancePanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.surfaceMuted,
                    ),
                    child: const Icon(Icons.person, color: AppTheme.text),
                  ),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Team (T1)',
                        style: TextStyle(
                          color: AppTheme.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Rank: #5',
                        style: TextStyle(
                          color: AppTheme.primaryDeep,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total Points',
                    style: TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '890.5',
                    style: TextStyle(
                      color: AppTheme.primaryDeep,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCard('Runs', '320', 0.8, const Color(0xFF2563EB)),
              _buildStatCard('Wickets', '120', 0.5, AppTheme.danger),
              _buildStatCard('Catches', '40', 0.3, const Color(0xFFF59E0B)),
              _buildStatCard('Bonus', '50.5', 0.4, AppTheme.primaryDeep),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    double percent,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 44,
          width: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 44 * percent,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardRow({
    required BuildContext context,
    required int rank,
    required String name,
    required String points,
    bool isCurrentUser = false,
  }) {
    Color rankColor = AppTheme.text;
    if (rank == 1) rankColor = const Color(0xFFF59E0B);
    if (rank == 2) rankColor = const Color(0xFF94A3B8);
    if (rank == 3) rankColor = const Color(0xFFB45309);

    return GestureDetector(
      onTap: () => _showOpponentTeamBottomSheet(context, name, rank, points),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isCurrentUser ? AppTheme.surfaceMuted : AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isCurrentUser ? AppTheme.primaryDeep : AppTheme.border,
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: rankColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.surfaceMuted,
                border: Border.all(
                  color: rank <= 3 ? rankColor : AppTheme.border,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.person, color: AppTheme.text),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: AppTheme.text,
                      fontSize: 16,
                      fontWeight: isCurrentUser ? FontWeight.w900 : FontWeight.w700,
                    ),
                  ),
                  if (isCurrentUser) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppTheme.primaryDeep),
                      ),
                      child: const Text(
                        'YOU',
                        style: TextStyle(
                          color: AppTheme.primaryDeep,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  points,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'pts',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showOpponentTeamBottomSheet(
    BuildContext context,
    String opponentName,
    int rank,
    String points,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.84,
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  border: Border(bottom: BorderSide(color: AppTheme.border)),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: AppTheme.border,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.surfaceMuted,
                                border: Border.all(
                                  color: rank == 1
                                      ? const Color(0xFFF59E0B)
                                      : AppTheme.border,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(Icons.person, color: AppTheme.text),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  opponentName,
                                  style: const TextStyle(
                                    color: AppTheme.text,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceMuted,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'Rank #$rank',
                                    style: const TextStyle(
                                      color: AppTheme.text,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Total Pts',
                              style: TextStyle(
                                color: AppTheme.textSoft,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              points,
                              style: const TextStyle(
                                color: AppTheme.primaryDeep,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF89C95D), Color(0xFF4E9F3D)],
                    ),
                  ),
                  child: Stack(
                    children: [
                      const Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 130,
                          height: 360,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(color: Colors.white54),
                                right: BorderSide(color: Colors.white54),
                                top: BorderSide(color: Colors.white38),
                                bottom: BorderSide(color: Colors.white38),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildRoleRow('WICKET-KEEPER', ['Dhoni (C)']),
                          _buildRoleRow('BATTERS', ['Gaikwad', 'Mitchell', 'R Singh']),
                          _buildRoleRow('ALL-ROUNDERS', ['Jadeja', 'Narine (VC)', 'Russell']),
                          _buildRoleRow('BOWLERS', [
                            'Starc',
                            'Pathirana',
                            'Chahar',
                            'Chakravarthy',
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleRow(String role, List<String> playerNames) {
    return Column(
      children: [
        Text(
          role,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: playerNames.map((name) {
            final isCaptain = name.contains('(C)');
            final isViceCaptain = name.contains('(VC)');
            final cleanName = name.replaceAll(' (C)', '').replaceAll(' (VC)', '');

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.88),
                        border: Border.all(
                          color: isCaptain
                              ? const Color(0xFFFACC15)
                              : isViceCaptain
                                  ? AppTheme.primaryDeep
                                  : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(Icons.person, color: AppTheme.text),
                    ),
                    if (isCaptain || isViceCaptain)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: isCaptain
                              ? const Color(0xFFFACC15)
                              : AppTheme.primaryDeep,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isCaptain ? 'C' : 'VC',
                          style: TextStyle(
                            color: isCaptain ? Colors.black : AppTheme.text,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    cleanName,
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
