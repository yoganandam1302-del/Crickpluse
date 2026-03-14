import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'fantasy_arena_screen.dart';
import 'global_leaderboard_screen.dart';
import 'head_to_head_screen.dart';
import 'host_match_screen.dart';
import 'matches_screen.dart';
import 'mega_contests_screen.dart';
import 'mini_game_screen.dart';
import 'news_feed_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _heroCard(),
                      const SizedBox(height: 24),
                      _sectionHeader('Quick Actions'),
                      const SizedBox(height: 14),
                      _quickActions(),
                      const SizedBox(height: 26),
                      _sectionHeader('Live & Upcoming'),
                      const SizedBox(height: 14),
                      _upcomingList(),
                      const SizedBox(height: 26),
                      _sectionHeader('Deep Analytics'),
                      const SizedBox(height: 14),
                      _analyticsGrid(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.heroGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (c) => const MiniGameScreen()),
            );
          },
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.sports_esports, color: AppTheme.text),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(18),
            ),
            alignment: Alignment.center,
            child: const Text(
              'CP',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CricPulse',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'Premium fantasy cricket dashboard',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Icon(
                Icons.notifications_none,
                color: AppTheme.text,
              ),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppTheme.border),
              ),
              alignment: Alignment.center,
              child: const Icon(Icons.person, color: AppTheme.text),
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppTheme.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF101828).withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8FAD2),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'LIVE MATCH',
                  style: TextStyle(
                    color: AppTheme.primaryDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'IPL 2026',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Mumbai Indians vs Royal Challengers',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'RCB need 15 runs from 8 balls. Track momentum, win probability, and contest insights in one place.',
            style: TextStyle(
              color: AppTheme.textSoft,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _statTile('MI', '176/5')),
              const SizedBox(width: 12),
              Expanded(child: _statTile('RCB', '162/7')),
              const SizedBox(width: 12),
              Expanded(child: _statTile('Win Prob', '64%')),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text('Track Ball'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.text,
        fontSize: 22,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  Widget _quickActions() {
    final actions = [
      ('Host Match', Icons.stadium, () => const HostMatchScreen()),
      ('News', Icons.article, () => const NewsFeedScreen()),
      ('Fantasy', Icons.emoji_events, () => const FantasyArenaScreen()),
      ('Compare', Icons.compare_arrows, () => const HeadToHeadScreen()),
      ('Rankings', Icons.bar_chart, () => const GlobalLeaderboardScreen()),
      ('Contests', Icons.stars, () => const MegaContestsScreen()),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: actions.map((item) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.$3()),
            );
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            padding: const EdgeInsets.all(18),
            decoration: AppTheme.softCardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppTheme.heroGradient,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.$2, color: AppTheme.text),
                ),
                const SizedBox(height: 14),
                Text(
                  item.$1,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Open premium cricket tools',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _upcomingList() {
    return Column(
      children: [
        _upcomingCard('Today 7:30 PM', 'CSK vs KKR', '34k joined'),
        const SizedBox(height: 12),
        _upcomingCard('Tomorrow', 'IND vs AUS', '120k joined'),
      ],
    );
  }

  Widget _upcomingCard(String time, String teams, String joined) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 72,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    color: AppTheme.primaryDeep,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  teams,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  joined,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MatchesScreen()),
              );
            },
            child: const Text(
              'View',
              style: TextStyle(
                color: AppTheme.text,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _analyticsGrid() {
    return Row(
      children: [
        Expanded(child: _analyticsCard('Win Rate', '64%', [0.4, 0.8, 0.55])),
        const SizedBox(width: 12),
        Expanded(child: _analyticsCard('Contest Form', 'A+', [0.6, 0.45, 0.9])),
      ],
    );
  }

  Widget _analyticsCard(String title, String value, List<double> bars) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.text,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 62,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bars
                  .map(
                    (bar) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 62 * bar,
                        decoration: BoxDecoration(
                          gradient: AppTheme.heroGradient,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home_filled, 'Home', 0),
          _navItem(Icons.search, 'Matches', 1, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => MatchesScreen()),
            );
          }),
          const SizedBox(width: 40),
          _navItem(Icons.emoji_events, 'Fantasy', 2, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FantasyArenaScreen()),
            );
          }),
          _navItem(Icons.person, 'Profile', 3, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label,
    int index, {
    VoidCallback? onTap,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: onTap ??
          () {
            setState(() {
              _selectedIndex = index;
            });
          },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? AppTheme.primaryDeep : AppTheme.textMuted,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppTheme.text : AppTheme.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
