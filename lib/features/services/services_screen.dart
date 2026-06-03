import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/widgets/skeleton.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});
  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _loading = true;

  static const _services = [
    (label: 'Yangiliklar', img: 'assets/images/icons/news.png', route: '/services/news'),
    (label: 'Murojatlar', img: 'assets/images/icons/mrj.png', route: '/services/appeals'),
    (label: 'Qatnov', img: 'assets/images/icons/qatnov.png', route: '/services/transport'),
    (label: 'Bank', img: 'assets/images/icons/mybank.png', route: '/services/bank'),
    (label: "E'lonlar", img: 'assets/images/icons/elonlar.png', route: '/services/ads'),
    (label: 'Namoz', img: 'assets/images/icons/namoz1.png', route: '/services/prayer'),
    (label: 'Xarita', img: 'assets/images/icons/map.png', route: '/services/map'),
    (label: 'Mahallam', img: 'assets/images/icons/mahallam.png', route: '/services/mahalla'),
    (label: 'Turizm', img: 'assets/images/icons/turism.png', route: '/services/tourism'),
    (label: 'Market', img: 'assets/images/icons/savat.png', route: '/market'),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(
      appBar: AppBar(title: const Text('Xizmatlar'), leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer)),
      body: const _ServicesSkeleton(),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xizmatlar'),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: ScaffoldWithNav.openDrawer,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _services.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (_, i) {
            final s = _services[i];
            return _ServiceTile(label: s.label, img: s.img, route: s.route);
          },
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final String img;
  final String route;

  const _ServiceTile({required this.label, required this.img, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(img, width: 48, height: 48),
            const SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesSkeleton extends StatelessWidget {
  const _ServicesSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.9,
            ),
            itemBuilder: (_, __) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [skBox(h: 48, r: 12), const SizedBox(height: 8), skBox(h: 10, w: 60)],
            ),
          ),
        ),
      );
}
