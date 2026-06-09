import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'c_transport'),
        accent: const Color(0xFFBF360C),
        body: const _TransportSkeleton(),
      );
    }
    return PremiumScaffold(
      title: tr(context, 'c_transport'),
      accent: const Color(0xFFBF360C),
      immersive: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Hero(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  _Card(
                    icon: Icons.local_taxi_rounded,
                    img: 'assets/images/111.png',
                    title: 'Taksi',
                    desc: "Shahar ichida va tashqarisida qulay taksi xizmati. Bir necha daqiqada yo'lingizga yo'ldosh.",
                    btn: 'Taksi chaqirish',
                    c1: Color(0xFFFBBF24),
                    c2: Color(0xFFF97316),
                  ),
                  SizedBox(height: 16),
                  _Card(
                    icon: Icons.directions_bus_rounded,
                    img: 'assets/images/222.png',
                    title: 'Avtobus',
                    desc: "Shahar marshrutlari va jadval. Barcha yo'nalishlar va to'xtash nuqtalari.",
                    btn: "Jadvalini ko'rish",
                    c1: Color(0xFF60A5FA),
                    c2: Color(0xFF2563EB),
                  ),
                  SizedBox(height: 16),
                  _Card(
                    icon: Icons.train_rounded,
                    img: 'assets/images/333.png',
                    title: 'Poyezdlar',
                    desc: "Viloyatlararo va xalqaro poyezd chiptalari. Qulay narx va jadval.",
                    btn: 'Chipta sotib olish',
                    c1: Color(0xFF34D399),
                    c2: Color(0xFF059669),
                  ),
                  SizedBox(height: 24),
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
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            'assets/images/taxi2.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _Card extends StatelessWidget {
  final IconData icon;
  final String img, title, desc, btn;
  final Color c1, c2;

  const _Card({
    required this.icon,
    required this.img,
    required this.title,
    required this.desc,
    required this.btn,
    required this.c1,
    required this.c2,
  });

  Widget _glassIcon() => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 32),
      );

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [c1, c2],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: c2.withValues(alpha: 0.35),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Decorative oversized icon
              Positioned(
                right: -24,
                bottom: -24,
                child: Icon(icon, size: 150, color: Colors.white.withValues(alpha: 0.12)),
              ),
              // Soft highlight circle
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
                            border: Border.all(color: Colors.white.withValues(alpha: 0.45), width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 3)),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              img,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              cacheWidth: 120,
                              errorBuilder: (_, __, ___) => _glassIcon(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tr(context, title),
                                style: const TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4ADE80),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    tr(context, 'tp_available'),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withValues(alpha: 0.85),
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
                      tr(context, desc),
                      style: TextStyle(
                        fontSize: 13.5,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: c2,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 0,
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(tr(context, btn), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: c2)),
                            const SizedBox(width: 6),
                            Icon(Icons.arrow_forward_rounded, size: 18, color: c2),
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
      );
}

class _TransportSkeleton extends StatelessWidget {
  const _TransportSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              skBox(h: 200, r: 0),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  for (int i = 0; i < 3; i++) ...[skBox(h: 120, r: 16), const SizedBox(height: 14)],
                ]),
              ),
            ],
          ),
        ),
      );
}
