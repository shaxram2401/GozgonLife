import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/theme/theme_provider.dart';

const _langs = ["O'zbekcha", 'Русский', 'English'];
const _langPref = 'language';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _State();
}

class _State extends ConsumerState<SettingsScreen> {
  bool _notifications = true;
  String _lang = _langs[0];

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
      _lang = p.getString(_langPref) ?? _langs[0];
    });
  }

  Future<void> _setNotifications(bool value) async {
    setState(() => _notifications = value);
    final p = await SharedPreferences.getInstance();
    await p.setBool('notifications', value);
  }

  Future<void> _setLang(String value) async {
    setState(() => _lang = value);
    final p = await SharedPreferences.getInstance();
    await p.setString(_langPref, value);
  }

  Future<void> _toggleTheme(bool value) async {
    ref.read(themeProvider.notifier).state = value;
    final p = await SharedPreferences.getInstance();
    await p.setBool('dark_mode', value);
  }

  void _showLangSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text('Tilni tanlang', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
              ..._langs.map((l) => ListTile(
                    leading: Icon(
                      l == _lang ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: l == _lang ? AppTheme.primary : AppTheme.textSecondary,
                    ),
                    title: Text(l),
                    onTap: () {
                      _setLang(l);
                      Navigator.pop(context);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrivacy() => _showTextSheet(
        "Maxfiylik siyosati",
        "G'ozg'on Life ilovasi foydalanuvchi ma'lumotlarini himoya qilishga sodiqdir.\n\n"
            "To'plangan ma'lumotlar: ism, familiya, telefon raqam, tug'ilgan sana.\n\n"
            "Ma'lumotlaringiz uchinchi shaxslarga berilmaydi va faqat xizmat ko'rsatish maqsadida ishlatiladi.\n\n"
            "Barcha axborot almashinuvi shifrlangan kanallar orqali amalga oshiriladi.\n\n"
            "Savollar uchun: support@gozgon.uz",
      );

  void _showTerms() => _showTextSheet(
        "Foydalanish shartlari",
        "G'ozg'on Life ilovasidan foydalanish ushbu shartlarga rozilikni bildiradi.\n\n"
            "1. Ilovadan faqat qonuniy maqsadlarda foydalaning.\n\n"
            "2. Boshqa foydalanuvchilar huquqlarini hurmat qiling.\n\n"
            "3. Noto'g'ri yoki yolg'on ma'lumot kiritmang.\n\n"
            "4. Ilova xavfsizligiga zarar yetkazuvchi harakatlardan saqlaning.\n\n"
            "5. Shartlar o'zgarishi haqida ilova orqali xabar beriladi.",
      );

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
                child: Text(body, style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.7)),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Sozlamalar')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionLabel(tt, 'Bildirishnomalar'),
          _card([
            SwitchListTile(
              secondary: _icon(Icons.notifications_outlined, const Color(0xFF3B82F6)),
              title: const Text('Push bildirishnomalar'),
              subtitle: const Text('Yangiliklar va xizmatlar haqida xabar'),
              value: _notifications,
              activeThumbColor: AppTheme.primary,
              onChanged: _setNotifications,
            ),
          ]),
          _sectionLabel(tt, 'Ko\'rinish'),
          _card([
            SwitchListTile(
              secondary: _icon(Icons.dark_mode_outlined, const Color(0xFF6366F1)),
              title: const Text('Tungi rejim'),
              subtitle: Text(isDark ? 'Yoqilgan' : "O'chirilgan"),
              value: isDark,
              activeThumbColor: AppTheme.primary,
              onChanged: _toggleTheme,
            ),
          ]),
          _sectionLabel(tt, 'Til'),
          _card([
            ListTile(
              leading: _icon(Icons.language_outlined, const Color(0xFF10B981)),
              title: const Text('Interfeys tili'),
              subtitle: Text(_lang),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
              onTap: _showLangSheet,
            ),
          ]),
          _sectionLabel(tt, 'Ilova haqida'),
          _card([
            ListTile(
              leading: _icon(Icons.info_outline_rounded, const Color(0xFF0EA5E9)),
              title: const Text('Versiya'),
              trailing: const Text('1.0.0', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.code_rounded, const Color(0xFF8B5CF6)),
              title: const Text('Dasturchi'),
              trailing: const Text("G'ozg'on IT", style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.email_outlined, const Color(0xFFF59E0B)),
              title: const Text('Aloqa'),
              trailing: const Text('support@gozgon.uz', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            ),
          ]),
          _sectionLabel(tt, 'Huquqiy'),
          _card([
            ListTile(
              leading: _icon(Icons.privacy_tip_outlined, const Color(0xFFEF4444)),
              title: const Text('Maxfiylik siyosati'),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
              onTap: _showPrivacy,
            ),
            _divider(),
            ListTile(
              leading: _icon(Icons.description_outlined, const Color(0xFF64748B)),
              title: const Text('Foydalanish shartlari'),
              trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textSecondary),
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
        child: Text(label, style: tt.labelLarge?.copyWith(color: AppTheme.textSecondary, fontWeight: FontWeight.w700)),
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
