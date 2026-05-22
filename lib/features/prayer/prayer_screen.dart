import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _prayers = [
  ('Bomdod', '04:35', Icons.nightlight_round),
  ('Quyosh', '05:54', Icons.wb_sunny_outlined),
  ('Peshin', '12:35', Icons.wb_sunny_rounded),
  ('Asr', '16:55', Icons.sunny_snowing),
  ('Shom', '19:15', Icons.nights_stay_outlined),
  ('Xufton', '20:30', Icons.dark_mode_outlined),
];

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

String _countdown(DateTime now) {
  final next = (_curIdx(now) + 1) % _prayers.length;
  final nextSec = _toMin(_prayers[next].$2) * 60;
  final nowSec = now.hour * 3600 + now.minute * 60 + now.second;
  var diff = nextSec - nowSec;
  if (diff < 0) diff += 86400;
  final h = (diff ~/ 3600).toString().padLeft(2, '0');
  final m = ((diff % 3600) ~/ 60).toString().padLeft(2, '0');
  final s = (diff % 60).toString().padLeft(2, '0');
  return '$h:$m:$s';
}

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});
  @override
  State<PrayerScreen> createState() => _State();
}

class _State extends State<PrayerScreen> {
  late DateTime _now;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = _curIdx(_now);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namoz Vaqti'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Header(now: _now, idx: idx),
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
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DateTime now;
  final int idx;
  const _Header({required this.now, required this.idx});

  @override
  Widget build(BuildContext context) {
    final next = (idx + 1) % _prayers.length;
    final nextName = _prayers[next].$1;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
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
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded, color: Colors.white60, size: 14),
                    const SizedBox(width: 4),
                    const Text(
                      "G'ozg'on shahri",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const Spacer(),
                    const Icon(Icons.mosque_rounded, color: Colors.white38, size: 22),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Joriy namoz',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _prayers[idx].$1,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          _prayers[idx].$2,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$nextName gacha',
                          style: const TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _countdown(now),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
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
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: isCurrent ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isCurrent
                  ? AppTheme.primary.withValues(alpha: 0.3)
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
                  ? Colors.white.withValues(alpha: 0.2)
                  : AppTheme.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: isCurrent ? Colors.white : AppTheme.primary,
              size: 20,
            ),
          ),
          title: Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: isCurrent ? Colors.white : AppTheme.textPrimary,
            ),
          ),
          trailing: Text(
            time,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isCurrent ? Colors.white : AppTheme.primary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}
