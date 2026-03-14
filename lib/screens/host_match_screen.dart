import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'create_match_teams_screen.dart';
import 'home_screen.dart';
import 'matches_screen.dart';

class HostMatchScreen extends StatefulWidget {
  const HostMatchScreen({super.key});

  @override
  State<HostMatchScreen> createState() => _HostMatchScreenState();
}

class _HostMatchScreenState extends State<HostMatchScreen> {
  double _overs = 20;

  final TextEditingController _matchTitleController = TextEditingController();
  final TextEditingController _venueController = TextEditingController(
    text: 'Lords Stadium, London',
  );

  String _ballType = 'Leather';
  String _pitchType = 'Turf';
  bool _isAdvancedSettingsVisible = false;

  @override
  void dispose() {
    _matchTitleController.dispose();
    _venueController.dispose();
    super.dispose();
  }

  void _nextStep() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateMatchTeamsScreen(
          matchTitle: _matchTitleController.text.isEmpty
              ? 'Friendly Match'
              : _matchTitleController.text,
          totalOvers: _overs.toInt(),
        ),
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
            padding: const EdgeInsets.only(bottom: 120),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildHeroBanner(),
                  const SizedBox(height: 18),
                  _buildMatchConfig(),
                  _buildAdvancedSettingsToggle(),
                  if (_isAdvancedSettingsVisible) _buildAdvancedSettings(),
                  const SizedBox(height: 16),
                  _buildMatchPreview(),
                  const SizedBox(height: 22),
                  _buildStartButton(),
                  const SizedBox(height: 14),
                  const Center(
                    child: Text(
                      'SAVE MATCH SETUP AS TEMPLATE',
                      style: TextStyle(
                        color: AppTheme.textSoft,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
    );
  }

  Widget _buildHeader() {
    return Row(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Host a Match',
                style: TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'CricPulse Premium custom setup',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
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
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.border),
          ),
          child: const Icon(Icons.settings_outlined, color: AppTheme.text, size: 20),
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_outlined,
              color: AppTheme.text,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Build Your Own Match Day',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Set the format, venue, pitch conditions, and get your teams ready in one premium flow.',
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

  Widget _buildSectionTitle(String title, IconData icon, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryDeep, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppTheme.text,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.textSoft,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildMatchConfig() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('MATCH CONFIGURATION', Icons.sports_cricket_rounded),
          const SizedBox(height: 18),
          _buildLabel('MATCH TITLE'),
          TextField(
            controller: _matchTitleController,
            style: const TextStyle(color: AppTheme.text, fontSize: 14),
            decoration: const InputDecoration(
              hintText: 'e.g. Weekend Warriors Final',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('FORMAT'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Text(
                        'T20 Professional',
                        style: TextStyle(
                          color: AppTheme.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('OVERS'),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _overs.toInt().toString(),
                            style: const TextStyle(
                              color: AppTheme.primaryDeep,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 7,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                                activeTrackColor: AppTheme.primaryDeep,
                                inactiveTrackColor: AppTheme.border,
                                thumbColor: AppTheme.primaryDeep,
                              ),
                              child: Slider(
                                value: _overs,
                                min: 1,
                                max: 50,
                                onChanged: (val) {
                                  setState(() => _overs = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('VENUE'),
                    TextField(
                      controller: _venueController,
                      style: const TextStyle(color: AppTheme.text, fontSize: 14),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: AppTheme.textSoft,
                          size: 18,
                        ),
                        hintText: 'Venue',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('TIME'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceMuted,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.schedule_outlined, color: AppTheme.textSoft, size: 16),
                          SizedBox(width: 8),
                          Text(
                            '19:30 PM',
                            style: TextStyle(
                              color: AppTheme.text,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettingsToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAdvancedSettingsVisible = !_isAdvancedSettingsVisible;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isAdvancedSettingsVisible
                  ? 'HIDE EXTRA SETTINGS'
                  : 'SHOW EXTRA SETTINGS',
              style: const TextStyle(
                color: AppTheme.primaryDeep,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            Icon(
              _isAdvancedSettingsVisible
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: AppTheme.primaryDeep,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettings() {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: AppTheme.softCardDecoration(radius: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('EXTRA FEATURES / CONDITIONS', Icons.tune_rounded),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('BALL TYPE'),
                    _buildDropdown(
                      _ballType,
                      ['Leather', 'Tennis', 'Tape'],
                      (val) => setState(() => _ballType = val!),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('PITCH TYPE'),
                    _buildDropdown(
                      _pitchType,
                      ['Turf', 'Matting', 'Cement'],
                      (val) => setState(() => _pitchType = val!),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppTheme.surface,
          icon: const Icon(Icons.arrow_drop_down_rounded, color: AppTheme.primaryDeep),
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildMatchPreview() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: AppTheme.primaryDeep,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Match Preview',
                  style: TextStyle(
                    color: AppTheme.text,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'T20 | ${_venueController.text} | ${_overs.toInt()} Overs',
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    height: 1.4,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Next Step',
                style: TextStyle(
                  color: AppTheme.primaryDeep,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Setup Teams',
                style: TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return ElevatedButton(
      onPressed: _nextStep,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NEXT STEP',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward_rounded, size: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home_outlined,
            'Home',
            false,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            ),
          ),
          _buildNavItem(
            Icons.search_rounded,
            'Matches',
            false,
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MatchesScreen()),
            ),
          ),
          const SizedBox(width: 60),
          _buildNavItem(Icons.emoji_events_outlined, 'Fantasy', true),
          _buildNavItem(Icons.person_outline_rounded, 'Profile', false),
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
      onTap: onTap,
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
              color: isSelected ? AppTheme.primaryDeep : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAB() {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.28),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Icon(Icons.add_rounded, color: AppTheme.text, size: 32),
    );
  }
}
