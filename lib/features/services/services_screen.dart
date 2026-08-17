import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
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
    (key: 'c_news', img: 'assets/images/icons/y1.png', route: '/services/news', accent: AppColors.news),
    (key: 'c_appeals', img: 'assets/images/icons/mr1.png', route: '/services/appeals', accent: AppColors.appeals),
    (key: 'c_transport', img: 'assets/images/icons/q1.png', route: '/services/transport', accent: AppColors.transport),
    (key: 'c_bank_short', img: 'assets/images/icons/b1.png', route: '/services/bank', accent: AppColors.bank),
    (key: 'c_ads', img: 'assets/images/icons/e1.png', route: '/services/ads', accent: AppColors.ads),
    (key: 'c_prayer', img: 'assets/images/icons/n1.png', route: '/services/prayer', accent: AppColors.prayer),
    (key: 'c_map', img: 'assets/images/icons/x1.png', route: '/services/map', accent: AppColors.map),
    (key: 'c_mahalla', img: 'assets/images/icons/m1.png', route: '/services/mahalla', accent: AppColors.mahalla),
    (key: 'c_tourism', img: 'assets/images/icons/t1.png', route: '/services/tourism', accent: AppColors.tourism),
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
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: _services.length,
        itemBuilder: (_, i) {
          final s = _services[i];
          return _ServiceRow(
            index: i,
            img: s.img,
            label: tr(context, s.key),
            accent: s.accent,
            onTap: () => context.push(s.route),
          );
        },
      ),
    );
  }
}

/// Premium ro'yxat qatori — rasm ikonka + nom + chevron.
class _ServiceRow extends StatefulWidget {
  final int index;
  final String img, label;
  final Color accent;
  final VoidCallback onTap;
  const _ServiceRow({
    required this.index,
    required this.img,
    required this.label,
    required this.accent,
    required this.onTap,
  });

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _in;

  @override
  void initState() {
    super.initState();
    _in = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    Future.delayed(Duration(milliseconds: 40 + widget.index * 55), () {
      if (mounted) _in.forward();
    });
  }

  @override
  void dispose() {
    _in.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedBuilder(
      animation: _in,
      builder: (context, child) {
        final v = _in.value.clamp(0.0, 1.0);
        final t = Curves.easeOut.transform(v);
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset((1 - t) * 18, 0), child: child),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.28 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            splashColor: widget.accent.withValues(alpha: 0.12),
            highlightColor: widget.accent.withValues(alpha: 0.06),
            onTap: () {
              HapticFeedback.lightImpact();
              widget.onTap();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  // Rasm ikonka — rangli glow bilan
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: dark ? 0.30 : 0.10),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Transform.scale(
                        scale: 1.16,
                        child: Image.asset(widget.img, fit: BoxFit.cover, cacheWidth: 200),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AppTheme.tp(context),
                      ),
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.accent.withValues(alpha: dark ? 0.26 : 0.16),
                      shape: BoxShape.circle,
                    ),
                    // O'z rangining to'q toni — dark'da ochroq (kontrast uchun).
                    child: Icon(Icons.chevron_right_rounded,
                        color: dark
                            ? Color.lerp(widget.accent, Colors.white, 0.25)!
                            : Color.lerp(widget.accent, Colors.black, 0.40)!,
                        size: 20),
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

class _ServicesSkeleton extends StatelessWidget {
  const _ServicesSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: 9,
          itemBuilder: (_, _) => Padding(
            padding: const EdgeInsets.only(bottom: 11),
            child: Row(
              children: [
                skBox(h: 54, w: 54, r: 16),
                const SizedBox(width: 15),
                Expanded(child: skBox(h: 14)),
                const SizedBox(width: 12),
                skBox(h: 30, w: 30, r: 15),
              ],
            ),
          ),
        ),
      );
}
