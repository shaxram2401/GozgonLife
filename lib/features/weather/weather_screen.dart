import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _url = 'https://api.open-meteo.com/v1/forecast'
    '?latitude=40.4969&longitude=65.6233'
    '&hourly=temperature_2m,weathercode'
    '&daily=temperature_2m_max,temperature_2m_min,weathercode'
    '&current_weather=true'
    '&timezone=Asia%2FTashkent';

class _WeatherData {
  final double temp, wind;
  final int code;
  final double dailyMin;
  final List<({String label, double temp, int code})> hourly;
  final List<({String label, double max, double min, int code})> daily;
  _WeatherData({
    required this.temp,
    required this.wind,
    required this.code,
    required this.dailyMin,
    required this.hourly,
    required this.daily,
  });
}

(IconData, String, Color) _info(int code) {
  if (code == 0) return (Icons.wb_sunny_rounded, 'Quyoshli', const Color(0xFFFBBF24));
  if (code <= 2) return (Icons.wb_sunny_rounded, 'Asosan quyoshli', const Color(0xFFFBBF24));
  if (code == 3) return (Icons.wb_cloudy_rounded, 'Bulutli', const Color(0xFF94A3B8));
  if (code <= 48) return (Icons.cloud_rounded, 'Tumanli', const Color(0xFF94A3B8));
  if (code <= 67) return (Icons.grain_rounded, "Yomg'ir", const Color(0xFF60A5FA));
  if (code <= 77) return (Icons.ac_unit_rounded, 'Qor', const Color(0xFFBAE6FD));
  if (code <= 82) return (Icons.grain_rounded, "Yomg'ir", const Color(0xFF60A5FA));
  return (Icons.thunderstorm_rounded, 'Momaqaldiroq', const Color(0xFF818CF8));
}

String _dayLabel(String dateStr, int i) {
  if (i == 0) return 'Bugun';
  if (i == 1) return 'Ertaga';
  const names = ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'];
  return names[DateTime.parse(dateStr).weekday - 1];
}

_WeatherData _parse(Map<String, dynamic> json) {
  final cw = json['current_weather'] as Map<String, dynamic>;
  final curTime = cw['time'] as String;

  final d = json['daily'] as Map<String, dynamic>;
  final dTimes = d['time'] as List;
  final dMax = d['temperature_2m_max'] as List;
  final dMin = d['temperature_2m_min'] as List;
  final dCodes = d['weathercode'] as List;
  final daily = List.generate(dTimes.length, (i) => (
    label: _dayLabel(dTimes[i] as String, i),
    max: (dMax[i] as num).toDouble(),
    min: (dMin[i] as num).toDouble(),
    code: (dCodes[i] as num).toInt(),
  ));

  final h = json['hourly'] as Map<String, dynamic>;
  final hTimes = h['time'] as List;
  final hTemps = h['temperature_2m'] as List;
  final hCodes = h['weathercode'] as List;
  int start = 0;
  for (int i = 0; i < hTimes.length; i++) {
    if ((hTimes[i] as String).compareTo(curTime) >= 0) { start = i; break; }
  }
  final hourly = List.generate(8, (i) {
    final idx = start + i;
    if (idx >= hTimes.length) return (label: '--', temp: 0.0, code: 0);
    final t = (hTimes[idx] as String).split('T')[1].substring(0, 5);
    return (
      label: i == 0 ? 'Hozir' : t,
      temp: (hTemps[idx] as num).toDouble(),
      code: (hCodes[idx] as num).toInt(),
    );
  });

  return _WeatherData(
    temp: (cw['temperature'] as num).toDouble(),
    wind: (cw['windspeed'] as num).toDouble(),
    code: (cw['weathercode'] as num).toInt(),
    dailyMin: (dMin[0] as num).toDouble(),
    hourly: hourly,
    daily: daily,
  );
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _State();
}

class _State extends State<WeatherScreen> {
  final _dio = Dio();
  _WeatherData? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() { _loading = true; _error = null; });
    try {
      final res = await _dio.get(_url);
      if (mounted) setState(() { _data = _parse(res.data); _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = "Ma'lumot yuklanmadi"; _loading = false; });
    }
  }

  @override
  void dispose() { _dio.close(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ob-havo'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
        actions: [IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: _fetch)],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_rounded, size: 56, color: AppTheme.textSecondary),
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: AppTheme.textSecondary)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _fetch, child: const Text('Qayta urinish')),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeroCard(data: _data!),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text('Soatlik prognoz',
                            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      _HourlyRow(items: _data!.hourly),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Text('7 kunlik prognoz',
                            style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      ),
                      ..._data!.daily.map((d) => _DayRow(item: d)),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final _WeatherData data;
  const _HeroCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final (icon, desc, _) = _info(data.code);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, Color(0xFF1D4ED8)],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white60, size: 16),
              SizedBox(width: 4),
              Text("G'ozg'on shahri", style: TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('+${data.temp.round()}°',
                      style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w200, height: 1)),
                  const SizedBox(height: 6),
                  Text(desc, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 2),
                  Text('Min: +${data.dailyMin.round()}°',
                      style: const TextStyle(color: Colors.white54, fontSize: 13)),
                ],
              ),
              const Spacer(),
              Icon(icon, color: const Color(0xFFFBBF24), size: 80),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat(Icons.air_rounded, '${data.wind.round()} km/h', 'Shamol'),
              _Stat(Icons.thermostat_rounded, '+${data.dailyMin.round()}°', 'Min'),
              _Stat(Icons.wb_sunny_outlined, '+${data.temp.round()}°', "Hozir"),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String value, label;
  const _Stat(this.icon, this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: Colors.white60, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      );
}

class _HourlyRow extends StatelessWidget {
  final List<({String label, double temp, int code})> items;
  const _HourlyRow({required this.items});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 96,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final h = items[i];
            final isNow = h.label == 'Hozir';
            final (icon, _, color) = _info(h.code);
            return Container(
              width: 68,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isNow ? AppTheme.primary : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(h.label,
                      style: TextStyle(fontSize: 11, color: isNow ? Colors.white70 : AppTheme.textSecondary)),
                  const SizedBox(height: 6),
                  Icon(icon, color: isNow ? Colors.white : color, size: 22),
                  const SizedBox(height: 6),
                  Text('+${h.temp.round()}°',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isNow ? Colors.white : AppTheme.textPrimary)),
                ],
              ),
            );
          },
        ),
      );
}

class _DayRow extends StatelessWidget {
  final ({String label, double max, double min, int code}) item;
  const _DayRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final (icon, _, color) = _info(item.code);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(item.label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Icon(icon, color: color, size: 22),
          const Spacer(),
          Text('+${item.min.round()}°',
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(width: 14),
          Text('+${item.max.round()}°',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}
