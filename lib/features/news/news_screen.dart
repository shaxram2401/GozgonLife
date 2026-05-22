import 'package:flutter/material.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _cats = ['Barchasi', 'Shahar', 'Sport', 'Hokimiyat', 'Tadbir', 'Mahalliy'];

Color _color(String cat) => switch (cat) {
      'Shahar' => const Color(0xFF10B981),
      'Sport' => const Color(0xFF3B82F6),
      'Hokimiyat' => const Color(0xFF6366F1),
      'Tadbir' => const Color(0xFFF59E0B),
      'Mahalliy' => const Color(0xFF8B5CF6),
      _ => AppTheme.primary,
    };

IconData _icon(String cat) => switch (cat) {
      'Shahar' => Icons.location_city_rounded,
      'Sport' => Icons.sports_soccer_rounded,
      'Hokimiyat' => Icons.account_balance_rounded,
      'Tadbir' => Icons.event_rounded,
      'Mahalliy' => Icons.people_rounded,
      _ => Icons.article_rounded,
    };

class _News {
  final String title, date, cat;
  final int views;
  const _News(this.title, this.date, this.cat, this.views);
}

const _items = [
  _News("G'ozg'onda yangi zamonaviy sport majmuasi qurilishi boshlandi", '21 may 2026', 'Sport', 1240),
  _News("Hokimiyat aholiga yangi raqamli kommunal xizmatlar taqdim etdi", '20 may 2026', 'Hokimiyat', 876),
  _News("Shahar markazida ko'cha ta'mirlash ishlari muvaffaqiyatli yakunlandi", '19 may 2026', 'Shahar', 654),
  _News("Yoshlar madaniyat festivali mingdan ortiq ishtirokchi bilan o'tkazildi", '18 may 2026', 'Tadbir', 532),
  _News("Mahalliy dehqonlar va fermerlar mahsulotlari ko'rgazmasi ochildi", '17 may 2026', 'Mahalliy', 421),
];

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _State();
}

class _State extends State<NewsScreen> {
  String _cat = 'Barchasi';

  List<_News> get _list =>
      _cat == 'Barchasi' ? _items : _items.where((n) => n.cat == _cat).toList();

  @override
  Widget build(BuildContext context) {
    final list = _list;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yangiliklar'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FilterRow(active: _cat, onTap: (c) => setState(() => _cat = c)),
          if (list.isEmpty)
            const Expanded(
              child: Center(
                child: Text('Yangiliklar topilmadi'),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: list.length,
                itemBuilder: (_, i) => i == 0
                    ? _FeaturedCard(item: list[0])
                    : Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _ListTile(item: list[i]),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTap;
  const _FilterRow({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 52,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: _cats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = _cats[i];
            final sel = c == active;
            return GestureDetector(
              onTap: () => onTap(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? AppTheme.primary : AppTheme.divider),
                ),
                child: Text(
                  c,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class _FeaturedCard extends StatelessWidget {
  final _News item;
  const _FeaturedCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _color(item.cat);
    final icon = _icon(item.cat);
    return Container(
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withValues(alpha: 0.7)],
        ),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(icon, size: 160, color: Colors.white.withValues(alpha: 0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Badge(cat: item.cat, light: true),
                const Spacer(),
                Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(item.date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    const SizedBox(width: 16),
                    const Icon(Icons.remove_red_eye_outlined, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text('${item.views}', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  final _News item;
  const _ListTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = _color(item.cat);
    final icon = _icon(item.cat);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Icon(icon, color: color, size: 36),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Badge(cat: item.cat, light: false),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 11, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text(item.date, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      const Spacer(),
                      const Icon(Icons.remove_red_eye_outlined, size: 11, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('${item.views}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String cat;
  final bool light;
  const _Badge({required this.cat, required this.light});

  @override
  Widget build(BuildContext context) {
    final color = _color(cat);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: light ? Colors.white.withValues(alpha: 0.25) : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        cat,
        style: TextStyle(
          color: light ? Colors.white : color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
