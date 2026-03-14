import 'package:cricpluse/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerStatsScreen extends StatefulWidget {
  final Map<String, dynamic> player;

  const PlayerStatsScreen({super.key, required this.player});

  @override
  State<PlayerStatsScreen> createState() => _PlayerStatsScreenState();
}

class _PlayerStatsScreenState extends State<PlayerStatsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;
  final List<int> _recentScores = [45, 12, 88, 104, 32];
  late final List<Map<String, String>> _quickStats;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _quickStats = [
      {'label': 'MATCHES', 'value': '142'},
      {'label': 'RUNS', 'value': widget.player['points'] ?? '4,520'},
      {'label': 'AVERAGE', 'value': '48.5'},
      {'label': 'STRIKE RATE', 'value': '138.2'},
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickStatsGrid(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Performance Form (Last 5)'),
                    const SizedBox(height: 14),
                    _buildFormChart(),
                    const SizedBox(height: 24),
                    _buildCareerSummaryTabs(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.text),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
            color: _isFavorite ? const Color(0xFFF59E0B) : AppTheme.text,
          ),
          onPressed: () {
            setState(() => _isFavorite = !_isFavorite);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _isFavorite ? 'Added to favorites' : 'Removed from favorites',
                ),
                backgroundColor: AppTheme.primaryDeep,
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.pageGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 72, 20, 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primaryDeep, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.22),
                          blurRadius: 20,
                          offset: const Offset(0, 12),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.player['avatar'] ??
                              'https://i.pravatar.cc/150?img=11',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          widget.player['name']?.toUpperCase() ?? 'PLAYER NAME',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppTheme.text,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'PRO',
                          style: TextStyle(
                            color: AppTheme.primaryDeep,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Right-Hand Bat | ${widget.player['tag'] ?? '@player'}',
                    style: const TextStyle(
                      color: AppTheme.textSoft,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: _quickStats.length,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.softCardDecoration(radius: 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _quickStats[index]['label']!,
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _quickStats[index]['value']!,
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: AppTheme.text,
        fontSize: 13,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildFormChart() {
    final maxScore = _recentScores.reduce((curr, next) => curr > next ? curr : next);
    return Container(
      height: 220,
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(_recentScores.length, (index) {
          final score = _recentScores[index];
          final heightFactor = (score / maxScore) * 110;
          var barColor = const Color(0xFF2563EB);
          if (score >= 100) {
            barColor = const Color(0xFFF59E0B);
          } else if (score >= 50) {
            barColor = AppTheme.primaryDeep;
          } else if (score < 20) {
            barColor = AppTheme.danger;
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: const TextStyle(
                  color: AppTheme.text,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 34,
                height: heightFactor,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: barColor.withOpacity(0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'M${index + 1}',
                style: const TextStyle(
                  color: AppTheme.textSoft,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCareerSummaryTabs() {
    return Column(
      children: [
        Container(
          height: 48,
          decoration: AppTheme.softCardDecoration(radius: 24),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.primary,
            ),
            labelColor: AppTheme.text,
            unselectedLabelColor: AppTheme.textSoft,
            labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'T20I'),
              Tab(text: 'ODI'),
              Tab(text: 'TEST'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStatsTabContent(
                hs: '122*',
                hundreds: '1',
                fifties: '37',
                sixes: '117',
              ),
              _buildStatsTabContent(
                hs: '183',
                hundreds: '50',
                fifties: '72',
                sixes: '150',
              ),
              _buildStatsTabContent(
                hs: '254*',
                hundreds: '29',
                fifties: '30',
                sixes: '24',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTabContent({
    required String hs,
    required String hundreds,
    required String fifties,
    required String sixes,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.softCardDecoration(radius: 24),
      child: Column(
        children: [
          _buildDetailedStatRow('Highest Score', hs, isHighlight: true),
          const Divider(color: AppTheme.border, height: 24),
          _buildDetailedStatRow('Centuries (100s)', hundreds),
          const Divider(color: AppTheme.border, height: 24),
          _buildDetailedStatRow('Fifties (50s)', fifties),
          const Divider(color: AppTheme.border, height: 24),
          _buildDetailedStatRow('Total Sixes', sixes),
        ],
      ),
    );
  }

  Widget _buildDetailedStatRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textSoft,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isHighlight ? AppTheme.primaryDeep : AppTheme.text,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
