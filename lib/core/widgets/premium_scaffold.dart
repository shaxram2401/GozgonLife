import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_theme.dart';

/// Premium frosted-glass app bar. Pastga scroll qilinganda butunlay yig'ilib,
/// tepa-chapda faqat suzuvchi menyu (yoki orqaga) tugmasi qoladi.
///
/// `Scaffold(appBar: ..., body: ...)` o'rniga ishlatiladi.
class PremiumScaffold extends StatefulWidget {
  final String title;
  final Widget body;

  /// O'ng tomondagi amallar (qidiruv, bildirishnoma va h.k.).
  final List<Widget>? actions;

  /// Eskirgan — drawer olib tashlangani uchun endi ta'sirsiz. Leading tugma
  /// faqat orqaga qaytish mumkin bo'lganda (push) ko'rsatiladi.
  final bool useDrawer;

  /// App bar gradient asosi. Standart — `AppTheme.primary`.
  final Color? accent;

  final Widget? floatingActionButton;
  final bool centerTitle;

  /// Banner ustiga "singib" ketadigan shaffof, to'rtburchak app bar.
  /// Body tepadan boshlanadi (banner status bar ortiga cho'ziladi), app bar
  /// faqat o'qilishi uchun nozik to'q gradient (scrim) bilan ustiga chiziladi.
  final bool immersive;

  /// true → to'liq sarlavhali app bar ko'rsatiladi (Yangiliklar, Xarita).
  /// false (standart) → barless rejim: hech qanday panel/sarlavha yo'q,
  /// faqat tepa-chapda suzuvchi ☰ (yoki ←) tugmasi qoladi.
  final bool showBar;

  /// Barless rejimda (showBar=false) suzuvchi ☰/← tugmasini ko'rsatish.
  /// `false` → hech qanday chrome yo'q; ekran o'z sarlavhasini quradi,
  /// body tepadan boshlanadi.
  final bool floatingButton;

  /// `showBar=true` bilan birga: app bar qulflanadi — scrollda yig'ilmaydi,
  /// doim tepada ko'rinib turadi.
  final bool pinnedBar;

  const PremiumScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.useDrawer = false,
    this.accent,
    this.floatingActionButton,
    this.centerTitle = true,
    this.immersive = false,
    this.showBar = false,
    this.floatingButton = true,
    this.pinnedBar = false,
  });

  @override
  State<PremiumScaffold> createState() => _PremiumScaffoldState();
}

class _PremiumScaffoldState extends State<PremiumScaffold> {
  bool _collapsed = false;

  bool _onScroll(ScrollNotification n) {
    if (widget.pinnedBar) return false; // qulflangan — yig'ilmaydi
    if (n.metrics.axis != Axis.vertical) return false;
    final c = n.metrics.pixels > 14;
    if (c != _collapsed) setState(() => _collapsed = c);
    return false;
  }

  /// Orqaga qaytish mumkinmi (push qilingan sahifa). Ildiz tablarda — yo'q.
  bool get _canBack => context.canPop();

  void _onLeading() {
    if (context.canPop()) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.paddingOf(context).top;
    const toolbar = 56.0;
    final barH = topPad + toolbar;
    final accent = widget.accent ?? AppTheme.primary;
    const leadingIcon = Icons.arrow_back_rounded;

    // ── Barless rejim: panel/sarlavha yo'q, faqat suzuvchi tugma ──
    if (!widget.showBar) {
      // Chrome'siz: ekran o'z sarlavhasini quradi, body tepadan boshlanadi.
      if (!widget.floatingButton) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: widget.floatingActionButton,
          body: widget.body,
        );
      }
      return Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: widget.floatingActionButton,
        body: Stack(
          children: [
            Positioned.fill(
              child: widget.immersive
                  ? widget.body
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Padding(
                        // Orqaga tugmasi bo'lsa — uning ostidan boshlanadi.
                        padding: EdgeInsets.only(top: topPad + (_canBack ? 52 : 8)),
                        child: widget.body,
                      ),
                    ),
            ),
            // Suzuvchi orqaga (←) tugmasi — faqat push qilingan sahifada.
            if (_canBack)
              Positioned(
                top: topPad + 6,
                left: 12,
                child: _floatingBtn(accent, dark, leadingIcon),
              ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: widget.floatingActionButton,
      body: Stack(
        children: [
          // Kontent. Immersive'da body tepadan boshlanadi (banner bar ortiga
          // cho'ziladi); aks holda bar balandligicha tepadan bo'sh joy.
          Positioned.fill(
            child: NotificationListener<ScrollNotification>(
              onNotification: _onScroll,
              child: widget.immersive
                  ? widget.body
                  : MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Padding(
                        padding: EdgeInsets.only(top: barH),
                        child: widget.body,
                      ),
                    ),
            ),
          ),
          // App bar — scrollda yuqoriga siljib yo'qoladi.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              offset: _collapsed ? const Offset(0, -1) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _collapsed ? 0 : 1,
                child: widget.immersive
                    ? _scrimBar(barH, topPad, leadingIcon)
                    : _bar(context, barH, topPad, accent, leadingIcon),
              ),
            ),
          ),
          // Suzuvchi orqaga tugmasi — scrollda paydo bo'ladi (faqat push'da).
          if (_canBack)
            Positioned(
              top: topPad + 6,
              left: 12,
              child: IgnorePointer(
                ignoring: !_collapsed,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  scale: _collapsed ? 1 : 0,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: _collapsed ? 1 : 0,
                    child: _floatingBtn(accent, dark, leadingIcon),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// App bar chap tomonidagi tugma — faqat push'da orqaga (←), aks holda
  /// sarlavhani markazda saqlash uchun bo'sh joy.
  Widget _leading(IconData icon) => _canBack
      ? _BarIcon(icon: icon, onTap: _onLeading)
      : const SizedBox(width: 44);

  Widget _bar(BuildContext context, double barH, double topPad, Color accent,
      IconData leadingIcon) {
    final trailing = widget.actions ?? const [SizedBox(width: 44)];
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: barH,
          padding: EdgeInsets.only(top: topPad, left: 6, right: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent,
                Color.lerp(accent, Colors.black, 0.22)!,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.38),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              _leading(leadingIcon),
              Expanded(
                child: Text(
                  widget.title,
                  textAlign:
                      widget.centerTitle ? TextAlign.center : TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              ...trailing,
            ],
          ),
        ),
      ),
    );
  }

  /// Immersive: shaffof, to'rtburchak app bar — banner ortidan ko'rinadi,
  /// faqat nozik to'q gradient (scrim) matn/ikonkani o'qilishli qiladi.
  Widget _scrimBar(double barH, double topPad, IconData leadingIcon) {
    final trailing = widget.actions ?? const [SizedBox(width: 44)];
    return Container(
      height: barH,
      padding: EdgeInsets.only(top: topPad, left: 6, right: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.42),
            Colors.black.withValues(alpha: 0.12),
            Colors.black.withValues(alpha: 0.0),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: Row(
        children: [
          _leading(leadingIcon),
          Expanded(
            child: Text(
              widget.title,
              textAlign:
                  widget.centerTitle ? TextAlign.center : TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
              ),
            ),
          ),
          ...trailing,
        ],
      ),
    );
  }

  Widget _floatingBtn(Color accent, bool dark, IconData icon) {
    return GestureDetector(
      onTap: _onLeading,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent, Color.lerp(accent, Colors.black, 0.22)!],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.5),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

/// App bar ichidagi yumaloq, yengil shaffof ikonka tugmasi.
class _BarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BarIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

/// App bar o'ng tomonidagi amal ikonkasi (oq, yumaloq sezuvchan).
class PremiumBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool badge;
  const PremiumBarAction(
      {super.key, required this.icon, required this.onTap, this.badge = false});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 24,
      child: SizedBox(
        width: 44,
        height: 44,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 23),
            if (badge)
              Positioned(
                top: 11,
                right: 11,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
