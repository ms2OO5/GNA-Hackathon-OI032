import 'package:flutter/material.dart';
import 'localization/localization.dart';
import 'scan_screen.dart';
import 'activity_screen.dart';

class MainShell extends StatefulWidget {
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  const MainShell({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  AppLanguage get _language => widget.language;

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalization(_language);

    final pages = [
      HomeTab(
        loc: loc,
        onChangeLanguage: widget.onLanguageChanged,
        onOpenScan: () => _onTabChanged(1),
        onOpenBinLocator: () => _onTabChanged(3),
        onOpenChallenges: () => _onTabChanged(4),
        onOpenEcoNews: () => _onTabChanged(5),
      ),
      ScanScreen(loc: loc),
      ActivityScreen(loc: loc),
      BinLocatorScreen(loc: loc),
      EcoChallengesScreen(loc: loc),
      EcoNewsScreen(loc: loc),
    ];

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0C3C34),
            Color(0xFF03141D),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: IndexedStack(
            index: _currentIndex,
            children: pages,
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF040E15),
            selectedItemColor: const Color(0xFF39D98A),
            unselectedItemColor: Colors.grey.shade500,
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: _onTabChanged,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.eco_outlined),
                label: loc.t(LocKeys.home),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.qr_code_scanner),
                label: loc.t(LocKeys.scan),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.event_note_outlined),
                label: loc.t(LocKeys.activities),
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                label: 'Bins',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.emoji_events_outlined),
                label: 'Challenges',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME TAB ----------------

class HomeTab extends StatefulWidget {
  final AppLocalization loc;
  final ValueChanged<AppLanguage> onChangeLanguage;
  final VoidCallback onOpenScan;
  final VoidCallback onOpenBinLocator;
  final VoidCallback onOpenChallenges;
  final VoidCallback onOpenEcoNews;

  const HomeTab({
    super.key,
    required this.loc,
    required this.onChangeLanguage,
    required this.onOpenScan,
    required this.onOpenBinLocator,
    required this.onOpenChallenges,
    required this.onOpenEcoNews,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  double _ecoScore = 98;
  double _wasteKg = 10;
  double _co2Kg = 3;
  int _pollutionUnits = 410000;
  int _communityRank = 5;

  final List<_Challenge> _challenges = [
    _Challenge(
      id: 'c1',
      title: 'Plastic Free Day',
      description: 'Avoid single-use plastic for one day.',
    ),
    _Challenge(
      id: 'c2',
      title: 'Bike to Work',
      description: 'Use cycle or walk instead of car.',
    ),
    _Challenge(
      id: 'c3',
      title: 'Recycling Sprint',
      description: 'Recycle 5 items this week.',
    ),
  ];

  AppLocalization get loc => widget.loc;

  void _applyEcoImpact({
    double wasteDelta = 0,
    double co2Delta = 0,
    int pollutionDelta = 0,
    int rankDelta = 0,
  }) {
    setState(() {
      _wasteKg += wasteDelta;
      _co2Kg += co2Delta;
      _pollutionUnits += pollutionDelta;
      _communityRank = (_communityRank + rankDelta).clamp(1, 999).toInt();

      final wasteNorm = (_wasteKg / 50.0).clamp(0.0, 1.0).toDouble();
      final co2Norm = (_co2Kg / 20.0).clamp(0.0, 1.0).toDouble();
      final pollNorm = (_pollutionUnits / 500000.0).clamp(0.0, 1.0).toDouble();
      final rankNorm = 1.0 -
          (((_communityRank - 1).toDouble() / 100.0).clamp(0.0, 1.0)).toDouble();

      final score = (wasteNorm + co2Norm + pollNorm + rankNorm) / 4.0;
      _ecoScore = (score * 100.0).clamp(0.0, 100.0).toDouble();
    });
  }

  void _handleQuickScan() {
    _applyEcoImpact(
      wasteDelta: 0.2,
      co2Delta: 0.05,
      pollutionDelta: 1200,
      rankDelta: -1,
    );
    _showSnack(context, 'Quick Scan recorded! Eco impact updated.');
    widget.onOpenScan();
  }

  void _handleChallengeToggle(_Challenge challenge) {
    setState(() {
      challenge.completed = !challenge.completed;
    });

    if (challenge.completed) {
      _applyEcoImpact(
        wasteDelta: 1.0,
        co2Delta: 0.5,
        pollutionDelta: 5000,
        rankDelta: -2,
      );
      _showSnack(context, 'Challenge completed! Eco impact boosted.');
    } else {
      _applyEcoImpact(
        wasteDelta: -1.0,
        co2Delta: -0.5,
        pollutionDelta: -5000,
        rankDelta: 2,
      );
      _showSnack(context, 'Challenge marked incomplete.');
    }
  }

  void _openDetail(BuildContext context, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SimpleDetailScreen(title: title),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _openLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF050F19),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.t(LocKeys.chooseLanguage),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text(loc.t(LocKeys.english),
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  widget.onChangeLanguage(AppLanguage.en);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text(loc.t(LocKeys.hindi),
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  widget.onChangeLanguage(AppLanguage.hi);
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language, color: Colors.white),
                title: Text(loc.t(LocKeys.punjabi),
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  widget.onChangeLanguage(AppLanguage.pa);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomSafe + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF39D98A), Color(0xFF3CB371)],
                      ),
                    ),
                    child: const Icon(Icons.recycling, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    loc.t(LocKeys.appName),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _openLanguageSheet(context),
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            loc.t(LocKeys.welcomeUser),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          EcoImpactCard(
            loc: loc,
            ecoScore: _ecoScore,
            onTapWaste: () => _showSnack(context, loc.t(LocKeys.wasteDiverted)),
            onTapPollution: () => _showSnack(context, loc.t(LocKeys.pollution)),
            onTapCO2: () => _showSnack(context, loc.t(LocKeys.co2Saved)),
            onTapRank: () => _showSnack(context, loc.t(LocKeys.communityRank)),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  label: loc.t(LocKeys.quickScan),
                  icon: Icons.qr_code_scanner,
                  onTap: _handleQuickScan,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  label: 'Bin Locator',
                  icon: Icons.location_on_outlined,
                  onTap: widget.onOpenBinLocator,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: QuickActionButton(
                  label: 'Challenges',
                  icon: Icons.emoji_events_outlined,
                  onTap: widget.onOpenChallenges,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: QuickActionButton(
                  label: 'Eco News',
                  icon: Icons.article_outlined,
                  onTap: widget.onOpenEcoNews,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            loc.t(LocKeys.featuredChallenges),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _challenges.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final c = _challenges[index];
                return ChallengeCard(
                  challenge: c,
                  onToggle: () => _handleChallengeToggle(c),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Challenge {
  final String id;
  final String title;
  final String description;
  bool completed;

  _Challenge({
    required this.id,
    required this.title,
    required this.description,
    this.completed = false,
  });
}

// ---------------- BIN LOCATOR SCREEN ----------------

class BinLocatorScreen extends StatelessWidget {
  final AppLocalization loc;

  const BinLocatorScreen({super.key, required this.loc});

  @override
  Widget build(BuildContext context) {
    final bins = <_BinInfo>[
      _BinInfo(
        name: 'Blue Bin',
        type: 'Dry Waste',
        distance: '120 m',
        status: '80% full',
        color: const Color(0xFF39D98A),
        icon: Icons.delete_outline,
      ),
      _BinInfo(
        name: 'Green Bin',
        type: 'Wet Waste',
        distance: '240 m',
        status: '35% full',
        color: const Color(0xFF13B6AA),
        icon: Icons.eco_outlined,
      ),
      _BinInfo(
        name: 'Red Bin',
        type: 'E-waste',
        distance: '430 m',
        status: 'Available',
        color: const Color(0xFFE78888),
        icon: Icons.battery_alert_outlined,
      ),
      _BinInfo(
        name: 'Yellow Bin',
        type: 'Paper',
        distance: '620 m',
        status: '60% full',
        color: const Color(0xFFF4A949),
        icon: Icons.description_outlined,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        const Text(
          'Bin Locator',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Find the nearest disposal point and check bin status.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF07151D),
                Color(0xFF0A1E22),
              ],
            ),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                  ),
                ),
              ),
              Positioned(
                left: 22,
                top: 28,
                child: _MapPin(label: 'You', color: const Color(0xFF39D98A)),
              ),
              Positioned(
                right: 42,
                top: 42,
                child: _MapPin(label: 'Blue Bin', color: const Color(0xFF13B6AA)),
              ),
              Positioned(
                left: 64,
                bottom: 32,
                child: _MapPin(label: 'Green Bin', color: const Color(0xFFF4A949)),
              ),
              Positioned(
                right: 58,
                bottom: 22,
                child: _MapPin(label: 'E-waste', color: const Color(0xFFE78888)),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.navigation_outlined, color: Color(0xFF39D98A)),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Nearest bin: Blue Bin • 120 m away',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Nearby bins',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        ...bins.map(
              (b) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _BinCard(bin: b),
          ),
        ),
      ],
    );
  }
}

class _BinInfo {
  final String name;
  final String type;
  final String distance;
  final String status;
  final Color color;
  final IconData icon;

  _BinInfo({
    required this.name,
    required this.type,
    required this.distance,
    required this.status,
    required this.color,
    required this.icon,
  });
}

class _BinCard extends StatelessWidget {
  final _BinInfo bin;

  const _BinCard({required this.bin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF050F19),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bin.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(bin.icon, color: bin.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bin.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${bin.type} • ${bin.distance}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                bin.status,
                style: TextStyle(
                  color: bin.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: bin.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Navigate',
                  style: TextStyle(
                    color: bin.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapPin extends StatelessWidget {
  final String label;
  final Color color;

  const _MapPin({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = const Color(0xFF0B2830);
    final line = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, base);

    for (double x = 20; x < size.width; x += 28) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), line);
    }
    for (double y = 20; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------- CHALLENGES SCREEN ----------------

class EcoChallengesScreen extends StatelessWidget {
  final AppLocalization loc;

  const EcoChallengesScreen({super.key, required this.loc});

  @override
  Widget build(BuildContext context) {
    final challenges = [
      _ChallengeUi(
        title: 'Plastic Free Day',
        subtitle: 'Avoid all single-use plastic today.',
        reward: '+120 Eco Points',
        progress: 0.8,
        color: const Color(0xFF39D98A),
        icon: Icons.no_drinks_outlined,
      ),
      _ChallengeUi(
        title: 'Recycle 5 Items',
        subtitle: 'Scan and recycle five recyclable items.',
        reward: '+90 Eco Points',
        progress: 0.55,
        color: const Color(0xFF13B6AA),
        icon: Icons.recycling_outlined,
      ),
      _ChallengeUi(
        title: 'Bike to Work',
        subtitle: 'Choose cycle or walking for one trip.',
        reward: '+70 Eco Points',
        progress: 0.35,
        color: const Color(0xFFF4A949),
        icon: Icons.pedal_bike_outlined,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        const Text(
          'Challenges',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Complete eco missions and earn rewards.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF050F19),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: Color(0xFF39D98A)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Daily streak: 6 days • Keep going for bonus rewards',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ...challenges.map(
              (c) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ChallengeCardUi(challenge: c),
          ),
        ),
      ],
    );
  }
}

class _ChallengeUi {
  final String title;
  final String subtitle;
  final String reward;
  final double progress;
  final Color color;
  final IconData icon;

  _ChallengeUi({
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.progress,
    required this.color,
    required this.icon,
  });
}

class _ChallengeCardUi extends StatelessWidget {
  final _ChallengeUi challenge;

  const _ChallengeCardUi({required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF050F19),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: challenge.color.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: challenge.color.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(challenge.icon, color: challenge.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      challenge.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: challenge.progress,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.06),
              valueColor: AlwaysStoppedAnimation<Color>(challenge.color),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                challenge.reward,
                style: TextStyle(
                  color: challenge.color,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: challenge.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Start',
                  style: TextStyle(
                    color: challenge.color,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------- ECO NEWS SCREEN ----------------

class EcoNewsScreen extends StatelessWidget {
  final AppLocalization loc;

  const EcoNewsScreen({super.key, required this.loc});

  @override
  Widget build(BuildContext context) {
    final news = [
      _NewsItem(
        title: 'Smart bins reduce overflow in urban areas',
        source: 'Municipal Update',
        time: '2h ago',
        summary:
        'Cities are using connected bin systems and route optimization to improve collection efficiency.',
        color: const Color(0xFF13B6AA),
        icon: Icons.sensors_outlined,
      ),
      _NewsItem(
        title: 'Recycling pickup demand increases this week',
        source: 'Eco Market',
        time: '5h ago',
        summary:
        'Local scrap collection has seen a rise as more users scan and sell recyclable material.',
        color: const Color(0xFF39D98A),
        icon: Icons.local_shipping_outlined,
      ),
      _NewsItem(
        title: 'E-waste safety reminders for households',
        source: 'Safety Brief',
        time: '1d ago',
        summary:
        'Old batteries and devices should be stored safely before handing them to authorized collectors.',
        color: const Color(0xFFE78888),
        icon: Icons.battery_alert_outlined,
      ),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      children: [
        const Text(
          'Eco News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Fresh updates from waste, recycling and sustainability.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.70),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 16),
        ...news.map(
              (n) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _NewsCard(item: n),
          ),
        ),
      ],
    );
  }
}

class _NewsItem {
  final String title;
  final String source;
  final String time;
  final String summary;
  final Color color;
  final IconData icon;

  _NewsItem({
    required this.title,
    required this.source,
    required this.time,
    required this.summary,
    required this.color,
    required this.icon,
  });
}

class _NewsCard extends StatelessWidget {
  final _NewsItem item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF050F19),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(item.icon, color: item.color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.source} • ${item.time}',
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.summary,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.35,
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

class EcoImpactCard extends StatelessWidget {
  final AppLocalization loc;
  final double ecoScore;
  final VoidCallback onTapWaste;
  final VoidCallback onTapPollution;
  final VoidCallback onTapCO2;
  final VoidCallback onTapRank;

  const EcoImpactCard({
    super.key,
    required this.loc,
    required this.ecoScore,
    required this.onTapWaste,
    required this.onTapPollution,
    required this.onTapCO2,
    required this.onTapRank,
  });

  @override
  Widget build(BuildContext context) {
    final scoreText = ecoScore.toStringAsFixed(0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF050F19),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Text(
            loc.t(LocKeys.myEcoImpact),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(140, 140),
                  painter: EcoGaugePainter(score: ecoScore),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$scoreText%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  top: 40,
                  child: GestureDetector(
                    onTap: onTapWaste,
                    child: _sideLabel(
                      icon: Icons.recycling,
                      text: loc.t(LocKeys.wasteDiverted),
                      alignRight: false,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 40,
                  child: GestureDetector(
                    onTap: onTapPollution,
                    child: _sideLabel(
                      icon: Icons.cloud_outlined,
                      text: loc.t(LocKeys.pollution),
                      alignRight: true,
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: onTapCO2,
                    child: _bottomLabel(
                      icon: Icons.co2,
                      text: loc.t(LocKeys.co2Saved),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: onTapRank,
                    child: _bottomLabel(
                      icon: Icons.emoji_events,
                      text: loc.t(LocKeys.communityRank),
                      alignRight: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sideLabel({
    required IconData icon,
    required String text,
    required bool alignRight,
  }) {
    final textWidget = Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Colors.white,
        height: 1.2,
      ),
    );

    return SizedBox(
      width: 90,
      child: Row(
        mainAxisAlignment:
        alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: alignRight
            ? [
          Flexible(child: textWidget),
          const SizedBox(width: 6),
          Icon(icon, size: 18, color: const Color(0xFF39D98A)),
        ]
            : [
          Icon(icon, size: 18, color: const Color(0xFF39D98A)),
          const SizedBox(width: 6),
          Flexible(child: textWidget),
        ],
      ),
    );
  }

  Widget _bottomLabel({
    required IconData icon,
    required String text,
    bool alignRight = false,
  }) {
    return SizedBox(
      width: 110,
      child: Row(
        mainAxisAlignment:
        alignRight ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!alignRight)
            Icon(icon, size: 18, color: const Color(0xFF39D98A)),
          if (!alignRight) const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              textAlign: alignRight ? TextAlign.right : TextAlign.left,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                height: 1.2,
              ),
            ),
          ),
          if (alignRight) const SizedBox(width: 6),
          if (alignRight)
            Icon(icon, size: 18, color: const Color(0xFF39D98A)),
        ],
      ),
    );
  }
}

class EcoGaugePainter extends CustomPainter {
  final double score;

  EcoGaugePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const strokeWidth = 14.0;
    const startAngle = -3.5;
    const sweepTotal = 4.4;

    final bgPaint = Paint()
      ..color = const Color(0xFF0B2830)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepTotal, false, bgPaint);

    final fraction = (score.clamp(0.0, 100.0) / 100.0).toDouble();
    final activeSweep = sweepTotal * fraction;

    final segments = [
      _GaugeSegment(color: const Color(0xFFF4A949), fraction: 0.25),
      _GaugeSegment(color: const Color(0xFF23B3A3), fraction: 0.30),
      _GaugeSegment(color: const Color(0xFF39D98A), fraction: 0.45),
    ];

    const gapFraction = 0.03;
    double used = 0.0;
    double currentAngle = startAngle;

    for (final seg in segments) {
      if (used >= fraction) break;

      final maxSegSweep = sweepTotal * seg.fraction;
      final remainingSweep = activeSweep - (sweepTotal * used);
      final sweep = remainingSweep.clamp(0.0, maxSegSweep).toDouble();

      if (sweep <= 0) {
        currentAngle += maxSegSweep + sweepTotal * gapFraction;
        used += seg.fraction + gapFraction;
        continue;
      }

      final paint = Paint()
        ..color = seg.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, currentAngle, sweep, false, paint);

      currentAngle += maxSegSweep + sweepTotal * gapFraction;
      used += seg.fraction + gapFraction;
    }
  }

  @override
  bool shouldRepaint(covariant EcoGaugePainter oldDelegate) =>
      oldDelegate.score != score;
}

class _GaugeSegment {
  final Color color;
  final double fraction;
  const _GaugeSegment({required this.color, required this.fraction});
}

class QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const QuickActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.35),
            width: 1.2,
          ),
          color: const Color(0xFF050F19),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  final _Challenge challenge;
  final VoidCallback onToggle;

  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final completed = challenge.completed;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onToggle,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF050F19),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: completed
                ? const Color(0xFF39D98A)
                : Colors.white.withOpacity(0.15),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFF243746),
                  child: Icon(
                    completed ? Icons.check : Icons.person_outline,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    challenge.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              challenge.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                  completed ? const Color(0xFF39D98A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: const Color(0xFF39D98A),
                  ),
                ),
                child: Text(
                  completed ? 'Completed' : 'Start',
                  style: TextStyle(
                    fontSize: 11,
                    color: completed ? Colors.black : const Color(0xFF39D98A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleDetailScreen extends StatelessWidget {
  final String title;

  const SimpleDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020910),
      appBar: AppBar(
        backgroundColor: const Color(0xFF020910),
        title: Text(title),
      ),
      body: Center(
        child: Text(
          '$title Screen\n(Implement logic here)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}