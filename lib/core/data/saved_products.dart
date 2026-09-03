import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saqlangan mahsulotlar — mahsulot title'i bo'yicha saqlanadi,
/// SharedPreferences'da doimiy turadi. UI ValueNotifier orqali yangilanadi.
class SavedProducts {
  SavedProducts._();

  static const _key = 'saved_products';
  static final ValueNotifier<Set<String>> titles = ValueNotifier(<String>{});

  /// Yuklash faqat bir marta boshlanadi, lekin keyingi chaqiruvlar
  /// TUGASHINI kutadi. Aks holda diskdan o'qish tugamasdan `toggle()`
  /// chaqirilsa, u bo'sh ro'yxat ustiga yozib, avval saqlanganlarni
  /// o'chirib yuborardi.
  static Future<void>? _loading;

  static Future<void> ensureLoaded() => _loading ??= _load();

  static Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    titles.value = (p.getStringList(_key) ?? const []).toSet();
  }

  static Future<void> toggle(String title) async {
    // Avval diskdagi ro'yxat yuklanib bo'lishi shart.
    await ensureLoaded();
    final s = Set<String>.from(titles.value);
    if (!s.remove(title)) s.add(title);
    titles.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, s.toList());
  }

  /// Seansdan chiqishda chaqiriladi — diskdan ham, xotiradan ham
  /// tozalaydi (aks holda qayta kirilganda eski ro'yxat ko'rinib turardi).
  static Future<void> clear() async {
    titles.value = <String>{};
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
