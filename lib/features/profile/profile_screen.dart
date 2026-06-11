import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/saved_products.dart';
import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../appeals/appeals_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _birthDate = '';

  String get _fullName {
    final name = '$_firstName $_lastName'.trim();
    return name.isEmpty ? tr(context, 'pr_user') : name;
  }

  String get _initials {
    final f = _firstName.isNotEmpty ? _firstName[0].toUpperCase() : '';
    final l = _lastName.isNotEmpty ? _lastName[0].toUpperCase() : '';
    final init = '$f$l';
    return init.isNotEmpty ? init : 'F';
  }

  @override
  void initState() {
    super.initState();
    SavedProducts.ensureLoaded();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    final rawBirth = p.getString('birth_date') ?? '';
    final birth = _formatBirth(rawBirth);
    setState(() {
      _firstName = p.getString('first_name') ?? '';
      _lastName = p.getString('last_name') ?? '';
      _phone = p.getString('phone') ?? '';
      _birthDate = birth;
    });
  }

  String _formatBirth(String iso) {
    if (iso.isEmpty) return '';
    final d = DateTime.tryParse(iso);
    if (d == null) return '';
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr(context, 'logout')),
        content: Text(tr(context, 'pr_logout_confirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(tr(context, 'cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(tr(context, 'logout'), style: const TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await SharedPreferences.getInstance().then((p) => p.clear());
    if (mounted) context.go('/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return PremiumScaffold(
      title: tr(context, 'nav_profile'),
      useDrawer: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _AvatarSection(
              initials: _initials,
              fullName: _fullName,
              phone: _phone,
              birthDate: _birthDate,
            ),
            const SizedBox(height: 18),
            // Menu card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: dark ? 0.25 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _menuItem(Icons.person_outline_rounded,
                      tr(context, 'pi_title'),
                      () => context.go('/services/personal-info')),
                  _divider(),
                  _menuItem(Icons.notifications_outlined,
                      tr(context, 'set_notifications'),
                      () => context.push('/notifications')),
                  _divider(),
                  _menuItem(Icons.settings_outlined,
                      tr(context, 'd_settings'),
                      () => context.push('/profile/settings')),
                  _divider(),
                  _menuItem(Icons.help_outline_rounded,
                      tr(context, 'pr_help'), () {}),
                  _divider(),
                  _menuItem(Icons.info_outline_rounded,
                      tr(context, 'pr_about_v'), () {}),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Logout — premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _logout,
                  child: Ink(
                    height: 54,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFEF4444)
                              .withValues(alpha: 0.3)),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.logout_rounded,
                              color: Color(0xFFEF4444), size: 20),
                          SizedBox(width: 8),
                          Text('Chiqish',
                              style: TextStyle(
                                  color: Color(0xFFEF4444),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.only(left: 64),
        child: Divider(height: 1, color: AppTheme.dv(context)),
      );

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.secondary.withValues(alpha: dark ? 0.28 : 0.18),
                AppTheme.primary.withValues(alpha: dark ? 0.20 : 0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          // Dark'da och ko'k — to'q fonda ko'rinishi uchun.
          child: Icon(icon,
              color: dark ? const Color(0xFF93C5FD) : AppTheme.primary,
              size: 20),
        ),
        title: Text(label,
            style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.tp(context))),
        trailing:
            Icon(Icons.chevron_right_rounded, color: AppTheme.ts(context), size: 20),
        onTap: onTap,
      );
  }
}

class _AvatarSection extends StatelessWidget {
  final String initials, fullName, phone, birthDate;
  const _AvatarSection({
    required this.initials,
    required this.fullName,
    required this.phone,
    required this.birthDate,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 0),
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3B82F6), AppTheme.primary],
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.45),
              blurRadius: 24,
              spreadRadius: -4,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.5), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    child: Text(
                      initials,
                      style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Builder(builder: (context) {
                    final dark =
                        Theme.of(context).brightness == Brightness.dark;
                    final c = dark
                        ? const Color(0xFF93C5FD)
                        : AppTheme.primary;
                    return Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.card(context),
                        shape: BoxShape.circle,
                        border: Border.all(color: c, width: 2),
                      ),
                      child:
                          Icon(Icons.camera_alt_rounded, color: c, size: 15),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(fullName,
                style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.4)),
            const SizedBox(height: 4),
            if (phone.isNotEmpty)
              Text(phone,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8))),
            if (birthDate.isNotEmpty) ...[
              const SizedBox(height: 3),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cake_outlined,
                      size: 13, color: Colors.white.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(birthDate,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7))),
                ],
              ),
            ],
            const SizedBox(height: 20),
            // Stats — shaffof oq chiplar (bosiluvchi)
            Row(
              children: [
                _stat(context, '0', tr(context, 'pr_my_ads')),
                _statDiv(),
                ValueListenableBuilder<Set<String>>(
                  valueListenable: SavedProducts.titles,
                  builder: (_, saved, _) => _stat(
                      context, '${saved.length}', tr(context, 'pr_saved'),
                      onTap: () => context.push('/profile/saved')),
                ),
                _statDiv(),
                _stat(context, '$kAppealsCount',
                    tr(context, 'pr_my_appeals'),
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (_) => const MyAppealsPage()),
                    )),
              ],
            ),
          ],
        ),
      );

  Widget _stat(BuildContext context, String n, String label,
          {VoidCallback? onTap}) =>
      Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            children: [
              Text(n,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)),
              const SizedBox(height: 3),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.75))),
            ],
          ),
        ),
      );

  Widget _statDiv() => Container(
      width: 1, height: 34, color: Colors.white.withValues(alpha: 0.2));
}
