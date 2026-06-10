import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _loading = true;

  static const _services = [
    (key: 'c_news', icon: Icons.newspaper_rounded, route: '/services/news', c1: Color(0xFF1E3A8A), c2: Color(0xFF3B82F6)),
    (key: 'c_appeals', icon: Icons.support_agent_rounded, route: '/services/appeals', c1: Color(0xFF0F6E56), c2: Color(0xFF1D9E75)),
    (key: 'c_transport', icon: Icons.directions_bus_rounded, route: '/services/transport', c1: Color(0xFF854F0B), c2: Color(0xFFEF9F27)),
    (key: 'c_bank_short', icon: Icons.account_balance_rounded, route: '/services/bank', c1: Color(0xFF0C447C), c2: Color(0xFF378ADD)),
    (key: 'c_ads', icon: Icons.campaign_rounded, route: '/services/ads', c1: Color(0xFFA32D2D), c2: Color(0xFFE24B4A)),
    (key: 'c_prayer', icon: Icons.mosque, route: '/services/prayer', c1: Color(0xFF534AB7), c2: Color(0xFF7F77DD)),
    (key: 'c_map', icon: Icons.map_rounded, route: '/services/map', c1: Color(0xFF006064), c2: Color(0xFF4DD0E1)),
    (key: 'c_mahalla', icon: Icons.location_city_rounded, route: '/services/mahalla', c1: Color(0xFF3B6D11), c2: Color(0xFF97C459)),
    (key: 'c_tourism', icon: Icons.landscape_rounded, route: '/services/tourism', c1: Color(0xFF7C2D12), c2: Color(0xFFEA580C)),
  ];

  @override
  void initState() {
    super.initState();
    final show = shouldShowSkeleton('services');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const PremiumScaffold(
        title: 'Xizmatlar',
        useDrawer: true,
        body: _ServicesSkeleton(),
      );
    }
    return PremiumScaffold(
      title: tr(context, 'nav_services'),
      useDrawer: true,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 16,
            childAspectRatio: 0.82,
          ),
          itemBuilder: (_, i) {
            final s = _services[i];
            return _ServiceTile(labelKey: s.key, icon: s.icon, route: s.route, c1: s.c1, c2: s.c2);
          },
        ),
      ),
    );
  }
}

class _ServiceTile extends StatefulWidget {
  final String labelKey;
  final IconData icon;
  final String route;
  final Color c1;
  final Color c2;

  const _ServiceTile({
    required this.labelKey,
    required this.icon,
    required this.route,
    required this.c1,
    required this.c2,
  });

  @override
  State<_ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<_ServiceTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push(widget.route),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [widget.c1, widget.c2],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.c2.withValues(alpha: dark ? 0.45 : 0.34),
                      blurRadius: 14,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: FractionallySizedBox(
                          heightFactor: 0.5,
                          widthFactor: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.22),
                                  Colors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Icon(widget.icon, color: Colors.white, size: 36),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              tr(context, widget.labelKey),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                color: dark ? Colors.white70 : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesSkeleton extends StatelessWidget {
  const _ServicesSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9,
            ),
            itemBuilder: (_, __) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [skBox(h: 48, r: 12), const SizedBox(height: 8), skBox(h: 10, w: 60)],
            ),
          ),
        ),
      );
}
