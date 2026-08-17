import 'package:flutter/material.dart';

/// Har bir bo'lim (feature) uchun YAGONA rasmiy rang — Home va Xizmatlar
/// plitkalari, shuningdek o'sha bo'limning o'z ekrani (PremiumScaffold
/// accent) shu yerdan foydalanadi. Rangni o'zgartirish kerak bo'lsa —
/// FAQAT shu yerda o'zgartiriladi, boshqa fayllarda emas.
class AppColors {
  AppColors._();

  static const news = Color(0xFF2563EB);
  static const appeals = Color(0xFF7C3AED);
  static const transport = Color(0xFFBF360C);
  static const bank = Color(0xFF0B6E4F);
  static const ads = Color(0xFFF59E0B);
  static const prayer = Color(0xFF006064);
  static const map = Color(0xFF37474F);
  static const mahalla = Color(0xFF92400E);
  static const tourism = Color(0xFFEA580C);
  static const market = Color(0xFFDC2626);
}

/// Burchak radiuslari — ekranlar bo'ylab bitta izchil shkala.
/// Yangi qiymat kerak bo'lsa, avval shu 4 tadan birortasi mos kelmasligini
/// tekshiring.
class AppRadius {
  AppRadius._();

  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
}

/// Shrift o'lchamlari shkalasi — har bir ekran o'zi 12.5/13.5/14.5 kabi
/// tasodifiy qiymat o'ylab topmasin, shu 8 ta darajadan birini tanlasin.
class AppFontSize {
  AppFontSize._();

  /// Kichik yorliq/belgi matni (masalan status chip ichida).
  static const tiny = 10.0;

  /// Ikkinchi darajali/meta matn (sana, manzil, kichik izoh).
  static const caption = 12.0;

  /// Oddiy matnning kichikroq varianti (kartadagi ikkinchi qator).
  static const bodySmall = 13.0;

  /// Standart matn o'lchami.
  static const body = 14.0;

  /// Ro'yxat/karta sarlavhasi, tugma matni.
  static const title = 16.0;

  /// Kichik bo'lim sarlavhasi.
  static const h2 = 18.0;

  /// Ekran/katta bo'lim sarlavhasi.
  static const h1 = 22.0;

  /// Katta ko'rsatkich (masalan narx, statistik raqam).
  static const display = 28.0;
}

/// Umumiy soya (shadow) retseptlari — har bir ekran o'zi blur/opacity
/// o'ylab topmasin, shu yerdan foydalansin.
class AppShadow {
  AppShadow._();

  /// Oddiy karta soyasi (light/dark rejimga moslashadi).
  static List<BoxShadow> card(bool dark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: dark ? 0.30 : 0.08),
          blurRadius: 14,
          offset: const Offset(0, 5),
        ),
      ];

  /// Bo'lim rangida "porlash" soyasi — ikonka plitkalari, tugmalar uchun.
  static List<BoxShadow> glow(Color hue, bool dark) => [
        BoxShadow(
          color: hue.withValues(alpha: dark ? 0.45 : 0.40),
          blurRadius: 14,
          spreadRadius: -1,
        ),
      ];
}
