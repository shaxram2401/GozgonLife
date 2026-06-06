import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

// ── Brand palette ──────────────────────────────────────────
const _purple = Color(0xFF7C3AED);
const _purpleDeep = Color(0xFF4A148C);

const _statuses = ['Barchasi', 'Qabulda', 'Jarayonda', 'Yakunlangan'];

const _statusColors = {
  'Qabulda': Color(0xFF6366F1),
  'Jarayonda': Color(0xFFF59E0B),
  'Yakunlangan': Color(0xFF10B981),
};

const _statusIcons = {
  'Qabulda': Icons.inbox_rounded,
  'Jarayonda': Icons.autorenew_rounded,
  'Yakunlangan': Icons.check_circle_rounded,
};

Color _statusColor(String s) => s == 'Barchasi' ? _purple : (_statusColors[s] ?? _purple);

// ── Premium panel dekoratsiyasi ─────────────────────────────
BoxDecoration _panel(BuildContext c, Color accent, {double radius = 20, double borderW = 1.8, double glow = 1}) {
  final dark = Theme.of(c).brightness == Brightness.dark;
  final colors = dark
      ? [Color.lerp(accent, const Color(0xFF0B0F16), 0.70)!, Color.lerp(accent, const Color(0xFF0B0F16), 0.84)!]
      : [
          Color.alphaBlend(accent.withValues(alpha: 0.05), Colors.white),
          Color.alphaBlend(accent.withValues(alpha: 0.14), Colors.white),
        ];
  return BoxDecoration(
    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: accent.withValues(alpha: dark ? 0.75 : 0.5), width: borderW),
    boxShadow: [
      BoxShadow(color: accent.withValues(alpha: (dark ? 0.40 : 0.28) * glow), blurRadius: 13, spreadRadius: -2),
      BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.35 : 0.10), blurRadius: 10, offset: const Offset(0, 5)),
    ],
  );
}

class _Appeal {
  final String title, category, status, date, number;
  final IconData icon;
  const _Appeal({
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.number,
    required this.icon,
  });
}

final _appeals = [
  const _Appeal(
    title: "Ko'chada chuqurlar ta'mirlanmagan",
    category: "Yo'l va transport",
    status: 'Jarayonda',
    date: '18 may 2026',
    number: 'MRJ-2026-001',
    icon: Icons.directions_car_rounded,
  ),
  const _Appeal(
    title: 'Suv ta\'minoti uzilgan, 3 kundan beri suv yo\'q',
    category: 'Kommunal xizmatlar',
    status: 'Qabulda',
    date: '19 may 2026',
    number: 'MRJ-2026-002',
    icon: Icons.water_drop_rounded,
  ),
  const _Appeal(
    title: 'Mahalliy klinikada navbat muammosi',
    category: 'Tibbiyot',
    status: 'Yakunlangan',
    date: '10 may 2026',
    number: 'MRJ-2026-003',
    icon: Icons.local_hospital_rounded,
  ),
  const _Appeal(
    title: 'Soliq to\'lovida texnik xatolik',
    category: 'Soliq',
    status: 'Yakunlangan',
    date: '05 may 2026',
    number: 'MRJ-2026-004',
    icon: Icons.account_balance_rounded,
  ),
  const _Appeal(
    title: 'Ruxsatsiz qurilish ob\'ekti',
    category: 'Qurilish',
    status: 'Jarayonda',
    date: '15 may 2026',
    number: 'MRJ-2026-005',
    icon: Icons.construction_rounded,
  ),
  const _Appeal(
    title: "Bog'da daraxtlar kesilgan",
    category: "Ko'kalamzorlashtirish",
    status: 'Qabulda',
    date: '20 may 2026',
    number: 'MRJ-2026-006',
    icon: Icons.park_rounded,
  ),
  const _Appeal(
    title: 'Mahalla yig\'iniga chaqiruv bo\'yicha savol',
    category: 'Boshqa masalalar',
    status: 'Yakunlangan',
    date: '01 may 2026',
    number: 'MRJ-2026-007',
    icon: Icons.help_rounded,
  ),
];

const _cats = [
  ("Yo'l va transport", Icons.directions_car_rounded),
  ('Kommunal xizmatlar', Icons.water_drop_rounded),
  ('Tibbiyot', Icons.local_hospital_rounded),
  ('Soliq', Icons.account_balance_rounded),
  ('Qurilish', Icons.construction_rounded),
  ("Ko'kalamzorlashtirish", Icons.park_rounded),
  ('Boshqa masalalar', Icons.help_rounded),
];

class AppealsScreen extends StatefulWidget {
  const AppealsScreen({super.key});
  @override
  State<AppealsScreen> createState() => _State();
}

class _State extends State<AppealsScreen> {
  String _status = 'Barchasi';
  bool _showNew = false;

  List<_Appeal> get _filtered => _status == 'Barchasi'
      ? _appeals
      : _appeals.where((a) => a.status == _status).toList();

  @override
  Widget build(BuildContext context) {
    final list = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'c_appeals')),
        backgroundColor: _purpleDeep,
        foregroundColor: Colors.white,
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      floatingActionButton: _Fab(open: _showNew, onTap: () => setState(() => _showNew = !_showNew)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Banner(onTap: () => setState(() => _showNew = !_showNew)),
            const SizedBox(height: 14),
            _StatusTabs(active: _status, onTap: (s) => setState(() => _status = s)),
            if (_showNew) _NewAppealForm(onClose: () => setState(() => _showNew = false)),
            _SectionHeader(title: tr(context, 'ap_mine'), badge: '${list.length}'),
            if (list.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('Murojaatlar topilmadi', style: TextStyle(color: AppTheme.ts(context)))),
              )
            else
              ...list.map((a) => _AppealCard(appeal: a)),
            _SectionHeader(title: tr(context, 'ap_categories')),
            ..._cats.map((c) => _CatTile(name: c.$1, icon: c.$2)),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;
  const _Fab({required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF9F67FF), _purple]),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(color: _purple.withValues(alpha: 0.5), blurRadius: 16, offset: const Offset(0, 6)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(open ? Icons.close_rounded : Icons.add_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(tr(context, 'ap_new'), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      );
}

class _Banner extends StatelessWidget {
  final VoidCallback onTap;
  const _Banner({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/images/murojat2.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}

class _StatusTabs extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTap;
  const _StatusTabs({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          children: _statuses.map((s) {
            final sel = s == active;
            final color = _statusColor(s);
            return GestureDetector(
              onTap: () => onTap(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 9),
                padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
                decoration: BoxDecoration(
                  gradient: sel
                      ? LinearGradient(colors: [Color.lerp(color, Colors.white, 0.18)!, color])
                      : null,
                  color: sel ? null : AppTheme.card(context),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: sel ? color : AppTheme.dv(context), width: 1.4),
                  boxShadow: sel
                      ? [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 10, offset: const Offset(0, 4))]
                      : null,
                ),
                child: Text(
                  tr(context, s),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                    color: sel ? Colors.white : AppTheme.ts(context),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String? badge;
  const _SectionHeader({required this.title, this.badge});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF9F67FF), _purple]),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: AppTheme.tp(context))),
            if (badge != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: _purple.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
                child: Text(badge!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _purple)),
              ),
            ],
          ],
        ),
      );
}

class _AppealCard extends StatelessWidget {
  final _Appeal appeal;
  const _AppealCard({required this.appeal});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final sColor = _statusColor(appeal.status);
    final sIcon = _statusIcons[appeal.status] ?? Icons.info_rounded;
    final textPrimary = dark ? Colors.white : AppTheme.textPrimary;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: _panel(context, sColor),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon tile — gradient
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color.lerp(sColor, Colors.white, 0.2)!, sColor],
                    ),
                    borderRadius: BorderRadius.circular(13),
                    boxShadow: [BoxShadow(color: sColor.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Icon(appeal.icon, color: Colors.white, size: 21),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, appeal.category),
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: dark ? Colors.white70 : AppTheme.textSecondary),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        appeal.number,
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: dark ? Colors.white54 : AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
                // Status badge — gradient pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Color.lerp(sColor, Colors.white, 0.15)!, sColor]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: sColor.withValues(alpha: 0.4), blurRadius: 7, offset: const Offset(0, 3))],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(sIcon, size: 12, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        tr(context, appeal.status),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tr(context, appeal.title),
              style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, height: 1.3, color: textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 9),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 12, color: dark ? Colors.white54 : AppTheme.textSecondary),
                const SizedBox(width: 5),
                Text(
                  appeal.date,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: dark ? Colors.white54 : AppTheme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CatTile extends StatelessWidget {
  final String name;
  final IconData icon;
  const _CatTile({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: _panel(context, _purple, radius: 16, borderW: 1.4, glow: 0.7),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF9F67FF), _purple]),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: Icon(icon, color: Colors.white, size: 21),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(tr(context, name),
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: dark ? Colors.white : AppTheme.textPrimary)),
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: _purple.withValues(alpha: 0.12), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_right_rounded, color: _purple, size: 19),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewAppealForm extends StatelessWidget {
  final VoidCallback onClose;
  const _NewAppealForm({required this.onClose});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: _panel(context, _purple, glow: 0.9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.edit_note_rounded, color: _purple, size: 22),
                const SizedBox(width: 8),
                Text(tr(context, 'ap_new'), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppTheme.tp(context))),
                const Spacer(),
                GestureDetector(onTap: onClose, child: Icon(Icons.close_rounded, size: 20, color: AppTheme.ts(context))),
              ],
            ),
            const SizedBox(height: 14),
            TextField(decoration: InputDecoration(hintText: tr(context, 'ap_subject'), prefixIcon: const Icon(Icons.title_rounded, color: _purple))),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(hintText: tr(context, 'ap_detail'), prefixIcon: const Icon(Icons.description_outlined, color: _purple), alignLabelWithHint: true),
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF9F67FF), _purple]),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.45), blurRadius: 12, offset: const Offset(0, 5))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(tr(context, 'send'), style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
