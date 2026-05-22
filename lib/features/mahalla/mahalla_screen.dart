import 'package:flutter/material.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _blue = Color(0xFF0EA5E9);

class MahallaScreen extends StatelessWidget {
  const MahallaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahallam'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _banner(),
            _header("MFY ro'yxati"),
            _mfy('Marmarobod MFY', "Marmarobod ko'chasi 12", '+998 75 221 10 01', 847),
            _mfy('Shayxon MFY', "Mustaqillik ko'chasi 34", '+998 75 221 10 02', 624),
            _mfy('Tumar MFY', "Amir Temur ko'chasi 7", '+998 75 221 10 03', 712),
            _mfy('Guliston MFY', "Bog'ishamol ko'chasi 18", '+998 75 221 10 04', 539),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _banner() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0369A1), _blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mahalla Fuqarolar\nYig'inlari", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.2)),
                  SizedBox(height: 8),
                  Text("G'ozg'on shahrida 4 ta MFY\n2 722 xotin-qiz ro'yxatda", style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
            const Icon(Icons.location_city_rounded, color: Colors.white, size: 56),
          ],
        ),
      );

  Widget _header(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );

  Widget _mfy(String name, String address, String phone, int xotin) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: _blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.home_work_rounded, color: _blue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 2),
                      Text(address, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.phone_outlined, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text(phone, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const Spacer(),
                const Icon(Icons.people_outlined, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 6),
                Text('$xotin xotin-qiz', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              ],
            ),
          ],
        ),
      );
}
