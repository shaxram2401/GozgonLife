import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/l10n/strings.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skeleton.dart';

const _cats = ['Barchasi', 'Savdo', 'Restoranlar', 'Xizmatlar', "Ish o'rinlari", 'Aksiyalar'];

const _catColors = {
  'Savdo': Color(0xFFF59E0B),
  'Restoranlar': Color(0xFFEF4444),
  'Xizmatlar': Color(0xFF3B82F6),
  "Ish o'rinlari": Color(0xFF10B981),
  'Aksiyalar': Color(0xFF8B5CF6),
};

const _catGradients = {
  'Savdo':        [Color(0xFFF59E0B), Color(0xFFFBBF24)],
  'Restoranlar':  [Color(0xFFEF4444), Color(0xFFF97316)],
  'Xizmatlar':    [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
  "Ish o'rinlari":[Color(0xFF10B981), Color(0xFF34D399)],
  'Aksiyalar':    [Color(0xFF8B5CF6), Color(0xFFEC4899)],
};

class _Ad {
  final String title, cat, phone;
  final IconData icon;
  const _Ad({required this.title, required this.cat, required this.phone, required this.icon});
}

const _ads = [
  _Ad(title: "Yangi qurilish materiallari ulgurji narxda", cat: 'Savdo', phone: '+998901234567', icon: Icons.construction_rounded),
  _Ad(title: "Osh va milliy taomlar kafesi", cat: 'Restoranlar', phone: '+998901234568', icon: Icons.restaurant_rounded),
  _Ad(title: "Santexnik — tezkor xizmat", cat: 'Xizmatlar', phone: '+998901234569', icon: Icons.plumbing_rounded),
  _Ad(title: "Kassir kerak, ish haqi yuqori", cat: "Ish o'rinlari", phone: '+998901234570', icon: Icons.work_rounded),
  _Ad(title: "Kiyimlar 50% chegirma hafta oxiri", cat: 'Aksiyalar', phone: '+998901234571', icon: Icons.local_offer_rounded),
  _Ad(title: "Telefon va aksessuarlar do'koni", cat: 'Savdo', phone: '+998901234572', icon: Icons.phone_android_rounded),
  _Ad(title: "Avtomobil ta'mirlash ustaxonasi", cat: 'Xizmatlar', phone: '+998901234573', icon: Icons.car_repair_rounded),
  _Ad(title: "Sushi va fast food yetkazib berish", cat: 'Restoranlar', phone: '+998901234574', icon: Icons.delivery_dining_rounded),
];

class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});
  @override
  State<AdsScreen> createState() => _State();
}

class _State extends State<AdsScreen> {
  String _cat = 'Barchasi';
  bool _loading = true;

  List<_Ad> get _filtered =>
      _cat == 'Barchasi' ? _ads : _ads.where((a) => a.cat == _cat).toList();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    if (_loading) return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'd_ads')), leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer)),
      body: const _AdsSkeleton(),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'd_ads')),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Banner(),
            _Tabs(active: _cat, onTap: (c) => setState(() => _cat = c)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
              child: Column(
                children: [
                  for (int i = 0; i < list.length; i += 2)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _AdCard(ad: list[i])),
                          const SizedBox(width: 10),
                          if (i + 1 < list.length)
                            Expanded(child: _AdCard(ad: list[i + 1]))
                          else
                            const Expanded(child: SizedBox()),
                        ],
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
}

class _Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            'assets/images/elon.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _Tabs extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTap;
  const _Tabs({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 46,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          itemCount: _cats.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = _cats[i];
            final sel = c == active;
            final color = _catColors[c] ?? AppTheme.primary;
            return GestureDetector(
              onTap: () => onTap(c),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: sel ? color : AppTheme.card(context),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel ? color : AppTheme.dv(context)),
                ),
                child: Text(
                  tr(context, c),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                    color: sel ? Colors.white : AppTheme.ts(context),
                  ),
                ),
              ),
            );
          },
        ),
      );
}

class _AdCard extends StatelessWidget {
  final _Ad ad;
  const _AdCard({required this.ad});

  @override
  Widget build(BuildContext context) {
    final color = _catColors[ad.cat] ?? AppTheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.panel(context, AppTheme.hueAmber),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            child: Container(
              height: 110,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: (_catGradients[ad.cat] ?? [color, color.withValues(alpha: 0.6)]).cast<Color>(),
                ),
              ),
              child: Icon(ad.icon, size: 48, color: Colors.white.withValues(alpha: 0.8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tr(context, ad.cat),
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: color),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  tr(context, ad.title),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    icon: Icon(Icons.phone_rounded, size: 14, color: color),
                    label: Text(tr(context, 'call')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdsSkeleton extends StatelessWidget {
  const _AdsSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              skBox(h: 200, r: 16),
              const SizedBox(height: 10),
              Row(children: [for (int i = 0; i < 4; i++) ...[skBox(w: 70, h: 30, r: 20), const SizedBox(width: 8)]]),
              const SizedBox(height: 12),
              for (int r = 0; r < 3; r++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (_) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        skBox(h: 110, r: 14),
                        const SizedBox(height: 8),
                        skBox(h: 10),
                        const SizedBox(height: 6),
                        skBox(h: 10, w: 80),
                        const SizedBox(height: 10),
                      ]),
                    ),
                  )),
                ),
              ],
            ],
          ),
        ),
      );
}
