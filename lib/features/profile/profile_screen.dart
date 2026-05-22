import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

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
    return name.isEmpty ? 'Foydalanuvchi' : name;
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
        title: const Text('Chiqish'),
        content: const Text('Chiqishni tasdiqlaysizmi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Bekor qilish'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Chiqish', style: TextStyle(color: Color(0xFFEF4444))),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _AvatarSection(
              initials: _initials,
              fullName: _fullName,
              phone: _phone,
              birthDate: _birthDate,
            ),
            _StatsRow(),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  _menuItem(Icons.person_outline_rounded, "Shaxsiy ma'lumotlar", () => context.go('/services/personal-info')),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.notifications_outlined, 'Bildirishnomalar', () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.help_outline_rounded, "Yordam va qo'llab-quvvatlash", () {}),
                  const Divider(height: 1, indent: 56),
                  _menuItem(Icons.info_outline_rounded, 'Ilova haqida v1.0.0', () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Chiqish'),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) => ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.primary, size: 20),
        ),
        title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary, size: 20),
        onTap: onTap,
      );
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
        padding: const EdgeInsets.fromLTRB(16, 28, 16, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.primary, Color(0xFF1D4ED8)],
          ),
        ),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  child: Text(
                    initials,
                    style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.primary, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, color: AppTheme.primary, size: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4),
            if (phone.isNotEmpty)
              Text(phone, style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.75))),
            if (birthDate.isNotEmpty) ...[
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cake_outlined, size: 13, color: Colors.white.withValues(alpha: 0.65)),
                  const SizedBox(width: 4),
                  Text(birthDate, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.65))),
                ],
              ),
            ],
          ],
        ),
      );
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 18),
        margin: const EdgeInsets.only(top: 1),
        child: Row(
          children: [
            _stat('0', "E'lonlarim"),
            _div(),
            _stat('0', 'Saqlangan'),
            _div(),
            _stat('0', 'Murojaatlarim'),
          ],
        ),
      );

  Widget _stat(String n, String label) => Expanded(
        child: Column(
          children: [
            Text(n, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primary)),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
          ],
        ),
      );

  Widget _div() => Container(width: 1, height: 36, color: AppTheme.divider);
}
