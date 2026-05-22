import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _State();
}

class _State extends State<PhoneScreen> {
  final _ctrl = TextEditingController();
  bool _loading = false;

  bool get _valid => _ctrl.text.replaceAll(' ', '').length == 9;

  Future<void> _submit() async {
    if (!_valid) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      context.push('/auth/otp', extra: '+998${_ctrl.text.replaceAll(' ', '')}');
    }
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
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Container(
                width: 56, height: 56,
                decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(14)),
                child: const Icon(Icons.phone_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 24),
              Text("Telefon raqam", style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text("SMS tasdiqlash kodi yuborish uchun\nraqamingizni kiriting", style: tt.bodyMedium?.copyWith(color: AppTheme.textSecondary, height: 1.5)),
              const SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(13)),
                        border: const Border(right: BorderSide(color: AppTheme.divider)),
                      ),
                      child: const Text('+998', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _ctrl,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 1),
                        decoration: const InputDecoration(
                          hintText: '90 123 45 67',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                          filled: false,
                        ),
                        onChanged: (v) {
                          final f = _format(v);
                          if (f != v) {
                            _ctrl.value = TextEditingValue(text: f, selection: TextSelection.collapsed(offset: f.length));
                          }
                          setState(() {});
                        },
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _valid && !_loading ? _submit : null,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('SMS yuborish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
