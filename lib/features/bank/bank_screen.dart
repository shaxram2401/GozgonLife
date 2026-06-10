import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skeleton.dart';

// ── Brand palette ──────────────────────────────────────────
const _green = Color(0xFF0B6E4F);
const _greenLight = Color(0xFF10B981);
const _greenDeep = Color(0xFF064E3B);

const _banks = [
  (name: "O'zmilliybank",               logo: 'assets/images/icons/nbu.png',    phone: '1344', color: Color(0xFF1E3A8A)), // to'q ko'k
  (name: 'Mikrokreditbank',              logo: 'assets/images/icons/mk.png',     phone: '1285', color: Color(0xFF059669)), // yashil
  (name: 'Aloqabank',                    logo: 'assets/images/icons/aloqa.png',  phone: '1144', color: Color(0xFF075985)), // to'q ko'k
  (name: 'Agrobank',                     logo: 'assets/images/icons/agro.png',   phone: '1216', color: Color(0xFF15803D)), // qoramtir yashil
  (name: 'Asakabank',                    logo: 'assets/images/icons/asaka.png',  phone: '1152', color: Color(0xFFDC2626)), // qizil
  (name: 'Turonbank',                    logo: 'assets/images/icons/tr.png',     phone: '1220', color: Color(0xFF1E40AF)), // qoramtir ko'k
  (name: 'Hamkorbank',                   logo: 'assets/images/icons/hamkor.png', phone: '1256', color: Color(0xFF16A34A)), // yashil
  (name: 'Sanoat Qurilish Bank',         logo: 'assets/images/icons/sqb.png',    phone: '1180', color: Color(0xFF1E3A8A)), // qoramtir ko'k
  (name: "Ipak Yo'li Bank",              logo: 'assets/images/icons/ipak.png',   phone: '1296', color: Color(0xFF047857)), // to'q yashil
  (name: 'Xalq Banki',                   logo: 'assets/images/icons/xalq.png',   phone: '1106', color: Color(0xFF065F46)), // qoramtir yashil
  (name: 'Ipoteka Bank',                 logo: 'assets/images/icons/ip.png',     phone: '1233', color: Color(0xFF047857)), // to'q yashil
  (name: 'Uzum Bank',                    logo: 'assets/images/icons/uzum.png',   phone: '1136', color: Color(0xFF6D28D9)), // to'q binafsha
  (name: 'Infin Bank',                   logo: 'assets/images/icons/infin.png',  phone: '1214', color: Color(0xFF1E40AF)), // to'q ko'k
  (name: 'Biznesni Rivojlantirish banki',logo: 'assets/images/icons/bz.png',     phone: '1254', color: Color(0xFFDC2626)), // qizil
  (name: 'Kapitalbank',                  logo: 'assets/images/icons/kapital.png',phone: '1340', color: Color(0xFFCA8A04)), // qoramtir sariq
  (name: 'TBC Bank',                     logo: 'assets/images/icons/tbc.png',    phone: '1150', color: Color(0xFF1E40AF)), // qoramtir ko'k
  (name: 'Anorbank',                     logo: 'assets/images/icons/anor.png',   phone: '1290', color: Color(0xFFB91C1C)), // qoramtir qizil
  (name: 'Tenge Bank',                   logo: 'assets/images/icons/tenge.png',  phone: '1245', color: Color(0xFF047857)), // to'q yashil
  (name: 'DavrBank',                     logo: 'assets/images/icons/davr.png',   phone: '1284', color: Color(0xFF1E40AF)), // qoramtir ko'k
  (name: 'Asia Alliance Bank',           logo: 'assets/images/icons/as.png',     phone: '1270', color: Color(0xFF2563EB)), // ko'k
];

const _rates = [
  (flag: '🇺🇸', code: 'USD', value: '12 850', delta: '+0.4%', up: true),
  (flag: '🇪🇺', code: 'EUR', value: '14 260', delta: '+0.2%', up: true),
  (flag: '🇷🇺', code: 'RUB', value: '160', delta: '-0.3%', up: false),
];

class BankScreen extends StatefulWidget {
  const BankScreen({super.key});
  @override
  State<BankScreen> createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  bool _loading = true;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    final show = shouldShowSkeleton('bank');
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

  Widget _toggleButton() {
    final dark = Theme.of(context).brightness == Brightness.dark;
    const c = _green;
    // Bank panellaridagi kabi fon
    final panelColors = dark
        ? [
            Color.lerp(c, const Color(0xFF0B0F16), 0.70)!,
            Color.lerp(c, const Color(0xFF0B0F16), 0.84)!,
          ]
        : [
            Color.alphaBlend(c.withValues(alpha: 0.05), Colors.white),
            Color.alphaBlend(c.withValues(alpha: 0.15), Colors.white),
          ];
    final deco = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: panelColors),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: c, width: 2.2),
      boxShadow: [
        BoxShadow(color: c.withValues(alpha: 0.45), blurRadius: 14, spreadRadius: -1),
        BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.35 : 0.14),
            blurRadius: 12,
            offset: const Offset(0, 6)),
      ],
    );
    const grad = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_greenLight, _green]);

    if (_expanded) {
      // Faqat ptichka — panel uslubidagi yumaloq tugma
      return Center(
        child: GestureDetector(
          onTap: () => setState(() => _expanded = false),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: deco.gradient,
              shape: BoxShape.circle,
              border: deco.border,
              boxShadow: deco.boxShadow,
            ),
            alignment: Alignment.center,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  gradient: grad,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: c.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 3)),
                  ]),
              child: const Icon(Icons.keyboard_arrow_up_rounded,
                  color: Colors.white, size: 24),
            ),
          ),
        ),
      );
    }

    // "Barcha banklar" — yozuv + tagida ptichka (iconsiz)
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _expanded = true),
      child: Column(
        children: [
          Text('Barcha banklar',
              style: TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  color: dark ? Color.lerp(c, Colors.white, 0.5)! : c)),
          const SizedBox(height: 8),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: grad,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: c.withValues(alpha: 0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 4)),
              ],
            ),
            child: const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 26),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'c_bank_short'),
        accent: _greenDeep,
        immersive: true,
        body: const _BankSkeleton(),
      );
    }
    return PremiumScaffold(
      title: tr(context, 'c_bank_short'),
      accent: _greenDeep,
      immersive: true,
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: _green,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            const _Banner(),
            const SizedBox(height: 16),
            // Premium header: sarlavha + sana
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_greenLight, _green]),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 11),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Markaziy bank kursi',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, height: 1.1, color: AppTheme.tp(context))),
                      const SizedBox(height: 2),
                      Text('Rasmiy ayirboshlash kursi',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppTheme.ts(context))),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_greenLight, _green]),
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(color: _green.withValues(alpha: 0.45), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 13),
                        const SizedBox(width: 6),
                        Text(
                          () {
                            final n = DateTime.now();
                            return '${n.day.toString().padLeft(2, '0')}.${n.month.toString().padLeft(2, '0')}.${n.year}';
                          }(),
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Kurslar — banner pastida
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  for (int i = 0; i < _rates.length; i++) ...[
                    if (i > 0) const SizedBox(width: 10),
                    Expanded(child: _RateCard(rate: _rates[i])),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 22),
            _SectionTitle(icon: Icons.account_balance_rounded, title: tr(context, 'bank_list')),
            const SizedBox(height: 4),
            ...List.generate(
              _expanded ? _banks.length : 7,
              (i) => Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: _BankCard(bank: _banks[i], index: i),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: _toggleButton(),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }
}

// ── Asil banner ─────────────────────────────────────────────
class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset('assets/images/bank2.png', fit: BoxFit.cover, alignment: Alignment.topCenter),
      ),
    );
  }
}

class _RateCard extends StatelessWidget {
  final ({String flag, String code, String value, String delta, bool up}) rate;
  const _RateCard({required this.rate});

  @override
  Widget build(BuildContext context) {
    final trend = rate.up ? _greenLight : const Color(0xFFEF4444);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.dv(context).withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(rate.flag, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 5),
              Text(rate.code, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.ts(context))),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(rate.value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.tp(context), letterSpacing: -0.5)),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: trend.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(rate.up ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded, size: 16, color: trend),
                Text(rate.delta, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: trend)),
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
                gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_greenLight, _green]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.tp(context))),
          ],
        ),
      );
}

class _BankCard extends StatefulWidget {
  final ({String name, String logo, String phone, Color color}) bank;
  final int index;
  const _BankCard({required this.bank, required this.index});

  @override
  State<_BankCard> createState() => _BankCardState();
}

class _BankCardState extends State<_BankCard> {
  bool _pressed = false;

  void _call() => launchUrl(Uri.parse('tel:${widget.bank.phone}'));

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final c = widget.bank.color;
    final cLight = Color.lerp(c, Colors.white, 0.18)!;
    final cDark = Color.lerp(c, Colors.black, 0.22)!;
    // Panel foni — light: eng och tus, dark: qop-qoramtir tus
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
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: panelColors),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: c, width: 2.2),
          boxShadow: [
            // rangli yaltiroq glow
            BoxShadow(color: c.withValues(alpha: 0.45), blurRadius: 14, spreadRadius: -1),
            // ko'tarilgan (raised) soya
            BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.35 : 0.14), blurRadius: 12, offset: const Offset(0, 6)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Row(
            children: [
              // Logo — toza oq tile
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 6, offset: const Offset(0, 3)),
                  ],
                ),
                child: Image.asset(
                  widget.bank.logo,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, e, st) => Icon(Icons.account_balance_rounded, color: c, size: 26),
                ),
              ),
              const SizedBox(width: 14),
              // Nomi + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.bank.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, height: 1.15, color: AppTheme.tp(context)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Batafsil ma'lumot",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: dark ? Color.lerp(c, Colors.white, 0.45)! : c),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Vertikal divider
              Container(width: 1.2, height: 42, color: AppTheme.dv(context).withValues(alpha: 0.8)),
              const SizedBox(width: 10),
              // Call tugmasi — gradientli pill
              GestureDetector(
                onTap: _call,
                onTapDown: (_) => setState(() => _pressed = true),
                onTapUp: (_) => setState(() => _pressed = false),
                onTapCancel: () => setState(() => _pressed = false),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: dark ? Colors.white : null,
                    gradient: dark ? null : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [cLight, cDark],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: (dark ? Colors.black : c).withValues(alpha: dark ? 0.45 : 0.5), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_in_talk_rounded, color: dark ? c : Colors.white, size: 18),
                      const SizedBox(width: 7),
                      Text(
                        widget.bank.phone,
                        style: TextStyle(color: dark ? c : Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BankSkeleton extends StatelessWidget {
  const _BankSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            skBox(h: 200, r: 0),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(children: List.generate(3, (_) => Expanded(
                child: Padding(padding: const EdgeInsets.only(right: 8), child: skBox(h: 96, r: 18)),
              ))),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(children: List.generate(6, (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: skBox(h: 84, r: 20),
              ))),
            ),
          ],
        ),
      );
}
