import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/l10n/strings.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skeleton.dart';
import '../ads/ads_screen.dart';
import '../market/market_screen.dart';

const _news = [
  (
    titleKey: 'news_bozor_title',
    date: '06 iyun 2026',
    color: Color(0xFF1E3A8A),
    icon: Icons.store_rounded,
    tagKey: 'tag_city',
    img: 'assets/images/bozor1.png',
  ),
  (
    titleKey: 'news_chp_title',
    date: '21 may 2026',
    color: Color(0xFF1D4ED8),
    icon: Icons.sports_soccer_rounded,
    tagKey: 'tag_sport',
    img: 'assets/images/chp1.jpg',
  ),
  (
    titleKey: 'news_bk_title',
    date: '1 iyun 2026',
    color: Color(0xFFF59E0B),
    icon: Icons.event_rounded,
    tagKey: 'tag_social',
    img: 'assets/images/bk1.jpg',
  ),
  (
    titleKey: 'news_sq_title',
    date: '26 may 2026',
    color: Color(0xFF065F46),
    icon: Icons.school_rounded,
    tagKey: 'tag_city',
    img: 'assets/images/sq1.jpg',
  ),
];

const _cats = [
  (key: 'c_news', img: 'assets/images/icons/11.png', route: '/services/news', c1: Color(0xFF1E3A8A), c2: Color(0xFF3B82F6)),
  (key: 'c_appeals', img: 'assets/images/icons/22.png', route: '/services/appeals', c1: Color(0xFF0F6E56), c2: Color(0xFF1D9E75)),
  (key: 'c_transport', img: 'assets/images/icons/33.png', route: '/services/transport', c1: Color(0xFF854F0B), c2: Color(0xFFEF9F27)),
  (key: 'c_bank', img: 'assets/images/icons/44.png', route: '/services/bank', c1: Color(0xFF0C447C), c2: Color(0xFF378ADD)),
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
    final show = shouldShowSkeleton('home');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: _HomeSkeleton());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: const Color(0xFF1E3A8A),
        child: CustomScrollView(
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
                const SizedBox(height: 16),
                const _CatGrid(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(
                      title: tr(context, 'd_ads'),
                      onMore: () => context.push('/services/ads')),
                ),
                const SizedBox(height: 12),
                const _AdsSlider(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(
                      title: tr(context, 'nav_market'),
                      onMore: () => context.go('/market')),
                ),
                const SizedBox(height: 12),
                const _MarketSlider(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
        ),
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
            Positioned.fill(
              child: Image.asset(
                'assets/images/weat.png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Color(0xFFFBBF24), size: 13),
                      const SizedBox(width: 4),
                      const Text(
                        "G'ozg'on, Navoiy",
                        style: TextStyle(color: Color(0xFFFBBF24), fontSize: 13, fontWeight: FontWeight.w700),
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
                              fontSize: 48,
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
                      const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 52),
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
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.secondary, AppTheme.primary],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
            color: AppTheme.tp(context),
          ),
        ),
        const Spacer(),
        if (onMore != null)
          GestureDetector(
            onTap: onMore,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.secondary
                    .withValues(alpha: dark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Barchasi',
                    style: TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_forward_rounded,
                      size: 14, color: AppTheme.secondary),
                ],
              ),
            ),
          ),
      ],
    );
  }
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
            item.img.startsWith('assets/')
                ? Image.asset(item.img, fit: BoxFit.cover, filterQuality: FilterQuality.high)
                : Image.network(
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
              right: 10,
              bottom: 10,
              child: GestureDetector(
                onTap: () => context.push('/services/news', extra: item.titleKey),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 52,
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
        child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _cats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 12,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (_, i) => _CatTile(cat: _cats[i]),
        ),
      );
}

class _CatTile extends StatefulWidget {
  final ({String key, String img, String route, Color c1, Color c2}) cat;
  const _CatTile({required this.cat});
  @override
  State<_CatTile> createState() => _CatTileState();
}

class _CatTileState extends State<_CatTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push(widget.cat.route),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: dark ? 0.35 : 0.14),
                      blurRadius: 13,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    widget.cat.img,
                    fit: BoxFit.fill,
                    cacheWidth: 220,
                    cacheHeight: 220,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              tr(context, widget.cat.key),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                height: 1.15,
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

// ── Ads slider (3 rotating) ──────────────────────────────────
class _AdsSlider extends StatelessWidget {
  const _AdsSlider();

  @override
  Widget build(BuildContext context) {
    final ads = kAds.take(3).toList();
    if (ads.isEmpty) return const SizedBox.shrink();
    return CarouselSlider.builder(
      itemCount: ads.length,
      options: CarouselOptions(
        height: 170,
        viewportFraction: 0.82,
        autoPlay: ads.length > 1,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: true,
        enlargeFactor: 0.14,
      ),
      itemBuilder: (_, i, realIdx) {
        final ad = ads[i];
        return GestureDetector(
          onTap: () => context.push('/services/ads/detail', extra: ad),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ad.image != null
                    ? Image.asset(ad.image!, fit: BoxFit.cover)
                    : Container(color: const Color(0xFFF59E0B)),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.78)
                      ],
                      stops: const [0.4, 1.0],
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Text(
                    ad.t(context),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Market slider (10 ta, 3 ko'rinadi, strelka bilan aylanadi) ──
class _MarketSlider extends StatefulWidget {
  const _MarketSlider();

  @override
  State<_MarketSlider> createState() => _MarketSliderState();
}

class _MarketSliderState extends State<_MarketSlider> {
  static const _wanted = [
    'iPhone 13 sotiladi',
    'Samsung xolodilnik sotiladi',
    'Spark sotiladi',
    'Nexia 2 sotiladi',
    'LG kir yuvish mashinasi sotiladi',
    'Asus noutbuk sotiladi',
    'Samsung A16 sotiladi',
    'Poco F3 sotiladi',
    'Smart Watch sotiladi',
    'AirPods Air sotiladi',
  ];

  late final List<Product> _items;
  late final PageController _ctrl;
  late final int _initialPage;

  @override
  void initState() {
    super.initState();
    _items = [
      for (final t in _wanted) ...kProducts.where((p) => p.title == t).take(1),
    ];
    // Markazda boshlash — qo'l bilan ikki tomonga cheksiz aylanadi.
    _initialPage = _items.isEmpty ? 0 : _items.length * 1000;
    // 1/3 dan biroz kichik — 3 ta asosiy karta + yon tomonlarda keyingi
    // mahsulotlarning qirralari ko'rinib turadi.
    _ctrl = PageController(viewportFraction: 0.30, initialPage: _initialPage);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    final n = _items.length;
    return SizedBox(
      height: 178,
      child: PageView.builder(
        controller: _ctrl,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          final p = _items[((index % n) + n) % n];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: _buildCard(context, p),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, Product p) {
    final c = productColor(p.category);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final imgBg = dark ? const Color(0xFF0F172A) : const Color(0xFFF1F3F6);
    return GestureDetector(
      onTap: () => context.push('/market/detail', extra: p),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.32)
                : AppTheme.primary.withValues(alpha: 0.40),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.3 : 0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image — 4 tomondan oq ramka
            Padding(
              padding: const EdgeInsets.all(7),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: SizedBox(
                  height: 92,
                  width: double.infinity,
                  child: p.image != null
                      ? Container(
                          color: imgBg,
                          child: Image.asset(p.image!, fit: BoxFit.contain),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [c, Color.lerp(c, Colors.black, 0.30)!],
                            ),
                          ),
                          child: Icon(p.icon,
                              size: 40,
                              color: Colors.white.withValues(alpha: 0.85)),
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2 qatorga fiksatsiya — barcha kartochka teng
                  SizedBox(
                    height: 32,
                    child: Text(
                      p.t(context),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                          color: AppTheme.tp(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(p.p(context),
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: dark
                              ? const Color(0xFF93C5FD)
                              : const Color(0xFF1E3A8A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
