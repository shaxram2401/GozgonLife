import 'package:flutter/material.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

class _Place {
  final String name, desc, location, tag;
  final IconData icon;
  final Color color;
  const _Place({
    required this.name,
    required this.desc,
    required this.location,
    required this.tag,
    required this.icon,
    required this.color,
  });
}

const _places = [
  _Place(
    name: "Shodmon Ko'li",
    desc: "Tog' etaklarida joylashgan sokin ko'l. Piknik va dam olish uchun ideal joy. Toza havo va ajoyib manzara.",
    location: '8 km shimol',
    tag: 'Tabiat',
    icon: Icons.water_rounded,
    color: Color(0xFF0EA5E9),
  ),
  _Place(
    name: "Qashqadaryo Vodiysi",
    desc: "Baland tog' dovonlari va yashil vodiylar. Piyoda sayohat va trekkingga mukammal marshrut.",
    location: '15 km sharq',
    tag: "Tog'",
    icon: Icons.terrain_rounded,
    color: Color(0xFF10B981),
  ),
  _Place(
    name: "Kumushkent Qal'asi",
    desc: "XIV asrga oid tarixiy qal'a xarobalari. O'rta asr arxitekturasi va boy tarix bilan tanishing.",
    location: "3 km g'arb",
    tag: 'Tarix',
    icon: Icons.castle_rounded,
    color: Color(0xFF8B5CF6),
  ),
  _Place(
    name: "Bodom Bog'i",
    desc: "Bahorda gullab-yashnagan bodom bog'lari. Mart-aprel oylarida ajoyib manzara hosil bo'ladi.",
    location: '5 km janub',
    tag: 'Tabiat',
    icon: Icons.park_rounded,
    color: Color(0xFFF59E0B),
  ),
  _Place(
    name: 'Tarixiy Masjid',
    desc: "Shahrimizning eng qadimiy binosi. Noyob naqsh va muqarnas bezaklar bilan bezatilgan.",
    location: 'Shahar markazi',
    tag: 'Madaniyat',
    icon: Icons.mosque_rounded,
    color: Color(0xFF059669),
  ),
  _Place(
    name: "Amir Temur Ko'chasi",
    desc: "Shaharning asosiy ko'chasi. Restoran, do'kon va madaniy markazlar bilan to'la.",
    location: 'Shahar markazi',
    tag: 'Shahar',
    icon: Icons.location_city_rounded,
    color: Color(0xFF6366F1),
  ),
];

class TourismScreen extends StatelessWidget {
  const TourismScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turizm'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeroBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                children: [
                  Text('Diqqatga sazovor joylar', style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Text('${_places.length} joy', style: tt.bodySmall?.copyWith(color: AppTheme.textSecondary)),
                ],
              ),
            ),
            ..._places.map((p) => _PlaceCard(place: p)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: 210,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF059669), Color(0xFF10B981)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.landscape_rounded, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "G'ozg'on Turizmi",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Tabiat va tarix — bir joyda kashf eting',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _PlaceCard extends StatelessWidget {
  final _Place place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: place.color.withValues(alpha: 0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(place.icon, size: 72, color: place.color.withValues(alpha: 0.35)),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: place.color,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      place.tag,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(place.name, style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textSecondary),
                    const SizedBox(width: 2),
                    Text(place.location, style: tt.bodySmall?.copyWith(color: AppTheme.textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  place.desc,
                  style: tt.bodySmall?.copyWith(color: AppTheme.textSecondary, height: 1.55),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: place.color,
                    side: BorderSide(color: place.color),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Icon(Icons.map_outlined, size: 16, color: place.color),
                  label: const Text("Yo'l ko'rsatish"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
