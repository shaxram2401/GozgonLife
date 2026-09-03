import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

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
  if (code == 0) return (Icons.wb_sunny_rounded, 'wx_sunny', const Color(0xFFFBBF24));
  if (code <= 2) return (Icons.wb_sunny_rounded, 'wx_mostly_sunny', const Color(0xFFFBBF24));
  if (code == 3) return (Icons.wb_cloudy_rounded, 'wx_cloudy', const Color(0xFF94A3B8));
  if (code <= 48) return (Icons.cloud_rounded, 'wx_fog', const Color(0xFF94A3B8));
  if (code <= 67) return (Icons.grain_rounded, 'wx_rain', const Color(0xFF60A5FA));
  if (code <= 77) return (Icons.ac_unit_rounded, 'wx_snow', const Color(0xFFBAE6FD));
  if (code <= 82) return (Icons.grain_rounded, 'wx_rain', const Color(0xFF60A5FA));
  return (Icons.thunderstorm_rounded, 'wx_thunder', const Color(0xFF818CF8));
}

/// Returns a translation key for the day label.
String _dayLabel(String dateStr, int i) {
  if (i == 0) return 'wx_today';
  if (i == 1) return 'wx_tomorrow';
  return 'wd_${DateTime.parse(dateStr).weekday}';
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
      label: i == 0 ? 'wx_now' : t,
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
      if (mounted) setState(() { _error = 'wx_error'; _loading = false; });
    }
  }

  @override
  void dispose() { _dio.close(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: tr(context, 'd_weather'),
      actions: [PremiumBarAction(icon: Icons.refresh_rounded, onTap: _fetch)],
      body: _loading
          ? const _WeatherSkeleton()
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_off_rounded, size: 56, color: AppTheme.ts(context)),
                      const SizedBox(height: 12),
                      Text(tr(context, _error!), style: TextStyle(color: AppTheme.ts(context))),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _fetch, child: Text(tr(context, 'retry'))),
                    ],
                  ),
                )
              : Builder(builder: (context) {
                  final rangeMax = _data!.daily
                      .fold<double>(-999, (p, d) => d.max > p ? d.max : p);
                  final rangeMin = _data!.daily
                      .fold<double>(999, (p, d) => d.min < p ? d.min : p);
                  // Bu ekranda ma'lumot haqiqiy — pastga tortilganda
                  // chinakam yangi so'rov yuboriladi.
                  return RefreshIndicator(
                    onRefresh: _fetch,
                    child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroCard(data: _data!),
                        const SizedBox(height: 8),
                        _SectionTitle(tr(context, 'wx_hourly')),
                        _HourlyRow(items: _data!.hourly),
                        _SectionTitle(tr(context, 'wx_7day')),
                        ..._data!.daily.map((d) => _DayRow(
                            item: d, rangeMin: rangeMin, rangeMax: rangeMax)),
                        const SizedBox(height: 24),
                      ],
                    ),
                    ),
                  );
                }),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final _WeatherData data;
  const _HeroCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final (icon, desc, accent) = _info(data.code);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.45),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/weat.png',
                  fit: BoxFit.cover, filterQuality: FilterQuality.high),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.primary.withValues(alpha: 0.62),
                      const Color(0xFF1D4ED8).withValues(alpha: 0.34),
                      Colors.black.withValues(alpha: 0.48),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.28)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on_rounded,
                            color: Colors.white, size: 15),
                        const SizedBox(width: 5),
                        Text(tr(context, 'wx_city'),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('+${data.temp.round()}°',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 76,
                                  fontWeight: FontWeight.w200,
                                  height: 0.95,
                                  letterSpacing: -2)),
                          const SizedBox(height: 4),
                          Text(tr(context, desc),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(
                              '${tr(context, 'wx_min')}: +${data.dailyMin.round()}°',
                              style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.78),
                                  fontSize: 13)),
                        ],
                      ),
                      const Spacer(),
                      Icon(icon, color: accent, size: 78, shadows: [
                        Shadow(
                            color: accent.withValues(alpha: 0.6),
                            blurRadius: 26),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.20)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _Stat(Icons.air_rounded, '${data.wind.round()} km/h',
                            tr(context, 'w_wind')),
                        const _VDiv(),
                        _Stat(Icons.thermostat_rounded,
                            '+${data.dailyMin.round()}°', tr(context, 'wx_min')),
                        const _VDiv(),
                        _Stat(Icons.wb_sunny_outlined, '+${data.temp.round()}°',
                            tr(context, 'wx_now')),
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

class _VDiv extends StatelessWidget {
  const _VDiv();
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 32, color: Colors.white.withValues(alpha: 0.22));
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppTheme.secondary, AppTheme.primary],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(text,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: AppTheme.tp(context))),
          ],
        ),
      );
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
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
        height: 104,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: items.length,
          itemBuilder: (_, i) {
            final h = items[i];
            final isNow = h.label == 'wx_now';
            final (icon, _, color) = _info(h.code);
            return Container(
              width: 70,
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: isNow
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [AppTheme.secondary, AppTheme.primary],
                      )
                    : null,
                color: isNow ? null : Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(18),
                border: isNow
                    ? null
                    : Border.all(
                        color: AppTheme.primary.withValues(alpha: 0.10)),
                boxShadow: [
                  BoxShadow(
                    color: isNow
                        ? AppTheme.primary.withValues(alpha: 0.35)
                        : Colors.black.withValues(alpha: dark ? 0.28 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(isNow ? tr(context, 'wx_now') : h.label,
                      style: TextStyle(fontSize: 11, color: isNow ? Colors.white70 : AppTheme.ts(context))),
                  const SizedBox(height: 6),
                  Icon(icon, color: isNow ? Colors.white : color, size: 22),
                  const SizedBox(height: 6),
                  Text('+${h.temp.round()}°',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isNow ? Colors.white : AppTheme.tp(context))),
                ],
              ),
            );
          },
        ),
      );
  }
}

class _DayRow extends StatelessWidget {
  final ({String label, double max, double min, int code}) item;
  final double rangeMin, rangeMax;
  const _DayRow(
      {required this.item, required this.rangeMin, required this.rangeMax});

  @override
  Widget build(BuildContext context) {
    final (icon, _, color) = _info(item.code);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final span = (rangeMax - rangeMin).clamp(1.0, double.infinity);
    final lo = ((item.min - rangeMin) / span).clamp(0.0, 1.0);
    final hi = ((item.max - rangeMin) / span).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(tr(context, item.label),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13.5)),
          ),
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Text('+${item.min.round()}°',
              style: TextStyle(
                  color: AppTheme.ts(context),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 10),
          Expanded(
            child: LayoutBuilder(builder: (_, c) {
              final w = c.maxWidth;
              return SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.divider,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Positioned(
                      left: w * lo,
                      width: (w * (hi - lo)).clamp(8.0, w),
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF60A5FA), Color(0xFFFBBF24)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(width: 10),
          Text('+${item.max.round()}°',
              style: const TextStyle(
                  fontWeight: FontWeight.w800, fontSize: 13.5)),
        ],
      ),
    );
  }
}

class _WeatherSkeleton extends StatelessWidget {
  const _WeatherSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              skBox(h: 200, r: 24),
              const SizedBox(height: 16),
              Row(children: List.generate(4, (_) => Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 8), child: skBox(h: 70, r: 12)),
              ))),
              const SizedBox(height: 16),
              skBox(h: 14, w: 100),
              const SizedBox(height: 12),
              for (int i = 0; i < 5; i++) ...[skBox(h: 56, r: 12), const SizedBox(height: 8)],
            ],
          ),
        ),
      );
}
