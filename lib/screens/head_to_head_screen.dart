import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

class HeadToHeadScreen extends StatelessWidget {
  const HeadToHeadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 12),
                _buildTeamSelectionHeader(),
                const SizedBox(height: 20),
                _buildRecentFormSection(),
                const SizedBox(height: 20),
                _buildStatsGrid(),
                const SizedBox(height: 20),
                _buildKeyMatchups(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
              'Head-to-Head',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSelectionHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(22),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTeamLogo('MI', 'Mumbai', const Color(0xFF2563EB)),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: AppTheme.heroGradient,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              _buildTeamLogo('RCB', 'Bangalore', AppTheme.danger),
            ],
          ),
          const SizedBox(height: 26),
          _buildWinProbabilityBar(),
        ],
      ),
    );
  }

  Widget _buildTeamLogo(String teamName, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 82,
          height: 82,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.3), width: 3),
          ),
          alignment: Alignment.center,
          child: Text(
            teamName,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildWinProbabilityBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'WIN PROBABILITY',
            style: TextStyle(
              color: AppTheme.textSoft,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '60%',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              '40%',
              style: TextStyle(
                color: AppTheme.danger,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(999)),
            color: AppTheme.surfaceMuted,
          ),
          child: Row(
            children: [
              Expanded(
                flex: 60,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(999),
                      bottomLeft: Radius.circular(999),
                    ),
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              Expanded(
                flex: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(999),
                      bottomRight: Radius.circular(999),
                    ),
                    color: AppTheme.danger,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentFormSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.softCardDecoration(radius: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'RECENT FORM (LAST 5)',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFormRow(['W', 'W', 'L', 'W', 'W']),
                _buildFormRow(['L', 'W', 'L', 'L', 'W']),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormRow(List<String> results) {
    return Row(
      children: results.map((result) {
        Color bgColor = AppTheme.surfaceMuted;
        Color textColor = AppTheme.textSoft;

        if (result == 'W') {
          bgColor = AppTheme.primary.withOpacity(0.18);
          textColor = AppTheme.primaryDeep;
        } else if (result == 'L') {
          bgColor = AppTheme.danger.withOpacity(0.12);
          textColor = AppTheme.danger;
        }

        return Container(
          margin: const EdgeInsets.only(right: 6),
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: textColor.withOpacity(0.2)),
          ),
          alignment: Alignment.center,
          child: Text(
            result,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatsGrid() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        children: [
          _buildStatComparison('Matches Played', '32', '32'),
          const Divider(color: AppTheme.border, height: 24),
          _buildStatComparison('Wins', '19', '13', highlightLeft: true),
          const Divider(color: AppTheme.border, height: 24),
          _buildStatComparison('Highest Score', '235', '262', highlightRight: true),
          const Divider(color: AppTheme.border, height: 24),
          _buildStatComparison('Lowest Score', '87', '49'),
          const Divider(color: AppTheme.border, height: 24),
          _buildStatComparison('Win % at Venue', '58%', '32%', highlightLeft: true),
        ],
      ),
    );
  }

  Widget _buildStatComparison(
    String label,
    String valA,
    String valB, {
    bool highlightLeft = false,
    bool highlightRight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            valA,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: highlightLeft ? const Color(0xFF2563EB) : AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            valB,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: highlightRight ? AppTheme.danger : AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyMatchups() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'KEY MATCHUPS',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          _buildMatchupCard(
            'Suryakumar Y.',
            'Mohammed Siraj',
            '78 Runs',
            '2 Dismissals',
          ),
          const SizedBox(height: 12),
          _buildMatchupCard(
            'Virat Kohli',
            'Jasprit Bumrah',
            '140 Runs',
            '4 Dismissals',
          ),
        ],
      ),
    );
  }

  Widget _buildMatchupCard(String p1, String p2, String stat1, String stat2) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p1,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat1,
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'VS',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  p2,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stat2,
                  style: const TextStyle(
                    color: AppTheme.danger,
                    fontSize: 12,
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
}
