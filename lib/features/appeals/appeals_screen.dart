import 'package:flutter/material.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'c_appeals'))),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _showNew = !_showNew),
        backgroundColor: const Color(0xFF7C3AED),
        icon: const Icon(Icons.add_rounded),
        label: Text(tr(context, 'ap_new')),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Banner(onTap: () => setState(() => _showNew = !_showNew)),
            _StatusTabs(active: _status, onTap: (s) => setState(() => _status = s)),
            if (_showNew) _NewAppealForm(onClose: () => setState(() => _showNew = false)),
            _SectionHeader(tr(context, 'ap_mine')),
            ..._filtered.map((a) => _AppealCard(appeal: a)),
            _SectionHeader(tr(context, 'ap_categories')),
            ..._cats.map((c) => _CatTile(name: c.$1, icon: c.$2)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  final VoidCallback onTap;
  const _Banner({required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.zero,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/images/murojat.png',
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
  Widget build(BuildContext context) => Container(
        color: AppTheme.panel(context, AppTheme.huePurple),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: _statuses.map((s) {
              final sel = s == active;
              final color = s == 'Barchasi' ? AppTheme.primary : (_statusColors[s] ?? AppTheme.primary);
              return GestureDetector(
                onTap: () => onTap(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  decoration: BoxDecoration(
                    color: sel ? color : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? color : AppTheme.divider),
                  ),
                  child: Text(
                    tr(context, s),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
                      color: sel ? Colors.white : AppTheme.ts(context),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      );
}

class _AppealCard extends StatelessWidget {
  final _Appeal appeal;
  const _AppealCard({required this.appeal});

  @override
  Widget build(BuildContext context) {
    final sColor = _statusColors[appeal.status] ?? AppTheme.primary;
    final sIcon = _statusIcons[appeal.status] ?? Icons.info_rounded;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      decoration: BoxDecoration(
        color: AppTheme.panel(context, AppTheme.huePurple),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(appeal.icon, color: const Color(0xFF7C3AED), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr(context, appeal.category),
                        style: TextStyle(fontSize: 11, color: AppTheme.ts(context)),
                      ),
                      Text(
                        appeal.number,
                        style: TextStyle(fontSize: 11, color: AppTheme.ts(context)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: sColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(sIcon, size: 12, color: sColor),
                      const SizedBox(width: 4),
                      Text(
                        tr(context, appeal.status),
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: sColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              tr(context, appeal.title),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, height: 1.3),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 12, color: AppTheme.ts(context)),
                const SizedBox(width: 4),
                Text(
                  appeal.date,
                  style: TextStyle(fontSize: 12, color: AppTheme.ts(context)),
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
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        decoration: BoxDecoration(
          color: AppTheme.panel(context, AppTheme.huePurple),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
          ],
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF7C3AED), size: 20),
          ),
          title: Text(tr(context, name), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.ts(context)),
          onTap: () {},
        ),
      );
}

class _NewAppealForm extends StatelessWidget {
  final VoidCallback onClose;
  const _NewAppealForm({required this.onClose});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.panel(context, AppTheme.huePurple),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7C3AED).withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(tr(context, 'ap_new'), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                const Spacer(),
                GestureDetector(onTap: onClose, child: Icon(Icons.close_rounded, size: 20, color: AppTheme.ts(context))),
              ],
            ),
            const SizedBox(height: 12),
            TextField(decoration: InputDecoration(hintText: tr(context, 'ap_subject'), prefixIcon: const Icon(Icons.title_rounded))),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(hintText: tr(context, 'ap_detail'), prefixIcon: const Icon(Icons.description_outlined), alignLabelWithHint: true),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
                onPressed: onClose,
                child: Text(tr(context, 'send')),
              ),
            ),
          ],
        ),
      );
}
