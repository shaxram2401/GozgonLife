import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/skeleton.dart';

const _blue = Color(0xFF0EA5E9);

class MahallaScreen extends StatefulWidget {
  const MahallaScreen({super.key});
  @override
  State<MahallaScreen> createState() => _MahallaScreenState();
}

class _MahallaScreenState extends State<MahallaScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Scaffold(
      appBar: AppBar(title: const Text('Mahallam'), leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer)),
      body: const _MahallaSkeleton(),
    );
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

  Widget _banner() => ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Image.asset(
            'assets/images/mahalla.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
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

class _MahallaSkeleton extends StatelessWidget {
  const _MahallaSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skBox(h: 180, r: 0),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  skBox(h: 16, w: 140),
                  const SizedBox(height: 12),
                  for (int i = 0; i < 4; i++) ...[skBox(h: 100, r: 14), const SizedBox(height: 12)],
                ]),
              ),
            ],
          ),
        ),
      );
}
