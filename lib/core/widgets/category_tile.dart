import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Premium kategoriya plitkasi.
///
/// - Rasm ikonka (qora burchaklar kesilgan, yumaloq squircle)
/// - Rangli yumshoq glow soya
/// - Ripple (InkWell) + haptik javob + bosishda kichrayish
/// - Ixtiyoriy badge (qizil nuqta)
/// - Ekran ochilganda ketma-ket (staggered) fade + scale paydo bo'lish
class CategoryTile extends StatefulWidget {
  final String img;
  final String label;
  final Color accent;
  final bool badge;
  final int index;
  final double iconFactor;
  final double labelSize;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.img,
    required this.label,
    required this.accent,
    required this.index,
    required this.onTap,
    this.badge = false,
    this.iconFactor = 0.74,
    this.labelSize = 12.5,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<CategoryTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _in;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _in = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 430));
    // Ketma-ket kechikish — indeksga qarab.
    Future.delayed(Duration(milliseconds: 50 + widget.index * 55), () {
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
        final t = Curves.easeOutBack.transform(v);
        final f = Curves.easeOut.transform(v);
        return Opacity(
          opacity: f,
          child: Transform.translate(
            offset: Offset(0, (1 - t) * 14),
            child: Transform.scale(scale: 0.84 + 0.16 * t, child: child),
          ),
        );
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: widget.iconFactor,
                  heightFactor: widget.iconFactor,
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final r = c.maxWidth * 0.28;
                      final br = BorderRadius.circular(r);
                      return Stack(
                        children: [
                          // Ikonka (qora chekka zoom bilan kesiladi) — yumshoq neytral soya
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: br,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: dark ? 0.30 : 0.10),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: br,
                              child: Transform.scale(
                                scale: 1.16,
                                child: Image.asset(
                                  widget.img,
                                  fit: BoxFit.cover,
                                  cacheWidth: 320,
                                ),
                              ),
                            ),
                          ),
                          // Ripple + tap + haptik
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: br,
                                splashColor:
                                    Colors.white.withValues(alpha: 0.22),
                                highlightColor:
                                    Colors.white.withValues(alpha: 0.08),
                                onTap: () {
                                  HapticFeedback.lightImpact();
                                  widget.onTap();
                                },
                                onHighlightChanged: (v) =>
                                    setState(() => _pressed = v),
                              ),
                            ),
                          ),
                          // Badge (qizil nuqta)
                          if (widget.badge)
                            Positioned(
                              right: 4,
                              top: 4,
                              child: Container(
                                width: 13,
                                height: 13,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFEF4444)
                                          .withValues(alpha: 0.6),
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 9),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: widget.labelSize,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
                height: 1.1,
                color: dark ? Colors.white : const Color(0xFF1E293B),
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
