import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/locale_provider.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../theme/theme_transition.dart';
import 'scroll_to_top.dart';

class ScaffoldWithNav extends StatefulWidget {
  static ScaffoldWithNavState? _state;

  static void openDrawer() => _state?.openDrawer();

  /// Nav shell (va demak drawer) hozir faolmi.
  static bool get hasDrawer => _state != null;

  final Widget child;
  final String location;

  const ScaffoldWithNav({super.key, required this.child, required this.location});

  @override
  State<ScaffoldWithNav> createState() => ScaffoldWithNavState();
}

class ScaffoldWithNavState extends State<ScaffoldWithNav>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  bool _drawerVisible = false;

  void openDrawer() {
    setState(() => _drawerVisible = true);
    _ctrl.forward();
  }

  void _close() {
    _ctrl.reverse().then((_) {
      if (mounted) setState(() => _drawerVisible = false);
    });
  }

  // Material 3 vektor ikonkalar — rasm/avatar ASSETLAR ishlatilmaydi.
  static const _tabs = [
    (key: 'nav_home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded, path: '/home'),
    (key: 'nav_services', icon: Icons.grid_view_outlined, activeIcon: Icons.grid_view_rounded, path: '/services'),
    (key: 'nav_zukkobek', icon: Icons.auto_awesome_outlined, activeIcon: Icons.auto_awesome, path: '/zukkobek'),
    (key: 'nav_market', icon: Icons.storefront_outlined, activeIcon: Icons.storefront_rounded, path: '/market'),
    (key: 'nav_profile', icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, path: '/profile'),
  ];

  /// Tab bosilganda: o'sha tabda turgan bo'lsak — ro'yxatni eng yuqoriga
  /// suramiz; aks holda o'sha bo'limga o'tamiz.
  void _onTab(String path) {
    final current = widget.location.split('?').first;
    if (current == path) {
      TabScrollTop.scrollToTop(path);
    } else {
      context.go(path);
    }
  }

  int get _selectedIndex {
    final location = widget.location;
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/zukkobek')) return 2;
    if (location.startsWith('/market')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    ScaffoldWithNav._state = this;
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );
    _slide = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic, reverseCurve: Curves.easeInCubic));
    _fade = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    if (ScaffoldWithNav._state == this) ScaffoldWithNav._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Yengil ko'kimtir premium gradient fon (marble o'rniga).
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppTheme.bgGradient(
                    Theme.of(context).brightness == Brightness.dark),
              ),
            ),
          ),
          widget.child,
          // Skeleton overlay drawer'dan PASTDA — mavzu almashganda asosiy
          // kontentni qoplaydi, lekin ochiq drawer ustida toza qoladi.
          const Positioned.fill(child: ThemeTransition()),
          if (_drawerVisible) ...[
            FadeTransition(
              opacity: _fade.drive(Tween(begin: 0.0, end: 0.45)),
              child: GestureDetector(
                onTap: _close,
                child: Container(color: Colors.black),
              ),
            ),
            SlideTransition(
              position: _slide,
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onHorizontalDragUpdate: (d) {
                    _ctrl.value += d.primaryDelta! / 300;
                  },
                  onHorizontalDragEnd: (d) {
                    if (_ctrl.value < 0.5 ||
                        (d.primaryVelocity ?? 0) < -300) {
                      _close();
                    } else {
                      _ctrl.forward();
                    }
                  },
                  child: _Drawer(onClose: _close, location: widget.location),
                ),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: _premiumNav(context),
    );
  }

  Widget _premiumNav(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final sel = _selectedIndex;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: 96,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Navigatsiya paneli (88dp) ──
            Positioned(
              left: 12,
              right: 12,
              bottom: 6,
              height: 88,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    // Glow (shadow o'rniga) — premium suzuvchi effekt.
                    BoxShadow(
                      color: (dark ? AppTheme.secondary : AppTheme.primary)
                          .withValues(alpha: dark ? 0.30 : 0.16),
                      blurRadius: 32,
                      spreadRadius: dark ? 1 : 0,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                    child: Container(
                      decoration: BoxDecoration(
                        color: dark
                            ? const Color(0xD90F172A)
                            : Colors.white.withValues(alpha: 0.72),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: dark
                              ? Colors.white.withValues(alpha: 0.08)
                              : Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                      child: Row(
                        children: [
                    _NavBarItem(
                        icon: _tabs[0].icon,
                        activeIcon: _tabs[0].activeIcon,
                        label: tr(context, _tabs[0].key),
                        active: sel == 0,
                        dark: dark,
                        onTap: () => _onTab(_tabs[0].path)),
                    _NavBarItem(
                        icon: _tabs[1].icon,
                        activeIcon: _tabs[1].activeIcon,
                        label: tr(context, _tabs[1].key),
                        active: sel == 1,
                        dark: dark,
                        onTap: () => _onTab(_tabs[1].path)),
                    // Markaziy slot — yorliq pastda, avatar tepada suzadi.
                    _NavBarItem.center(
                        label: tr(context, _tabs[2].key),
                        active: sel == 2,
                        dark: dark,
                        onTap: () => _onTab(_tabs[2].path)),
                    _NavBarItem(
                        icon: _tabs[3].icon,
                        activeIcon: _tabs[3].activeIcon,
                        label: tr(context, _tabs[3].key),
                        active: sel == 3,
                        dark: dark,
                        onTap: () => _onTab(_tabs[3].path)),
                    _NavBarItem(
                        icon: _tabs[4].icon,
                        activeIcon: _tabs[4].activeIcon,
                        label: tr(context, _tabs[4].key),
                        active: sel == 4,
                        dark: dark,
                        onTap: () => _onTab(_tabs[4].path)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Suzuvchi AI markaziy tugma (panel tepasiga chiqib turadi) ──
            Positioned(
              top: -30,
              left: 0,
              right: 0,
              height: 84,
              child: Center(
                child: _AiCenterButton(
                  active: sel == 2,
                  onTap: () => _onTab(_tabs[2].path),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bosishda kichrayadigan animatsiyali o'rovchi.
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _TapScale({required this.child, required this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> {
  double _s = 1;
  void _set(double v) => setState(() => _s = v);

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => _set(0.86),
        onTapUp: (_) => _set(1),
        onTapCancel: () => _set(1),
        child: AnimatedScale(
          scale: _s,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: widget.child,
        ),
      );
}

/// Yon navigatsiya elementi (ikonka + yorliq). Markaziy slot uchun `.center`.
class _NavBarItem extends StatelessWidget {
  final IconData? icon, activeIcon;
  final String label;
  final bool active, dark, isCenter;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.dark,
    required this.onTap,
  }) : isCenter = false;

  const _NavBarItem.center({
    required this.label,
    required this.active,
    required this.dark,
    required this.onTap,
  })  : icon = null,
        activeIcon = null,
        isCenter = true;

  @override
  Widget build(BuildContext context) {
    final activeColor = dark ? AppTheme.secondary : AppTheme.primary;
    final inactive =
        dark ? const Color(0xFF8AA0C6) : const Color(0xFF94A3B8);
    final color = active ? activeColor : inactive;
    return Expanded(
      child: _TapScale(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 28,
                child: isCenter
                    ? const SizedBox.shrink()
                    : Icon(active ? activeIcon : icon, size: 26, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: -0.2,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Suzuvchi AI markaziy tugma — doiraviy gradient avatar, lupa (qidiruv)
/// konsepsiyasi, sparkle, pulslanuvchi ko'k glow. Hech qanday rasm assetisiz.
class _AiCenterButton extends StatefulWidget {
  final bool active;
  final VoidCallback onTap;
  const _AiCenterButton({required this.active, required this.onTap});

  @override
  State<_AiCenterButton> createState() => _AiCenterButtonState();
}

class _AiCenterButtonState extends State<_AiCenterButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  double _scale = 1;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _set(double v) => setState(() => _scale = v);

  @override
  Widget build(BuildContext context) {
    final size = widget.active ? 82.0 : 72.0;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => _set(0.9),
      onTapUp: (_) => _set(1),
      onTapCancel: () => _set(1),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _pulse,
          builder: (context, _) {
            final dark = Theme.of(context).brightness == Brightness.dark;
            final p = _pulse.value; // 0..1
            // Dark mode'da yanada yorqin ko'k glow.
            final base = dark
                ? (widget.active ? 0.70 : 0.52)
                : (widget.active ? 0.55 : 0.38);
            final glow = base + p * (dark ? 0.24 : 0.18);
            final glowColor =
                dark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: glowColor.withValues(alpha: glow),
                    blurRadius: (dark ? 26 : 22) + p * (dark ? 16 : 12),
                    spreadRadius: (dark ? 2 : 1) + p * 2,
                  ),
                ],
              ),
              // Zukkobek mascoti (dumaloq avatar).
              child: ClipOval(
                child: Image.asset(
                  'assets/images/icons/zigi.png',
                  fit: BoxFit.cover,
                  width: size,
                  height: size,
                  errorBuilder: (_, e, st) => Container(
                    color: const Color(0xFF1E3A8A),
                    alignment: Alignment.center,
                    child: Icon(Icons.search_rounded,
                        color: Colors.white, size: size * 0.4),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Drawer extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  final String location;
  const _Drawer({required this.onClose, required this.location});

  @override
  ConsumerState<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends ConsumerState<_Drawer> {
  static const _items = [
    (key: 'd_news', icon: Icons.newspaper_rounded, route: '/services/news'),
    (key: 'd_weather', icon: Icons.wb_sunny_rounded, route: '/services/weather'),
    (key: 'd_appeals', icon: Icons.support_agent_rounded, route: '/services/appeals'),
    (key: 'd_ads', icon: Icons.campaign_rounded, route: '/services/ads'),
    (key: 'd_bank', icon: Icons.account_balance_rounded, route: '/services/bank'),
    (key: 'd_tourism', icon: Icons.landscape_rounded, route: '/services/tourism'),
    (key: 'd_contact', icon: Icons.phone_rounded, route: '/services/contact'),
    (key: 'd_settings', icon: Icons.settings_rounded, route: '/services/settings'),
  ];

  bool _isActive(String route) =>
      widget.location == route || widget.location.startsWith('$route/');

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final accent = dark ? AppTheme.secondary : AppTheme.primary;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      width: 314,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        child: Material(
          color: AppTheme.card(context),
          elevation: 24,
          shadowColor: Colors.black54,
          child: Column(
            children: [
              const _DrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 6, bottom: 10),
                  children: [
                    _groupLabel(context, tr(context, 'd_grp_menu')),
                    ..._items.map((e) => _DrawerTile(
                          icon: e.icon,
                          label: tr(context, e.key),
                          active: _isActive(e.route),
                          accent: accent,
                          onTap: () {
                            widget.onClose();
                            context.go(e.route);
                          },
                        )),
                    _groupLabel(context, tr(context, 'd_settings')),
                    // Til
                    _SettingRow(
                      icon: Icons.language_rounded,
                      label: tr(context, 'language'),
                      accent: accent,
                      onTap: () => _langSheet(context),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: accent.withValues(alpha: dark ? 0.22 : 0.10),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              languageLabel(
                                  ref.watch(localeProvider).languageCode),
                              style: TextStyle(
                                  fontSize: 12.5,
                                  color: accent,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded,
                              size: 18,
                              color: AppTheme.ts(context).withValues(alpha: 0.5)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Divider(
                          height: 1, color: AppTheme.dv(context)),
                    ),
                    const SizedBox(height: 6),
                    // Chiqish
                    _DrawerTile(
                      icon: Icons.logout_rounded,
                      label: tr(context, 'logout'),
                      active: false,
                      accent: const Color(0xFFEF4444),
                      danger: true,
                      onTap: () => _logout(context),
                    ),
                  ],
                ),
              ),
              // Footer — versiya
              Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 16 + bottomPad),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_rounded,
                        size: 14, color: accent.withValues(alpha: 0.8)),
                    const SizedBox(width: 6),
                    Text(
                      "G'ozg'on Life · v1.0.0",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.ts(context)),
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

  Widget _groupLabel(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 14, 16, 7),
        child: Text(
          text.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.3,
            color: AppTheme.ts(context).withValues(alpha: 0.7),
          ),
        ),
      );

  void _langSheet(BuildContext ctx) {
    final current = ref.read(localeProvider).languageCode;
    final dark = Theme.of(ctx).brightness == Brightness.dark;
    final accent = dark ? AppTheme.secondary : AppTheme.primary;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: AppTheme.card(ctx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.dv(ctx),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(tr(ctx, 'choose_language'),
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              ...supportedLanguages.map((l) {
                final sel = l.code == current;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                  child: Material(
                    color: sel
                        ? accent.withValues(alpha: dark ? 0.20 : 0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        ref.read(localeProvider.notifier).setLanguage(l.code);
                        Navigator.pop(ctx);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        child: Row(
                          children: [
                            Text(l.label,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight:
                                        sel ? FontWeight.w700 : FontWeight.w500,
                                    color: sel
                                        ? accent
                                        : AppTheme.tp(ctx))),
                            const Spacer(),
                            Icon(
                              sel
                                  ? Icons.check_circle_rounded
                                  : Icons.circle_outlined,
                              color: sel
                                  ? accent
                                  : AppTheme.ts(ctx).withValues(alpha: 0.5),
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext ctx) async {
    final router = GoRouter.of(ctx);
    widget.onClose();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(tr(context, 'logout')),
        content: Text(tr(context, 'logout_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'cancel'))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'logout'), style: const TextStyle(color: Color(0xFFEF4444)))),
        ],
      ),
    );
    if (ok != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('logged_in');
    await prefs.remove('phone');
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('birth_date');
    if (mounted) router.go('/onboarding');
  }
}

/// Sarlavha — faqat shahar rasmi (hero).
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.paddingOf(context).top;
    return SizedBox(
      width: double.infinity,
      height: topPad + 240,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Shahar rasmi
          Image.asset(
            dark ? 'assets/images/uuu.png' : 'assets/images/uu.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            cacheWidth: 800,
          ),
          // Status bar ikonkalari uchun nozik tepa scrim
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 34,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.30),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Premium drawer qatori — rangli ikona plitkasi, faol holat ajratilishi.
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final Color accent;
  final bool danger;
  final VoidCallback onTap;
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.active,
    required this.accent,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        active || danger ? accent : AppTheme.tp(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
      child: Material(
        color: active
            ? accent.withValues(alpha: dark ? 0.20 : 0.10)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    gradient: active
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent,
                              Color.lerp(accent, Colors.black, 0.18)!
                            ])
                        : null,
                    color: active
                        ? null
                        : accent.withValues(alpha: dark ? 0.16 : 0.10),
                    borderRadius: BorderRadius.circular(11),
                    boxShadow: active
                        ? [
                            BoxShadow(
                                color: accent.withValues(alpha: 0.40),
                                blurRadius: 9,
                                offset: const Offset(0, 3))
                          ]
                        : null,
                  ),
                  child: Icon(icon,
                      size: 20, color: active ? Colors.white : accent),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight:
                          active ? FontWeight.w700 : FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                if (!danger)
                  Icon(Icons.chevron_right_rounded,
                      size: 18,
                      color: active
                          ? accent
                          : AppTheme.ts(context).withValues(alpha: 0.45)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sozlama qatori — ikona plitkasi + yorliq + o'ng tomonda boshqaruv.
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accent;
  final Widget trailing;
  final VoidCallback? onTap;
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.accent,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: dark ? 0.16 : 0.10),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, size: 20, color: accent),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.tp(context)),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
