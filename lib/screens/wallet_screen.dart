import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

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
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildTotalBalanceCard(),
                const SizedBox(height: 24),
                const Text(
                  'Balance Details',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                _buildBalanceDetailRow(
                  title: 'Amount Unutilized',
                  amount: 'Rs 150',
                  icon: Icons.account_balance_wallet_outlined,
                  color: AppTheme.primaryDeep,
                ),
                const SizedBox(height: 12),
                _buildBalanceDetailRow(
                  title: 'Winnings',
                  amount: 'Rs 2,450',
                  icon: Icons.emoji_events_outlined,
                  color: const Color(0xFFF59E0B),
                  actionText: 'WITHDRAW',
                  onAction: () {},
                ),
                const SizedBox(height: 12),
                _buildBalanceDetailRow(
                  title: 'Discount Bonus',
                  amount: 'Rs 120',
                  icon: Icons.card_giftcard_outlined,
                  color: const Color(0xFF2563EB),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Manage Payments',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                _buildManagePaymentsSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                'My Wallet',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.text,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Track balance, winnings, and payment methods.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w600,
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.history, color: AppTheme.text, size: 22),
        ),
      ],
    );
  }

  Widget _buildTotalBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.account_balance_wallet,
                color: AppTheme.textSoft,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Total Balance',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Rs 2,720',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 40,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('ADD CASH'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceDetailRow({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: AppTheme.softCardDecoration(radius: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          if (actionText != null && onAction != null)
            OutlinedButton(
              onPressed: onAction,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.text,
                side: const BorderSide(color: AppTheme.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          else
            const Icon(
              Icons.info_outline,
              color: AppTheme.textMuted,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildManagePaymentsSection() {
    return Container(
      decoration: AppTheme.softCardDecoration(radius: 20),
      child: Column(
        children: [
          _buildActionItem(
            icon: Icons.account_balance_outlined,
            title: 'Manage Bank Accounts',
            subtitle: 'Add or remove bank accounts',
            isTop: true,
          ),
          const Divider(color: AppTheme.border, height: 1),
          _buildActionItem(
            icon: Icons.credit_card_outlined,
            title: 'Manage Cards',
            subtitle: 'Saved credit and debit cards',
          ),
          const Divider(color: AppTheme.border, height: 1),
          _buildActionItem(
            icon: Icons.receipt_long_outlined,
            title: 'Recent Transactions',
            subtitle: 'View your deposit and withdrawal history',
            isBottom: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isTop = false,
    bool isBottom = false,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.vertical(
        top: isTop ? const Radius.circular(20) : Radius.zero,
        bottom: isBottom ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.textSoft, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
