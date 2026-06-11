import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _State();
}

class _State extends State<PhoneScreen> {
  final _ctrl = TextEditingController();
  final _focus = FocusNode();
  bool _loading = false;
  bool _register = false; // false = Kirish, true = Ro'yxatdan o'tish
  bool _focused = false;

  // Light premium palitra.
  static const _primary = Color(0xFF1E3A8A);
  static const _secondary = Color(0xFF2563EB);
  static const _accent = Color(0xFF60A5FA);
  static const _bg = Color(0xFFF8FAFC);
  static const _navy = Color(0xFF0F172A);
  static const _slate = Color(0xFF64748B);

  bool get _valid => _ctrl.text.replaceAll(' ', '').length == 9;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _focused = _focus.hasFocus));
  }

  Future<void> _submit() async {
    if (!_valid || _loading) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);
    context.push('/auth/otp', extra: {
      'phone': '+998 ${_ctrl.text}',
      'register': _register,
    });
  }

  Future<void> _googleSignIn() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    final p = await SharedPreferences.getInstance();
    await p.setString('auth_token', 'glt_${DateTime.now().millisecondsSinceEpoch}');
    await p.setBool('logged_in', true);
    if (mounted) context.go('/home');
  }

  String _format(String v) {
    final d = v.replaceAll(RegExp(r'\D'), '');
    final b = StringBuffer();
    for (int i = 0; i < d.length && i < 9; i++) {
      if (i == 2 || i == 5 || i == 7) b.write(' ');
      b.write(d[i]);
    }
    return b.toString();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          // ── Yumshoq ko'k ambient nur (tepa markazda) ──
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Center(
                child: Container(
                  width: 360,
                  height: 360,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _accent.withValues(alpha: 0.16),
                        _accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ── Smart-city pattern: nozik grid + tarmoq (juda past alpha) ──
          const Positioned.fill(
            child: IgnorePointer(child: CustomPaint(painter: _CityPattern())),
          ),
          // ── G'ozg'on shahar silueti — watermark, sarlavha orqasida ──
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.16,
            height: 280,
            child: const IgnorePointer(
              child: CustomPaint(painter: _CitySkyline(), size: Size.infinite),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  // ── Logo: oq premium karta + ko'k ambient glow ──
                  Center(
                    child: Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: _secondary.withValues(alpha: 0.22),
                            blurRadius: 36,
                            spreadRadius: -2,
                            offset: const Offset(0, 12),
                          ),
                          BoxShadow(
                            color: _navy.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/images/pipi.png',
                        fit: BoxFit.contain,
                        errorBuilder: (_, e, st) => const Center(
                          child: Text(
                            "G'",
                            style: TextStyle(
                              color: _primary,
                              fontSize: 44,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Center(
                    child: Text(
                      "G'ozg'on Life",
                      style: TextStyle(
                          color: _navy,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Center(
                    child: Text(
                      "Shahringizning smart ilovasi",
                      style: TextStyle(
                          color: _slate, fontSize: 14, letterSpacing: 0.1),
                    ),
                  ),
                  const Spacer(flex: 2),

                  // ── Kirish / Ro'yxat — oq panel, gradient pill ──
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: _navy.withValues(alpha: 0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 48,
                      child: Stack(
                        children: [
                          AnimatedAlign(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            alignment: _register
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: FractionallySizedBox(
                              widthFactor: 0.5,
                              heightFactor: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [_primary, _secondary],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          _secondary.withValues(alpha: 0.35),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              _tab('Kirish', !_register,
                                  () => setState(() => _register = false)),
                              _tab("Ro'yxatdan o'tish", _register,
                                  () => setState(() => _register = true)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Yorliq — ko'k telefon ikonkasi bilan ──
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Row(
                      children: [
                        Icon(Icons.phone_rounded, size: 17, color: _primary),
                        SizedBox(width: 8),
                        Text(
                          'Telefon raqamingiz',
                          style: TextStyle(
                              color: _navy,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── Telefon input — oq karta, fokusda ko'k glow ──
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _focused
                            ? _secondary
                            : _navy.withValues(alpha: 0.07),
                        width: _focused ? 1.6 : 1,
                      ),
                      boxShadow: [
                        if (_focused)
                          BoxShadow(
                            color: _secondary.withValues(alpha: 0.20),
                            blurRadius: 20,
                            spreadRadius: -2,
                          )
                        else
                          BoxShadow(
                            color: _navy.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(18, 0, 14, 0),
                          child: Text('+998',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                  color: _navy)),
                        ),
                        Container(
                            width: 1,
                            height: 28,
                            color: _navy.withValues(alpha: 0.08)),
                        Expanded(
                          child: TextField(
                            controller: _ctrl,
                            focusNode: _focus,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            cursorColor: _secondary,
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.8,
                                color: _navy),
                            decoration: InputDecoration(
                              hintText: '90 123 45 67',
                              hintStyle: TextStyle(
                                  color: _slate.withValues(alpha: 0.45),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 17),
                            ),
                            onChanged: (v) {
                              final f = _format(v);
                              if (f != v) {
                                _ctrl.value = TextEditingValue(
                                    text: f,
                                    selection: TextSelection.collapsed(
                                        offset: f.length));
                              }
                              setState(() {});
                            },
                            onSubmitted: (_) => _submit(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  // ── Asosiy CTA — ko'k gradient, o'ngda dumaloq strelka ──
                  _ctaButton(
                    label: _register ? "Ro'yxatdan o'tish" : 'Kirish',
                    loading: _loading,
                    enabled: _valid,
                    onTap: _submit,
                  ),
                  const SizedBox(height: 20),

                  // yoki
                  Row(
                    children: [
                      Expanded(
                          child:
                              Divider(color: _navy.withValues(alpha: 0.08))),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        child: Text('yoki',
                            style: TextStyle(color: _slate, fontSize: 13)),
                      ),
                      Expanded(
                          child:
                              Divider(color: _navy.withValues(alpha: 0.08))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  _googleButton(),
                  const SizedBox(height: 16),
                  // ── Shartlar — qalqon ikonkasi bilan ──
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user_outlined,
                            size: 15, color: _slate.withValues(alpha: 0.8)),
                        const SizedBox(width: 6),
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              text: 'Davom etish orqali siz ',
                              style: const TextStyle(
                                  color: _slate, fontSize: 12, height: 1.4),
                              children: [
                                TextSpan(
                                  text: 'shartlarga',
                                  style: TextStyle(
                                      color: _secondary,
                                      fontWeight: FontWeight.w600),
                                ),
                                const TextSpan(text: ' rozilik bildirasiz'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String label, bool sel, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
                color: sel ? Colors.white : _navy.withValues(alpha: 0.75),
              ),
              child: Text(label, textAlign: TextAlign.center),
            ),
          ),
        ),
      );

  Widget _ctaButton({
    required String label,
    required bool loading,
    required bool enabled,
    required VoidCallback onTap,
  }) =>
      AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled && !loading ? 1 : 0.55,
        child: GestureDetector(
          onTap: enabled && !loading ? onTap : null,
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [_primary, _secondary],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: enabled && !loading
                  ? [
                      BoxShadow(
                        color: _secondary.withValues(alpha: 0.40),
                        blurRadius: 24,
                        spreadRadius: -2,
                        offset: const Offset(0, 10),
                      ),
                    ]
                  : const [],
            ),
            child: loading
                ? const Center(
                    child: SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2.4),
                    ),
                  )
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.1)),
                      Positioned(
                        right: 9,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: const Icon(Icons.arrow_forward_rounded,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      );

  Widget _googleButton() => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _loading ? null : _googleSignIn,
          child: Ink(
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _navy.withValues(alpha: 0.06)),
              boxShadow: [
                BoxShadow(
                  color: _navy.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Rangli Google "G" harfi
                Text('G',
                    style: TextStyle(
                        color: Color(0xFF4285F4),
                        fontSize: 22,
                        fontWeight: FontWeight.w800)),
                SizedBox(width: 12),
                Text('Google orqali kirish',
                    style: TextStyle(
                        color: _navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
}

/// Smart-city fon naqshi (light): juda nozik ko'k grid, tarmoq chiziqlari
/// va zarralar — alpha 5% dan past, premium watermark qatlami.
class _CityPattern extends CustomPainter {
  const _CityPattern();

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7); // deterministik — har repaint bir xil
    final w = size.width, h = size.height;
    const blue = Color(0xFF2563EB);

    // 1) Nozik grid
    final grid = Paint()
      ..color = blue.withValues(alpha: 0.030)
      ..strokeWidth = 1;
    const step = 56.0;
    for (double x = 0; x < w; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), grid);
    }
    for (double y = 0; y < h; y += step) {
      canvas.drawLine(Offset(0, y), Offset(w, y), grid);
    }

    // 2) Tarmoq chiziqlari + node'lar (shahar xaritasi tasviri)
    final line = Paint()
      ..color = blue.withValues(alpha: 0.045)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final node = Paint()..color = blue.withValues(alpha: 0.09);
    final pts = List.generate(
        14, (_) => Offset(rnd.nextDouble() * w, rnd.nextDouble() * h));
    for (int i = 0; i < pts.length - 1; i += 2) {
      final p1 = pts[i], p2 = pts[i + 1];
      final mid = Offset((p1.dx + p2.dx) / 2, math.min(p1.dy, p2.dy) - 30);
      canvas.drawPath(
          Path()
            ..moveTo(p1.dx, p1.dy)
            ..quadraticBezierTo(mid.dx, mid.dy, p2.dx, p2.dy),
          line);
      canvas.drawCircle(p1, 2.2, node);
      canvas.drawCircle(p2, 2.2, node);
    }

    // 3) Zarralar
    final dot = Paint()..color = blue.withValues(alpha: 0.05);
    for (int i = 0; i < 26; i++) {
      canvas.drawCircle(
          Offset(rnd.nextDouble() * w, rnd.nextDouble() * h),
          rnd.nextDouble() * 1.8 + 0.6,
          dot);
    }
  }

  @override
  bool shouldRepaint(covariant _CityPattern oldDelegate) => false;
}

/// G'ozg'on shahar silueti — hashamatli light watermark. Uch qatlam:
/// uzoq tuman qatlami, o'rta binolar va oldingi landmark'lar (gumbazli
/// bino, minora-teleminorasi, zinapoyali osmono'par binolar, derazalar).
class _CitySkyline extends CustomPainter {
  const _CitySkyline();

  static const _blue = Color(0xFF1E3A8A);

  // ── Oddiy bino: tepasi tekis / zinapoyali / qiya tom ──
  void _building(Canvas c, Paint p, double x, double w, double top,
      double bottom, int style) {
    final path = Path();
    switch (style) {
      case 1: // zinapoyali tepa (art-deco)
        path
          ..moveTo(x, bottom)
          ..lineTo(x, top + 18)
          ..lineTo(x + w * 0.18, top + 18)
          ..lineTo(x + w * 0.18, top + 8)
          ..lineTo(x + w * 0.38, top + 8)
          ..lineTo(x + w * 0.38, top)
          ..lineTo(x + w * 0.62, top)
          ..lineTo(x + w * 0.62, top + 8)
          ..lineTo(x + w * 0.82, top + 8)
          ..lineTo(x + w * 0.82, top + 18)
          ..lineTo(x + w, top + 18)
          ..lineTo(x + w, bottom);
      case 2: // qiya tomli zamonaviy minora
        path
          ..moveTo(x, bottom)
          ..lineTo(x, top + 14)
          ..lineTo(x + w, top)
          ..lineTo(x + w, bottom);
      default: // tekis tepa, yengil parapet
        path
          ..moveTo(x, bottom)
          ..lineTo(x, top)
          ..lineTo(x + w * 0.12, top)
          ..lineTo(x + w * 0.12, top - 4)
          ..lineTo(x + w * 0.88, top - 4)
          ..lineTo(x + w * 0.88, top)
          ..lineTo(x + w, top)
          ..lineTo(x + w, bottom);
    }
    path.close();
    c.drawPath(path, p);
  }

  // ── Gumbazli bino (registon uslubidagi landmark) ──
  void _dome(Canvas c, Paint p, double cx, double bottom, double w,
      double bodyH) {
    final top = bottom - bodyH;
    // Tana
    c.drawRect(Rect.fromLTRB(cx - w / 2, top, cx + w / 2, bottom), p);
    // Gumbaz
    c.drawPath(
        Path()
          ..moveTo(cx - w / 2 - 4, top)
          ..quadraticBezierTo(cx - w / 2 - 4, top - w * 0.52, cx, top - w * 0.62)
          ..quadraticBezierTo(cx + w / 2 + 4, top - w * 0.52, cx + w / 2 + 4, top)
          ..close(),
        p);
    // Uchidagi nayza
    c.drawLine(Offset(cx, top - w * 0.62), Offset(cx, top - w * 0.62 - 12),
        Paint()..color = p.color..strokeWidth = 2);
    c.drawCircle(Offset(cx, top - w * 0.62 - 14), 2.4, p);
    // Yon kichik minoralar
    for (final dx in [-w / 2 - 12.0, w / 2 + 12.0]) {
      c.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromLTWH(cx + dx - 4, top - 18, 8, bodyH + 18),
              const Radius.circular(4)),
          p);
      c.drawCircle(Offset(cx + dx, top - 22), 5, p);
    }
  }

  // ── Teleminorasi (uzun ingichka, kuzatuv shari bilan) ──
  void _tower(Canvas c, Paint p, double cx, double bottom, double h) {
    final top = bottom - h;
    // Oyoqlar (uchburchak asos)
    c.drawPath(
        Path()
          ..moveTo(cx - 14, bottom)
          ..lineTo(cx - 3, top + h * 0.35)
          ..lineTo(cx + 3, top + h * 0.35)
          ..lineTo(cx + 14, bottom)
          ..close(),
        p);
    // Tanasi
    c.drawRect(
        Rect.fromLTRB(cx - 2.5, top + h * 0.12, cx + 2.5, top + h * 0.4), p);
    // Kuzatuv shari va disk
    c.drawCircle(Offset(cx, top + h * 0.30), 7.5, p);
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(
                center: Offset(cx, top + h * 0.40), width: 26, height: 6),
            const Radius.circular(3)),
        p);
    // Shpil
    c.drawLine(Offset(cx, top + h * 0.12), Offset(cx, top),
        Paint()..color = p.color..strokeWidth = 2);
  }

  // ── Bir qator binolar qatlami ──
  void _layer(Canvas c, Size s, double alpha, List<(double, double, int)> specs) {
    final p = Paint()..color = _blue.withValues(alpha: alpha);
    for (final (fx, fh, style) in specs) {
      final w = s.width * 0.085;
      _building(c, p, s.width * fx, w, s.height * (1 - fh), s.height, style);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // ── Uzoq qatlam: mayda binolar, tuman ichida ──
    _layer(canvas, size, 0.035, const [
      (0.02, 0.30, 0), (0.10, 0.42, 1), (0.19, 0.26, 2), (0.27, 0.48, 0),
      (0.36, 0.34, 1), (0.46, 0.52, 2), (0.55, 0.30, 0), (0.64, 0.44, 1),
      (0.74, 0.36, 2), (0.83, 0.50, 0), (0.92, 0.28, 1),
    ]);

    // ── O'rta qatlam: yirikroq binolar ──
    _layer(canvas, size, 0.060, const [
      (0.00, 0.46, 1), (0.13, 0.30, 0), (0.30, 0.58, 2), (0.44, 0.38, 1),
      (0.60, 0.50, 0), (0.76, 0.34, 2), (0.90, 0.55, 1),
    ]);

    // ── Oldingi qatlam: landmark'lar ──
    final front = Paint()..color = _blue.withValues(alpha: 0.085);
    _tower(canvas, front, w * 0.085, h, h * 0.92); // chapda teleminorasi
    _dome(canvas, front, w * 0.88, h, w * 0.105, h * 0.30); // o'ngda gumbaz
    _building(canvas, front, w * 0.225, w * 0.105, h * 0.34, h, 1);
    _building(canvas, front, w * 0.40, w * 0.09, h * 0.46, h, 2);
    _building(canvas, front, w * 0.56, w * 0.10, h * 0.28, h, 0);
    _building(canvas, front, w * 0.70, w * 0.085, h * 0.40, h, 1);

    // ── Oldingi binolarda derazalar (juda nozik nuqta-panjara) ──
    final win = Paint()..color = _blue.withValues(alpha: 0.05);
    final rnd = math.Random(5);
    for (final (fx, fw, fh) in const [
      (0.225, 0.105, 0.60), (0.40, 0.09, 0.50), (0.56, 0.10, 0.68),
      (0.70, 0.085, 0.56),
    ]) {
      final left = w * fx, bw = w * fw, top = h - h * fh;
      for (double y = top + 14; y < h - 10; y += 13) {
        for (double x = left + 7; x < left + bw - 8; x += 11) {
          if (rnd.nextDouble() > 0.45) {
            canvas.drawRRect(
                RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 4.5, 6),
                    const Radius.circular(1.2)),
                win);
          }
        }
      }
    }

    // ── Pastdan oqqa singib ketadigan tuman (silliq birlashish) ──
    canvas.drawRect(
      Rect.fromLTWH(0, h * 0.55, w, h * 0.45),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFF8FAFC).withValues(alpha: 0.0),
            const Color(0xFFF8FAFC).withValues(alpha: 0.85),
          ],
        ).createShader(Rect.fromLTWH(0, h * 0.55, w, h * 0.45)),
    );
  }

  @override
  bool shouldRepaint(covariant _CitySkyline oldDelegate) => false;
}
