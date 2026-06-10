import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

const _accent = Color(0xFFBF360C);
const _accentLight = Color(0xFFFF7043);

typedef _Feature = ({IconData icon, String key});

const _services = [
  (
    icon: Icons.local_taxi_rounded,
    img: 'assets/images/111.png',
    title: 'Taksi',
    desc:
        "Shahar ichida va tashqarisida qulay taksi xizmati. Bir necha daqiqada yo'lingizga yo'ldosh.",
    btn: 'Taksi chaqirish',
    c1: Color(0xFFFBBF24),
    c2: Color(0xFFF97316),
    features: <_Feature>[
      (icon: Icons.access_time_filled_rounded, key: 'tp_taxi_a'),
      (icon: Icons.bolt_rounded, key: 'tp_taxi_b'),
    ],
  ),
  (
    icon: Icons.directions_bus_rounded,
    img: 'assets/images/222.png',
    title: 'Avtobus',
    desc:
        "Shahar marshrutlari va jadval. Barcha yo'nalishlar va to'xtash nuqtalari.",
    btn: "Jadvalini ko'rish",
    c1: Color(0xFF60A5FA),
    c2: Color(0xFF2563EB),
    features: <_Feature>[
      (icon: Icons.route_rounded, key: 'tp_bus_a'),
      (icon: Icons.schedule_rounded, key: 'tp_bus_b'),
    ],
  ),
  (
    icon: Icons.train_rounded,
    img: 'assets/images/333.png',
    title: 'Poyezdlar',
    desc: "Viloyatlararo va xalqaro poyezd chiptalari. Qulay narx va jadval.",
    btn: 'Chipta sotib olish',
    c1: Color(0xFF34D399),
    c2: Color(0xFF059669),
    features: <_Feature>[
      (icon: Icons.confirmation_number_rounded, key: 'tp_train_a'),
      (icon: Icons.public_rounded, key: 'tp_train_b'),
    ],
  ),
];

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});
  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final show = shouldShowSkeleton('transport');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'c_transport'),
        accent: _accent,
        immersive: true,
        body: const _TransportSkeleton(),
      );
    }
    return PremiumScaffold(
      title: tr(context, 'c_transport'),
      accent: _accent,
      immersive: true,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: _accent,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const _Hero(),
            const SizedBox(height: 6),
            _SectionTitle(
                icon: Icons.commute_rounded, title: tr(context, 'tp_types')),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                children: [
                  for (int i = 0; i < _services.length; i++) ...[
                    if (i > 0) const SizedBox(height: 16),
                    _Card(s: _services[i]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            Localizations.localeOf(context).languageCode == 'ru'
                ? 'assets/images/qatnovru.png'
                : 'assets/images/qatnovuz.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_accentLight, _accent]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.tp(context))),
          ],
        ),
      );
}

class _Card extends StatefulWidget {
  final ({
    IconData icon,
    String img,
    String title,
    String desc,
    String btn,
    Color c1,
    Color c2,
    List<_Feature> features,
  }) s;
  const _Card({required this.s});

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _pressed = false;

  Widget _glassIcon() => Container(
        width: 62,
        height: 62,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(widget.s.icon, color: Colors.white, size: 32),
      );

  @override
  Widget build(BuildContext context) {
    final s = widget.s;
    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [s.c1, s.c2],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: s.c2.withValues(alpha: 0.40),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              // Yuqori glossy yorug'lik
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 90,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withValues(alpha: 0.20),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              // Dekorativ katta ikonka
              Positioned(
                right: -22,
                bottom: -26,
                child: Icon(s.icon,
                    size: 156, color: Colors.white.withValues(alpha: 0.13)),
              ),
              // Yumshoq doira
              Positioned(
                left: -30,
                top: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.45),
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              s.img,
                              width: 62,
                              height: 62,
                              fit: BoxFit.cover,
                              cacheWidth: 124,
                              errorBuilder: (_, e, st) => _glassIcon(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(context, s.title),
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4ADE80),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFF4ADE80),
                                            blurRadius: 6),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tr(context, 'tp_available'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color:
                                          Colors.white.withValues(alpha: 0.85),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tr(context, s.desc),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Xususiyat chiplari
                    Row(
                      children: [
                        for (final f in s.features) ...[
                          _FeatureChip(icon: f.icon, label: tr(context, f.key)),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                    const SizedBox(height: 18),
                    _CtaButton(
                      label: tr(context, s.btn),
                      color: s.c2,
                      onTap: () {},
                      onPressChange: (v) => setState(() => _pressed = v),
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

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: Colors.white),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      );
}

class _CtaButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final ValueChanged<bool> onPressChange;
  const _CtaButton({
    required this.label,
    required this.color,
    required this.onTap,
    required this.onPressChange,
  });

  @override
  State<_CtaButton> createState() => _CtaButtonState();
}

class _CtaButtonState extends State<_CtaButton> {
  void _set(bool v) => widget.onPressChange(v);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.label,
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: widget.color)),
            const SizedBox(width: 6),
            Icon(Icons.arrow_forward_rounded, size: 18, color: widget.color),
          ],
        ),
      ),
    );
  }
}

class _TransportSkeleton extends StatelessWidget {
  const _TransportSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            skBox(h: 200, r: 0),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                skBox(h: 16, w: 150),
                const SizedBox(height: 14),
                for (int i = 0; i < 3; i++) ...[
                  skBox(h: 210, r: 26),
                  const SizedBox(height: 16)
                ],
              ]),
            ),
          ],
        ),
      );
}
