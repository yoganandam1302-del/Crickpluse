import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';

import 'head_to_head_screen.dart';
import 'home_screen.dart';
import 'live_chat_screen.dart';
import 'matches_screen.dart';

class MatchDetailsScreen extends StatefulWidget {
  const MatchDetailsScreen({super.key});

  @override
  State<MatchDetailsScreen> createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLiveTab(),
                    _buildScorecardTab(),
                    _buildSquadsTab(),
                    _buildTableTab(),
                    _buildCommentaryTab(),
                    const LiveChatWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingPlayButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Column(
        children: [
          Row(
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
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppTheme.text,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mumbai Indians vs RCB',
                      style: TextStyle(
                        color: AppTheme.text,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'IPL 2026 • Match 25',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Text(
                  'LIVE',
                  style: TextStyle(
                    color: AppTheme.primaryDeep,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            decoration: AppTheme.softCardDecoration(glow: true, radius: 28),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _teamHeader(
                        'MI',
                        'Mumbai Indians',
                        '176/5',
                        '20 overs',
                        const Color(0xFF2563EB),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Expanded(
                      child: _teamHeader(
                        'RCB',
                        'Royal Challengers',
                        '162/7',
                        '18.4 overs',
                        const Color(0xFFE5484D),
                        alignEnd: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Match Snapshot',
                            style: TextStyle(
                              color: AppTheme.text,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _miniStat('CRR', '8.67')),
                          const SizedBox(width: 10),
                          Expanded(child: _miniStat('RRR', '11.25', alert: true)),
                          const SizedBox(width: 10),
                          Expanded(child: _miniStat('Win Prob', '64%')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicator: BoxDecoration(
          gradient: AppTheme.heroGradient,
          borderRadius: BorderRadius.circular(14),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppTheme.text,
        unselectedLabelColor: AppTheme.textSoft,
        dividerColor: Colors.transparent,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
        tabs: const [
          Tab(text: 'LIVE'),
          Tab(text: 'SCORECARD'),
          Tab(text: 'SQUADS'),
          Tab(text: 'TABLE'),
          Tab(text: 'COMMENTARY'),
          Tab(text: 'CHAT'),
        ],
      ),
    );
  }

  Widget _buildLiveTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        _sectionCard(
          title: 'Live Action',
          child: Column(
            children: [
              _batterRow('Suryakumar Yadav', '68', '34', '200.0', striker: true),
              const Divider(color: AppTheme.border),
              _batterRow('Tim David', '14', '9', '155.5'),
              const Divider(color: AppTheme.border),
              _bowlerRow('Mohammed Siraj', '3.4', '32', '2', '8.73'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'Ball Tracker',
          action: 'Over 19',
          child: Column(
            children: [
              Container(
                height: 240,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCC6A6),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 116,
                        height: 210,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC9AE87),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    _ballPoint(top: 48, left: 126, color: AppTheme.danger),
                    _ballPoint(top: 92, left: 175, color: const Color(0xFF2563EB)),
                    _ballPoint(top: 144, left: 110, color: AppTheme.primaryDeep),
                    _ballPoint(top: 172, left: 170, color: const Color(0xFF2563EB)),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _LegendDot(color: AppTheme.danger, label: 'Short'),
                  SizedBox(width: 16),
                  _LegendDot(color: Color(0xFF2563EB), label: 'Good'),
                  SizedBox(width: 16),
                  _LegendDot(color: AppTheme.primaryDeep, label: 'Full'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'Win Probability',
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Row(
                  children: [
                    Expanded(
                      flex: 64,
                      child: Container(height: 12, color: const Color(0xFF2563EB)),
                    ),
                    Expanded(
                      flex: 36,
                      child: Container(height: 12, color: AppTheme.danger),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mumbai Indians 64%',
                    style: TextStyle(
                      color: Color(0xFF2563EB),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'RCB 36%',
                    style: TextStyle(
                      color: AppTheme.danger,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'Turning Point',
          child: const Text(
            'Suryakumar Yadav changed the match in the 18th over with back-to-back boundaries, pushing Mumbai into a winning position and shifting the pressure fully onto RCB.',
            style: TextStyle(
              color: AppTheme.textSoft,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScorecardTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        _sectionCard(
          title: 'Mumbai Indians Innings',
          child: Column(
            children: const [
              _ScoreRow(name: 'Rohit Sharma', value: '32 (20)'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Ishan Kishan', value: '24 (18)'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Suryakumar Yadav', value: '68 (34)'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Tim David', value: '14 (9)'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Extras', value: '18'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Total', value: '176/5'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'Bowling',
          child: Column(
            children: const [
              _ScoreRow(name: 'Mohammed Siraj', value: '3.4 • 32/2'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Harshal Patel', value: '4 • 38/1'),
              Divider(color: AppTheme.border),
              _ScoreRow(name: 'Maxwell', value: '2 • 17/0'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSquadsTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        _sectionCard(
          title: 'Mumbai Indians Squad',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _PlayerChip(name: 'Rohit Sharma'),
              _PlayerChip(name: 'Ishan Kishan'),
              _PlayerChip(name: 'Suryakumar Yadav'),
              _PlayerChip(name: 'Tim David'),
              _PlayerChip(name: 'Hardik Pandya'),
              _PlayerChip(name: 'Jasprit Bumrah'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'RCB Squad',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _PlayerChip(name: 'Virat Kohli'),
              _PlayerChip(name: 'Faf du Plessis'),
              _PlayerChip(name: 'Glenn Maxwell'),
              _PlayerChip(name: 'Dinesh Karthik'),
              _PlayerChip(name: 'Mohammed Siraj'),
              _PlayerChip(name: 'Harshal Patel'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: [
        _sectionCard(
          title: 'Points Table Snapshot',
          child: Column(
            children: const [
              _TableRow(rank: '1', team: 'Rajasthan Royals', points: '14'),
              Divider(color: AppTheme.border),
              _TableRow(rank: '2', team: 'Mumbai Indians', points: '12'),
              Divider(color: AppTheme.border),
              _TableRow(rank: '3', team: 'Chennai Super Kings', points: '10'),
              Divider(color: AppTheme.border),
              _TableRow(rank: '4', team: 'Royal Challengers', points: '10'),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _sectionCard(
          title: 'Quick Compare',
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HeadToHeadScreen()),
                );
              },
              child: const Text('Open Head to Head'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentaryTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      children: const [
        _CommentaryCard(
          over: '18.4',
          title: 'FOUR',
          body:
              'Full outside off, Suryakumar slices it over backward point for another boundary.',
          accent: AppTheme.primaryDeep,
        ),
        SizedBox(height: 12),
        _CommentaryCard(
          over: '18.3',
          title: '2 RUNS',
          body:
              'Driven firmly into the gap at deep cover. Quick running keeps the pressure on.',
          accent: Color(0xFF2563EB),
        ),
        SizedBox(height: 12),
        _CommentaryCard(
          over: '18.2',
          title: 'SIX',
          body:
              'Short ball punished. Pulled deep into the leg-side stands with complete control.',
          accent: AppTheme.danger,
        ),
      ],
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
    String? action,
  }) {
    return Container(
      decoration: AppTheme.softCardDecoration(),
      padding: const EdgeInsets.all(20),
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
              const Spacer(),
              if (action != null)
                Text(
                  action,
                  style: const TextStyle(
                    color: AppTheme.textSoft,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _teamHeader(
    String short,
    String name,
    String score,
    String overs,
    Color color, {
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (alignEnd)
              Text(
                short,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w800,
                ),
              ),
            if (alignEnd) const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              alignment: Alignment.center,
              child: Text(
                short.substring(0, 1),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            if (!alignEnd) const SizedBox(width: 8),
            if (!alignEnd)
              Text(
                short,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          score,
          style: const TextStyle(
            color: AppTheme.text,
            fontSize: 28,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          overs,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          name,
          textAlign: alignEnd ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            color: AppTheme.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _miniStat(String label, String value, {bool alert = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: alert ? AppTheme.danger : AppTheme.text,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _batterRow(
    String name,
    String runs,
    String balls,
    String strikeRate, {
    bool striker = false,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            children: [
              if (striker)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 9,
                  height: 9,
                  decoration: const BoxDecoration(
                    color: AppTheme.primaryDeep,
                    shape: BoxShape.circle,
                  ),
                ),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: AppTheme.text,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Text(
            runs,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            balls,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSoft),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            strikeRate,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _bowlerRow(
    String name,
    String overs,
    String runs,
    String wickets,
    String eco,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            name,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            overs,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSoft),
          ),
        ),
        Expanded(
          child: Text(
            runs,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textSoft),
          ),
        ),
        Expanded(
          child: Text(
            wickets,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            eco,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }

  Widget _ballPoint({
    required double top,
    required double left,
    required Color color,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildFloatingPlayButton() {
    return Container(
      width: 64,
      height: 64,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppTheme.heroGradient,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(Icons.sports_esports, color: AppTheme.text, size: 30),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 84,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            Icons.home,
            'HOME',
            false,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
          _buildNavItem(
            Icons.search,
            'MATCHES',
            true,
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const MatchesScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 60),
          _buildNavItem(Icons.emoji_events, 'FANTASY', false),
          _buildNavItem(Icons.person, 'PROFILE', false),
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
      onTap: onTap ?? () {},
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
              color: isSelected ? AppTheme.text : AppTheme.textMuted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.name, required this.value});

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppTheme.text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PlayerChip extends StatelessWidget {
  const _PlayerChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceMuted,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        name,
        style: const TextStyle(
          color: AppTheme.text,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({
    required this.rank,
    required this.team,
    required this.points,
  });

  final String rank;
  final String team;
  final String points;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 28,
          child: Text(
            rank,
            style: const TextStyle(
              color: AppTheme.primaryDeep,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        Expanded(
          child: Text(
            team,
            style: const TextStyle(
              color: AppTheme.text,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Text(
          points,
          style: const TextStyle(
            color: AppTheme.text,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _CommentaryCard extends StatelessWidget {
  const _CommentaryCard({
    required this.over,
    required this.title,
    required this.body,
    required this.accent,
  });

  final String over;
  final String title;
  final String body;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppTheme.softCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                over,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: TextStyle(
                  color: accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            body,
            style: const TextStyle(
              color: AppTheme.textSoft,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
