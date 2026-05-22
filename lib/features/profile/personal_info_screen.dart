import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});
  @override
  State<PersonalInfoScreen> createState() => _State();
}

class _State extends State<PersonalInfoScreen> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  DateTime? _birthDate;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    if (!mounted) return;
    final rawBirth = p.getString('birth_date') ?? '';
    setState(() {
      _firstName.text = p.getString('first_name') ?? '';
      _lastName.text = p.getString('last_name') ?? '';
      _phone.text = p.getString('phone') ?? '';
      _birthDate = rawBirth.isNotEmpty ? DateTime.tryParse(rawBirth) : null;
      _loading = false;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 10)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final p = await SharedPreferences.getInstance();
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    await p.setString('first_name', first);
    await p.setString('last_name', last);
    await p.setString('user_name', '$first $last'.trim());
    await p.setString('phone', _phone.text.trim());
    if (_birthDate != null) {
      await p.setString('birth_date', _birthDate!.toIso8601String());
    }
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Ma'lumotlar saqlandi"),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _formatBirth(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shaxsiy ma'lumotlar"),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      _fieldCard(
                        label: 'Ism',
                        icon: Icons.person_outline_rounded,
                        child: TextField(
                          controller: _firstName,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDeco(),
                          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _fieldCard(
                        label: 'Familiya',
                        icon: Icons.person_outline_rounded,
                        child: TextField(
                          controller: _lastName,
                          textCapitalization: TextCapitalization.words,
                          decoration: _inputDeco(),
                          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _fieldCard(
                        label: 'Telefon raqam',
                        icon: Icons.phone_outlined,
                        child: TextField(
                          controller: _phone,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d\+\s]'))],
                          decoration: _inputDeco(),
                          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _fieldCard(
                        label: "Tug'ilgan sana",
                        icon: Icons.cake_outlined,
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppTheme.primary, size: 20),
                          onPressed: _pickDate,
                        ),
                        child: GestureDetector(
                          onTap: _pickDate,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: AppTheme.divider)),
                            ),
                            child: Text(
                              _birthDate != null ? _formatBirth(_birthDate!) : "Sanani tanlang",
                              style: tt.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: _birthDate != null ? AppTheme.textPrimary : AppTheme.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Saqlash"),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _fieldCard({
    required String label,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primary)),
              const Spacer(),
              ?trailing,
            ],
          ),
          child,
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  InputDecoration _inputDeco() => const InputDecoration(
        border: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.divider)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.divider)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primary, width: 2)),
        contentPadding: EdgeInsets.symmetric(vertical: 14),
        isDense: true,
        suffixIcon: Icon(Icons.edit_outlined, color: AppTheme.primary, size: 18),
      );
}
