import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});
  @override
  State<TermsScreen> createState() => _State();
}

class _State extends State<TermsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foydalanish shartlari'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Foydalanish shartlari va maxfiylik siyosati",
                            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primary),
                          ),
                          const SizedBox(height: 16),
                          _section(tt, '1. Umumiy qoidalar',
                              "G'ozg'on Life ilovasi foydalanuvchilarga shahar xizmatlari, yangiliklar, ma'lumotlar va boshqa xizmatlardan foydalanish imkonini beradi. Ilovadan foydalanish ushbu shartlarga rozilikni bildiradi."),
                          _section(tt, '2. Shaxsiy ma\'lumotlar',
                              "Siz tomonidan kiritilgan ma'lumotlar (ism, familiya, telefon raqam, tug'ilgan sana) faqat xizmat ko'rsatish maqsadida ishlatiladi va uchinchi shaxslarga berilmaydi. Ma'lumotlaringiz himoyalangan serverda saqlanadi."),
                          _section(tt, '3. Maxfiylik siyosati',
                              "Ma'lumotlaringiz xavfsizligi ta'minlanadi. Har qanday axborot almashinuvi shifrlangan kanallar orqali amalga oshiriladi. Biz siz haqingizda to'plangan ma'lumotlarni marketing maqsadlarida foydalanmaymiz."),
                          _section(tt, '4. Foydalanuvchi majburiyatlari',
                              "Siz ilovadan qonunga xilof maqsadlarda foydalanmaslik, boshqa foydalanuvchilar huquqlarini hurmat qilish va noto'g'ri ma'lumot kiritmасlik majburiyatini olasiz."),
                          _section(tt, '5. Cookie va tahlil',
                              "Ilovani yaxshilash maqsadida foydalanish statistikasi to'planadi. Bu ma'lumotlar shaxsiylashtirilmagan holda qayta ishlanadi."),
                          _section(tt, '6. Shartlar o\'zgarishi',
                              "G'ozg'on Life xizmat shartlarini istalgan vaqtda o'zgartirish huquqini saqlab qoladi. O'zgarishlar haqida ilova orqali xabar beriladi."),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _accepted = !_accepted),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _accepted ? AppTheme.primary.withValues(alpha: 0.06) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _accepted ? AppTheme.primary : AppTheme.divider,
                            width: _accepted ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _accepted ? AppTheme.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _accepted ? AppTheme.primary : AppTheme.textSecondary,
                                  width: 2,
                                ),
                              ),
                              child: _accepted
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Foydalanish shartlari va maxfiylik siyosatini o'qidim va qabul qilaman",
                                style: tt.bodyMedium?.copyWith(
                                  color: _accepted ? AppTheme.textPrimary : AppTheme.textSecondary,
                                  fontWeight: _accepted ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _accepted ? () => context.go('/auth/success') : null,
              child: const Text("Davom etish"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(TextTheme tt, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
          const SizedBox(height: 4),
          Text(body, style: tt.bodySmall?.copyWith(color: AppTheme.textSecondary, height: 1.6)),
        ],
      ),
    );
  }
}
