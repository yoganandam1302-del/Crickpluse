import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;

  final List<String> _filters = ['All', 'Matches', 'Fantasy', 'Offers'];

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'matches',
      'title': 'Wicket! Kohli is OUT',
      'message': 'Caught by Suryakumar Yadav. RCB 162/7 (18.4 overs)',
      'time': 'Just now',
      'isRead': false,
      'icon': Icons.sports_cricket,
      'color': AppTheme.danger,
    },
    {
      'type': 'fantasy',
      'title': 'Contest Won!',
      'message': 'You won Rs 1,500 in the Mega Contest for MI vs CSK.',
      'time': '2 hours ago',
      'isRead': false,
      'icon': Icons.emoji_events,
      'color': const Color(0xFFF59E0B),
    },
    {
      'type': 'matches',
      'title': 'Match Started',
      'message': 'MI vs RCB has officially begun. Tap to view live scorecard.',
      'time': '3 hours ago',
      'isRead': true,
      'icon': Icons.stadium,
      'color': const Color(0xFF2563EB),
    },
    {
      'type': 'offers',
      'title': 'Deposit Bonus Unlocked!',
      'message': 'Get 100% bonus up to Rs 500 on your next deposit.',
      'time': '1 day ago',
      'isRead': true,
      'icon': Icons.percent,
      'color': AppTheme.primaryDeep,
    },
    {
      'type': 'fantasy',
      'title': 'Lineups Announced',
      'message': 'Starting XIs for IND vs AUS are out. Edit your fantasy team now.',
      'time': '1 day ago',
      'isRead': true,
      'icon': Icons.people,
      'color': const Color(0xFF7C3AED),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildFiltersBar(),
              const SizedBox(height: 16),
              Expanded(child: _buildNotificationsList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
              child: const Icon(Icons.arrow_back, color: AppTheme.text, size: 20),
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                for (final notif in _notifications) {
                  notif['isRead'] = true;
                }
              });
            },
            child: const Text(
              'Mark all as read',
              style: TextStyle(
                color: AppTheme.primaryDeep,
                fontSize: 12,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: TextStyle(
              color: AppTheme.text,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Stay updated with your latest alerts.',
            style: TextStyle(
              color: AppTheme.textSoft,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilterIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFilterIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.heroGradient : null,
                color: isSelected ? null : AppTheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : AppTheme.border,
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildNotificationsList() {
    var filteredList = _notifications;
    if (_selectedFilterIndex != 0) {
      final filterType = _filters[_selectedFilterIndex].toLowerCase();
      filteredList = _notifications.where((n) => n['type'] == filterType).toList();
    }

    if (filteredList.isEmpty) {
      return const Center(
        child: Text(
          'No notifications here.',
          style: TextStyle(color: AppTheme.textSoft, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return _buildNotificationCard(filteredList[index]);
      },
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final isRead = notif['isRead'] as bool;
    final accentColor = notif['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? AppTheme.surface : AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRead ? AppTheme.border : accentColor.withOpacity(0.35),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              notif['isRead'] = true;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isRead ? AppTheme.border : accentColor.withOpacity(0.45),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    notif['icon'] as IconData,
                    color: isRead ? AppTheme.textSoft : accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'] as String,
                              style: TextStyle(
                                color: AppTheme.text,
                                fontSize: 16,
                                fontWeight: isRead ? FontWeight.w700 : FontWeight.w800,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(left: 8),
                              decoration: BoxDecoration(
                                color: accentColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['message'] as String,
                        style: TextStyle(
                          color: isRead ? AppTheme.textSoft : AppTheme.text,
                          fontSize: 13,
                          height: 1.45,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        notif['time'] as String,
                        style: TextStyle(
                          color: isRead ? AppTheme.textMuted : accentColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
