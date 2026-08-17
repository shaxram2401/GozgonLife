import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/premium_page.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

// ── Brand palette — AppColors.mahalla asosida (design_tokens.dart) ──
const _blue = AppColors.mahalla;
const _blueLight = Color(0xFFB45309);
const _blueDeep = Color(0xFF78350F);

typedef Mfy = ({String name, String address, String phone, int women});

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
        showBar: false,
        floatingButton: false,
        body: Column(
          children: [
            PremiumHeader(title: tr(context, 'c_mahalla'), accent: _blueDeep),
            const Expanded(child: _MahallaSkeleton()),
          ],
        ),
      );
    }
    final totalWomen =
        _mfyList.fold<int>(0, (s, m) => s + m.women);
    final bannerImg = Localizations.localeOf(context).languageCode == 'ru'
        ? 'assets/images/mxru.png'
        : 'assets/images/mxuz.png';
    return PremiumScaffold(
      title: tr(context, 'c_mahalla'),
      accent: _blueDeep,
      showBar: false,
      floatingButton: false,
      body: Column(
        children: [
          PremiumHeader(title: tr(context, 'c_mahalla'), accent: _blueDeep),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: _blue,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: [
                  PremiumBanner(image: bannerImg, aspectRatio: 1672 / 941),
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
          ),
        ],
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
                          fontSize: AppFontSize.h1,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          color: AppTheme.tp(context))),
                ),
                Text(label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppFontSize.caption,
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
                    fontSize: AppFontSize.h2,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.tp(context))),
          ],
        ),
      );
}

class _MfyCard extends StatefulWidget {
  final Mfy mfy;
  const _MfyCard({required this.mfy});

  @override
  State<_MfyCard> createState() => _MfyCardState();
}

class _MfyCardState extends State<_MfyCard> {
  bool _pressed = false;

  void _call() => launchUrl(Uri.parse('tel:${widget.mfy.phone}'));

  void _openDetail() =>
      context.push('/services/mahalla/detail', extra: widget.mfy);

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
    return GestureDetector(
      onTap: _openDetail,
      child: AnimatedScale(
      scale: _pressed ? 0.975 : 1,
      duration: const Duration(milliseconds: 120),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: panelColors),
          borderRadius: BorderRadius.circular(AppRadius.lg),
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
                              fontSize: AppFontSize.title,
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
                                    fontSize: AppFontSize.caption,
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
                              fontSize: AppFontSize.bodySmall,
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
                                fontSize: AppFontSize.body,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: skBox(h: 250, r: 30),
            ),
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

// ── Mahalla yettiligi (7 nafar mas'ul faol) ──────────────────
// Hozircha taxminiy/namunaviy ism-familiya va telefon raqamlari —
// keyinchalik mahalla ma'muriyatidan olinib almashtiriladi.
typedef _SevenMember = ({
  String role,
  String desc,
  IconData icon,
  IconData prop,
  String name,
  String phone,
});

const _seven = <_SevenMember>[
  (
    role: 'mh_role_rais',
    desc: 'mh_desc_rais',
    icon: Icons.record_voice_over_rounded,
    prop: Icons.groups_rounded,
    name: 'Ergash Yusupov',
    phone: '+998 90 123 45 01',
  ),
  (
    role: 'mh_role_hokim',
    desc: 'mh_desc_hokim',
    icon: Icons.work_rounded,
    prop: Icons.handshake_rounded,
    name: 'Bahrom Qodirov',
    phone: '+998 90 123 45 02',
  ),
  (
    role: 'mh_role_yoshlar',
    desc: 'mh_desc_yoshlar',
    icon: Icons.sports_soccer_rounded,
    prop: Icons.emoji_events_rounded,
    name: 'Sardor Nematov',
    phone: '+998 90 123 45 03',
  ),
  (
    role: 'mh_role_ayollar',
    desc: 'mh_desc_ayollar',
    icon: Icons.storefront_rounded,
    prop: Icons.handyman_rounded,
    name: 'Nodira Xolmatova',
    phone: '+998 90 123 45 04',
  ),
  (
    role: 'mh_role_profilaktika',
    desc: 'mh_desc_profilaktika',
    icon: Icons.local_police_rounded,
    prop: Icons.shield_rounded,
    name: 'Aziz Toshpulatov',
    phone: '+998 90 123 45 05',
  ),
  (
    role: 'mh_role_soliq',
    desc: 'mh_desc_soliq',
    icon: Icons.receipt_long_rounded,
    prop: Icons.calculate_rounded,
    name: 'Diyor Rashidov',
    phone: '+998 90 123 45 06',
  ),
  (
    role: 'mh_role_ijtimoiy',
    desc: 'mh_desc_ijtimoiy',
    icon: Icons.volunteer_activism_rounded,
    prop: Icons.elderly_rounded,
    name: 'Gulnora Saidova',
    phone: '+998 90 123 45 07',
  ),
];

class MahallaDetailPage extends StatelessWidget {
  final Mfy mfy;
  const MahallaDetailPage({super.key, required this.mfy});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: tr(context, mfy.name),
      accent: _blueDeep,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 15, color: _blue),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  tr(context, mfy.address),
                  style: TextStyle(
                      fontSize: AppFontSize.bodySmall,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ts(context)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(
              icon: Icons.groups_2_rounded, title: tr(context, 'mh_seven_title')),
          const SizedBox(height: 4),
          ..._seven.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _SevenCard(member: m),
              )),
        ],
      ),
    );
  }
}

class _SevenCard extends StatelessWidget {
  final _SevenMember member;
  const _SevenCard({required this.member});

  void _call() => launchUrl(Uri.parse('tel:${member.phone}'));

  void _openSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _SevenSheet(member: member),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _openSheet(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppTheme.dv(context).withValues(alpha: 0.6)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_blueLight, _blueDeep]),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(member.icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(context, member.role),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppFontSize.caption,
                        fontWeight: FontWeight.w700,
                        color: dark ? Color.lerp(_blue, Colors.white, 0.45)! : _blueDeep),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    member.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppFontSize.title,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.tp(context)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _call,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _blue.withValues(alpha: dark ? 0.22 : 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.phone_in_talk_rounded,
                    size: 18,
                    color: dark ? Color.lerp(_blue, Colors.white, 0.45)! : _blueDeep),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Katta pastdan ochiladigan oyna: tepada ism-familiya/telefon,
// o'rtada vazifa tavsifi, pastda rasm (illyustratsiya) ──────────
class _SevenSheet extends StatelessWidget {
  final _SevenMember member;
  const _SevenSheet({required this.member});

  void _call() => launchUrl(Uri.parse('tel:${member.phone}'));

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    color: AppTheme.dv(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // ── Ism-familiya va telefon raqami (tepada) ──
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: _blue.withValues(alpha: dark ? 0.22 : 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(Icons.person_rounded,
                        size: 26,
                        color: dark ? Color.lerp(_blue, Colors.white, 0.45)! : _blueDeep),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: TextStyle(
                              fontSize: AppFontSize.h2,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.tp(context)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.phone,
                          style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.ts(context)),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _call,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [_blueLight, _blueDeep]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: _blue.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.phone_in_talk_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                  height: 1.2, color: AppTheme.dv(context).withValues(alpha: 0.8)),
              const SizedBox(height: 22),
              // ── Lavozim nomi va vazifasi haqida qisqacha ma'lumot ──
              Text(
                tr(context, member.role),
                style: TextStyle(
                    fontSize: AppFontSize.h1,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.tp(context)),
              ),
              const SizedBox(height: 10),
              Text(
                tr(context, member.desc),
                style: TextStyle(
                    fontSize: AppFontSize.body,
                    height: 1.55,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.ts(context)),
              ),
              const SizedBox(height: 28),
              // ── Rasm (illyustratsiya) — pastda ──
              Center(child: _RolePicture(main: member.icon, prop: member.prop)),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lavozimni tasvirlaydigan sodda illyustratsiya — asosiy ikonka +
/// pastki burchakda kichik "belgi" ikonkasi, rasm o'rnida ishlatiladi.
class _RolePicture extends StatelessWidget {
  final IconData main;
  final IconData prop;
  const _RolePicture({required this.main, required this.prop});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_blueLight, _blueDeep]),
              borderRadius: BorderRadius.circular(46),
              boxShadow: [
                BoxShadow(
                    color: _blue.withValues(alpha: 0.45),
                    blurRadius: 26,
                    offset: const Offset(0, 12)),
              ],
            ),
            child: Icon(main, color: Colors.white, size: 96),
          ),
          Positioned(
            right: -10,
            bottom: -10,
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: _blueDeep, width: 3),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.18),
                      blurRadius: 10,
                      offset: const Offset(0, 4)),
                ],
              ),
              child: Icon(prop, color: _blueDeep, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}
