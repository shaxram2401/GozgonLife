import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});
  @override
  State<OtpScreen> createState() => _State();
}

class _State extends State<OtpScreen> {
  final _ctrls = List.generate(6, (_) => TextEditingController());
  final _nodes = List.generate(6, (_) => FocusNode());
  bool _loading = false;
  int _seconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) { t.cancel(); return; }
      if (mounted) setState(() => _seconds--);
    });
  }

  void _onChanged(int i, String v) {
    if (v.length == 1 && i < 5) _nodes[i + 1].requestFocus();
    if (v.isEmpty && i > 0) _nodes[i - 1].requestFocus();
    setState(() {});
    if (_otp.length == 6) _verify();
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_otp.length < 6 || _loading) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    final p = await SharedPreferences.getInstance();
    await p.setString('phone', widget.phone);
    if (mounted) {
      setState(() => _loading = false);
      context.go('/auth/profile');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _ctrls) { c.dispose(); }
    for (final f in _nodes) { f.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Tasdiqlash'), backgroundColor: Colors.transparent, foregroundColor: AppTheme.textPrimary, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('SMS kodni kiriting', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: tt.bodyMedium?.copyWith(color: AppTheme.textSecondary),
                children: [
                  const TextSpan(text: 'Kod yuborildi: '),
                  TextSpan(text: widget.phone, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
                ],
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (i) => SizedBox(
                width: 48, height: 58,
                child: TextField(
                  controller: _ctrls[i],
                  focusNode: _nodes[i],
                  onChanged: (v) => _onChanged(i, v),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.divider)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.primary, width: 2)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )),
            ),
            const SizedBox(height: 24),
            Center(
              child: _seconds > 0
                  ? Text('Qayta yuborish: $_seconds s', style: const TextStyle(color: AppTheme.textSecondary))
                  : TextButton(
                      onPressed: () { setState(() => _seconds = 60); _startTimer(); },
                      child: const Text('Kodni qayta yuborish'),
                    ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _otp.length == 6 && !_loading ? _verify : null,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Tasdiqlash'),
            ),
          ],
        ),
      ),
    );
  }
}
