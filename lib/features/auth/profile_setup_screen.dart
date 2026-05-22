import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _State();
}

class _State extends State<ProfileSetupScreen> {
  final _name = TextEditingController();
  final _surname = TextEditingController();
  DateTime? _birthDate;
  bool _loading = false;

  bool get _valid => _name.text.trim().isNotEmpty && _surname.text.trim().isNotEmpty;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppTheme.primary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (!_valid || _loading) return;
    setState(() => _loading = true);
    final p = await SharedPreferences.getInstance();
    await p.setString('user_name', '${_name.text.trim()} ${_surname.text.trim()}');
    await p.setString('first_name', _name.text.trim());
    await p.setString('last_name', _surname.text.trim());
    if (_birthDate != null) {
      await p.setString('birth_date', _birthDate!.toIso8601String());
    }
    if (mounted) {
      setState(() => _loading = false);
      context.go('/auth/terms');
    }
  }

  @override
  void dispose() { _name.dispose(); _surname.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final birth = _birthDate == null ? null : '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}';

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 52,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.1),
                      child: const Icon(Icons.person_rounded, size: 56, color: AppTheme.primary),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: Container(
                        width: 32, height: 32,
                        decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text('Profilingiz', style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text("Ma'lumotlaringizni kiriting", style: tt.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
              const SizedBox(height: 24),
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Ism', prefixIcon: Icon(Icons.person_outline_rounded)),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _surname,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(hintText: 'Familiya', prefixIcon: Icon(Icons.person_outline_rounded)),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: AppTheme.textSecondary, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        birth ?? 'Tug\'ilgan sana',
                        style: TextStyle(fontSize: 15, color: birth == null ? AppTheme.textSecondary : AppTheme.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _valid && !_loading ? _save : null,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Davom etish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
