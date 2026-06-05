import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/locale_provider.dart';
import '../l10n/strings.dart';
import '../theme/app_theme.dart';
import '../theme/theme_provider.dart';

class ScaffoldWithNav extends StatefulWidget {
  static ScaffoldWithNavState? _state;

  static void openDrawer() => _state?.drawerKey.currentState?.openDrawer();

  final Widget child;
  final String location;

  const ScaffoldWithNav({super.key, required this.child, required this.location});

  @override
  State<ScaffoldWithNav> createState() => ScaffoldWithNavState();
}

class ScaffoldWithNavState extends State<ScaffoldWithNav> {
  final drawerKey = GlobalKey<ScaffoldState>();

  static const _tabs = [
    (key: 'nav_home', light: 'assets/images/icons/home_light.png', dark: 'assets/images/icons/home_dark.png', path: '/home'),
    (key: 'nav_services', light: 'assets/images/icons/more_light.png', dark: 'assets/images/icons/more_dark.png', path: '/services'),
    (key: 'nav_zukkobek', light: 'assets/images/icons/zukko_light.png', dark: 'assets/images/icons/zukko_dark.png', path: '/zukkobek'),
    (key: 'nav_market', light: 'assets/images/icons/market_light.png', dark: 'assets/images/icons/market_dark.png', path: '/market'),
    (key: 'nav_profile', light: 'assets/images/icons/profil_light.png', dark: 'assets/images/icons/profil_dark.png', path: '/profile'),
  ];

  int get _selectedIndex {
    final location = widget.location;
    if (location.startsWith('/services')) return 1;
    if (location.startsWith('/zukkobek')) return 2;
    if (location.startsWith('/market')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  void initState() {
    super.initState();
    ScaffoldWithNav._state = this;
  }

  @override
  void dispose() {
    if (ScaffoldWithNav._state == this) ScaffoldWithNav._state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const _Drawer(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Theme.of(context).brightness == Brightness.dark
                  ? 'assets/images/dark_bg.png'
                  : 'assets/images/marble_bg.png',
              fit: BoxFit.cover,
              cacheWidth: 800,
            ),
          ),
          widget.child,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => context.go(_tabs[i].path),
        destinations: List.generate(_tabs.length, (i) {
              final t = _tabs[i];
              return NavigationDestination(
                icon: Image.asset(
                  _selectedIndex == i ? t.dark : t.light,
                  width: 32,
                  height: 32,
                  cacheWidth: 64,
                  cacheHeight: 64,
                ),
                label: tr(context, t.key),
              );
            }),
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
  static const _items = [
    (key: 'd_home', icon: Icons.home_outlined, route: '/home'),
    (key: 'd_news', icon: Icons.newspaper_outlined, route: '/services/news'),
    (key: 'd_weather', icon: Icons.wb_sunny_outlined, route: '/services/weather'),
    (key: 'd_appeals', icon: Icons.support_agent_outlined, route: '/services/appeals'),
    (key: 'd_ads', icon: Icons.campaign_outlined, route: '/services/ads'),
    (key: 'd_bank', icon: Icons.account_balance_outlined, route: '/services/bank'),
    (key: 'd_tourism', icon: Icons.landscape_outlined, route: '/services/tourism'),
    (key: 'd_contact', icon: Icons.phone_outlined, route: '/services/contact'),
    (key: 'd_settings', icon: Icons.settings_outlined, route: '/services/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppTheme.secondary : AppTheme.primary;
    return Drawer(
      child: Column(
        children: [
          _Header(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              children: [
                ..._items.map((e) => ListTile(
                      leading: Icon(e.icon, color: iconColor, size: 22),
                      title: Text(tr(context, e.key), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      onTap: () { Navigator.pop(context); context.go(e.route); },
                      dense: true,
                    )),
                const Divider(indent: 16, endIndent: 16),
                SwitchListTile(
                  secondary: Icon(Icons.dark_mode_outlined, color: iconColor, size: 22),
                  title: Text(tr(context, 'night_mode'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  value: ref.watch(themeProvider),
                  activeThumbColor: AppTheme.secondary,
                  onChanged: _toggleTheme,
                  dense: true,
                ),
                ListTile(
                  leading: Icon(Icons.language_outlined, color: iconColor, size: 22),
                  title: Text(tr(context, 'language'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  trailing: Text(languageLabel(ref.watch(localeProvider).languageCode),
                      style: TextStyle(fontSize: 13, color: iconColor, fontWeight: FontWeight.w600)),
                  onTap: () => _langSheet(context),
                  dense: true,
                ),
                const Divider(indent: 16, endIndent: 16),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 22),
                  title: Text(tr(context, 'logout'), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFEF4444))),
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
    final current = ref.read(localeProvider).languageCode;
    showModalBottomSheet(
      context: ctx,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(tr(ctx, 'choose_language'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            ...supportedLanguages.map((l) => ListTile(
                  leading: Icon(
                    l.code == current ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: l.code == current ? AppTheme.primary : AppTheme.textSecondary,
                    size: 22,
                  ),
                  title: Text(l.label),
                  onTap: () {
                    ref.read(localeProvider.notifier).setLanguage(l.code);
                    Navigator.pop(ctx);
                  },
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
        title: Text(tr(context, 'logout')),
        content: Text(tr(context, 'logout_confirm')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr(context, 'cancel'))),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(tr(context, 'logout'), style: const TextStyle(color: Color(0xFFEF4444)))),
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
      Image.asset('assets/images/uu.png', width: double.infinity, height: 250, fit: BoxFit.cover, alignment: Alignment.center, cacheWidth: 800);
}
