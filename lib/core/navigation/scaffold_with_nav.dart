import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class ScaffoldWithNav extends StatelessWidget {
  static final drawerKey = GlobalKey<ScaffoldState>();

  static void openDrawer() => drawerKey.currentState?.openDrawer();

  final Widget child;
  final String location;

  const ScaffoldWithNav({super.key, required this.child, required this.location});

  static const _tabs = [
    (label: 'Bosh', img: 'assets/images/icons/home.png', path: '/home'),
    (label: 'Xizmatlar', img: 'assets/images/icons/barcha.png', path: '/services'),
    (label: 'Zukkobek', img: 'assets/images/icons/zukko.png', path: '/zukkobek'),
    (label: 'Market', img: 'assets/images/icons/savat.png', path: '/market'),
    (label: 'Profil', img: 'assets/images/icons/profil.png', path: '/profile'),
  ];

  int get _selectedIndex {
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/zukkobek')) return 2;
    if (location.startsWith('/market')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const _Drawer(),
      body: child,
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _tabs.asMap().entries.map((e) {
            final selected = e.key == _selectedIndex;
            final color = selected ? const Color(0xFF2563EB) : Colors.grey;
            return GestureDetector(
              onTap: () => context.go(e.value.path),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(e.value.img, width: 42, height: 42, fit: BoxFit.contain, filterQuality: FilterQuality.high),
                  const SizedBox(height: 4),
                  Text(e.value.label, style: TextStyle(fontSize: 11, color: color, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Drawer extends ConsumerStatefulWidget {
  const _Drawer();

  @override
  ConsumerState<_Drawer> createState() => _DrawerState();
}

class _DrawerState extends ConsumerState<_Drawer> {
  String _lang = "O'zbekcha";

  static const _items = [
    (label: 'Bosh sahifa', icon: Icons.home_outlined, route: '/home'),
    (label: 'Yangiliklar', icon: Icons.newspaper_outlined, route: '/services/news'),
    (label: 'Ob-havo', icon: Icons.wb_sunny_outlined, route: '/services/weather'),
    (label: 'Murojatlar', icon: Icons.support_agent_outlined, route: '/services/appeals'),
    (label: "E'lonlar", icon: Icons.campaign_outlined, route: '/services/ads'),
    (label: 'Bank', icon: Icons.account_balance_outlined, route: '/services/bank'),
    (label: 'Turizm', icon: Icons.landscape_outlined, route: '/services/tourism'),
    (label: 'Aloqa', icon: Icons.phone_outlined, route: '/services/contact'),
    (label: 'Sozlamalar', icon: Icons.settings_outlined, route: '/services/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _Header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              children: [
                ..._items.map((e) => ListTile(
                      leading: Icon(e.icon, color: AppTheme.primary, size: 22),
                      title: Text(e.label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      onTap: () { Navigator.pop(context); context.go(e.route); },
                      dense: true,
                    )),
                const Divider(indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode_outlined, color: AppTheme.primary, size: 22),
                  title: const Text('Tungi rejim', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  value: ref.watch(themeProvider),
                  activeThumbColor: AppTheme.secondary,
                  onChanged: _toggleTheme,
                  dense: true,
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined, color: AppTheme.primary, size: 22),
                  title: const Text('Til', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: Text(_lang, style: const TextStyle(fontSize: 13, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                  onTap: () => _langSheet(context),
                  dense: true,
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 22),
                  title: const Text('Chiqish', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFEF4444))),
                  onTap: () => _logout(context),
                  dense: true,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            child: Text("G'ozg'on Life v1.0.0", style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTheme(bool value) async {
    ref.read(themeProvider.notifier).state = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark_mode', value);
  }

  void _langSheet(BuildContext ctx) {
    const langs = ["O'zbekcha", 'Русский', 'English'];
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Tilni tanlang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            ...langs.map((l) => ListTile(
                  leading: Icon(
                    l == _lang ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: l == _lang ? AppTheme.primary : AppTheme.textSecondary,
                    size: 22,
                  ),
                  title: Text(l),
                  onTap: () { setState(() => _lang = l); Navigator.pop(ctx); },
                )),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext ctx) async {
    final router = GoRouter.of(ctx);
    Navigator.pop(ctx);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Chiqish'),
        content: const Text("Hisobdan chiqmoqchimisiz?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Chiqish', style: TextStyle(color: Color(0xFFEF4444)))),
        ],
      ),
    );
    if (ok != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('logged_in');
    await prefs.remove('phone');
    await prefs.remove('first_name');
    await prefs.remove('last_name');
    await prefs.remove('birth_date');
    if (mounted) router.go('/onboarding');
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Image.asset('assets/images/menufoto.png', width: double.infinity, height: 250, fit: BoxFit.cover, alignment: Alignment.center);
}
