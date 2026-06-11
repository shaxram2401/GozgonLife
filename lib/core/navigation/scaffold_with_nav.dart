import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../theme/theme_transition.dart';
import 'scroll_to_top.dart';

/// Pastki navigatsiya qobig'i. Drawer (yon menyu) BUTUNLAY olib tashlangan —
/// barcha bo'limlar pastki nav yoki Profil orqali ochiladi.
class ScaffoldWithNav extends StatelessWidget {
  final Widget child;
  final String location;

  const ScaffoldWithNav({super.key, required this.child, required this.location});

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
  void _onTab(BuildContext context, String path) {
    final current = location.split('?').first;
    if (current == path) {
      TabScrollTop.scrollToTop(path);
    } else {
      context.go(path);
    }
  }

  int get _selectedIndex {
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/zukkobek')) return 2;
    if (location.startsWith('/market')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
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
          child,
          // Mavzu almashganda asosiy kontentni qoplaydigan skeleton overlay.
          const Positioned.fill(child: ThemeTransition()),
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
        height: 76,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Navigatsiya paneli (kichik, shaffof shisha) ──
            Positioned(
              left: 14,
              right: 14,
              bottom: 6,
              height: 58,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    // Glow (shadow o'rniga) — premium suzuvchi effekt.
                    BoxShadow(
                      color: (dark ? AppTheme.secondary : AppTheme.primary)
                          .withValues(alpha: dark ? 0.22 : 0.12),
                      blurRadius: 28,
                      spreadRadius: 0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                    child: Container(
                      decoration: BoxDecoration(
                        // Orqa fon kesilgan — yarim shaffof, fon ko'rinib turadi.
                        color: dark
                            ? Colors.white.withValues(alpha: 0.06)
                            : Colors.white.withValues(alpha: 0.30),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: dark
                              ? Colors.white.withValues(alpha: 0.10)
                              : Colors.white.withValues(alpha: 0.55),
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
                        onTap: () => _onTab(context, _tabs[0].path)),
                    _NavBarItem(
                        icon: _tabs[1].icon,
                        activeIcon: _tabs[1].activeIcon,
                        label: tr(context, _tabs[1].key),
                        active: sel == 1,
                        dark: dark,
                        onTap: () => _onTab(context, _tabs[1].path)),
                    // Markaziy slot — yorliq pastda, avatar tepada suzadi.
                    _NavBarItem.center(
                        label: tr(context, _tabs[2].key),
                        active: sel == 2,
                        dark: dark,
                        onTap: () => _onTab(context, _tabs[2].path)),
                    _NavBarItem(
                        icon: _tabs[3].icon,
                        activeIcon: _tabs[3].activeIcon,
                        label: tr(context, _tabs[3].key),
                        active: sel == 3,
                        dark: dark,
                        onTap: () => _onTab(context, _tabs[3].path)),
                    _NavBarItem(
                        icon: _tabs[4].icon,
                        activeIcon: _tabs[4].activeIcon,
                        label: tr(context, _tabs[4].key),
                        active: sel == 4,
                        dark: dark,
                        onTap: () => _onTab(context, _tabs[4].path)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // ── Suzuvchi AI markaziy tugma (panel tepasiga chiqib turadi) ──
            Positioned(
              top: -24,
              left: 0,
              right: 0,
              height: 72,
              child: Center(
                child: _AiCenterButton(
                  active: sel == 2,
                  onTap: () => _onTab(context, _tabs[2].path),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 22,
              child: isCenter
                  ? const SizedBox.shrink()
                  : Icon(active ? activeIcon : icon, size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: -0.2,
                color: color,
              ),
            ),
          ],
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
    final size = widget.active ? 66.0 : 58.0;
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
                // Elegant oq ring — premium AI tugma hissi.
                border: Border.all(
                  color: Colors.white.withValues(alpha: dark ? 0.35 : 0.90),
                  width: 2.5,
                ),
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
