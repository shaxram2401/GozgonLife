import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import 'auth_widgets.dart';

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
      context.go('/auth/success');
    }
  }

  @override
  void dispose() { _name.dispose(); _surname.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final birth = _birthDate == null ? null : '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}';

    return Scaffold(
      body: Stack(
        children: [
          const AuthBackdrop(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.secondary.withValues(alpha: 0.18),
                                AppTheme.primary.withValues(alpha: 0.12),
                              ],
                            ),
                            border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.2),
                                width: 2),
                          ),
                          child: const Icon(Icons.person_rounded,
                              size: 54, color: AppTheme.primary),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppTheme.secondary, AppTheme.primary],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: AppTheme.card(context), width: 3),
                            ),
                            child: const Icon(Icons.camera_alt_rounded,
                                color: Colors.white, size: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(tr(context, 'ps_title'),
                      style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Text(tr(context, 'ps_sub'),
                      style: tt.bodyMedium
                          ?.copyWith(color: AppTheme.ts(context), height: 1.5)),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _name,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: tr(context, 'pi_first'),
                        prefixIcon:
                            const Icon(Icons.person_outline_rounded)),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _surname,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        hintText: tr(context, 'pi_last'),
                        prefixIcon:
                            const Icon(Icons.badge_outlined)),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      decoration: BoxDecoration(
                        color: AppTheme.card(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.dv(context)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: AppTheme.ts(context), size: 20),
                          const SizedBox(width: 12),
                          Text(
                            birth ?? tr(context, 'pi_birth'),
                            style: TextStyle(
                                fontSize: 15,
                                color: birth == null
                                    ? AppTheme.ts(context)
                                    : AppTheme.tp(context)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  AuthButton(
                    label: tr(context, 'continue'),
                    enabled: _valid,
                    loading: _loading,
                    onTap: _save,
                    icon: Icons.arrow_forward_rounded,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
