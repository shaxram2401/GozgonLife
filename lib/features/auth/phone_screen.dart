import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _State();
}

class _State extends State<PhoneScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;
  bool _register = false; // false = Kirish, true = Ro'yxatdan o'tish

  bool get _valid => _ctrl.text.replaceAll(' ', '').length == 9;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1E3A8A), Color(0xFF11205A)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo — brendli belgi
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Text(
                      "G'",
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 46,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    "G'ozg'on Life",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    "Shahringizning smart ilovasi",
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 14),
                  ),
                ),
                const SizedBox(height: 36),

                // Kirish / Ro'yxat toggle
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      _tab('Kirish', !_register, () {
                        setState(() => _register = false);
                      }),
                      _tab("Ro'yxatdan o'tish", _register, () {
                        setState(() => _register = true);
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                Text(
                  'Telefon raqamingiz',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                // Phone field
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 12, 0),
                        child: Text('+998',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.white.withValues(alpha: 0.9))),
                      ),
                      Container(
                          width: 1,
                          height: 28,
                          color: Colors.white.withValues(alpha: 0.18)),
                      Expanded(
                        child: TextField(
                          controller: _ctrl,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          cursorColor: Colors.white,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                              color: Colors.white),
                          decoration: InputDecoration(
                            hintText: '90 123 45 67',
                            hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 18),
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
                const SizedBox(height: 24),

                // Davom etish — oq tugma
                _whiteButton(
                  label: _register ? "Ro'yxatdan o'tish" : 'Kirish',
                  loading: _loading,
                  enabled: _valid,
                  onTap: _submit,
                ),
                const SizedBox(height: 22),

                // yoki
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                            color: Colors.white.withValues(alpha: 0.2))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('yoki',
                          style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 13)),
                    ),
                    Expanded(
                        child: Divider(
                            color: Colors.white.withValues(alpha: 0.2))),
                  ],
                ),
                const SizedBox(height: 22),

                // Google
                _googleButton(),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Davom etish orqali siz shartlarga rozilik bildirasiz',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11.5,
                        height: 1.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tab(String label, bool sel, VoidCallback onTap) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: sel ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: sel ? AppTheme.primary : Colors.white,
              ),
            ),
          ),
        ),
      );

  Widget _whiteButton({
    required String label,
    required bool loading,
    required bool enabled,
    required VoidCallback onTap,
  }) =>
      AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled && !loading ? 1 : 0.55,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: enabled && !loading ? onTap : null,
            child: Ink(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: AppTheme.primary, strokeWidth: 2.4),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(label,
                              style: const TextStyle(
                                  color: AppTheme.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded,
                              color: AppTheme.primary, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );

  Widget _googleButton() => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _loading ? null : _googleSignIn,
          child: Ink(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  alignment: Alignment.center,
                  child: const Text('G',
                      style: TextStyle(
                          color: Color(0xFF4285F4),
                          fontSize: 17,
                          fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                const Text('Google orqali kirish',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
}
