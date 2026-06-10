import 'package:flutter/material.dart';

import '../navigation/scaffold_with_nav.dart';
import '../theme/app_theme.dart';

/// Toza header — chapda ☰ (drawer), markazda bo'lim nomi, o'ngda bildirishnoma.
/// Banner asosiy element bo'lishi uchun sarlavha kichik va neytral.
class PremiumHeader extends StatelessWidget {
  final String title;
  final Color accent;
  final bool notification;
  const PremiumHeader({
    super.key,
    required this.title,
    required this.accent,
    this.notification = true,
  });

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.only(top: topPad + 6, left: 8, right: 8, bottom: 4),
      child: SizedBox(
        height: 50,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppTheme.tp(context),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: _HeaderIcon(
                icon: Icons.menu_rounded,
                color: AppTheme.tp(context),
                onTap: ScaffoldWithNav.openDrawer,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _HeaderIcon(
                icon: Icons.notifications_rounded,
                color: AppTheme.tp(context),
                onTap: () {},
                badge: notification,
                badgeColor: accent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool badge;
  final Color? badgeColor;
  const _HeaderIcon({
    required this.icon,
    required this.color,
    required this.onTap,
    this.badge = false,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 46,
        height: 46,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            if (badge)
              Positioned(
                top: 9,
                right: 9,
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    color: badgeColor ?? const Color(0xFFEF4444),
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: AppTheme.card(context), width: 1.6),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Premium banner — full width (16 margin), 250px, radius 30, premium shadow.
/// Sahifaning asosiy vizual (markaziy) elementi.
class PremiumBanner extends StatelessWidget {
  final String image;
  final double height;
  const PremiumBanner({super.key, required this.image, this.height = 250});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.22),
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

/// Kategoriya kartasi — ikona plitkasi + yorliq (tanlanganda accent fon).
class FilterCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const FilterCard({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: selected ? color : AppTheme.card(context),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: selected ? color : AppTheme.dv(context)),
                boxShadow: [
                  BoxShadow(
                    color: selected
                        ? color.withValues(alpha: 0.40)
                        : Colors.black.withValues(alpha: dark ? 0.30 : 0.06),
                    blurRadius: selected ? 12 : 9,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Icon(icon, color: selected ? Colors.white : color, size: 26),
            ),
            const SizedBox(height: 7),
            Text(
              label,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                height: 1.1,
                color: selected ? color : AppTheme.tp(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
