import 'package:flutter/material.dart';
import 'localization/localization.dart';

class DetectedGarbageItem {
  final String id;
  final String name;
  final String category;
  final String suggestedBin;
  final double quantityKg;
  final IconData icon;
  final Color accent;

  const DetectedGarbageItem({
    required this.id,
    required this.name,
    required this.category,
    required this.suggestedBin,
    required this.quantityKg,
    required this.icon,
    required this.accent,
  });
}

class NearbyBuyer {
  final String id;
  final String name;
  final String type;
  final String address;
  final double distanceKm;
  final double rating;
  final bool pickupAvailable;
  final bool openNow;
  final List<String> acceptedCategories;
  final String priceHint;
  final String eta;
  final String phone;
  final Color accent;

  const NearbyBuyer({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.distanceKm,
    required this.rating,
    required this.pickupAvailable,
    required this.openNow,
    required this.acceptedCategories,
    required this.priceHint,
    required this.eta,
    required this.phone,
    required this.accent,
  });
}

class SoldActivity {
  final String id;
  final String itemName;
  final String category;
  final double weightKg;
  final double amount;
  final String buyerName;
  final String dateText;
  final String status;
  final IconData icon;
  final Color accent;

  const SoldActivity({
    required this.id,
    required this.itemName,
    required this.category,
    required this.weightKg,
    required this.amount,
    required this.buyerName,
    required this.dateText,
    required this.status,
    required this.icon,
    required this.accent,
  });
}

class ActivityScreen extends StatefulWidget {
  final AppLocalization loc;

  const ActivityScreen({super.key, required this.loc});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedFilter = 0;

  final List<String> _filters = const [
    'All',
    'Plastic',
    'Paper',
    'Metal',
    'Glass',
    'E-waste',
  ];

  final List<DetectedGarbageItem> _detectedItems = const [
    DetectedGarbageItem(
      id: '1',
      name: 'Plastic Bottle',
      category: 'Plastic',
      suggestedBin: 'Blue bin',
      quantityKg: 1.8,
      icon: Icons.local_drink_outlined,
      accent: Color(0xFF49D7B0),
    ),
    DetectedGarbageItem(
      id: '2',
      name: 'Cardboard',
      category: 'Paper',
      suggestedBin: 'Dry waste',
      quantityKg: 4.2,
      icon: Icons.inventory_2_outlined,
      accent: Color(0xFFD5A25C),
    ),
    DetectedGarbageItem(
      id: '3',
      name: 'Metal Scrap',
      category: 'Metal',
      suggestedBin: 'Scrap pickup',
      quantityKg: 3.1,
      icon: Icons.settings_input_component_outlined,
      accent: Color(0xFF9BB3C9),
    ),
    DetectedGarbageItem(
      id: '4',
      name: 'Battery',
      category: 'E-waste',
      suggestedBin: 'E-waste point',
      quantityKg: 0.6,
      icon: Icons.battery_3_bar_outlined,
      accent: Color(0xFFE78888),
    ),
  ];

  final List<SoldActivity> _soldActivities = const [
    SoldActivity(
      id: '1',
      itemName: 'Plastic Bottles',
      category: 'Plastic',
      weightKg: 2.4,
      amount: 38,
      buyerName: 'GreenLoop Recycler',
      dateText: 'Today • 11:20 AM',
      status: 'Completed',
      icon: Icons.local_drink_outlined,
      accent: Color(0xFF49D7B0),
    ),
    SoldActivity(
      id: '2',
      itemName: 'Old Newspapers',
      category: 'Paper',
      weightKg: 5.8,
      amount: 64,
      buyerName: 'Kabadi Point',
      dateText: 'Yesterday • 4:45 PM',
      status: 'Completed',
      icon: Icons.article_outlined,
      accent: Color(0xFFD5A25C),
    ),
    SoldActivity(
      id: '3',
      itemName: 'Iron Scrap',
      category: 'Metal',
      weightKg: 3.6,
      amount: 96,
      buyerName: 'EcoMetal Works',
      dateText: '12 Apr • 1:10 PM',
      status: 'Completed',
      icon: Icons.hardware_outlined,
      accent: Color(0xFF9BB3C9),
    ),
    SoldActivity(
      id: '4',
      itemName: 'Used Battery Pack',
      category: 'E-waste',
      weightKg: 0.8,
      amount: 22,
      buyerName: 'SafeCell E-Waste',
      dateText: '10 Apr • 5:00 PM',
      status: 'Safe drop-off',
      icon: Icons.battery_alert_outlined,
      accent: Color(0xFFE78888),
    ),
  ];

  final List<NearbyBuyer> _buyers = const [
    NearbyBuyer(
      id: '1',
      name: 'GreenLoop Recycler',
      type: 'Verified recycler',
      address: 'GT Road, Phagwara',
      distanceKm: 1.2,
      rating: 4.7,
      pickupAvailable: true,
      openNow: true,
      acceptedCategories: ['Plastic', 'Paper', 'Glass'],
      priceHint: 'Plastic up to ₹16/kg',
      eta: '8 min away',
      phone: '+91 98765 11001',
      accent: Color(0xFF49D7B0),
    ),
    NearbyBuyer(
      id: '2',
      name: 'Kabadi Point',
      type: 'Local scrap buyer',
      address: 'Model Town, Phagwara',
      distanceKm: 2.4,
      rating: 4.4,
      pickupAvailable: true,
      openNow: true,
      acceptedCategories: ['Paper', 'Metal', 'Plastic'],
      priceHint: 'Paper up to ₹12/kg',
      eta: '11 min away',
      phone: '+91 98765 11002',
      accent: Color(0xFF7AE5C0),
    ),
    NearbyBuyer(
      id: '3',
      name: 'EcoMetal Works',
      type: 'Metal collection',
      address: 'Industrial Area, Phagwara',
      distanceKm: 4.8,
      rating: 4.6,
      pickupAvailable: false,
      openNow: true,
      acceptedCategories: ['Metal'],
      priceHint: 'Metal up to ₹28/kg',
      eta: '15 min away',
      phone: '+91 98765 11003',
      accent: Color(0xFF9BB3C9),
    ),
    NearbyBuyer(
      id: '4',
      name: 'SafeCell E-Waste',
      type: 'E-waste drop point',
      address: 'Jalandhar Road, Phagwara',
      distanceKm: 5.1,
      rating: 4.8,
      pickupAvailable: false,
      openNow: false,
      acceptedCategories: ['E-waste', 'Battery'],
      priceHint: 'Battery safe disposal',
      eta: '18 min away',
      phone: '+91 98765 11004',
      accent: Color(0xFFE78888),
    ),
  ];

  List<NearbyBuyer> get _filteredBuyers {
    final selected = _filters[_selectedFilter];
    if (selected == 'All') return _buyers;
    return _buyers.where((b) {
      return b.acceptedCategories.any(
            (c) => c.toLowerCase().contains(selected.toLowerCase()),
      );
    }).toList();
  }

  List<SoldActivity> get _filteredActivities {
    final selected = _filters[_selectedFilter];
    if (selected == 'All') return _soldActivities;
    return _soldActivities
        .where((a) => a.category.toLowerCase() == selected.toLowerCase())
        .toList();
  }

  double get _totalWeight {
    return _soldActivities.fold(0, (sum, item) => sum + item.weightKg);
  }

  double get _totalIncome {
    return _soldActivities.fold(0, (sum, item) => sum + item.amount);
  }

  int get _totalOrders => _soldActivities.length;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isCompact = width < 360;
    final horizontal = isCompact ? 12.0 : 16.0;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF041119),
            Color(0xFF061821),
            Color(0xFF020910),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 10, horizontal, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ResponsiveHeader(),
                    const SizedBox(height: 18),
                    _buildHeroCard(context),
                    const SizedBox(height: 22),
                    const Text(
                      'Your activities',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Sold items history and earnings overview.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.68),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(horizontal, 12, horizontal, 0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final selected = _selectedFilter == index;
                    return InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () => setState(() => _selectedFilter = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          gradient: selected
                              ? const LinearGradient(
                            colors: [Color(0xFF39D98A), Color(0xFF13B6AA)],
                          )
                              : null,
                          color: selected ? null : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: selected
                                ? Colors.transparent
                                : Colors.white.withOpacity(0.08),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            _filters[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected ? Colors.black : Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 14, horizontal, 0),
              sliver: SliverList.separated(
                itemCount: _filteredActivities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _SoldActivityCard(activity: _filteredActivities[index]);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 10),
                child: const Text(
                  'Detected items',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 176,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: horizontal),
                  scrollDirection: Axis.horizontal,
                  itemCount: _detectedItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return _DetectedItemCard(item: _detectedItems[index]);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(horizontal, 24, horizontal, 0),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 6,
                  children: [
                    const Text(
                      'Nearby buyers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '${_filteredBuyers.length} found',
                      style: const TextStyle(
                        color: Color(0xFF39D98A),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(horizontal, 14, horizontal, 120),
              sliver: SliverList.separated(
                itemCount: _filteredBuyers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  return _NearbyBuyerCard(buyer: _filteredBuyers[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 370;
        final tileWidth =
        isNarrow ? constraints.maxWidth : (constraints.maxWidth - 10) / 2;

        return Container(
          padding: EdgeInsets.all(isNarrow ? 12 : 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A1E22),
                const Color(0xFF0D2E2D).withOpacity(0.95),
                const Color(0xFF07151D),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF7AE5C0).withOpacity(0.24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: tileWidth,
                    child: _MetricTile(
                      title: 'Total sold',
                      value: '${_totalWeight.toStringAsFixed(1)} kg',
                      icon: Icons.scale_outlined,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _MetricTile(
                      title: 'Total income',
                      value: '₹${_totalIncome.toStringAsFixed(0)}',
                      icon: Icons.currency_rupee_rounded,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _MetricTile(
                      title: 'Orders',
                      value: '$_totalOrders',
                      icon: Icons.receipt_long_outlined,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: const _MetricTile(
                      title: 'Top category',
                      value: 'Metal',
                      icon: Icons.trending_up_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.07),
                  ),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 1),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        color: Color(0xFF7AE5C0),
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Great job! Your recent sales are reducing landfill waste and generating extra side income.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ResponsiveHeader extends StatelessWidget {
  const _ResponsiveHeader();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF39D98A), Color(0xFF13B6AA)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF39D98A).withOpacity(0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Icon(
                Icons.storefront_outlined,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity Hub',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isCompact ? 22 : 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Your sold garbage, earnings and nearby buyers.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SoldActivityCard extends StatelessWidget {
  final SoldActivity activity;

  const _SoldActivityCard({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF06121A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 340;

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: activity.accent.withOpacity(0.16),
                          ),
                          child: Icon(activity.icon, color: activity.accent),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            activity.itemName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _StatusChip(
                      text: activity.status,
                      color: const Color(0xFF49D7B0),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${activity.category} • ${activity.weightKg.toStringAsFixed(1)} kg',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: activity.accent.withOpacity(0.16),
                    ),
                    child: Icon(activity.icon, color: activity.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.itemName,
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
                          '${activity.category} • ${activity.weightKg.toStringAsFixed(1)} kg',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(
                    text: activity.status,
                    color: const Color(0xFF49D7B0),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final tileWidth = w < 380 ? w : (w - 20) / 3;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Earned',
                      value: '₹${activity.amount.toStringAsFixed(0)}',
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Buyer',
                      value: activity.buyerName,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Date',
                      value: activity.dateText,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetectedItemCard extends StatelessWidget {
  final DetectedGarbageItem item;

  const _DetectedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF07131C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.accent.withOpacity(0.16),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: item.accent),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.quantityKg.toStringAsFixed(1)} kg • ${item.category}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              item.suggestedBin,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: item.accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NearbyBuyerCard extends StatelessWidget {
  final NearbyBuyer buyer;

  const _NearbyBuyerCard({required this.buyer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF06121A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 345;

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: buyer.accent.withOpacity(0.16),
                          ),
                          child: Icon(
                            Icons.recycling_outlined,
                            color: buyer.accent,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            buyer.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _StatusChip(
                      text: buyer.openNow ? 'Open' : 'Closed',
                      color: buyer.openNow
                          ? const Color(0xFF49D7B0)
                          : const Color(0xFFE78888),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${buyer.type} • ${buyer.distanceKm.toStringAsFixed(1)} km',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: buyer.accent.withOpacity(0.16),
                    ),
                    child: Icon(
                      Icons.recycling_outlined,
                      color: buyer.accent,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buyer.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${buyer.type} • ${buyer.distanceKm.toStringAsFixed(1)} km',
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
                  const SizedBox(width: 8),
                  _StatusChip(
                    text: buyer.openNow ? 'Open' : 'Closed',
                    color: buyer.openNow
                        ? const Color(0xFF49D7B0)
                        : const Color(0xFFE78888),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 330;

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white54,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            buyer.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      buyer.eta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: buyer.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 1),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: Colors.white54,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      buyer.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      buyer.eta,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: buyer.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: buyer.acceptedCategories
                .map(
                  (e) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  e,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
                .toList(),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final tileWidth = constraints.maxWidth < 380
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 20) / 3;

              return Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Price hint',
                      value: buyer.priceHint,
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Pickup',
                      value: buyer.pickupAvailable ? 'Available' : 'Drop-off only',
                    ),
                  ),
                  SizedBox(
                    width: tileWidth,
                    child: _QuickInfoTile(
                      label: 'Rating',
                      value: '${buyer.rating} ★',
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStack = constraints.maxWidth < 355;

              if (isStack) {
                return Column(
                  children: [
                    _ActionBtn(
                      title: 'Call',
                      icon: Icons.call_outlined,
                      filled: false,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      title: 'Navigate',
                      icon: Icons.navigation_outlined,
                      filled: false,
                      fullWidth: true,
                    ),
                    const SizedBox(height: 10),
                    _ActionBtn(
                      title: buyer.pickupAvailable ? 'Book pickup' : 'Sell now',
                      icon: Icons.bolt_rounded,
                      filled: true,
                      fullWidth: true,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _ActionBtn(
                      title: 'Call',
                      icon: Icons.call_outlined,
                      filled: false,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionBtn(
                      title: 'Navigate',
                      icon: Icons.navigation_outlined,
                      filled: false,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ActionBtn(
                      title: buyer.pickupAvailable ? 'Book pickup' : 'Sell now',
                      icon: Icons.bolt_rounded,
                      filled: true,
                      fullWidth: true,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF7AE5C0), size: 18),
          const SizedBox(height: 10),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _QuickInfoTile({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusChip({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 108),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.14),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool filled;
  final bool fullWidth;

  const _ActionBtn({
    required this.title,
    required this.icon,
    required this.filled,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: fullWidth ? double.infinity : null,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        gradient: filled
            ? const LinearGradient(
          colors: [Color(0xFF39D98A), Color(0xFF13B6AA)],
        )
            : null,
        color: filled ? null : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: filled ? Colors.transparent : Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: filled ? Colors.black : Colors.white,
          ),
          const SizedBox(width: 7),
          Flexible(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: filled ? Colors.black : Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (fullWidth) return child;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 92),
      child: child,
    );
  }
}