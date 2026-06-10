import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/widgets/category_tile.dart';
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
    (key: 'c_news', img: 'assets/images/icons/1111.png', route: '/services/news', accent: Color(0xFF2563EB)),
    (key: 'c_appeals', img: 'assets/images/icons/2222.png', route: '/services/appeals', accent: Color(0xFF7C3AED)),
    (key: 'c_transport', img: 'assets/images/icons/3333.png', route: '/services/transport', accent: Color(0xFFDC2626)),
    (key: 'c_bank_short', img: 'assets/images/icons/4444.png', route: '/services/bank', accent: Color(0xFF16A34A)),
    (key: 'c_ads', img: 'assets/images/icons/5555.png', route: '/services/ads', accent: Color(0xFFF97316)),
    (key: 'c_prayer', img: 'assets/images/icons/6666.png', route: '/services/prayer', accent: Color(0xFF0D9488)),
    (key: 'c_map', img: 'assets/images/icons/7777.png', route: '/services/map', accent: Color(0xFF64748B)),
    (key: 'c_mahalla', img: 'assets/images/icons/8888.png', route: '/services/mahalla', accent: Color(0xFF0EA5E9)),
    (key: 'c_tourism', img: 'assets/images/icons/9999.png', route: '/services/tourism', accent: Color(0xFFEA580C)),
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
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PremiumScaffold(
      title: tr(context, 'nav_services'),
      useDrawer: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.30 : 0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
                decoration: BoxDecoration(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                      color: Colors.white
                          .withValues(alpha: dark ? 0.14 : 0.55)),
                ),
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _services.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 18,
                    childAspectRatio: 0.82,
                  ),
                  itemBuilder: (_, i) {
                    final s = _services[i];
                    return CategoryTile(
                      index: i,
                      img: s.img,
                      label: tr(context, s.key),
                      accent: s.accent,
                      iconFactor: 0.76,
                      onTap: () => context.push(s.route),
                    );
                  },
                ),
              ),
            ),
          ),
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
