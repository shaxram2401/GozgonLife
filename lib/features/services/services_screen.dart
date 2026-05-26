import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/scaffold_with_nav.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  static const _services = [
    (label: 'Yangiliklar', icon: Icons.newspaper_rounded, route: '/services/news', color: Color(0xFF3B82F6), img: ''),
    (label: 'Murojatlar', icon: Icons.support_agent_rounded, route: '/services/appeals', color: Color(0xFF10B981), img: ''),
    (label: 'Qatnov', icon: Icons.directions_bus_rounded, route: '/services/transport', color: Color(0xFFF59E0B), img: ''),
    (label: 'Bank', icon: Icons.account_balance_rounded, route: '/services/bank', color: Color(0xFF6366F1), img: ''),
    (label: "E'lonlar", icon: Icons.campaign_rounded, route: '/services/ads', color: Color(0xFFEF4444), img: ''),
    (label: 'Namoz', icon: Icons.mosque_rounded, route: '/services/prayer', color: Color(0xFF059669), img: ''),
    (label: 'Xarita', icon: Icons.map_rounded, route: '/services/map', color: Color(0xFF0EA5E9), img: ''),
    (label: 'Mahallam', icon: Icons.location_city_rounded, route: '/services/mahalla', color: Color(0xFF8B5CF6), img: ''),
    (label: 'Turizm', icon: Icons.landscape_rounded, route: '/services/tourism', color: Color(0xFF059669), img: 'assets/images/icons/turism.png'),
    (label: 'Market', icon: Icons.store_rounded, route: '/market', color: Color(0xFFF97316), img: ''),
  ];

  @override
  Widget build(BuildContext context) {
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
            return _ServiceTile(label: s.label, icon: s.icon, color: s.color, route: s.route, img: s.img);
          },
        ),
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  final String img;

  const _ServiceTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.route,
    this.img = '',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
            Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: img.isNotEmpty
                  ? Image.asset(img, width: 80, height: 80, fit: BoxFit.contain, filterQuality: FilterQuality.high)
                  : Icon(icon, color: color, size: 58),
            ),
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
