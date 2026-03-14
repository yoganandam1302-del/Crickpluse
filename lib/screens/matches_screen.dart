import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'match_details_screen.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.text,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Matches',
                            style: TextStyle(
                              color: AppTheme.text,
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'Live, upcoming, and completed fixtures',
                            style: TextStyle(
                              color: AppTheme.textSoft,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
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
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  tabs: const [
                    Tab(text: 'LIVE'),
                    Tab(text: 'UPCOMING'),
                    Tab(text: 'COMPLETED'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveMatchesTab(),
                    _buildUpcomingMatchesTab(),
                    _buildCompletedMatchesTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildLiveMatchesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        _buildLiveMatchCard(
          tourneyName: 'IPL 2026',
          teamA: 'Mumbai Indians',
          teamAShort: 'MI',
          teamB: 'Royal Challengers',
          teamBShort: 'RCB',
          scoreA: '176/5',
          oversA: '20.0 overs',
          scoreB: '162/7',
          oversB: '18.4 overs',
          crr: '8.67',
          rrr: '11.25',
        ),
      ],
    );
  }

  Widget _buildLiveMatchCard({
    required String tourneyName,
    required String teamA,
    required String teamAShort,
    required String teamB,
    required String teamBShort,
    required String scoreA,
    required String oversA,
    required String scoreB,
    required String oversB,
    required String crr,
    required String rrr,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MatchDetailsScreen()),
        );
      },
      child: Container(
        decoration: AppTheme.softCardDecoration(glow: true),
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tourneyName,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusBadge('LIVE', AppTheme.primaryDeep),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _buildTeamScoreBlock(
                    teamA,
                    teamAShort,
                    scoreA,
                    oversA,
                    const Color(0xFF2563EB),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Expanded(
                  child: _buildTeamScoreBlock(
                    teamB,
                    teamBShort,
                    scoreB,
                    oversB,
                    const Color(0xFFE5484D),
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceMuted,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Text(
                        'WIN PROBABILITY',
                        style: TextStyle(
                          color: AppTheme.textSoft,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 65,
                          child: Container(
                            height: 10,
                            color: const Color(0xFF2563EB),
                          ),
                        ),
                        Expanded(
                          flex: 35,
                          child: Container(
                            height: 10,
                            color: const Color(0xFFE5484D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'MI 65%',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'RCB 35%',
                        style: TextStyle(
                          color: Color(0xFFE5484D),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: _statCard('CRR', crr)),
                const SizedBox(width: 12),
                Expanded(child: _statCard('Ground', 'Small')),
                const SizedBox(width: 12),
                Expanded(child: _statCard('RRR', rrr, alert: true)),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _actionButton(
                    'View Match',
                    true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MatchDetailsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(child: _actionButton('Fantasy', false)),
                const SizedBox(width: 10),
                Expanded(child: _actionButton('Stats', false)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingMatchesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        _buildUpcomingMatchCard(
          tourneyName: 'IPL 2026',
          teamA: 'Chennai Super Kings',
          teamB: 'Delhi Capitals',
          dateTime: 'Today 7:30 PM',
          venue: 'Wankhede Stadium',
        ),
      ],
    );
  }

  Widget _buildUpcomingMatchCard({
    required String tourneyName,
    required String teamA,
    required String teamB,
    required String dateTime,
    required String venue,
  }) {
    return Container(
      decoration: AppTheme.softCardDecoration(),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                tourneyName,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _buildStatusBadge('UPCOMING', AppTheme.textSoft),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            teamA,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'VS',
            style: TextStyle(
              color: AppTheme.primaryDeep,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            teamB,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppTheme.textSoft,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.location_on_outlined,
                  color: AppTheme.textSoft,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    venue,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.notifications_active_outlined),
              label: const Text('Remind Me'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedMatchesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      children: [
        _buildCompletedMatchCard(
          summary: 'Rajasthan Royals beat Punjab Kings by 6 wickets',
          teamA: 'RR',
          scoreA: '180/4',
          teamB: 'PBKS',
          scoreB: '178/7',
        ),
      ],
    );
  }

  Widget _buildCompletedMatchCard({
    required String summary,
    required String teamA,
    required String scoreA,
    required String teamB,
    required String scoreB,
  }) {
    return Container(
      decoration: AppTheme.softCardDecoration(),
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Text(
            summary,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.primaryDeep,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _completedScore(teamA, scoreA),
              const Text(
                'VS',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontWeight: FontWeight.w800,
                ),
              ),
              _completedScore(teamB, scoreB),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MatchDetailsScreen()),
                );
              },
              icon: const Icon(Icons.assignment_outlined),
              label: const Text('Scorecard'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.text,
                side: const BorderSide(color: AppTheme.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _completedScore(String team, String score) {
    return Column(
      children: [
        Text(
          team,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          score,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 24,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildTeamScoreBlock(
    String fullName,
    String shortName,
    String score,
    String overs,
    Color teamColor, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (alignEnd)
              Text(
                shortName,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            if (alignEnd) const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: teamColor.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: teamColor.withOpacity(0.4)),
              ),
              alignment: Alignment.center,
              child: Text(
                shortName.substring(0, 1),
                style: TextStyle(
                  color: teamColor,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (!alignEnd) const SizedBox(width: 8),
            if (!alignEnd)
              Text(
                shortName,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          score,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          overs,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          fullName,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, {bool alert = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: alert ? AppTheme.danger : AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    String label,
    bool primary, {
    VoidCallback? onTap,
  }) {
    return primary
        ? ElevatedButton(
            onPressed: onTap ?? () {},
            child: Text(label),
          )
        : OutlinedButton(
            onPressed: onTap ?? () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.text,
              side: const BorderSide(color: AppTheme.border),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(Icons.sports_esports, color: AppTheme.text, size: 30),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home,
            'HOME',
            false,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
          _buildNavItem(Icons.search, 'MATCHES', true),
          const SizedBox(width: 60),
          _buildNavItem(Icons.emoji_events, 'FANTASY', false),
          _buildNavItem(Icons.person, 'PROFILE', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isSelected, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryDeep : AppTheme.textMuted,
            size: 24,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.text : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
