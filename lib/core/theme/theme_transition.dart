import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_theme.dart';
import 'theme_provider.dart';

/// Mavzu (light ⇄ dark) almashganda butun ekranni qisqa vaqtga (yarim soniya)
/// shimmerli skeleton bilan qoplaydi — keskin rang sakrashini yumshatadi.
class ThemeTransition extends ConsumerStatefulWidget {
  const ThemeTransition({super.key});

  @override
  ConsumerState<ThemeTransition> createState() => _ThemeTransitionState();
}

class _ThemeTransitionState extends ConsumerState<ThemeTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  Timer? _timer;
  bool _show = false; // ko'rinishi kerakmi (opacity nishoni)
  bool _mounted = false; // fade tugaguncha daraxtda saqlanadi

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  void _trigger() {
    _timer?.cancel();
    if (!_shimmer.isAnimating) _shimmer.repeat();
    setState(() {
      _show = true;
      _mounted = true;
    });
    _timer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _show = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(themeProvider, (_, __) => _trigger());
    // Bo'sh holatda shaffof va bosishni bloklamaydi.
    if (!_mounted) return const IgnorePointer(child: SizedBox.shrink());
    return IgnorePointer(
      child: AnimatedOpacity(
        opacity: _show ? 1 : 0,
        // Darhol to'liq qoplaydi (yozuvlar ko'rinmasin), oxirida silliq so'nadi.
        duration: _show
            ? Duration.zero
            : const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        onEnd: () {
          if (!_show && mounted) {
            _shimmer.stop();
            setState(() => _mounted = false);
          }
        },
        child: _Skeleton(shimmer: _shimmer),
      ),
    );
  }
}

class _Skeleton extends StatelessWidget {
  final Animation<double> shimmer;
  const _Skeleton({required this.shimmer});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final base =
        dark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final highlight =
        dark ? const Color(0xFF334155) : const Color(0xFFF8FAFC);

    // Scaffold foni shaffof — shuning uchun to'liq qoplaydigan, shaffofsiz
    // gradient fonni o'zimiz chizamiz (aks holda yozuvlar oraliqdan ko'rinadi).
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppTheme.bgGradient(dark)),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: shimmer,
          builder: (context, _) {
            Widget box(double w, double h, {double r = 12}) => _ShimmerBox(
                  width: w,
                  height: h,
                  radius: r,
                  base: base,
                  highlight: highlight,
                  t: shimmer.value,
                );
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sarlavha qatori
                  Row(
                    children: [
                      box(44, 44, r: 22),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          box(120, 14),
                          const SizedBox(height: 8),
                          box(80, 12),
                        ],
                      ),
                      const Spacer(),
                      box(40, 40, r: 12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Banner
                  box(double.infinity, 140, r: 20),
                  const SizedBox(height: 20),
                  // Kategoriya kvadratlari
                  Row(
                    children: [
                      for (var i = 0; i < 4; i++) ...[
                        if (i > 0) const SizedBox(width: 12),
                        Expanded(child: box(0, 64, r: 16)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 22),
                  box(140, 16),
                  const SizedBox(height: 14),
                  // Ro'yxat qatorlari
                  for (var i = 0; i < 4; i++) ...[
                    Row(
                      children: [
                        box(56, 56, r: 14),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              box(double.infinity, 13),
                              const SizedBox(height: 8),
                              box(160, 11),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width, height, radius, t;
  final Color base, highlight;
  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.base,
    required this.highlight,
    required this.t,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width == 0 ? null : width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: [base, highlight, base],
          stops: const [0.35, 0.5, 0.65],
          transform: _SweepTransform(t),
        ),
      ),
    );
  }
}

/// Gradientni chapdan o'ngga suradi (shimmer porlashi).
class _SweepTransform extends GradientTransform {
  final double t;
  const _SweepTransform(this.t);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * (t * 2 - 1), 0, 0);
}
