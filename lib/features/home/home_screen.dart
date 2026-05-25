import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _news = [
  (
    title: "G'ozg'onda yangi sport majmuasi qurilishi boshlandi",
    date: '21 may 2026',
    color: Color(0xFF1D4ED8),
    icon: Icons.sports_soccer_rounded,
    tag: 'Sport',
  ),
  (
    title: "Shahar markazida ko'cha ta'mirlash ishlari yakunlandi",
    date: '20 may 2026',
    color: Color(0xFF065F46),
    icon: Icons.construction_rounded,
    tag: 'Shahar',
  ),
  (
    title: "Yangi ijtimoiy loyihalar e'lon qilindi",
    date: '19 may 2026',
    color: Color(0xFF7C2D12),
    icon: Icons.people_rounded,
    tag: 'Ijtimoiy',
  ),
];

const _cats = [
  (label: 'Yangiliklar', icon: Icons.newspaper_rounded, route: '/services/news', color: Color(0xFF3B82F6)),
  (label: 'Murojatlar', icon: Icons.support_agent_rounded, route: '/services/appeals', color: Color(0xFF10B981)),
  (label: 'Qatnov', icon: Icons.directions_bus_rounded, route: '/services/transport', color: Color(0xFFF59E0B)),
  (label: 'MyBank', icon: Icons.account_balance_rounded, route: '/services/bank', color: Color(0xFF6366F1)),
  (label: "E'lonlar", icon: Icons.campaign_rounded, route: '/services/ads', color: Color(0xFFEF4444)),
  (label: 'Namoz', icon: Icons.mosque_rounded, route: '/services/prayer', color: Color(0xFF059669)),
  (label: 'Xarita', icon: Icons.map_rounded, route: '/services/map', color: Color(0xFF0EA5E9)),
  (label: 'Mahallam', icon: Icons.location_city_rounded, route: '/services/mahalla', color: Color(0xFF8B5CF6)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _newsIdx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            leading: IconButton(
              icon: const Icon(Icons.menu_rounded),
              onPressed: ScaffoldWithNav.openDrawer,
            ),
            title: const Text("G'ozg'on Life"),
            actions: [
              IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Greeting(),
                const _WeatherCard(),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(title: 'Yangiliklar'),
                ),
                const SizedBox(height: 12),
                _NewsSlider(idx: _newsIdx, onChanged: (i) => setState(() => _newsIdx = i)),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _Header(title: 'Kategoriyalar', onMore: () => context.go('/services')),
                ),
                const SizedBox(height: 12),
                const _CatGrid(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "G'ozg'on Life 👋",
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bugun qanday yordam bera olamiz?',
            style: tt.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _WeatherCard extends StatelessWidget {
  const _WeatherCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/services/weather'),
      child: Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.45),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 80,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, color: Colors.white60, size: 13),
                      const SizedBox(width: 4),
                      const Text(
                        "G'ozg'on, Qashqadaryo",
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        '21 may, chorshanba',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.open_in_full_rounded, color: Colors.white70, size: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '+28°',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60,
                              fontWeight: FontWeight.w200,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Quyoshli',
                                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.wb_sunny_rounded, color: Color(0xFFFBBF24), size: 72),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _WStat(icon: Icons.water_drop_outlined, value: '45%', label: 'Namlik'),
                      _WDiv(),
                      _WStat(icon: Icons.air_rounded, value: '5 km/h', label: 'Shamol'),
                      _WDiv(),
                      _WStat(icon: Icons.thermostat_rounded, value: '22°', label: 'Kechasi'),
                    ],
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

class _WStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _WStat({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: Colors.white60, size: 17),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      );
}

class _WDiv extends StatelessWidget {
  const _WDiv();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 32, color: Colors.white.withValues(alpha: 0.15));
}

class _Header extends StatelessWidget {
  final String title;
  final VoidCallback? onMore;

  const _Header({required this.title, this.onMore});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          if (onMore != null)
            GestureDetector(
              onTap: onMore,
              child: const Text(
                'Barchasi →',
                style: TextStyle(color: AppTheme.secondary, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      );
}

class _NewsSlider extends StatelessWidget {
  final int idx;
  final ValueChanged<int> onChanged;

  const _NewsSlider({required this.idx, required this.onChanged});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          CarouselSlider.builder(
            itemCount: _news.length,
            options: CarouselOptions(
              height: 196,
              viewportFraction: 0.88,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: true,
              enlargeFactor: 0.12,
              onPageChanged: (i, _) => onChanged(i),
            ),
            itemBuilder: (_, i, _) => _NewsCard(item: _news[i]),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_news.length, (i) {
              final active = i == idx;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppTheme.primary : AppTheme.divider,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      );
}

class _NewsCard extends StatelessWidget {
  final ({String title, String date, Color color, IconData icon, String tag}) item;

  const _NewsCard({required this.item});

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [item.color, item.color.withValues(alpha: 0.7)],
                ),
              ),
              child: Icon(item.icon, size: 80, color: Colors.white.withValues(alpha: 0.15)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withValues(alpha: 0.72)],
                  stops: const [0.35, 1.0],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.tag,
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, height: 1.35),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.date,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.65), fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _CatGrid extends StatelessWidget {
  const _CatGrid();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _CatRow(start: 0),
            const SizedBox(height: 10),
            _CatRow(start: 4),
          ],
        ),
      );
}

class _CatRow extends StatelessWidget {
  final int start;
  const _CatRow({required this.start});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 92,
        child: Row(
          children: [
            for (int i = start; i < start + 4; i++) ...[
              if (i > start) const SizedBox(width: 10),
              Expanded(child: _CatTile(cat: _cats[i])),
            ],
          ],
        ),
      );
}

class _CatTile extends StatelessWidget {
  final ({String label, IconData icon, String route, Color color}) cat;

  const _CatTile({required this.cat});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => context.push(cat.route),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cat.color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(cat.icon, color: cat.color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(
                cat.label,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, height: 1.2),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
}
