import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'fantasy_leaderboard_screen.dart';

class ContestLobbyScreen extends StatefulWidget {
  const ContestLobbyScreen({super.key});

  @override
  State<ContestLobbyScreen> createState() => _ContestLobbyScreenState();
}

class _ContestLobbyScreenState extends State<ContestLobbyScreen> {
  String _selectedFilter = 'All Contests';

  final List<String> _filters = [
    'All Contests',
    'Mega',
    'H2H',
    'Small League',
    'Practice',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                _buildContestTypeFilters(),
                const SizedBox(height: 24),
                if (_selectedFilter == 'All Contests' ||
                    _selectedFilter == 'Mega') ...[
                  _buildSectionHeader(
                    'Mega Contests',
                    'Large prize pools with premium competition.',
                  ),
                  const SizedBox(height: 14),
                  _buildContestCard(
                    title: 'Mega Contest',
                    prizePool: 'Rs 1,00,000',
                    entryFee: 'Rs 49',
                    totalSpots: 5000,
                    filledSpots: 3500,
                    firstPrize: 'Rs 10,000',
                    winnersPercent: '60%',
                    isMega: true,
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedFilter == 'All Contests' ||
                    _selectedFilter == 'Small League') ...[
                  _buildSectionHeader(
                    'Small League',
                    'Balanced contests with better odds.',
                  ),
                  const SizedBox(height: 14),
                  _buildContestCard(
                    title: 'Hot Contest',
                    prizePool: 'Rs 50,000',
                    entryFee: 'Rs 35',
                    totalSpots: 2000,
                    filledSpots: 1800,
                    firstPrize: 'Rs 5,000',
                    winnersPercent: '50%',
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedFilter == 'All Contests' ||
                    _selectedFilter == 'H2H') ...[
                  _buildSectionHeader(
                    'Head-to-Head',
                    'Quick 1v1 battles for confident players.',
                  ),
                  const SizedBox(height: 14),
                  _buildContestCard(
                    title: 'Head to Head',
                    prizePool: 'Rs 10,000',
                    entryFee: 'Rs 5,200',
                    totalSpots: 2,
                    filledSpots: 1,
                    firstPrize: 'Rs 10,000',
                    winnersPercent: '50%',
                  ),
                  const SizedBox(height: 14),
                ],
                if (_selectedFilter == 'All Contests' ||
                    _selectedFilter == 'Practice') ...[
                  _buildSectionHeader(
                    'Practice Contests',
                    'Free contests to test combinations.',
                  ),
                  const SizedBox(height: 14),
                  _buildContestCard(
                    title: 'Practice Contest',
                    prizePool: 'Glory',
                    entryFee: 'Free',
                    totalSpots: 10000,
                    filledSpots: 2500,
                    firstPrize: 'Bragging Rights',
                    winnersPercent: '100%',
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            child: const Icon(Icons.arrow_back, color: AppTheme.text, size: 20),
          ),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contests',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Choose the contest that fits your style.',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                color: AppTheme.primaryDeep,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Rs 4,520',
                style: TextStyle(
                  color: AppTheme.text,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContestTypeFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              right: index != _filters.length - 1 ? 10 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = label;
                });
              },
              child: _buildFilterChip(label, _selectedFilter == label),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        gradient: isSelected ? AppTheme.heroGradient : null,
        color: isSelected ? null : AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isSelected ? Colors.transparent : AppTheme.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.text,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildContestCard({
    required String title,
    required String prizePool,
    required String entryFee,
    required int totalSpots,
    required int filledSpots,
    required String firstPrize,
    required String winnersPercent,
    bool isMega = false,
  }) {
    final fillPercentage = filledSpots / totalSpots;
    final spotsLeft = totalSpots - filledSpots;

    return Container(
      decoration: AppTheme.softCardDecoration(glow: isMega),
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppTheme.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        if (isMega) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceMuted,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'MEGA',
                              style: TextStyle(
                                color: AppTheme.primaryDeep,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Prize Pool',
                      style: TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      prizePool,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.heroGradient,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ElevatedButton(
                  onPressed: () => _showJoinConfirmation(context, entryFee),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  child: Text('JOIN $entryFee'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fillPercentage,
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.heroGradient,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$spotsLeft spots left',
                style: const TextStyle(
                  color: AppTheme.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                '$totalSpots spots',
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceMuted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _footerStat(Icons.emoji_events_outlined, firstPrize),
                _footerStat(Icons.military_tech_outlined, winnersPercent),
                _footerMode('M'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerStat(IconData icon, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppTheme.primaryDeep, size: 16),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _footerMode(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.border),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppTheme.text,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  void _showJoinConfirmation(BuildContext context, String entryFee) {
    final feeAmount = int.tryParse(entryFee.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    const currentBalance = 2720;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Confirmation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 22),
              _buildConfirmationRow('Current Balance', 'Rs $currentBalance', isBold: true),
              const SizedBox(height: 12),
              _buildConfirmationRow('Entry Fee', '- Rs $feeAmount', color: AppTheme.danger),
              const SizedBox(height: 12),
              _buildConfirmationRow('Usable Bonus', '- Rs 0'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: AppTheme.border),
              ),
              _buildConfirmationRow('To Pay', 'Rs $feeAmount', isBold: true),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  if (currentBalance >= feeAmount) {
                    Navigator.pop(context);
                    _showSuccessDialog(context);
                  } else {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Insufficient balance. Please add cash.'),
                      ),
                    );
                  }
                },
                child: const Text('JOIN CONTEST'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmationRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppTheme.textSoft,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? AppTheme.text,
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppTheme.primaryDeep,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Contest Joined',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'You have successfully joined the contest. Best of luck.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const FantasyLeaderboardScreen(),
                      ),
                    );
                  },
                  child: const Text('VIEW LEADERBOARD'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
