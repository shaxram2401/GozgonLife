import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class _Slide {
  final IconData icon;
  final String title, subtitle;
  final List<({IconData icon, String label})> features;
  const _Slide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.features,
  });
}

const _slides = [
  _Slide(
    icon: Icons.location_city_rounded,
    title: "Shahar Xizmatlari",
    subtitle: "G'ozg'on shahri haqida so'nggi yangiliklar, ob-havo ma'lumotlari va turizm imkoniyatlari",
    features: [
      (icon: Icons.newspaper_rounded, label: 'Yangiliklar'),
      (icon: Icons.wb_sunny_rounded, label: 'Ob-havo'),
      (icon: Icons.landscape_rounded, label: 'Turizm'),
    ],
  ),
  _Slide(
    icon: Icons.precision_manufacturing_rounded,
    title: "Sanoat va Murojatlar",
    subtitle: "Shahar sanoati, hokimiyatga murojaat va e'lonlar platformasi",
    features: [
      (icon: Icons.factory_rounded, label: 'Sanoat'),
      (icon: Icons.support_agent_rounded, label: 'Murojatlar'),
      (icon: Icons.campaign_rounded, label: "E'lonlar"),
    ],
  ),
  _Slide(
    icon: Icons.smart_toy_rounded,
    title: "Zukkobek AI",
    subtitle: "Sun'iy intellekt yordamchi va barcha xizmatlar bir joyda",
    features: [
      (icon: Icons.mosque_rounded, label: 'Namoz'),
      (icon: Icons.map_rounded, label: 'Xarita'),
      (icon: Icons.store_rounded, label: 'Market'),
    ],
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _State();
}

class _State extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarded', true);
    if (mounted) context.go('/auth/phone');
  }

  void _next() {
    if (_page < _slides.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E3A8A), Color(0xFF1E40AF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _page > 0
                          ? () => _ctrl.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              )
                          : null,
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: _page > 0 ? Colors.white70 : Colors.transparent,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _finish,
                      child: Text(
                        "O'tkazib yuborish",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _ctrl,
                  itemCount: _slides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (_, i) => _SlidePage(slide: _slides[i]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 36),
                child: Row(
                  children: [
                    Row(
                      children: List.generate(_slides.length, (i) {
                        final active = i == _page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 280),
                          margin: const EdgeInsets.only(right: 7),
                          width: active ? 26 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.white30,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _next,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: isLast ? AppTheme.accent : Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isLast ? 'Boshlash' : 'Keyingi',
                              style: TextStyle(
                                color: isLast ? Colors.white : AppTheme.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                              color: isLast ? Colors.white : AppTheme.primary,
                              size: 18,
                            ),
                          ],
                        ),
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
  }
}

class _SlidePage extends StatelessWidget {
  final _Slide slide;
  const _SlidePage({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          const Spacer(flex: 2),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              Icon(slide.icon, size: 68, color: Colors.white),
            ],
          ),
          const Spacer(flex: 1),
          Text(
            slide.title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            slide.subtitle,
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withValues(alpha: 0.72),
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Row(
            children: List.generate(slide.features.length, (i) {
              final f = slide.features[i];
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < slide.features.length - 1 ? 12 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.13),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Column(
                    children: [
                      Icon(f.icon, color: Colors.white, size: 30),
                      const SizedBox(height: 10),
                      Text(
                        f.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
