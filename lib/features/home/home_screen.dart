import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/l10n/strings.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skeleton.dart';

const _news = [
  (
    titleKey: 'news1_title',
    date: '21 may 2026',
    color: Color(0xFF1D4ED8),
    icon: Icons.sports_soccer_rounded,
    tagKey: 'tag_sport',
    img: 'https://images.unsplash.com/photo-1643105095873-64c53d2a8fa6?w=800&q=80&fm=jpg',
  ),
  (
    titleKey: 'news2_title',
    date: '20 may 2026',
    color: Color(0xFF065F46),
    icon: Icons.construction_rounded,
    tagKey: 'tag_city',
    img: 'https://images.unsplash.com/photo-1518290581883-8a26c3735cd2?w=800&q=80&fm=jpg',
  ),
  (
    titleKey: 'news3_title',
    date: '19 may 2026',
    color: Color(0xFF7C2D12),
    icon: Icons.people_rounded,
    tagKey: 'tag_social',
    img: 'https://images.unsplash.com/photo-1615373111465-965023eb989c?w=800&q=80&fm=jpg',
  ),
];

const _cats = [
  (key: 'c_news', img: 'assets/images/icons/11.png', route: '/services/news', c1: Color(0xFF1E3A8A), c2: Color(0xFF3B82F6)),
  (key: 'c_appeals', img: 'assets/images/icons/22.png', route: '/services/appeals', c1: Color(0xFF0F6E56), c2: Color(0xFF1D9E75)),
  (key: 'c_transport', img: 'assets/images/icons/33.png', route: '/services/transport', c1: Color(0xFF854F0B), c2: Color(0xFFEF9F27)),
  (key: 'c_bank', img: 'assets/images/icons/444.png', route: '/services/bank', c1: Color(0xFF0C447C), c2: Color(0xFF378ADD)),
  (key: 'c_ads', img: 'assets/images/icons/55.png', route: '/services/ads', c1: Color(0xFFA32D2D), c2: Color(0xFFE24B4A)),
  (key: 'c_prayer', img: 'assets/images/icons/66.png', route: '/services/prayer', c1: Color(0xFF534AB7), c2: Color(0xFF7F77DD)),
  (key: 'c_map', img: 'assets/images/icons/77.png', route: '/services/map', c1: Color(0xFF006064), c2: Color(0xFF4DD0E1)),
  (key: 'c_mahalla', img: 'assets/images/icons/88.png', route: '/services/mahalla', c1: Color(0xFF3B6D11), c2: Color(0xFF97C459)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _newsIdx = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: _HomeSkeleton());
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            centerTitle: true,
            backgroundColor: const Color(0xFF1E3A8A),
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: ScaffoldWithNav.openDrawer,
            ),
            title: const Text(
              "G'ozg'on Life",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Greeting(),
                const _WeatherCard(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(title: tr(context, 'news')),
                ),
                const SizedBox(height: 12),
                _NewsSlider(idx: _newsIdx, onChanged: (i) => setState(() => _newsIdx = i)),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(title: tr(context, 'categories'), onMore: () => context.go('/services')),
                ),
                const SizedBox(height: 12),
                const _CatGrid(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "G'ozg'on Life 👋",
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.tp(context),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tr(context, 'home_greeting_sub'),
            style: tt.bodyMedium?.copyWith(color: AppTheme.ts(context)),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/services/weather'),
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: AppTheme.card(context).withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 80,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.card(context).withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white60, size: 13),
                      const SizedBox(width: 4),
                      Text(
                        tr(context, 'w_location'),
                        style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '21 may, chorshanba',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppTheme.card(context).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.open_in_full_rounded, color: Colors.white70, size: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '+28°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.w200,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.card(context).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  tr(context, 'w_sunny'),
                                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 72),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _WStat(icon: Icons.water_drop_outlined, value: '45%', label: tr(context, 'w_humidity')),
                      const _WDiv(),
                      _WStat(icon: Icons.air_rounded, value: '5 km/h', label: tr(context, 'w_wind')),
                      const _WDiv(),
                      _WStat(icon: Icons.thermostat_rounded, value: '22°', label: tr(context, 'w_night')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

class _WStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: Colors.white60, size: 17),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      );
}

class _WDiv extends StatelessWidget {
  const _WDiv();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.15));
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;

  const _Header({required this.title, this.onMore});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: const Text(
                'Barchasi →',
                style: TextStyle(color: AppTheme.secondary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      );
}

class _NewsSlider extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onChanged;

  const _NewsSlider({required this.idx, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          CarouselSlider.builder(
            itemCount: _news.length,
            options: CarouselOptions(
              height: 196,
              viewportFraction: 0.88,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              enlargeFactor: 0.12,
              onPageChanged: (i, _) => onChanged(i),
            ),
            itemBuilder: (_, i, _) => _NewsCard(item: _news[i]),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_news.length, (i) {
              final active = i == idx;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppTheme.primary : AppTheme.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      );
}

class _NewsCard extends StatelessWidget {
  final ({String titleKey, String date, Color color, IconData icon, String tagKey, String img}) item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.img,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: item.color,
                child: Icon(item.icon, size: 80, color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tr(context, item.tagKey),
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr(context, item.titleKey),
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _CatGrid extends StatelessWidget {
  const _CatGrid();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _CatRow(start: 0),
            const SizedBox(height: 10),
            _CatRow(start: 4),
          ],
        ),
      );
}

class _CatRow extends StatelessWidget {
  final int start;
  const _CatRow({required this.start});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 160,
        child: Row(
          children: [
            for (int i = start; i < start + 4; i++) ...[
              if (i > start) const SizedBox(width: 10),
              Expanded(child: _CatTile(cat: _cats[i])),
            ],
          ],
        ),
      );
}

class _CatTile extends StatelessWidget {
  final ({String key, String img, String route, Color c1, Color c2}) cat;

  const _CatTile({required this.cat});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push(cat.route),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [cat.c1, cat.c2],
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: OverflowBox(
                    maxWidth: 84,
                    maxHeight: 84,
                    child: Image.asset(cat.img, width: 84, height: 84, fit: BoxFit.cover, cacheWidth: 168, cacheHeight: 168),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tr(context, cat.key),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.2),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skBox(h: 20, w: 160),
              const SizedBox(height: 8),
              skBox(h: 14, w: 100),
              const SizedBox(height: 20),
              skBox(h: 180, r: 20),
              const SizedBox(height: 20),
              skBox(h: 14, w: 120),
              const SizedBox(height: 12),
              Row(children: List.generate(4, (_) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(children: [skBox(h: 60, r: 12), const SizedBox(height: 6), skBox(h: 10)]),
                ),
              ))),
              const SizedBox(height: 20),
              skBox(h: 14, w: 120),
              const SizedBox(height: 12),
              skBox(h: 120, r: 16),
            ],
          ),
        ),
      );
}
