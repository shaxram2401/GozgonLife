import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _emergency = [
  (name: 'Tez yordam', number: '1103', icon: Icons.local_hospital_rounded, color: Color(0xFF10B981)),
  (name: "Yong'in xizmati", number: '1101', icon: Icons.local_fire_department_rounded, color: Color(0xFFEF4444)),
  (name: 'Militsiya', number: '1102', icon: Icons.local_police_rounded, color: Color(0xFF6366F1)),
  (name: 'Gaz xizmati', number: '1104', icon: Icons.gas_meter_rounded, color: Color(0xFFF59E0B)),
  (name: 'Elektr xizmati', number: '1154', icon: Icons.electrical_services_rounded, color: Color(0xFFF97316)),
  (name: 'Suv ta\'minoti', number: '1255', icon: Icons.water_rounded, color: Color(0xFF0EA5E9)),
  (name: 'Hokimiyat', number: '1198', icon: Icons.account_balance_rounded, color: Color(0xFF8B5CF6)),
  (name: 'Ijtimoiy yordam', number: '1159', icon: Icons.volunteer_activism_rounded, color: Color(0xFFEC4899)),
  (name: 'Bank xizmati', number: '1254', icon: Icons.credit_card_rounded, color: Color(0xFF0891B2)),
  (name: "Yo'l yordam", number: '1157', icon: Icons.directions_car_rounded, color: Color(0xFF64748B)),
];

const _socials = [
  (name: 'Telegram', icon: Icons.send_rounded, url: 'https://t.me/gozgon_life', color: Color(0xFF0088CC)),
  (name: 'Instagram', icon: Icons.camera_alt_rounded, url: 'https://instagram.com', color: Color(0xFFE1306C)),
  (name: 'Facebook', icon: Icons.facebook_rounded, url: 'https://facebook.com', color: Color(0xFF1877F2)),
  (name: 'YouTube', icon: Icons.play_circle_outline_rounded, url: 'https://youtube.com', color: Color(0xFFFF0000)),
];

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  void _call(String number) => launchUrl(Uri.parse('tel:$number'));

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aloqa'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('Favqulodda raqamlar', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ),
            ..._emergency.map((e) => Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(color: e.color.withValues(alpha: 0.12), shape: BoxShape.circle),
                      child: Icon(e.icon, color: e.color, size: 22),
                    ),
                    title: Text(e.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text(e.number, style: TextStyle(fontSize: 18, color: e.color, fontWeight: FontWeight.w800, letterSpacing: 1)),
                    trailing: GestureDetector(
                      onTap: () => _call(e.number),
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(color: e.color, shape: BoxShape.circle),
                        child: const Icon(Icons.phone_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('Ijtimoiy tarmoqlar', style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: Row(
                children: _socials.map((s) => Expanded(
                  child: GestureDetector(
                    onTap: () => launchUrl(Uri.parse(s.url), mode: LaunchMode.externalApplication),
                    child: Container(
                      margin: EdgeInsets.only(right: s.name != 'YouTube' ? 10 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: s.color.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: s.color.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Icon(s.icon, color: s.color, size: 26),
                          const SizedBox(height: 6),
                          Text(s.name, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: s.color)),
                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, Color(0xFF1D4ED8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 14),
            const Text("Bog'lanish", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text(
              "G'ozg'on shahri xizmatlari va favqulodda raqamlar",
              style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
          ],
        ),
      );
}
