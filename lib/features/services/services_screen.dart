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
    (key: 'c_news', img: 'assets/images/icons/11.png', route: '/services/news', c1: Color(0xFF1E3A8A), c2: Color(0xFF3B82F6)),
    (key: 'c_appeals', img: 'assets/images/icons/22.png', route: '/services/appeals', c1: Color(0xFF0F6E56), c2: Color(0xFF1D9E75)),
    (key: 'c_transport', img: 'assets/images/icons/33.png', route: '/services/transport', c1: Color(0xFF854F0B), c2: Color(0xFFEF9F27)),
    (key: 'c_bank_short', img: 'assets/images/icons/44.png', route: '/services/bank', c1: Color(0xFF0C447C), c2: Color(0xFF378ADD)),
    (key: 'c_ads', img: 'assets/images/icons/55.png', route: '/services/ads', c1: Color(0xFFA32D2D), c2: Color(0xFFE24B4A)),
    (key: 'c_prayer', img: 'assets/images/icons/66.png', route: '/services/prayer', c1: Color(0xFF534AB7), c2: Color(0xFF7F77DD)),
    (key: 'c_map', img: 'assets/images/icons/77.png', route: '/services/map', c1: Color(0xFF006064), c2: Color(0xFF4DD0E1)),
    (key: 'c_mahalla', img: 'assets/images/icons/88.png', route: '/services/mahalla', c1: Color(0xFF3B6D11), c2: Color(0xFF97C459)),
    (key: 'c_tourism', img: 'assets/images/icons/99.png', route: '/services/tourism', c1: Color(0xFF7C2D12), c2: Color(0xFFEA580C)),
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
            return _ServiceTile(labelKey: s.key, img: s.img, route: s.route, c1: s.c1, c2: s.c2);
          },
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String labelKey;
  final String img;
  final String route;
  final Color? c1;
  final Color? c2;

  const _ServiceTile({required this.labelKey, required this.img, required this.route, this.c1, this.c2});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.35 : 0.14),
                    blurRadius: 13,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(img,
                    fit: BoxFit.fill,
                    cacheWidth: 240,
                    cacheHeight: 240),
              ),
            ),
          ),
          const SizedBox(height: 9),
          Text(
            tr(context, labelKey),
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
