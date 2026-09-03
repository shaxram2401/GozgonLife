import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/premium_page.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/premium_scaffold.dart';

// ── Brand palette — AppColors.appeals asosida (design_tokens.dart) ──
const _purple = AppColors.appeals;
const _purpleDeep = Color(0xFF4A148C);

const _statuses = ['Barchasi', 'Qabulda', 'Jarayonda', 'Yakunlangan'];

// Holat ranglari — Qabulda binafsha, Jarayonda sariq, Yakunlangan yashil.
const _statusColors = {
  'Qabulda': _purple,
  'Jarayonda': Color(0xFFF59E0B),
  'Yakunlangan': Color(0xFF10B981),
};

const _statusIcons = {
  'Qabulda': Icons.inbox_rounded,
  'Jarayonda': Icons.autorenew_rounded,
  'Yakunlangan': Icons.check_circle_rounded,
};

Color _statusColor(String s) => s == 'Barchasi' ? _purple : (_statusColors[s] ?? _purple);

/// Rang ustidagi matn/ikona rangi — yorqin fon uchun qora, to'q fon uchun oq.
Color _onColor(Color c) => c.computeLuminance() > 0.6 ? const Color(0xFF1F2937) : Colors.white;

// ── Kategoriyalar — `color` endi faqat IKONA glifining rangi (plitka va
// sahifa esa har doim binafsha). ──────────────────────────────
class _Cat {
  final String key;
  final IconData icon;
  final Color color; // ikona glifi rangi
  final String? emoji; // soliq uchun pul qopi 💰
  const _Cat(this.key, this.icon, this.color, {this.emoji});
}

const _categories = [
  _Cat('Shahar hokimligi', Icons.account_balance_rounded, Color(0xFF111827)), // qora
  _Cat('Bandlik', Icons.work_rounded, Color(0xFF8B5E3C)), // jigarrang
  _Cat("Yo'l va transport", Icons.directions_car_rounded, Color(0xFF2563EB)), // kok
  _Cat('Kommunal xizmatlar', Icons.water_drop_rounded, Color(0xFF64748B)), // kulrang
  _Cat('Tibbiyot', Icons.local_hospital_rounded, Color(0xFFDC2626)), // qizil
  _Cat('Soliq', Icons.savings_rounded, Color(0xFFF59E0B), emoji: '💰'), // sariq
  _Cat("Qurilish/kadastr/uy xo'jaligi", Icons.home_work_rounded, Color(0xFF1E3A8A)), // to'q kok
  _Cat("Ko'kalamzorlashtirish", Icons.park_rounded, Color(0xFF16A34A)), // yashil
  _Cat('Boshqa masalalar', Icons.help_rounded, Color(0xFF111827)), // qora
];

final _catByKey = {for (final c in _categories) c.key: c};
_Cat _catFor(String key) =>
    _catByKey[key] ?? const _Cat('Boshqa masalalar', Icons.help_rounded, Color(0xFF111827));

/// Binafsha to'rtburchak plitka + oq doira + kategoriya rangidagi ikona/emoji.
class _CatIcon extends StatelessWidget {
  final _Cat cat;
  final double size;
  const _CatIcon({required this.cat, required this.size});

  @override
  Widget build(BuildContext context) {
    final inner = size * 0.66;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF9F67FF), _purple],
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Center(
        child: Container(
          width: inner,
          height: inner,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: Center(
            child: cat.emoji != null
                ? Text(cat.emoji!, style: TextStyle(fontSize: inner * 0.58))
                : Icon(cat.icon, color: cat.color, size: inner * 0.6),
          ),
        ),
      ),
    );
  }
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

/// Profil statistikasi uchun — murojaatlar soni.
int get kAppealsCount => _appeals.length;

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
    icon: Icons.savings_rounded,
  ),
  const _Appeal(
    title: 'Ruxsatsiz qurilish ob\'ekti',
    category: "Qurilish/kadastr/uy xo'jaligi",
    status: 'Jarayonda',
    date: '15 may 2026',
    number: 'MRJ-2026-005',
    icon: Icons.home_work_rounded,
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

class AppealsScreen extends StatelessWidget {
  const AppealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerImg = Localizations.localeOf(context).languageCode == 'ru'
        ? 'assets/images/murojatru.png'
        : 'assets/images/murojatuz.png';
    return PremiumScaffold(
      title: tr(context, 'c_appeals'),
      accent: _purpleDeep,
      showBar: false,
      floatingButton: false,
      body: Column(
        children: [
          PremiumHeader(title: tr(context, 'c_appeals'), accent: _purpleDeep),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshGesture,
              color: _purple,
              child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner — murojatlar hero rasmi.
                  PremiumBanner(image: bannerImg, aspectRatio: 1672 / 941),
                  const SizedBox(height: 18),
                  // ── Mening murojaatlarim — alohida bosiluvchi panel ──
                  _MyAppealsBanner(count: _appeals.length),
                  // ── Murojaat kategoriyalari ──
                  _SectionHeader(title: tr(context, 'ap_categories')),
                  ..._categories.map((c) => _CatTile(cat: c)),
                  const SizedBox(height: 90),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }
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
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: sel ? color : AppTheme.dv(context), width: 1.4),
                  boxShadow: sel
                      ? [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 10, offset: const Offset(0, 4))]
                      : null,
                ),
                child: Text(
                  tr(context, s),
                  style: TextStyle(
                    fontSize: AppFontSize.bodySmall,
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

/// Alohida bosiluvchi binafsha panel — "Mening murojaatlarim". Bosilganda
/// barcha murojaatlar ro'yxati alohida sahifada ochiladi.
class _MyAppealsBanner extends StatelessWidget {
  final int count;
  const _MyAppealsBanner({required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => const MyAppealsPage()),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 4),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF9F67FF), _purple, _purpleDeep],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: _purple.withValues(alpha: 0.45), blurRadius: 22, spreadRadius: -2, offset: const Offset(0, 12)),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(18, 24, 16, 24),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(tr(context, 'ap_mine'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: AppFontSize.h1, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.4)),
                      ),
                      const SizedBox(width: 9),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(20)),
                        child: Text('$count',
                            style: const TextStyle(fontSize: AppFontSize.body, fontWeight: FontWeight.w800, color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(tr(context, 'ap_my_sub'),
                      style: TextStyle(fontSize: AppFontSize.bodySmall, color: Colors.white.withValues(alpha: 0.88))),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), shape: BoxShape.circle),
              child: const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Mening murojaatlarim" sahifasi — binafsha app bar, holat bo'yicha filtr
/// va barcha murojaatlar ro'yxati.
class MyAppealsPage extends StatefulWidget {
  const MyAppealsPage({super.key});

  @override
  State<MyAppealsPage> createState() => MyAppealsPageState();
}

class MyAppealsPageState extends State<MyAppealsPage> {
  String _status = 'Barchasi';

  List<_Appeal> get _filtered => _status == 'Barchasi'
      ? _appeals
      : _appeals.where((a) => a.status == _status).toList();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final topPad = MediaQuery.paddingOf(context).top;
    final base = dark ? const Color(0xFF0B1120) : const Color(0xFFF4F9FF);
    final list = _filtered;
    return Scaffold(
      backgroundColor: Colors.transparent,
      // Yangi murojaat — kategoriyalar ro'yxatiga qaytaradi
      // (murojaat aynan kategoriya tanlashdan boshlanadi).
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.edit_rounded),
        label: Text(
          tr(context, 'ap_new'),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.alphaBlend(_purple.withValues(alpha: dark ? 0.26 : 0.16), base),
              base,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: Column(
          children: [
            // Binafsha app bar
            Container(
              padding: EdgeInsets.only(top: topPad + 6, left: 6, right: 16, bottom: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _purpleDeep],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                boxShadow: [BoxShadow(color: _purple.withValues(alpha: 0.45), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  const Icon(Icons.assignment_rounded, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(tr(context, 'ap_mine'),
                        style: const TextStyle(fontSize: AppFontSize.h2, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.20), borderRadius: BorderRadius.circular(20)),
                    child: Text('${list.length}',
                        style: const TextStyle(fontSize: AppFontSize.body, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _StatusTabs(active: _status, onTap: (s) => setState(() => _status = s)),
            const SizedBox(height: 8),
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Text(tr(context, 'ap_empty'),
                          style: TextStyle(color: AppTheme.ts(context), fontWeight: FontWeight.w600)),
                    )
                  : ListView(
                      // Pastda 96px — suzuvchi "Yangi murojaat" tugmasi
                      // oxirgi kartani berkitmasligi uchun.
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                      children: list.map((a) => _AppealCard(appeal: a)).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

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
            Text(title, style: TextStyle(fontSize: AppFontSize.h2, fontWeight: FontWeight.w800, color: AppTheme.tp(context))),
          ],
        ),
      );
}

/// Murojaat kartochkasi — yorqin oq panel (binafsha banner ustida aniq
/// ko'rinadi), holat rangida ikona va status pill.
class _AppealCard extends StatelessWidget {
  final _Appeal appeal;
  const _AppealCard({required this.appeal});

  @override
  Widget build(BuildContext context) {
    final sColor = _statusColor(appeal.status);
    final sIcon = _statusIcons[appeal.status] ?? Icons.info_rounded;
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _CatIcon(cat: _catFor(appeal.category), size: 42),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tr(context, appeal.category),
                          style: TextStyle(fontSize: AppFontSize.caption, fontWeight: FontWeight.w600, color: AppTheme.ts(context))),
                      const SizedBox(height: 1),
                      Text(appeal.number,
                          style: TextStyle(fontSize: AppFontSize.caption, fontWeight: FontWeight.w500, color: AppTheme.ts(context).withValues(alpha: 0.7))),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                      Text(tr(context, appeal.status),
                          style: const TextStyle(fontSize: AppFontSize.caption, fontWeight: FontWeight.w700, color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 11),
            Text(tr(context, appeal.title),
                style: TextStyle(fontSize: AppFontSize.body, fontWeight: FontWeight.w700, height: 1.3, color: AppTheme.tp(context)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 9),
            Row(
              children: [
                Icon(Icons.calendar_today_rounded, size: 12, color: AppTheme.ts(context)),
                const SizedBox(width: 5),
                Text(appeal.date,
                    style: TextStyle(fontSize: AppFontSize.caption, fontWeight: FontWeight.w500, color: AppTheme.ts(context))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Kategoriya plitkasi — o'z rangida; bosilganda o'sha rangli murojaat
/// shakli sahifasi ochiladi.
class _CatTile extends StatelessWidget {
  final _Cat cat;
  const _CatTile({required this.cat});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(builder: (_) => _CategoryAppealPage(cat: cat)),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.25 : 0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          child: Row(
            children: [
              _CatIcon(cat: cat, size: 46),
              const SizedBox(width: 13),
              Expanded(
                child: Text(tr(context, cat.key),
                    style: TextStyle(fontSize: AppFontSize.body, fontWeight: FontWeight.w700, color: AppTheme.tp(context))),
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
      ),
    );
  }
}

/// Kategoriya bo'yicha murojaat shakli — tanlangan kategoriya rangida
/// ochiladi. Ism, familiya, telefon, rasm joylash va katta muammo tavsifi.
class _CategoryAppealPage extends StatefulWidget {
  final _Cat cat;
  const _CategoryAppealPage({required this.cat});

  @override
  State<_CategoryAppealPage> createState() => _CategoryAppealPageState();
}

class _CategoryAppealPageState extends State<_CategoryAppealPage> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();
  final _problem = TextEditingController();

  /// Biriktirilgan rasm. Veb'da fayl yo'li bo'lmaydi, shuning uchun
  /// baytlar o'qib olinadi va shu orqali ko'rsatiladi.
  XFile? _photo;
  Uint8List? _photoBytes;
  bool get _hasPhoto => _photo != null;

  Future<void> _pickPhoto() async {
    if (_hasPhoto) {
      setState(() {
        _photo = null;
        _photoBytes = null;
      });
      return;
    }

    // Veb'da kamera/galereya ajratilmaydi — brauzer o'zi fayl tanlash
    // oynasini ochadi. Telefonda esa foydalanuvchi tanlaydi.
    ImageSource? source = ImageSource.gallery;
    if (!kIsWeb) {
      source = await _askSource();
      if (source == null) return;
    }

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 82,
      );
      if (picked == null) return;
      final bytes = await picked.readAsBytes();
      if (!mounted) return;
      setState(() {
        _photo = picked;
        _photoBytes = bytes;
      });
    } catch (e) {
      debugPrint('Rasm tanlashda xatolik: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr(context, 'ap_photo_error'))),
      );
    }
  }

  /// Kamera yoki galereya — pastdan chiqadigan tanlov.
  Future<ImageSource?> _askSource() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.card(ctx),
          borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.dv(ctx),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: _purple,
                  child: Icon(Icons.photo_camera_rounded, color: Colors.white),
                ),
                title: Text(tr(ctx, 'ap_photo_camera'),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: _purple,
                  child: Icon(Icons.photo_library_rounded, color: Colors.white),
                ),
                title: Text(tr(ctx, 'ap_photo_gallery'),
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    _problem.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: _purple,
      content: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: Colors.white),
          const SizedBox(width: 10),
          Expanded(child: Text(tr(context, 'ap_submitted'), style: const TextStyle(fontWeight: FontWeight.w700))),
        ],
      ),
    ));
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    // Sahifa har doim bir xil binafsha — faqat ikona kategoriya rangida.
    const color = _purple;
    final topPad = MediaQuery.paddingOf(context).top;
    final base = dark ? const Color(0xFF0B1120) : const Color(0xFFF4F9FF);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.alphaBlend(color.withValues(alpha: dark ? 0.26 : 0.16), base),
              base,
            ],
            stops: const [0.0, 0.42],
          ),
        ),
        child: Column(
          children: [
            // ── Rangli app bar ──
            Container(
              padding: EdgeInsets.only(top: topPad + 6, left: 6, right: 14, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, Color.lerp(color, Colors.black, 0.28)!],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
                boxShadow: [BoxShadow(color: color.withValues(alpha: 0.45), blurRadius: 20, offset: const Offset(0, 8))],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  ),
                  _CatIcon(cat: widget.cat, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr(context, 'ap_form_title'),
                            style: TextStyle(fontSize: AppFontSize.caption, fontWeight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.85))),
                        const SizedBox(height: 1),
                        Text(tr(context, widget.cat.key),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: AppFontSize.h2, fontWeight: FontWeight.w800, color: Colors.white, height: 1.15)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ── Forma ──
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _fieldLabel(context, tr(context, 'ap_first_name')),
                    _field(context, color, _first, tr(context, 'ap_first_name'), Icons.person_outline_rounded),
                    const SizedBox(height: 14),
                    _fieldLabel(context, tr(context, 'ap_last_name')),
                    _field(context, color, _last, tr(context, 'ap_last_name'), Icons.badge_outlined),
                    const SizedBox(height: 14),
                    _fieldLabel(context, tr(context, 'ap_phone')),
                    _field(context, color, _phone, '+998 90 123 45 67', Icons.phone_outlined,
                        keyboard: TextInputType.phone),
                    const SizedBox(height: 18),
                    // Rasm joylash tugmasi
                    _PhotoButton(
                      color: color,
                      added: _hasPhoto,
                      preview: _photoBytes,
                      onTap: _pickPhoto,
                    ),
                    const SizedBox(height: 18),
                    // Katta muammo tavsifi
                    _fieldLabel(context, tr(context, 'ap_problem')),
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.card(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: dark ? Colors.white.withValues(alpha: 0.08) : color.withValues(alpha: 0.20)),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: dark ? 0.25 : 0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: TextField(
                        controller: _problem,
                        maxLines: 7,
                        minLines: 7,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: tr(context, 'ap_detail'),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    // Yuborish tugmasi
                    GestureDetector(
                      onTap: _submit,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color.lerp(color, Colors.white, 0.18)!, color],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 14, offset: const Offset(0, 6))],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.send_rounded, color: _onColor(color), size: 19),
                            const SizedBox(width: 8),
                            Text(tr(context, 'ap_submit'),
                                style: TextStyle(color: _onColor(color), fontSize: AppFontSize.title, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String label) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 7),
        child: Text(label, style: TextStyle(fontSize: AppFontSize.bodySmall, fontWeight: FontWeight.w700, color: AppTheme.tp(context))),
      );

  Widget _field(BuildContext context, Color color, TextEditingController c, String hint, IconData icon,
      {TextInputType? keyboard}) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: c,
      keyboardType: keyboard,
      inputFormatters: keyboard == TextInputType.phone
          ? [FilteringTextInputFormatter.allow(RegExp(r'[0-9 +()-]'))]
          : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: color),
        filled: true,
        fillColor: AppTheme.card(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dark ? Colors.white.withValues(alpha: 0.08) : color.withValues(alpha: 0.20)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 1.7),
        ),
      ),
    );
  }
}

class _PhotoButton extends StatelessWidget {
  final Color color;
  final bool added;
  final VoidCallback onTap;

  /// Tanlangan rasmning ko'rinishi (baytlar) — bo'lsa, ikonka o'rniga
  /// kichik nusxasi ko'rsatiladi.
  final Uint8List? preview;
  const _PhotoButton({
    required this.color,
    required this.added,
    required this.onTap,
    this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: added ? 0.14 : 0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: added ? 0.6 : 0.35), width: 1.6),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              child: preview != null
                  ? Image.memory(preview!, fit: BoxFit.cover)
                  : Icon(
                      added
                          ? Icons.check_circle_rounded
                          : Icons.add_a_photo_rounded,
                      color: color,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr(context, added ? 'ap_photo_added' : 'ap_add_photo'),
                      style: TextStyle(fontSize: AppFontSize.body, fontWeight: FontWeight.w700, color: AppTheme.tp(context))),
                  const SizedBox(height: 2),
                  Text(tr(context, 'ap_photo_hint'),
                      style: TextStyle(fontSize: AppFontSize.caption, color: AppTheme.ts(context))),
                ],
              ),
            ),
            Icon(added ? Icons.close_rounded : Icons.chevron_right_rounded, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
