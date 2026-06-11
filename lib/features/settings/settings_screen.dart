import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/locale_provider.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/widgets/premium_scaffold.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _State();
}

class _State extends ConsumerState<SettingsScreen> {
  bool _notifications = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notifications = p.getBool('notifications') ?? true;
    });
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notifications = value);
    final p = await SharedPreferences.getInstance();
    await p.setBool('notifications', value);
  }

  Future<void> _toggleTheme(bool value) async {
    ref.read(themeProvider.notifier).state = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark_mode', value);
  }

  /// Til qatori — oldida dumaloq bayroq, o'ngda tanlangani belgisi.
  Widget _langOption(String code, String label) {
    final selected = ref.watch(localeProvider).languageCode == code;
    return ListTile(
      leading: _RoundFlag(code),
      title: Text(label,
          style: TextStyle(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppTheme.primary : AppTheme.tp(context))),
      trailing: Icon(
        selected ? Icons.check_circle_rounded : Icons.circle_outlined,
        color: selected ? AppTheme.primary : AppTheme.ts(context),
      ),
      onTap: () => ref.read(localeProvider.notifier).setLanguage(code),
    );
  }

  void _showPrivacy() => _showTextSheet(tr(context, 'set_privacy'), tr(context, 'set_privacy_body'));

  void _showTerms() => _showTextSheet(tr(context, 'set_terms'), tr(context, 'set_terms_body'));

  void _showTextSheet(String title, String body) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => Column(
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Text(body, style: TextStyle(fontSize: 14, color: AppTheme.ts(context), height: 1.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(themeProvider);
    final tt = Theme.of(context).textTheme;
    return PremiumScaffold(
      title: tr(context, 'd_settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel(tt, tr(context, 'set_notifications')),
          _card([
            SwitchListTile(
              secondary: _icon(Icons.notifications_outlined, const Color(0xFF3B82F6)),
              title: Text(tr(context, 'set_push')),
              subtitle: Text(tr(context, 'set_push_sub')),
              value: _notifications,
              activeThumbColor: AppTheme.primary,
              onChanged: _setNotifications,
            ),
          ]),
          _sectionLabel(tt, tr(context, 'set_appearance')),
          _card([
            SwitchListTile(
              secondary: _icon(Icons.dark_mode_outlined, const Color(0xFF6366F1)),
              title: Text(tr(context, 'night_mode')),
              subtitle: Text(isDark ? tr(context, 'set_dark_on') : tr(context, 'set_dark_off')),
              value: isDark,
              activeThumbColor: AppTheme.primary,
              onChanged: _toggleTheme,
            ),
          ]),
          _sectionLabel(tt, tr(context, 'language')),
          _card([
            for (var i = 0; i < supportedLanguages.length; i++) ...[
              if (i > 0) _divider(),
              _langOption(supportedLanguages[i].code, supportedLanguages[i].label),
            ],
          ]),
          _sectionLabel(tt, tr(context, 'set_about')),
          _card([
            ListTile(
              leading: _icon(Icons.info_outline_rounded, const Color(0xFF0EA5E9)),
              title: Text(tr(context, 'set_version')),
              trailing: Text('1.0.0', style: TextStyle(color: AppTheme.ts(context), fontSize: 14)),
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.code_rounded, const Color(0xFF8B5CF6)),
              title: Text(tr(context, 'set_developer')),
              trailing: Text(tr(context, 'set_dev_name'), style: TextStyle(color: AppTheme.ts(context), fontSize: 13)),
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.email_outlined, const Color(0xFFF59E0B)),
              title: Text(tr(context, 'd_contact')),
              trailing: Text('support@gozgon.uz', style: TextStyle(color: AppTheme.ts(context), fontSize: 12)),
            ),
          ]),
          _sectionLabel(tt, tr(context, 'set_legal')),
          _card([
            ListTile(
              leading: _icon(Icons.privacy_tip_outlined, const Color(0xFFEF4444)),
              title: Text(tr(context, 'set_privacy')),
              trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.ts(context)),
              onTap: _showPrivacy,
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.description_outlined, const Color(0xFF64748B)),
              title: Text(tr(context, 'set_terms')),
              trailing: Icon(Icons.chevron_right_rounded, color: AppTheme.ts(context)),
              onTap: _showTerms,
            ),
          ]),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _sectionLabel(TextTheme tt, String label) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
        child: Text(label, style: tt.labelLarge?.copyWith(color: AppTheme.ts(context), fontWeight: FontWeight.w700)),
      );

  Widget _card(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(children: children),
      );

  Widget _divider() => const Divider(height: 1, indent: 56);

  Widget _icon(IconData icon, Color color) => Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: color, size: 20),
      );
}

/// Dumaloq davlat bayrog'i — gorizontal yo'l-yo'l (UZ / RU).
class _RoundFlag extends StatelessWidget {
  final String code;
  const _RoundFlag(this.code);

  @override
  Widget build(BuildContext context) {
    final stripes = code == 'ru'
        ? const [Color(0xFFFFFFFF), Color(0xFF0039A6), Color(0xFFD52B1E)]
        : const [Color(0xFF0099B5), Color(0xFFFFFFFF), Color(0xFF1EB53A)];
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Column(
          children: [
            for (final c in stripes) Expanded(child: Container(color: c)),
          ],
        ),
      ),
    );
  }
}
