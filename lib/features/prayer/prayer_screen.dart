import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/premium_page.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

const _prayers = [
  ('Bomdod', '04:35', Icons.nightlight_round),
  ('Quyosh', '05:54', Icons.wb_sunny_outlined),
  ('Peshin', '12:35', Icons.wb_sunny_rounded),
  ('Asr', '16:55', Icons.sunny_snowing),
  ('Shom', '19:15', Icons.nights_stay_outlined),
  ('Xufton', '20:30', Icons.dark_mode_outlined),
];

// Banner-teal yashil — light: to'q, dark: och
Color _green(BuildContext c) => Theme.of(c).brightness == Brightness.dark
    ? const Color(0xFF34D399)
    : const Color(0xFF0F766E);

int _toMin(String t) {
  final p = t.split(':');
  return int.parse(p[0]) * 60 + int.parse(p[1]);
}

int _curIdx(DateTime now) {
  final cur = now.hour * 60 + now.minute;
  for (int i = _prayers.length - 1; i >= 0; i--) {
    if (cur >= _toMin(_prayers[i].$2)) return i;
  }
  return _prayers.length - 1;
}

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _State();
}

class _State extends State<PrayerScreen> {
  late DateTime _now;
  late Timer _timer;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
    final show = shouldShowSkeleton('prayer');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'prayer_title'),
        accent: AppColors.prayer,
        showBar: false,
        floatingButton: false,
        body: Column(
          children: [
            PremiumHeader(
                title: tr(context, 'prayer_title'),
                accent: AppColors.prayer),
            const Expanded(child: _PrayerSkeleton()),
          ],
        ),
      );
    }
    final idx = _curIdx(_now);
    return PremiumScaffold(
      title: tr(context, 'prayer_title'),
      accent: AppColors.prayer,
      showBar: false,
      floatingButton: false,
      body: Column(
        children: [
          PremiumHeader(
              title: tr(context, 'prayer_title'),
              accent: AppColors.prayer),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const PremiumBanner(
                    image: 'assets/images/namoz3.png',
                    aspectRatio: 1672 / 941),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: List.generate(_prayers.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _Tile(
                          name: _prayers[i].$1,
                          time: _prayers[i].$2,
                          icon: _prayers[i].$3,
                          isCurrent: i == idx,
                        ),
                      );
                    }),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 28),
                  child: _QiblaCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Qibla: G'ozg'on koordinatalaridan Makka tomon yo'nalish ──
const _lat = 40.62 * math.pi / 180; // G'ozg'on
const _lon = 65.48 * math.pi / 180;
const _mLat = 21.4225 * math.pi / 180; // Makka (Ka'ba)
const _mLon = 39.8262 * math.pi / 180;

/// Qibla azimuti (gradusda, shimoldan soat yo'nalishida).
double get _qiblaBearing {
  final dLon = _mLon - _lon;
  final y = math.sin(dLon);
  final x = math.cos(_lat) * math.tan(_mLat) - math.sin(_lat) * math.cos(dLon);
  var deg = math.atan2(y, x) * 180 / math.pi;
  if (deg < 0) deg += 360;
  return deg;
}

/// Pastki karta — bosilganda qibla kompasi ochiladi.
class _QiblaCard extends StatelessWidget {
  const _QiblaCard();

  @override
  Widget build(BuildContext context) {
    final green = _green(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (_) => const _QiblaSheet(),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: green.withValues(alpha: 0.45), width: 1.4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.28 : 0.07),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: green.withValues(alpha: dark ? 0.20 : 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Image.asset('assets/images/icons/qibla.png',
                  fit: BoxFit.contain),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qiblani topish',
                      style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: AppTheme.tp(context))),
                  const SizedBox(height: 3),
                  Text('Kompas orqali Ka\'ba yo\'nalishini aniqlang',
                      style: TextStyle(
                          fontSize: 12, color: AppTheme.ts(context))),
                ],
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: green.withValues(alpha: dark ? 0.26 : 0.14),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.explore_rounded, color: green, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

/// Qibla kompasi — bottom sheet. Strelka shimoldan qibla azimutiga buriladi.
class _QiblaSheet extends StatelessWidget {
  const _QiblaSheet();

  @override
  Widget build(BuildContext context) {
    final green = _green(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bearing = _qiblaBearing; // ~236° — janubi-g'arb
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tutqich
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.ts(context).withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          Text('Qibla yo\'nalishi',
              style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppTheme.tp(context))),
          const SizedBox(height: 4),
          Text("G'ozg'on shahri uchun",
              style: TextStyle(fontSize: 13, color: AppTheme.ts(context))),
          const SizedBox(height: 22),
          // ── Kompas ──
          SizedBox(
            width: 250,
            height: 250,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(250, 250),
                  painter: _CompassDial(
                    dark: dark,
                    accent: green,
                    textColor: AppTheme.tp(context),
                  ),
                ),
                // Qibla strelkasi + Ka'ba belgisi (azimutga burilgan)
                Transform.rotate(
                  angle: bearing * math.pi / 180,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Ka'ba ikonkasi — tik turishi uchun teskari buriladi
                      Transform.rotate(
                        angle: -bearing * math.pi / 180,
                        child: Container(
                          width: 44,
                          height: 44,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: AppTheme.card(context),
                            shape: BoxShape.circle,
                            border: Border.all(color: green, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: green.withValues(alpha: 0.45),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Image.asset(
                              'assets/images/icons/qibla.png',
                              fit: BoxFit.contain),
                        ),
                      ),
                      // Strelka tanasi
                      Container(
                        width: 4,
                        height: 62,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              green,
                              green.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 62 + 44.0), // markazga balans
                    ],
                  ),
                ),
                // Markaz nuqta
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: green,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppTheme.card(context), width: 2.5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Daraja ko'rsatkichi
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: green.withValues(alpha: dark ? 0.18 : 0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: green.withValues(alpha: 0.35)),
            ),
            child: Text(
              "${bearing.round()}° — janubi-g'arbiy yo'nalish",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: green),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            "Telefonni tekis ushlab, yuqori tomonini shimolga (N) qarating — Ka'ba belgisi qibla tomonni ko'rsatadi.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.5, height: 1.5, color: AppTheme.ts(context)),
          ),
        ],
      ),
    );
  }
}

/// Kompas shkalasi — doira, gradus chiziqchalari va N/E/S/W harflari.
class _CompassDial extends CustomPainter {
  final bool dark;
  final Color accent;
  final Color textColor;
  const _CompassDial(
      {required this.dark, required this.accent, required this.textColor});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    // Tashqi doira
    canvas.drawCircle(
        c,
        r - 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = accent.withValues(alpha: 0.35));
    // Ichki xira doira
    canvas.drawCircle(
        c,
        r - 34,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = textColor.withValues(alpha: 0.10));

    // Chiziqchalar: har 15° — mayda, har 90° — yo'g'on
    for (int d = 0; d < 360; d += 15) {
      final rad = d * math.pi / 180;
      final main = d % 90 == 0;
      final p1 = c +
          Offset(math.sin(rad), -math.cos(rad)) * (r - 6);
      final p2 = c +
          Offset(math.sin(rad), -math.cos(rad)) *
              (r - (main ? 20.0 : 13.0));
      canvas.drawLine(
          p1,
          p2,
          Paint()
            ..strokeWidth = main ? 3 : 1.4
            ..strokeCap = StrokeCap.round
            ..color = main
                ? accent.withValues(alpha: 0.8)
                : textColor.withValues(alpha: 0.30));
    }

    // N / E / S / W harflari
    const dirs = [('N', 0), ('E', 90), ('S', 180), ('W', 270)];
    for (final (label, deg) in dirs) {
      final rad = deg * math.pi / 180;
      final pos = c + Offset(math.sin(rad), -math.cos(rad)) * (r - 32);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: deg == 0 ? accent : textColor.withValues(alpha: 0.65),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos - Offset(tp.width / 2, tp.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant _CompassDial old) =>
      old.dark != dark || old.accent != accent;
}

class _Tile extends StatelessWidget {
  final String name, time;
  final IconData icon;
  final bool isCurrent;
  const _Tile({
    required this.name,
    required this.time,
    required this.icon,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final green = _green(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Faol qatordagi matn — och yashil fonda qora, to'q yashilda oq
    final onActive = dark ? Colors.black87 : Colors.white;
    return Container(
      decoration: BoxDecoration(
        color: isCurrent ? green : AppTheme.card(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isCurrent
                ? green.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCurrent
                ? onActive.withValues(alpha: 0.2)
                : green.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isCurrent ? onActive : green,
            size: 20,
          ),
        ),
        title: Text(
          tr(context, name),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isCurrent ? onActive : AppTheme.tp(context),
          ),
        ),
        trailing: Text(
          time,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isCurrent ? onActive : green,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

class _PrayerSkeleton extends StatelessWidget {
  const _PrayerSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: skBox(h: 250, r: 30),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    for (int i = 0; i < 6; i++) ...[
                      skBox(h: 64, r: 14),
                      const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
