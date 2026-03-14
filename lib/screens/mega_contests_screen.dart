import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

class MegaContestsScreen extends StatefulWidget {
  const MegaContestsScreen({super.key});

  @override
  State<MegaContestsScreen> createState() => _MegaContestsScreenState();
}

class _MegaContestsScreenState extends State<MegaContestsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All',
    'Mega Contests',
    'Head-to-Head',
    'Winner Takes All',
    'Practice',
  ];

  final List<Map<String, dynamic>> _contests = [
    {
      'prizePool': 'Rs 1 Crore',
      'entryFee': 49,
      'firstPrize': 'Rs 10 Lakhs',
      'winPercent': 62,
      'maxTeams': 20,
      'guaranteed': true,
      'spotsTotal': 250000,
      'spotsFilled': 185000,
      'isMultiEntry': true,
      'badge': 'MEGA',
    },
    {
      'prizePool': 'Rs 50 Lakhs',
      'entryFee': 39,
      'firstPrize': 'Rs 5 Lakhs',
      'winPercent': 55,
      'maxTeams': 11,
      'guaranteed': true,
      'spotsTotal': 150000,
      'spotsFilled': 145000,
      'isMultiEntry': true,
      'badge': 'HOT',
    },
    {
      'prizePool': 'Rs 10,000',
      'entryFee': 5750,
      'firstPrize': 'Rs 10,000',
      'winPercent': 50,
      'maxTeams': 1,
      'guaranteed': false,
      'spotsTotal': 2,
      'spotsFilled': 1,
      'isMultiEntry': false,
      'badge': 'H2H',
    },
    {
      'prizePool': 'Rs 1 Lakh',
      'entryFee': 99,
      'firstPrize': 'Rs 1 Lakh',
      'winPercent': 1,
      'maxTeams': 5,
      'guaranteed': true,
      'spotsTotal': 1100,
      'spotsFilled': 450,
      'isMultiEntry': true,
      'badge': 'WINNER TAKES ALL',
    },
    {
      'prizePool': 'Practice',
      'entryFee': 0,
      'firstPrize': 'Glory',
      'winPercent': 40,
      'maxTeams': 1,
      'guaranteed': false,
      'spotsTotal': 10000,
      'spotsFilled': 1200,
      'isMultiEntry': false,
      'badge': 'FREE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildTopBar()),
            SliverToBoxAdapter(child: _buildMatchHeader()),
            SliverToBoxAdapter(child: _buildFilterChips()),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final contest = _contests[index];
                if (_selectedFilterIndex == 1 &&
                    contest['badge'] != 'MEGA' &&
                    contest['badge'] != 'HOT') {
                  return const SizedBox.shrink();
                } else if (_selectedFilterIndex == 2 &&
                    contest['badge'] != 'H2H') {
                  return const SizedBox.shrink();
                } else if (_selectedFilterIndex == 3 &&
                    contest['badge'] != 'WINNER TAKES ALL') {
                  return const SizedBox.shrink();
                } else if (_selectedFilterIndex == 4 &&
                    contest['badge'] != 'FREE') {
                  return const SizedBox.shrink();
                }
                return _buildContestCard(contest);
              }, childCount: _contests.length),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create Team feature coming soon!'),
              backgroundColor: AppTheme.primaryDeep,
            ),
          );
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: AppTheme.text,
        icon: const Icon(Icons.add),
        label: const Text(
          'CREATE TEAM',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 16),
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
              child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppTheme.text),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Contests',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppTheme.border),
            ),
            child: const Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: Color(0xFFF59E0B), size: 16),
                SizedBox(width: 6),
                Text(
                  'Rs 4,250',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 13,
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

  Widget _buildMatchHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTeamLogo('MI', 'Mumbai', const Color(0xFF004BA0)),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '02h 45m 12s',
                  style: TextStyle(
                    color: AppTheme.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'TATA IPL 2026',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          _buildTeamLogo('RCB', 'Bangalore', const Color(0xFFD32F2F)),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String abbrev, String name, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.12),
            border: Border.all(color: color.withOpacity(0.28), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            abbrev,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            color: AppTheme.text,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilterIndex = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primary : AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryDeep : AppTheme.border,
                ),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: AppTheme.text,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContestCard(Map<String, dynamic> contest) {
    final spotsFilled = contest['spotsFilled'] as int;
    final spotsTotal = contest['spotsTotal'] as int;
    final fillPercentage = spotsTotal > 0 ? (spotsFilled / spotsTotal) : 0.0;
    final spotsLeft = spotsTotal - spotsFilled;

    var badgeColor = const Color(0xFF2563EB);
    if (contest['badge'] == 'MEGA') badgeColor = const Color(0xFFF59E0B);
    if (contest['badge'] == 'HOT') badgeColor = AppTheme.danger;
    if (contest['badge'] == 'FREE') badgeColor = AppTheme.primaryDeep;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Prize Pool',
                    style: TextStyle(color: AppTheme.textSoft, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      contest['badge'],
                      style: TextStyle(
                        color: badgeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Entry',
                style: TextStyle(color: AppTheme.textSoft, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                contest['prizePool'],
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final fee = contest['entryFee'];
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Joined contest for ${fee == 0 ? 'Free' : 'Rs $fee'}'),
                      backgroundColor: AppTheme.primaryDeep,
                    ),
                  );
                },
                child: Text(
                  contest['entryFee'] == 0 ? 'FREE' : 'Rs ${contest['entryFee']}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: fillPercentage.toDouble(),
              minHeight: 8,
              backgroundColor: AppTheme.surfaceMuted,
              valueColor: AlwaysStoppedAnimation<Color>(
                spotsLeft < 1000 ? AppTheme.danger : AppTheme.primaryDeep,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                spotsLeft == 0 ? 'Contest Full' : '${_formatNumber(spotsLeft)} spots left',
                style: TextStyle(
                  color: spotsLeft < 1000 ? AppTheme.danger : AppTheme.primaryDeep,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '${_formatNumber(spotsTotal)} spots',
                style: const TextStyle(color: AppTheme.textSoft, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                _buildMetaItem(Icons.emoji_events_outlined, '${contest['firstPrize']}'),
                const SizedBox(width: 16),
                _buildMetaItem(Icons.military_tech_outlined, '${contest['winPercent']}%'),
                const Spacer(),
                if (contest['guaranteed'])
                  _buildMetaIcon(Icons.verified_rounded, 'Guaranteed', AppTheme.primaryDeep),
                if (contest['isMultiEntry'])
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildMetaIcon(Icons.copy_rounded, 'Multi-Entry', AppTheme.textSoft),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textSoft, size: 14),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildMetaIcon(IconData icon, String tooltip, Color color) {
    return Tooltip(
      message: tooltip,
      child: Icon(icon, color: color, size: 16),
    );
  }

  String _formatNumber(int number) {
    if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
