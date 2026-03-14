import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'player_stats_screen.dart';

class GlobalLeaderboardScreen extends StatefulWidget {
  const GlobalLeaderboardScreen({super.key});

  @override
  State<GlobalLeaderboardScreen> createState() =>
      _GlobalLeaderboardScreenState();
}

class _GlobalLeaderboardScreenState extends State<GlobalLeaderboardScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['Weekly', 'Monthly', 'All-Time'];

  final List<Map<String, dynamic>> _top3Players = [
    {
      'name': 'Rahul Sh.',
      'tag': '@pro_rahul',
      'avatar': 'https://i.pravatar.cc/150?img=11',
      'points': '45,230',
      'winRate': '68%',
      'rank': 2,
    },
    {
      'name': 'Priya Das',
      'tag': '@priya_crush',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'points': '52,400',
      'winRate': '74%',
      'rank': 1,
    },
    {
      'name': 'Vikram R.',
      'tag': '@vicky_striker',
      'avatar': 'https://i.pravatar.cc/150?img=12',
      'points': '41,100',
      'winRate': '62%',
      'rank': 3,
    },
  ];

  final List<Map<String, dynamic>> _otherPlayers = [
    {
      'name': 'Amit Patel',
      'tag': '@amit_p',
      'points': '39,800',
      'avatar': 'https://i.pravatar.cc/150?img=13',
      'trend': 1,
    },
    {
      'name': 'Neha Gupta',
      'tag': '@neha_g',
      'points': '38,500',
      'avatar': 'https://i.pravatar.cc/150?img=20',
      'trend': -1,
    },
    {
      'name': 'Sanjay K.',
      'tag': '@sanjay_k',
      'points': '37,200',
      'avatar': 'https://i.pravatar.cc/150?img=33',
      'trend': 2,
    },
    {
      'name': 'Kavya M.',
      'tag': '@kavya_m',
      'points': '36,900',
      'avatar': 'https://i.pravatar.cc/150?img=42',
      'trend': 0,
    },
    {
      'name': 'Rohan Das',
      'tag': '@rohan_d',
      'points': '35,100',
      'avatar': 'https://i.pravatar.cc/150?img=55',
      'trend': -2,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFiltersBar(),
              const SizedBox(height: 18),
              _buildPodiumSection(),
              const SizedBox(height: 8),
              Expanded(child: _buildLeaderboardList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
            child: Text(
              'Global Ranking',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
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
            child: const Icon(Icons.share_outlined, color: AppTheme.text, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 52,
        decoration: AppTheme.softCardDecoration(radius: 24),
        child: Row(
          children: List.generate(_filters.length, (index) {
            final isSelected = _selectedFilterIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilterIndex = index),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _filters[index],
                    style: TextStyle(
                      color: AppTheme.text,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildPodiumSection() {
    return SizedBox(
      height: 300,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildPodiumStep(_top3Players[0], 2, 180, const Color(0xFFC0C0C0)),
          const SizedBox(width: 8),
          _buildPodiumStep(_top3Players[1], 1, 230, const Color(0xFFF59E0B)),
          const SizedBox(width: 8),
          _buildPodiumStep(_top3Players[2], 3, 160, const Color(0xFFCD7F32)),
        ],
      ),
    );
  }

  Widget _buildPodiumStep(
    Map<String, dynamic> player,
    int rank,
    double height,
    Color medalColor,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerStatsScreen(player: player),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: rank == 1 ? 84 : 68,
                height: rank == 1 ? 84 : 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: medalColor.withOpacity(0.7), width: 3),
                  image: DecorationImage(
                    image: NetworkImage(player['avatar']),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: medalColor.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: medalColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              if (rank == 1)
                const Positioned(
                  top: -18,
                  child: Icon(
                    Icons.star_rounded,
                    color: Color(0xFFF59E0B),
                    size: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            player['name'],
            style: TextStyle(
              color: AppTheme.text,
              fontSize: rank == 1 ? 16 : 14,
              fontWeight: FontWeight.w800,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            player['points'],
            style: TextStyle(
              color: medalColor,
              fontSize: rank == 1 ? 14 : 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: rank == 1 ? 110 : 90,
            height: height - 120,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Win Rate',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player['winRate'],
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList() {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'TOP PLAYERS',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'POINTS',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _otherPlayers.length,
              itemBuilder: (context, index) {
                final player = _otherPlayers[index];
                final rank = index + 4;
                return _buildLeaderboardListItem(player, rank);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardListItem(Map<String, dynamic> player, int rank) {
    IconData trendIcon = Icons.remove_rounded;
    Color trendColor = AppTheme.textMuted;

    if (player['trend'] > 0) {
      trendIcon = Icons.arrow_upward_rounded;
      trendColor = AppTheme.primaryDeep;
    } else if (player['trend'] < 0) {
      trendIcon = Icons.arrow_downward_rounded;
      trendColor = AppTheme.danger;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerStatsScreen(player: player),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: AppTheme.softCardDecoration(radius: 22),
        child: Row(
          children: [
            SizedBox(
              width: 34,
              child: Column(
                children: [
                  Text(
                    '$rank',
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(trendIcon, color: trendColor, size: 14),
                ],
              ),
            ),
            Container(
              width: 46,
              height: 46,
              margin: const EdgeInsets.only(left: 8, right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(player['avatar']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player['name'],
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    player['tag'],
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                player['points'],
                style: const TextStyle(
                  color: AppTheme.primaryDeep,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
