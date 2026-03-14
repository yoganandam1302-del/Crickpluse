import 'package:cricpluse/app_theme.dart';
import 'package:cricpluse/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _autoPlayVideos = false;
  bool _dataSaver = false;
  late int _themeSelection;

  @override
  void initState() {
    super.initState();
    if (appThemeNotifier.value == ThemeMode.system) {
      _themeSelection = 0;
    } else if (appThemeNotifier.value == ThemeMode.light) {
      _themeSelection = 1;
    } else {
      _themeSelection = 2;
    }
  }

  void _showComingSoon(String title, {Color color = AppTheme.primaryDeep}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title coming soon!'),
        backgroundColor: color,
      ),
    );
  }

  void _updateTheme(int index) {
    setState(() => _themeSelection = index);
    if (index == 0) {
      appThemeNotifier.value = ThemeMode.system;
    } else if (index == 1) {
      appThemeNotifier.value = ThemeMode.light;
    } else {
      appThemeNotifier.value = ThemeMode.dark;
    }
  }

  Future<void> _showDeleteDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Delete Account?',
          style: TextStyle(
            color: AppTheme.text,
            fontWeight: FontWeight.w800,
          ),
        ),
        content: const Text(
          'This action is permanent. Your contests, wallet data, and profile history will be removed.',
          style: TextStyle(
            color: AppTheme.textSoft,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'CANCEL',
              style: TextStyle(color: AppTheme.textSoft),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.danger,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _showComingSoon('Delete account', color: AppTheme.danger);
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 22),
                _buildHeroCard(),
                const SizedBox(height: 24),
                _buildSectionTitle('App Preferences'),
                const SizedBox(height: 12),
                _buildThemeSelector(),
                const SizedBox(height: 14),
                _buildToggleTile(
                  icon: Icons.notifications_active_outlined,
                  color: const Color(0xFF2563EB),
                  title: 'Push Notifications',
                  subtitle: 'Match alerts, winnings, and breaking news',
                  value: _pushNotifications,
                  onChanged: (value) => setState(() => _pushNotifications = value),
                ),
                const SizedBox(height: 14),
                _buildToggleTile(
                  icon: Icons.play_circle_outline,
                  color: const Color(0xFFF59E0B),
                  title: 'Auto-Play Videos',
                  subtitle: 'Automatically play highlights and reels',
                  value: _autoPlayVideos,
                  onChanged: (value) => setState(() => _autoPlayVideos = value),
                ),
                const SizedBox(height: 14),
                _buildToggleTile(
                  icon: Icons.data_usage_outlined,
                  color: AppTheme.primaryDeep,
                  title: 'Data Saver Mode',
                  subtitle: 'Reduce media quality on mobile data',
                  value: _dataSaver,
                  onChanged: (value) => setState(() => _dataSaver = value),
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.language_outlined,
                  color: const Color(0xFF7C3AED),
                  title: 'Language & Region',
                  subtitle: 'English (US), India',
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.folder_open_outlined,
                  color: const Color(0xFF0EA5E9),
                  title: 'Storage & Data',
                  subtitle: 'Manage 120 MB cache and downloads',
                ),
                const SizedBox(height: 26),
                _buildSectionTitle('Account & Security'),
                const SizedBox(height: 12),
                _buildNavTile(
                  icon: Icons.workspace_premium_outlined,
                  color: const Color(0xFFF59E0B),
                  title: 'CricPulse Pro',
                  subtitle: 'Manage your premium subscription',
                  onTap: () => _showComingSoon('CricPulse Pro'),
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.lock_outline,
                  color: AppTheme.primaryDeep,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.phonelink_lock_outlined,
                  color: const Color(0xFF2563EB),
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add an extra layer of security',
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.delete_outline,
                  color: AppTheme.danger,
                  title: 'Delete Account',
                  subtitle: 'Permanently remove your account data',
                  isDestructive: true,
                  onTap: _showDeleteDialog,
                ),
                const SizedBox(height: 26),
                _buildSectionTitle('Support & About'),
                const SizedBox(height: 12),
                _buildNavTile(
                  icon: Icons.help_outline,
                  color: const Color(0xFF7C3AED),
                  title: 'Help Center',
                  subtitle: 'FAQs and live support',
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.article_outlined,
                  color: const Color(0xFF0EA5E9),
                  title: 'Terms of Service',
                  subtitle: 'Read our terms and conditions',
                ),
                const SizedBox(height: 14),
                _buildNavTile(
                  icon: Icons.privacy_tip_outlined,
                  color: AppTheme.primaryDeep,
                  title: 'Privacy Policy',
                  subtitle: 'How we collect and protect your data',
                ),
                const SizedBox(height: 26),
                _buildSignOutCard(),
                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    'CricPulse v2.4.1 (Build 8902)',
                    style: TextStyle(
                      color: AppTheme.textMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
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
        _circleButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () => Navigator.pop(context),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tune your CricPulse experience',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 26),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.24),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.tune_rounded,
              color: AppTheme.text,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Personalize Everything',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Control alerts, theme, privacy, and account security from one clean dashboard.',
                  style: TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: AppTheme.text, size: 18),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.textSoft,
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.palette_outlined,
                  color: AppTheme.primaryDeep,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'App Theme',
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Choose how CricPulse looks on your device',
                      style: TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _buildThemeOption(0, 'System', Icons.brightness_auto_outlined),
              const SizedBox(width: 10),
              _buildThemeOption(1, 'Light', Icons.light_mode_outlined),
              const SizedBox(width: 10),
              _buildThemeOption(2, 'Dark', Icons.dark_mode_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(int index, String label, IconData icon) {
    final isSelected = _themeSelection == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _updateTheme(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primary : AppTheme.surfaceMuted,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppTheme.primaryDeep : AppTheme.border,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.22),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: AppTheme.text,
                size: 20,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
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
                    color: AppTheme.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeColor: AppTheme.primaryDeep,
            trackColor: AppTheme.border,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () => _showComingSoon(title),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: AppTheme.softCardDecoration(radius: 24),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
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
                    style: TextStyle(
                      color: isDestructive ? AppTheme.danger : AppTheme.text,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isDestructive ? AppTheme.danger : AppTheme.textMuted,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutCard() {
    return GestureDetector(
      onTap: () => _showComingSoon('Sign out', color: AppTheme.danger),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: AppTheme.danger.withOpacity(0.08),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppTheme.danger.withOpacity(0.16)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.danger, size: 20),
            SizedBox(width: 10),
            Text(
              'SIGN OUT',
              style: TextStyle(
                color: AppTheme.danger,
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
