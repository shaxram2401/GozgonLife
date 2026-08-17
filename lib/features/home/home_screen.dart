import 'dart:ui' show ImageFilter;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/saved_products.dart';
import '../../core/l10n/strings.dart';
import '../../core/navigation/scroll_to_top.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/category_tile.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';
import '../ads/ads_screen.dart';
import '../market/market_screen.dart';

// News component brand accents (Variant 4 — Compact Card)
const _newsPrimary = Color(0xFF1E3A8A);
const _newsSecondary = Color(0xFF3B82F6);

const _news = [
  (
    titleKey: 'news_bozor_title',
    date: '06 iyun 2026',
    color: Color(0xFF1E3A8A),
    icon: Icons.store_rounded,
    tagKey: 'tag_city',
    img: 'assets/images/bozor1.png',
    views: '1 256',
  ),
  (
    titleKey: 'news_chp_title',
    date: '21 may 2026',
    color: Color(0xFF1D4ED8),
    icon: Icons.sports_soccer_rounded,
    tagKey: 'tag_sport',
    img: 'assets/images/chp1.jpg',
    views: '2 048',
  ),
  (
    titleKey: 'news_bk_title',
    date: '1 iyun 2026',
    color: Color(0xFFF59E0B),
    icon: Icons.event_rounded,
    tagKey: 'tag_social',
    img: 'assets/images/bk1.jpg',
    views: '894',
  ),
  (
    titleKey: 'news_sq_title',
    date: '26 may 2026',
    color: Color(0xFF065F46),
    icon: Icons.school_rounded,
    tagKey: 'tag_city',
    img: 'assets/images/sq1.jpg',
    views: '1 730',
  ),
];

const _cats = [
  (key: 'c_news', img: 'assets/images/icons/y1.png', route: '/services/news', accent: AppColors.news),
  (key: 'c_appeals', img: 'assets/images/icons/mr1.png', route: '/services/appeals', accent: AppColors.appeals),
  (key: 'c_transport', img: 'assets/images/icons/q1.png', route: '/services/transport', accent: AppColors.transport),
  (key: 'c_bank', img: 'assets/images/icons/b1.png', route: '/services/bank', accent: AppColors.bank),
  (key: 'c_ads', img: 'assets/images/icons/e1.png', route: '/services/ads', accent: AppColors.ads),
  (key: 'c_prayer', img: 'assets/images/icons/n1.png', route: '/services/prayer', accent: AppColors.prayer),
  (key: 'c_map', img: 'assets/images/icons/x1.png', route: '/services/map', accent: AppColors.map),
  (key: 'c_mahalla', img: 'assets/images/icons/m1.png', route: '/services/mahalla', accent: AppColors.mahalla),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _newsIdx = 0;
  bool _loading = true;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    TabScrollTop.register('/home', _scrollCtrl);
    final show = shouldShowSkeleton('home');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  void dispose() {
    TabScrollTop.unregister('/home', _scrollCtrl);
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: _HomeSkeleton());
    return PremiumScaffold(
      title: "G'ozg'on Life",
      floatingButton: false,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: const Color(0xFF1E3A8A),
        child: CustomScrollView(
          controller: _scrollCtrl,
          slivers: [
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
                  child: _Header(title: tr(context, 'categories')),
                ),
                const SizedBox(height: 16),
                const _CatGrid(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(
                      title: tr(context, 'd_ads'),
                      // Ko'rinishi aniq sariq — light'da to'qroq amber.
                      accent: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFFFBBF24)
                          : const Color(0xFFD97706),
                      onMore: () => context.push('/services/ads')),
                ),
                const SizedBox(height: 12),
                const _AdsSlider(),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(
                      title: tr(context, 'nav_market'),
                      accent: AppColors.market,
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

/// Yumaloq frosted-glass ikonka tugmasi.
class _GlassIconBtn extends StatelessWidget {
  final IconData icon;
  final bool badge;
  final VoidCallback onTap;
  const _GlassIconBtn(
      {required this.icon, required this.onTap, this.badge = false});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: dark
                  ? Colors.white.withValues(alpha: 0.10)
                  : Colors.white.withValues(alpha: 0.55),
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: dark ? 0.14 : 0.65)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? 0.25 : 0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, color: AppTheme.tp(context), size: 22),
                if (badge)
                  Positioned(
                    top: 11,
                    right: 11,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
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

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final topPad = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPad + 14, 16, 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(context, 'home_greeting_title'),
                  style: tt.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppTheme.tp(context),
                    fontSize: AppFontSize.h1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tr(context, 'home_greeting_sub'),
                  style: tt.bodyMedium?.copyWith(color: AppTheme.ts(context)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _GlassIconBtn(
              icon: Icons.notifications_outlined,
              badge: true,
              onTap: () => context.push('/notifications')),
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
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.30),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
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
            // Glass ramka — nozik ichki yorug' chiziq
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.20)),
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
                        style: TextStyle(color: Color(0xFFFBBF24), fontSize: AppFontSize.bodySmall, fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '21 may, chorshanba',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: AppFontSize.caption),
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
                              fontSize: 56,
                              fontWeight: FontWeight.w200,
                              letterSpacing: -2,
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
                                  style: const TextStyle(color: Colors.white, fontSize: AppFontSize.caption, fontWeight: FontWeight.w500),
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

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;

  /// Taxtacha + "Barchasi" rangi. null → standart ko'k.
  final Color? accent;

  const _Header({required this.title, this.onMore, this.accent});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final a = accent ?? AppTheme.secondary;
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: accent == null
                  ? const [AppTheme.secondary, AppTheme.primary]
                  : [a, Color.lerp(a, Colors.black, 0.25)!],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSize.h2,
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
                color: a.withValues(alpha: dark ? 0.18 : 0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Barchasi',
                    style: TextStyle(
                        color: a,
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 3),
                  Icon(Icons.arrow_forward_rounded, size: 14, color: a),
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
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _news.length,
          options: CarouselOptions(
            height: 100,
            viewportFraction: 0.92,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 15),
            autoPlayCurve: Curves.easeInOut,
            enlargeCenterPage: false,
            onPageChanged: (i, _) => onChanged(i),
          ),
          itemBuilder: (_, i, _) => _NewsCard(item: _news[i]),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_news.length, (i) {
            final active = i == idx;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 450),
              curve: Curves.elasticOut,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? (dark ? _newsSecondary : _newsPrimary)
                    : AppTheme.divider,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final ({String titleKey, String date, Color color, IconData icon, String tagKey, String img, String views}) item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => context.push('/services/news', extra: item.titleKey),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.30 : 0.07),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: dark
                    ? Colors.white.withValues(alpha: 0.10)
                    : Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: Colors.white.withValues(alpha: dark ? 0.14 : 0.65)),
              ),
              child: Row(
                children: [
                  // Thumbnail — 84×84, r20, edge-to-edge crop
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: item.img.startsWith('assets/')
                        ? Image.asset(item.img,
                            width: 84,
                            height: 84,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high)
                        : Image.network(
                            item.img,
                            width: 84,
                            height: 84,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              width: 84,
                              height: 84,
                              color: item.color,
                              child: Icon(item.icon,
                                  size: 36,
                                  color: Colors.white.withValues(alpha: 0.3)),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge — floating pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2.5),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [_newsPrimary, Color(0xFF2B4CAD)]),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            tr(context, item.tagKey),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.tiny,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tr(context, item.titleKey),
                          style: TextStyle(
                              color: AppTheme.tp(context),
                              fontSize: AppFontSize.caption,
                              fontWeight: FontWeight.w700,
                              height: 1.25,
                              letterSpacing: -0.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_rounded,
                                size: 10, color: AppTheme.ts(context)),
                            const SizedBox(width: 3),
                            Text(item.date,
                                style: TextStyle(
                                    color: AppTheme.ts(context),
                                    fontSize: AppFontSize.tiny)),
                            const SizedBox(width: 8),
                            Icon(Icons.visibility_outlined,
                                size: 11, color: AppTheme.ts(context)),
                            const SizedBox(width: 3),
                            Text(item.views,
                                style: TextStyle(
                                    color: AppTheme.ts(context),
                                    fontSize: AppFontSize.tiny)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Circular glass action button
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [_newsPrimary, Color(0xFF2B4CAD)],
                      ),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white, size: 17),
                  ),
                  const SizedBox(width: 4),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CatGrid extends StatelessWidget {
  const _CatGrid();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.30 : 0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 13, sigmaY: 13),
            child: Container(
              decoration: BoxDecoration(
                // Ko'k marmar — yumshoq diagonal gradient.
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: dark
                      ? [
                          const Color(0xFF1E3A5F).withValues(alpha: 0.55),
                          const Color(0xFF14294A).withValues(alpha: 0.40),
                          const Color(0xFF1E3A5F).withValues(alpha: 0.50),
                        ]
                      : [
                          const Color(0xFFBFDBFE).withValues(alpha: 0.70),
                          const Color(0xFFEFF6FF).withValues(alpha: 0.85),
                          const Color(0xFFCBDDFB).withValues(alpha: 0.75),
                        ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: Colors.white
                        .withValues(alpha: dark ? 0.14 : 0.55)),
              ),
              child: Stack(
                children: [
                  // Marmar tomirlari
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: CustomPaint(painter: _MarbleVeins(dark)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 18, 14, 14),
                    child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _cats.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.80,
                ),
                      itemBuilder: (_, i) {
                        final c = _cats[i];
                        return CategoryTile(
                          index: i,
                          img: c.img,
                          label: tr(context, c.key),
                          accent: c.accent,
                          badge: c.key == 'c_news',
                          iconFactor: 0.74,
                          onTap: () => context.push(c.route),
                        );
                      },
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
}

/// Ko'k marmar tomirlari — yumshoq, deyarli sezilmas egri chiziqlar.
class _MarbleVeins extends CustomPainter {
  final bool dark;
  const _MarbleVeins(this.dark);

  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()..style = PaintingStyle.stroke;

    // Oq tomir (keng, yumshoq) yoki to'q ko'k tomir (ingichka, aniqroq).
    void vein(Path path, double w, double a,
        {bool blue = false, double blur = 7}) {
      p
        ..strokeWidth = w
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur)
        // Dark'da oq tomirlar ancha xira — matn bilan raqobat qilmasin.
        ..color = blue
            ? const Color(0xFF3B82F6)
                .withValues(alpha: dark ? a * 0.6 : a)
            : (dark
                ? const Color(0xFF93B4E8).withValues(alpha: a * 0.14)
                : Colors.white.withValues(alpha: a));
      canvas.drawPath(path, p);
    }

    // Keng yumshoq oq tomirlar — asosiy marmar oqimi (kuchaytirilgan)
    vein(
        Path()
          ..moveTo(-10, s.height * 0.25)
          ..cubicTo(s.width * 0.30, s.height * 0.05, s.width * 0.50,
              s.height * 0.50, s.width * 1.05, s.height * 0.30),
        34,
        1.0);
    vein(
        Path()
          ..moveTo(-10, s.height * 0.70)
          ..cubicTo(s.width * 0.25, s.height * 0.95, s.width * 0.60,
              s.height * 0.55, s.width * 1.05, s.height * 0.80),
        28,
        0.90);
    vein(
        Path()
          ..moveTo(s.width * 0.15, -10)
          ..cubicTo(s.width * 0.35, s.height * 0.40, s.width * 0.10,
              s.height * 0.70, s.width * 0.40, s.height * 1.05),
        24,
        0.80);
    vein(
        Path()
          ..moveTo(s.width * 0.65, -10)
          ..cubicTo(s.width * 0.85, s.height * 0.25, s.width * 0.60,
              s.height * 0.65, s.width * 0.92, s.height * 1.05),
        20,
        0.70);
    // Ingichka aniq oq tomirlar — marmar "yorig'i" effekti (qalinroq, yorqin)
    vein(
        Path()
          ..moveTo(-10, s.height * 0.28)
          ..cubicTo(s.width * 0.32, s.height * 0.08, s.width * 0.48,
              s.height * 0.52, s.width * 1.05, s.height * 0.33),
        4,
        1.0,
        blur: 0.8);
    vein(
        Path()
          ..moveTo(s.width * 0.18, -10)
          ..cubicTo(s.width * 0.38, s.height * 0.42, s.width * 0.12,
              s.height * 0.72, s.width * 0.42, s.height * 1.05),
        3.2,
        1.0,
        blur: 0.7);
    vein(
        Path()
          ..moveTo(-10, s.height * 0.66)
          ..cubicTo(s.width * 0.28, s.height * 0.92, s.width * 0.58,
              s.height * 0.52, s.width * 1.05, s.height * 0.77),
        2.8,
        0.95,
        blur: 0.7);
    vein(
        Path()
          ..moveTo(s.width * 0.68, -10)
          ..cubicTo(s.width * 0.88, s.height * 0.28, s.width * 0.62,
              s.height * 0.62, s.width * 0.95, s.height * 1.05),
        2.6,
        0.90,
        blur: 0.7);
    // Shox yoriqlar — asosiy yoriqdan ajralib chiqadigan mayda tomirchalar
    vein(
        Path()
          ..moveTo(s.width * 0.45, s.height * 0.30)
          ..cubicTo(s.width * 0.55, s.height * 0.18, s.width * 0.68,
              s.height * 0.22, s.width * 0.80, s.height * 0.10),
        1.8,
        0.85,
        blur: 0.6);
    vein(
        Path()
          ..moveTo(s.width * 0.30, s.height * 0.55)
          ..cubicTo(s.width * 0.42, s.height * 0.62, s.width * 0.50,
              s.height * 0.78, s.width * 0.66, s.height * 0.86),
        1.6,
        0.80,
        blur: 0.6);
    vein(
        Path()
          ..moveTo(s.width * 0.10, s.height * 0.42)
          ..cubicTo(s.width * 0.06, s.height * 0.55, s.width * 0.16,
              s.height * 0.68, s.width * 0.08, s.height * 0.85),
        1.5,
        0.75,
        blur: 0.6);
    vein(
        Path()
          ..moveTo(s.width * 0.82, s.height * 0.45)
          ..cubicTo(s.width * 0.90, s.height * 0.55, s.width * 0.82,
              s.height * 0.68, s.width * 0.92, s.height * 0.80),
        1.5,
        0.75,
        blur: 0.6);
    // Ko'k tomirlar — chuqurlik va kontrast (kuchaytirilgan)
    vein(
        Path()
          ..moveTo(s.width * 0.55, -10)
          ..cubicTo(s.width * 0.70, s.height * 0.30, s.width * 0.50,
              s.height * 0.60, s.width * 0.78, s.height * 1.05),
        7,
        0.65,
        blue: true,
        blur: 2.2);
    vein(
        Path()
          ..moveTo(-10, s.height * 0.50)
          ..cubicTo(s.width * 0.20, s.height * 0.35, s.width * 0.55,
              s.height * 0.75, s.width * 1.05, s.height * 0.58),
        5.5,
        0.55,
        blue: true,
        blur: 1.8);
    vein(
        Path()
          ..moveTo(s.width * 0.85, -10)
          ..cubicTo(s.width * 0.95, s.height * 0.35, s.width * 0.70,
              s.height * 0.65, s.width * 0.95, s.height * 1.05),
        4.5,
        0.50,
        blue: true,
        blur: 1.8);
    vein(
        Path()
          ..moveTo(s.width * 0.05, -10)
          ..cubicTo(s.width * 0.02, s.height * 0.30, s.width * 0.18,
              s.height * 0.55, s.width * 0.06, s.height * 1.05),
        4,
        0.45,
        blue: true,
        blur: 1.8);
    // To'q ko'k ingichka kontrast chiziqlar — toshning "chuqur yoriqlari"
    p
      ..strokeWidth = 1.4
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5)
      ..color = const Color(0xFF1E3A8A).withValues(alpha: dark ? 0.50 : 0.35);
    canvas.drawPath(
        Path()
          ..moveTo(-10, s.height * 0.30)
          ..cubicTo(s.width * 0.33, s.height * 0.10, s.width * 0.47,
              s.height * 0.54, s.width * 1.05, s.height * 0.35),
        p);
    canvas.drawPath(
        Path()
          ..moveTo(s.width * 0.20, -10)
          ..cubicTo(s.width * 0.40, s.height * 0.44, s.width * 0.14,
              s.height * 0.74, s.width * 0.44, s.height * 1.05),
        p);
  }

  @override
  bool shouldRepaint(covariant _MarbleVeins old) => old.dark != dark;
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
        height: 180,
        viewportFraction: 0.92,
        autoPlay: ads.length > 1,
        autoPlayInterval: const Duration(seconds: 6),
        autoPlayCurve: Curves.easeInOut,
        enlargeCenterPage: false,
      ),
      itemBuilder: (_, i, _) {
        final ad = ads[i];
        return GestureDetector(
          onTap: () => context.push('/services/ads/detail', extra: ad),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              // Sariq kontur
              border: Border.all(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.75),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.14),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
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
                          Colors.black.withValues(alpha: 0.82)
                        ],
                        stops: const [0.30, 1.0],
                      ),
                    ),
                  ),
                  // Sarlavha + CTA
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            ad.t(context),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: AppFontSize.title,
                                fontWeight: FontWeight.w700,
                                height: 1.3),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Batafsil',
                                  style: TextStyle(
                                      color: Color(0xFF1E3A8A),
                                      fontSize: AppFontSize.caption,
                                      fontWeight: FontWeight.w800)),
                              SizedBox(width: 3),
                              Icon(Icons.arrow_forward_rounded,
                                  size: 13, color: Color(0xFF1E3A8A)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  @override
  void initState() {
    super.initState();
    _items = [
      for (final t in _wanted) ...kProducts.where((p) => p.title == t).take(1),
    ];
    SavedProducts.ensureLoaded();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();
    // Yon tomonlarda 16px bo'sh joy (karta ichki paddingi 5 + 11).
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11),
      child: CarouselSlider.builder(
      itemCount: _items.length,
      options: CarouselOptions(
        height: 158,
        // Aniq 1/3 — ekranda 3 ta to'liq karta, qirralar ko'rinmaydi.
        viewportFraction: 1 / 3,
        padEnds: false,
        enlargeCenterPage: false,
        // Har 15 soniyada bitta karta silliq o'ngdan chapga suriladi.
        autoPlay: _items.length > 3,
        autoPlayInterval: const Duration(seconds: 15),
        autoPlayAnimationDuration: const Duration(milliseconds: 650),
        autoPlayCurve: Curves.easeInOutCubic,
      ),
      itemBuilder: (_, i, _) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: _buildCard(context, _items[i]),
      ),
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
          borderRadius: BorderRadius.circular(20),
          // Qizil kontur
          border: Border.all(
            color: (dark ? const Color(0xFFF87171) : const Color(0xFFB91C1C))
                .withValues(alpha: dark ? 0.55 : 0.45),
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.26 : 0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image — 4 tomondan oq ramka
            Padding(
              padding: const EdgeInsets.all(6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 82,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      p.image != null
                          ? Container(
                              color: imgBg,
                              child:
                                  Image.asset(p.image!, fit: BoxFit.contain),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    c,
                                    Color.lerp(c, Colors.black, 0.30)!
                                  ],
                                ),
                              ),
                              child: Icon(p.icon,
                                  size: 40,
                                  color:
                                      Colors.white.withValues(alpha: 0.85)),
                            ),
                      // Wishlist tugmasi — bosilsa saqlanadi/o'chadi
                      Positioned(
                        right: 5,
                        top: 5,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => SavedProducts.toggle(p.title),
                          child: ValueListenableBuilder<Set<String>>(
                            valueListenable: SavedProducts.titles,
                            builder: (_, saved, _) {
                              final on = saved.contains(p.title);
                              return Container(
                                width: 21,
                                height: 21,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.90),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withValues(alpha: 0.10),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  on
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 11.5,
                                  color: on
                                      ? const Color(0xFFEF4444)
                                      : const Color(0xFF1E3A8A),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(9, 0, 9, 9),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2 qatorga fiksatsiya — barcha kartochka teng
                  SizedBox(
                    height: 28,
                    child: Text(
                      p.t(context),
                      style: TextStyle(
                          fontSize: AppFontSize.caption,
                          fontWeight: FontWeight.w600,
                          height: 1.22,
                          letterSpacing: -0.1,
                          color: AppTheme.tp(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(p.p(context),
                      style: TextStyle(
                          fontSize: AppFontSize.bodySmall,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: dark
                              ? const Color(0xFFF87171)
                              : const Color(0xFFB91C1C)),
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
