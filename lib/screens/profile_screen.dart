import 'dart:io';

import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'login_screen.dart';
import 'profile_data.dart';
import 'refer_and_earn_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  String _name = ProfileData.instance.name;
  String _username = ProfileData.instance.username;
  String _location = ProfileData.instance.location;

  @override
  void initState() {
    super.initState();
    _profileImage = ProfileData.instance.profileImage;
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(source: source, imageQuality: 80);
    if (image != null) {
      setState(() => _profileImage = File(image.path));
      ProfileData.instance.profileImage = File(image.path);
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Update Profile Photo',
              style: TextStyle(
                color: AppTheme.text,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            _sheetAction(
              icon: Icons.camera_alt_outlined,
              color: AppTheme.primaryDeep,
              label: 'Take Photo',
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.camera);
              },
            ),
            _sheetAction(
              icon: Icons.photo_library_outlined,
              color: const Color(0xFF2563EB),
              label: 'Choose from Gallery',
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_profileImage != null)
              _sheetAction(
                icon: Icons.delete_outline,
                color: AppTheme.danger,
                label: 'Remove Photo',
                onTap: () {
                  Navigator.pop(ctx);
                  setState(() => _profileImage = null);
                  ProfileData.instance.profileImage = null;
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _sheetAction({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(
        label,
        style: const TextStyle(color: AppTheme.text, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _name);
    final usernameCtrl = TextEditingController(text: _username.replaceFirst('@', ''));
    final locationCtrl = TextEditingController(text: _location);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: AppTheme.text, fontWeight: FontWeight.w800),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField('Full Name', nameCtrl, Icons.person_outline),
              const SizedBox(height: 16),
              _buildEditField('Username', usernameCtrl, Icons.alternate_email),
              const SizedBox(height: 16),
              _buildEditField('Location', locationCtrl, Icons.location_on_outlined),
            ],
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
            onPressed: () {
              setState(() {
                _name = nameCtrl.text.trim();
                _username = '@${usernameCtrl.text.trim()}';
                _location = locationCtrl.text.trim();
              });
              ProfileData.instance.name = _name;
              ProfileData.instance.username = _username;
              ProfileData.instance.location = _location;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated!'),
                  backgroundColor: AppTheme.primaryDeep,
                ),
              );
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(
    String label,
    TextEditingController ctrl,
    IconData icon,
  ) {
    return TextField(
      controller: ctrl,
      style: const TextStyle(color: AppTheme.text),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryDeep, size: 20),
      ),
    );
  }

  void _showSettingsSheet(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.45,
          builder: (_, scrollCtrl) => ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text(
                  'GOT IT',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildStatsGrid()),
            SliverToBoxAdapter(child: _buildFantasyStats()),
            SliverToBoxAdapter(child: _buildAchievements()),
            SliverToBoxAdapter(child: _buildSettingsSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 28),
      decoration: const BoxDecoration(
        gradient: AppTheme.pageGradient,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: _showPhotoOptions,
                child: Stack(
                  children: [
                    Container(
                      width: 86,
                      height: 86,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.primaryDeep, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.18),
                            blurRadius: 18,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _profileImage != null
                            ? Image.file(_profileImage!, fit: BoxFit.cover)
                            : Image.network(
                                'https://i.pravatar.cc/200?img=5',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryDeep,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: AppTheme.text,
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      style: const TextStyle(
                        color: AppTheme.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFACC15), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'PRO PLAYER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _username,
                            style: const TextStyle(
                              color: AppTheme.textSoft,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: AppTheme.primaryDeep,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _location,
                            style: const TextStyle(
                              color: AppTheme.textSoft,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  _headerAction(
                    Icons.settings_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  _headerAction(Icons.edit_outlined, onTap: _showEditProfileDialog),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerAction(IconData icon, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: AppTheme.text, size: 18),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildStatBox('Contests\nJoined', '47', const Color(0xFF2563EB)),
          const SizedBox(width: 12),
          _buildStatBox('Contests\nWon', '12', AppTheme.primaryDeep),
          const SizedBox(width: 12),
          _buildStatBox('Win\nRate', '25.5%', const Color(0xFFF59E0B)),
          const SizedBox(width: 12),
          _buildStatBox('Total\nWinnings', 'Rs 2.7k', const Color(0xFF7C3AED)),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.18)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSoft,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFantasyStats() {
    final items = [
      {
        'label': 'Avg. Points',
        'value': '834.5',
        'icon': Icons.trending_up,
        'color': AppTheme.primaryDeep,
      },
      {
        'label': 'Best Rank',
        'value': '#3',
        'icon': Icons.emoji_events,
        'color': const Color(0xFFF59E0B),
      },
      {
        'label': 'Teams Made',
        'value': '24',
        'icon': Icons.group,
        'color': const Color(0xFF2563EB),
      },
      {
        'label': 'H2H Wins',
        'value': '18',
        'icon': Icons.sports_cricket,
        'color': const Color(0xFF7C3AED),
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fantasy Performance',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'IPL 2026',
                  style: TextStyle(
                    color: AppTheme.primaryDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((a) {
              final color = a['color'] as Color;
              return Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(a['icon'] as IconData, color: color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a['value'] as String,
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    a['label'] as String,
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 10,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {
        'icon': Icons.star,
        'color': const Color(0xFFFACC15),
        'title': 'First Win',
        'subtitle': 'Won first contest',
      },
      {
        'icon': Icons.local_fire_department,
        'color': AppTheme.danger,
        'title': '10 Streak',
        'subtitle': '10 in a row',
      },
      {
        'icon': Icons.diamond,
        'color': AppTheme.primaryDeep,
        'title': 'Century',
        'subtitle': '100+ points',
      },
      {
        'icon': Icons.military_tech,
        'color': const Color(0xFF7C3AED),
        'title': 'Top 3',
        'subtitle': 'Finished Top 3',
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: achievements.map((a) {
              final color = a['color'] as Color;
              return Column(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: color.withOpacity(0.3), width: 2),
                    ),
                    child: Icon(a['icon'] as IconData, color: color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a['title'] as String,
                    style: const TextStyle(
                      color: AppTheme.text,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SizedBox(
                    width: 72,
                    child: Text(
                      a['subtitle'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: AppTheme.softCardDecoration(radius: 22),
      child: Column(
        children: [
          _buildSettingsItem(
            Icons.card_giftcard,
            'Refer & Earn',
            const Color(0xFFF59E0B),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferAndEarnScreen()),
              );
            },
          ),
          _buildSettingsDivider(),
          _buildSettingsItem(
            Icons.notifications_outlined,
            'Notifications',
            const Color(0xFF2563EB),
            onTap: () => _showSettingsSheet(
              'Notifications',
              'Control your push notifications for match alerts, fantasy scores, and contest results.',
              Icons.notifications_outlined,
              const Color(0xFF2563EB),
            ),
          ),
          _buildSettingsDivider(),
          _buildSettingsItem(
            Icons.verified_user_outlined,
            'KYC Verification',
            AppTheme.primaryDeep,
            onTap: () => _showSettingsSheet(
              'KYC Verification',
              'Complete your KYC verification to unlock withdrawals and contest entry.',
              Icons.verified_user_outlined,
              AppTheme.primaryDeep,
            ),
          ),
          _buildSettingsDivider(),
          _buildSettingsItem(
            Icons.account_balance_wallet_outlined,
            'Payment Methods',
            const Color(0xFFF59E0B),
            onTap: () => _showSettingsSheet(
              'Payment Methods',
              'Manage your saved UPI IDs, bank accounts, and cards for seamless entries and withdrawals.',
              Icons.account_balance_wallet_outlined,
              const Color(0xFFF59E0B),
            ),
          ),
          _buildSettingsDivider(),
          _buildSettingsItem(
            Icons.privacy_tip_outlined,
            'Privacy & Security',
            AppTheme.primaryDeep,
            onTap: () => _showSettingsSheet(
              'Privacy & Security',
              'Manage your data privacy settings, two-factor authentication, and account security.',
              Icons.privacy_tip_outlined,
              AppTheme.primaryDeep,
            ),
          ),
          _buildSettingsDivider(),
          _buildSettingsItem(
            Icons.help_outline,
            'Help & Support',
            const Color(0xFF7C3AED),
            onTap: () => _showSettingsSheet(
              'Help & Support',
              'Our support team is available 24/7. Browse FAQs, raise a ticket, or chat with us live.',
              Icons.help_outline,
              const Color(0xFF7C3AED),
            ),
          ),
          _buildSettingsDivider(),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppTheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  title: const Text(
                    'Logout?',
                    style: TextStyle(
                      color: AppTheme.text,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  content: const Text(
                    'Are you sure you want to log out?',
                    style: TextStyle(color: AppTheme.textSoft),
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        'LOGOUT',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.danger.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: AppTheme.danger,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Logout',
                    style: TextStyle(
                      color: AppTheme.danger,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    Color color, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsDivider() {
    return const Divider(
      height: 1,
      color: AppTheme.border,
      indent: 76,
      endIndent: 20,
    );
  }
}
