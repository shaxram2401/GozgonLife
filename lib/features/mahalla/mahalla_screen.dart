import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

// ── Brand palette ──────────────────────────────────────────
const _blue = Color(0xFF0EA5E9);
const _blueLight = Color(0xFF38BDF8);
const _blueDeep = Color(0xFF0369A1);

const _mfyList = [
  (name: 'Marmarobod MFY', address: "Marmarobod ko'chasi 12", phone: '+998 75 221 10 01', women: 847),
  (name: 'Shayxon MFY',    address: "Mustaqillik ko'chasi 34", phone: '+998 75 221 10 02', women: 624),
  (name: 'Tumar MFY',      address: "Amir Temur ko'chasi 7",   phone: '+998 75 221 10 03', women: 712),
  (name: 'Guliston MFY',   address: "Bog'ishamol ko'chasi 18", phone: '+998 75 221 10 04', women: 539),
];

class MahallaScreen extends StatefulWidget {
  const MahallaScreen({super.key});
  @override
  State<MahallaScreen> createState() => _MahallaScreenState();
}

class _MahallaScreenState extends State<MahallaScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final show = shouldShowSkeleton('mahalla');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'c_mahalla'),
        accent: _blueDeep,
        immersive: true,
        body: const _MahallaSkeleton(),
      );
    }
    final totalWomen =
        _mfyList.fold<int>(0, (s, m) => s + m.women);
    return PremiumScaffold(
      title: tr(context, 'c_mahalla'),
      accent: _blueDeep,
      immersive: true,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: _blue,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const _Banner(),
            const SizedBox(height: 16),
            // ── Statistika kartalari ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      icon: Icons.home_work_rounded,
                      value: '${_mfyList.length}',
                      label: tr(context, 'mh_count'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      icon: Icons.groups_rounded,
                      value: _grouped(totalWomen),
                      label: tr(context, 'mh_women_total'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionTitle(
                icon: Icons.location_city_rounded,
                title: tr(context, 'mh_list')),
            const SizedBox(height: 4),
            ..._mfyList.map((m) => Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: _MfyCard(mfy: m),
                )),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // 2722 → "2 722"
  static String _grouped(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}

// ── Banner ───────────────────────────────────────────────────
class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            Localizations.localeOf(context).languageCode == 'ru'
                ? 'assets/images/mahallaru.png'
                : 'assets/images/mahallauz.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _StatCard(
      {required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.dv(context).withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_blueLight, _blue]),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: _blue.withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppTheme.tp(context))),
                ),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ts(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_blueLight, _blue]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.tp(context))),
          ],
        ),
      );
}

class _MfyCard extends StatefulWidget {
  final ({String name, String address, String phone, int women}) mfy;
  const _MfyCard({required this.mfy});

  @override
  State<_MfyCard> createState() => _MfyCardState();
}

class _MfyCardState extends State<_MfyCard> {
  bool _pressed = false;

  void _call() => launchUrl(Uri.parse('tel:${widget.mfy.phone}'));

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    const c = _blue;
    final cLight = Color.lerp(c, Colors.white, 0.18)!;
    final cDark = Color.lerp(c, Colors.black, 0.22)!;
    final panelColors = dark
        ? [
            Color.lerp(c, const Color(0xFF0B0F16), 0.70)!,
            Color.lerp(c, const Color(0xFF0B0F16), 0.84)!,
          ]
        : [
            Color.alphaBlend(c.withValues(alpha: 0.05), Colors.white),
            Color.alphaBlend(c.withValues(alpha: 0.15), Colors.white),
          ];
    return AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: panelColors),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c, width: 2.2),
          boxShadow: [
            BoxShadow(
                color: c.withValues(alpha: 0.40),
                blurRadius: 14,
                spreadRadius: -1),
            BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.35 : 0.12),
                blurRadius: 12,
                offset: const Offset(0, 6)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Ikonka plitkasi
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_blueLight, _blueDeep]),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                            color: c.withValues(alpha: 0.45),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Icon(Icons.home_work_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tr(context, widget.mfy.name),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.15,
                              color: AppTheme.tp(context)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded,
                                size: 14,
                                color: dark
                                    ? Color.lerp(c, Colors.white, 0.45)!
                                    : c),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                tr(context, widget.mfy.address),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.ts(context)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                  height: 1.2,
                  color: AppTheme.dv(context).withValues(alpha: 0.8)),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Aholi soni
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 7),
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: dark ? 0.22 : 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.groups_rounded,
                            size: 16,
                            color: dark
                                ? Color.lerp(c, Colors.white, 0.45)!
                                : _blueDeep),
                        const SizedBox(width: 6),
                        Text(
                          tr(context, 'mh_women')
                              .replaceAll('{n}', '${widget.mfy.women}'),
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: dark
                                  ? Color.lerp(c, Colors.white, 0.45)!
                                  : _blueDeep),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  // Qo'ng'iroq tugmasi
                  GestureDetector(
                    onTap: _call,
                    onTapDown: (_) => setState(() => _pressed = true),
                    onTapUp: (_) => setState(() => _pressed = false),
                    onTapCancel: () => setState(() => _pressed = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 11),
                      decoration: BoxDecoration(
                        color: dark ? Colors.white : null,
                        gradient: dark
                            ? null
                            : LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [cLight, cDark]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: (dark ? Colors.black : c)
                                  .withValues(alpha: dark ? 0.45 : 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.phone_in_talk_rounded,
                              color: dark ? c : Colors.white, size: 18),
                          const SizedBox(width: 7),
                          Text(
                            tr(context, 'mh_call'),
                            style: TextStyle(
                                color: dark ? c : Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MahallaSkeleton extends StatelessWidget {
  const _MahallaSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            skBox(h: 200, r: 0),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: [
                Expanded(child: skBox(h: 70, r: 18)),
                const SizedBox(width: 12),
                Expanded(child: skBox(h: 70, r: 18)),
              ]),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: [
                skBox(h: 16, w: 140),
                const SizedBox(height: 12),
                for (int i = 0; i < 4; i++) ...[
                  skBox(h: 116, r: 20),
                  const SizedBox(height: 12)
                ],
              ]),
            ),
          ],
        ),
      );
}
