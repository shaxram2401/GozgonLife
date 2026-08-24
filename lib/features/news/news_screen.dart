import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/pressable_card.dart';
import '../../core/widgets/skeleton.dart';

const _cats = ['Barchasi', 'Shahar', 'Sport', 'Hokimiyat', 'Tadbir', 'Mahalliy'];

Color _color(String cat) => switch (cat) {
      'Shahar' => const Color(0xFF10B981),
      'Sport' => const Color(0xFF3B82F6),
      'Hokimiyat' => const Color(0xFF6366F1),
      'Tadbir' => const Color(0xFFF59E0B),
      'Mahalliy' => const Color(0xFF8B5CF6),
      _ => AppTheme.primary,
    };

IconData _icon(String cat) => switch (cat) {
      'Shahar' => Icons.location_city_rounded,
      'Sport' => Icons.sports_soccer_rounded,
      'Hokimiyat' => Icons.account_balance_rounded,
      'Tadbir' => Icons.event_rounded,
      'Mahalliy' => Icons.people_rounded,
      _ => Icons.article_rounded,
    };

class _News {
  final String title, date, cat;
  final int views;
  final String? img;
  final String? body;
  final List<String> imgs;
  const _News(this.title, this.date, this.cat, this.views, {this.img, this.body, this.imgs = const []});
}

const _items = [
  _News(
    'news_bozor_title',
    '06 iyun 2026',
    'Hokimiyat',
    1540,
    img: 'assets/images/bozor1.png',
    body: 'news_bozor_body',
    imgs: ['assets/images/bozor1.png', 'assets/images/bozor2.jpg', 'assets/images/bozor3.jpg', 'assets/images/bozor4.jpg'],
  ),
  _News(
    'news_h_title',
    '16 may 2026',
    'Shahar',
    340,
    img: 'assets/images/h1.jpg',
    body: 'news_h_body',
    imgs: ['assets/images/h1.jpg', 'assets/images/h2.jpg', 'assets/images/h3.jpg', 'assets/images/h4.jpg', 'assets/images/h5.jpg'],
  ),
  _News(
    'news_ib_title',
    '15 may 2026',
    'Tadbir',
    380,
    img: 'assets/images/ib1.jpg',
    body: 'news_ib_body',
    imgs: ['assets/images/ib1.jpg', 'assets/images/ib2.jpg', 'assets/images/ib3.jpg', 'assets/images/ib4.jpg', 'assets/images/ib5.jpg'],
  ),
  _News(
    'news_sy_title',
    '19 may 2026',
    'Hokimiyat',
    430,
    img: 'assets/images/sy1.jpg',
    body: 'news_sy_body',
    imgs: ['assets/images/sy1.jpg', 'assets/images/sy2.jpg', 'assets/images/sy3.jpg', 'assets/images/sy4.jpg', 'assets/images/sy5.jpg'],
  ),
  _News(
    'news_bl_title',
    '20 may 2026',
    'Shahar',
    490,
    img: 'assets/images/bl1.jpg',
    body: 'news_bl_body',
    imgs: ['assets/images/bl1.jpg', 'assets/images/bl2.jpg', 'assets/images/bl3.jpg', 'assets/images/bl4.jpg', 'assets/images/bl5.jpg'],
  ),
  _News(
    'news_ysh_title',
    '21 iyun 2026',
    'Hokimiyat',
    580,
    img: 'assets/images/ysh1.jpg',
    body: 'news_ysh_body',
    imgs: ['assets/images/ysh1.jpg', 'assets/images/ysh2.jpg', 'assets/images/ysh3.jpg', 'assets/images/ysh4.jpg'],
  ),
  _News(
    'news_chp_title',
    '21 may 2026',
    'Sport',
    1100,
    img: 'assets/images/chp1.jpg',
    body: 'news_chp_body',
    imgs: ['assets/images/chp1.jpg', 'assets/images/chp2.jpg', 'assets/images/chp3.jpg', 'assets/images/chp4.jpg', 'assets/images/chp5.jpg'],
  ),
  _News(
    'news_qrb_title',
    '26 may 2026',
    'Hokimiyat',
    650,
    img: 'assets/images/qrb1.jpg',
    body: 'news_qrb_body',
    imgs: ['assets/images/qrb1.jpg', 'assets/images/qrb2.jpg', 'assets/images/qrb3.jpg', 'assets/images/qrb4.jpg'],
  ),
  _News(
    'news_bk_title',
    '1 iyun 2026',
    'Tadbir',
    720,
    img: 'assets/images/bk1.jpg',
    body: 'news_bk_body',
    imgs: ['assets/images/bk1.jpg', 'assets/images/bk2.jpg', 'assets/images/bk3.jpg', 'assets/images/bk4.jpg'],
  ),
  _News(
    'news_sq_title',
    '26 may 2026',
    'Shahar',
    890,
    img: 'assets/images/sq1.jpg',
    body: 'news_sq_body',
    imgs: ['assets/images/sq1.jpg', 'assets/images/sq2.jpg', 'assets/images/sq3.jpg', 'assets/images/sq4.jpg'],
  ),
];

class NewsScreen extends StatefulWidget {
  final String? openKey;
  const NewsScreen({super.key, this.openKey});
  @override
  State<NewsScreen> createState() => _State();
}

class _State extends State<NewsScreen> {
  String _cat = 'Barchasi';
  bool _loading = true;
  bool _showIntro = false;

  List<_News> get _list =>
      _cat == 'Barchasi' ? _items : _items.where((n) => n.cat == _cat).toList();

  @override
  void initState() {
    super.initState();
    // Intro banner faqat ilova bo'yicha ENG BIRINCHI marta (umumiy kirishda)
    // ko'rsatiladi; aniq maqolaga (openKey) o'tilganda ko'rsatilmaydi.
    _maybeShowIntro();
    final show = shouldShowSkeleton('news');
    _loading = show;
    void afterReady() {
      if (!mounted) return;
      if (show) setState(() => _loading = false);
      if (widget.openKey != null) {
        final item = _items.where((n) => n.title == widget.openKey).firstOrNull;
        if (item != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _openDetail(context, item);
          });
        }
      }
    }
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), afterReady);
    } else {
      afterReady();
    }
  }

  Future<void> _maybeShowIntro() async {
    if (widget.openKey != null) return;
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('news_intro_seen') ?? false;
    if (seen || !mounted) return;
    setState(() => _showIntro = true);
    await prefs.setBool('news_intro_seen', true);
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  void _openDetail(BuildContext context, _News item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.92,
        maxChildSize: 0.97,
        minChildSize: 0.5,
        expand: false,
        builder: (_, ctrl) => _DetailSheet(item: item, scrollController: ctrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _list;
    final scaffold = PremiumScaffold(
      title: tr(context, 'news'),
      accent: AppColors.news,
      showBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(active: _cat, onTap: (c) => setState(() {
            _cat = c;
            _loading = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              if (mounted) setState(() => _loading = false);
            });
          })),
          if (_loading)
            const Expanded(child: _SkeletonList())
          else if (list.isEmpty)
            Expanded(child: Center(child: Text(tr(context, 'Yangiliklar topilmadi'))))
          else
            Expanded(
              child: RefreshIndicator(
              onRefresh: _refresh,
              color: const Color(0xFF1E3A8A),
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: list.length,
                itemBuilder: (_, i) => i == 0
                    ? PressableCard(
                        onTap: () => _openDetail(context, list[0]),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        child: _FeaturedCard(item: list[0]),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: PressableCard(
                          onTap: () => _openDetail(context, list[i]),
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: _ListTile(item: list[i]),
                        ),
                      ),
              ),
              ),
            ),
        ],
      ),
    );
    if (!_showIntro) return scaffold;
    return Stack(
      children: [
        scaffold,
        Positioned.fill(
          child: _NewsIntro(
            onDismiss: () => setState(() => _showIntro = false),
          ),
        ),
      ],
    );
  }
}

/// Yangiliklar bo'limiga kirganda bir marta chiqadigan intro overlay.
/// Fon xiralashadi, markazda banner; istalgan joyga bosilsa yo'qoladi.
class _NewsIntro extends StatefulWidget {
  final VoidCallback onDismiss;
  const _NewsIntro({required this.onDismiss});

  @override
  State<_NewsIntro> createState() => _NewsIntroState();
}

class _NewsIntroState extends State<_NewsIntro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 340))
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _close() {
    _c.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = Curves.easeOut.transform(_c.value.clamp(0.0, 1.0));
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _close,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Xira fon
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16 * t, sigmaY: 16 * t),
                child: Container(
                    color: Colors.black.withValues(alpha: 0.5 * t)),
              ),
              // Markazdagi banner
              Center(
                child: Opacity(
                  opacity: t,
                  child: Transform.scale(
                    scale: 0.9 + 0.1 * t,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: 0.45),
                                blurRadius: 30,
                                offset: const Offset(0, 14)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset(
                            'assets/images/yangiliklar.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // "Bosing" maslahati
              Positioned(
                left: 0,
                right: 0,
                bottom: 54,
                child: Opacity(
                  opacity: t,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app_rounded,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 7),
                          Text(
                            tr(context, 'news_intro_hint'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    final base = Colors.grey[300]!;
    final highlight = Colors.grey[100]!;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Featured card skeleton
          Container(
            height: 220,
            decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(20)),
          ),
          const SizedBox(height: 12),
          // List tile skeletons
          for (int i = 0; i < 4; i++) ...[
            Container(
              height: 90,
              decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(16)),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTap;
  const _FilterRow({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _cats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = _cats[i];
            final sel = c == active;
            return GestureDetector(
              onTap: () => onTap(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primary : AppTheme.card(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? AppTheme.primary : AppTheme.dv(context)),
                ),
                child: Text(
                  tr(context, c),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? Colors.white : AppTheme.ts(context),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class _FeaturedCard extends StatelessWidget {
  final _News item;
  const _FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _color(item.cat);
    final icon = _icon(item.cat);
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          if (item.img != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(item.img!, fit: BoxFit.cover, filterQuality: FilterQuality.high),
              ),
            ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: item.img != null
                      ? [Colors.transparent, Colors.black.withValues(alpha: 0.75)]
                      : [Colors.transparent, Colors.transparent],
                ),
              ),
            ),
          ),
          if (item.img == null)
            Positioned(
              right: -20,
              top: -20,
              child: Icon(icon, size: 160, color: Colors.white.withValues(alpha: 0.1)),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Badge(cat: item.cat, light: true),
                const Spacer(),
                Text(
                  tr(context, item.title),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(item.date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove_red_eye_outlined, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${item.views}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final _News item;
  const _ListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final icon = _icon(item.cat);
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: item.img != null
                ? Image.asset(item.img!, width: 90, height: 90, fit: BoxFit.cover, filterQuality: FilterQuality.high)
                : Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                ),
              ),
              child: Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 36),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Badge(cat: item.cat, light: false),
                  const SizedBox(height: 6),
                  Text(
                    tr(context, item.title),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 11, color: AppTheme.ts(context)),
                      const SizedBox(width: 4),
                      Text(item.date, style: TextStyle(fontSize: 12, color: AppTheme.ts(context))),
                      const Spacer(),
                      Icon(Icons.remove_red_eye_outlined, size: 11, color: AppTheme.ts(context)),
                      const SizedBox(width: 4),
                      Text('${item.views}', style: TextStyle(fontSize: 12, color: AppTheme.ts(context))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String cat;
  final bool light;
  const _Badge({required this.cat, required this.light});

  @override
  Widget build(BuildContext context) {
    final color = _color(cat);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: 0.25) : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tr(context, cat),
        style: TextStyle(
          color: light ? Colors.white : color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.45),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      );
}

class _DetailCatBadge extends StatelessWidget {
  final String cat;
  const _DetailCatBadge({required this.cat});

  @override
  Widget build(BuildContext context) {
    final color = _color(cat);
    final icon = _icon(cat);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            tr(context, cat),
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailSheet extends StatefulWidget {
  final _News item;
  final ScrollController scrollController;
  const _DetailSheet({required this.item, required this.scrollController});

  @override
  State<_DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<_DetailSheet> {
  late final PageController _pc;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pc = PageController();
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Column(
      children: [
        Container(
          width: 36, height: 4,
          margin: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
        ),
        Expanded(
          child: ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            children: [
              if (item.imgs.isNotEmpty) ...[
                SizedBox(
                  height: 220,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: PageView.builder(
                          controller: _pc,
                          itemCount: item.imgs.length,
                          onPageChanged: (i) => setState(() => _page = i),
                          itemBuilder: (_, i) => Image.asset(item.imgs[i], fit: BoxFit.cover, filterQuality: FilterQuality.high),
                        ),
                      ),
                      if (_page > 0)
                        Positioned(
                          left: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _NavBtn(
                              icon: Icons.chevron_left_rounded,
                              onTap: () => _pc.previousPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              ),
                            ),
                          ),
                        ),
                      if (_page < item.imgs.length - 1)
                        Positioned(
                          right: 8,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: _NavBtn(
                              icon: Icons.chevron_right_rounded,
                              onTap: () => _pc.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(item.imgs.length, (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _page == i ? 22 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _page == i ? Colors.white : Colors.white.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
              ] else if (item.img != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(item.img!, width: double.infinity, height: 220, fit: BoxFit.cover, filterQuality: FilterQuality.high),
                ),
              const SizedBox(height: 20),
              _DetailCatBadge(cat: item.cat),
              const SizedBox(height: 12),
              Text(
                tr(context, item.title),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, height: 1.3),
              ),
              const SizedBox(height: 10),
              Row(children: [
                Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(item.date, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(width: 16),
                Icon(Icons.remove_red_eye_outlined, size: 13, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text('${item.views}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ]),
              const SizedBox(height: 16),
              if (item.body != null)
                Text(
                  tr(context, item.body!),
                  style: const TextStyle(fontSize: 15, height: 1.7),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
