import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saqlangan mahsulotlar — mahsulot title'i bo'yicha saqlanadi,
/// SharedPreferences'da doimiy turadi. UI ValueNotifier orqali yangilanadi.
class SavedProducts {
  SavedProducts._();

  static const _key = 'saved_products';
  static final ValueNotifier<Set<String>> titles = ValueNotifier(<String>{});
  static bool _loaded = false;

  static Future<void> ensureLoaded() async {
    if (_loaded) return;
    _loaded = true;
    final p = await SharedPreferences.getInstance();
    titles.value = (p.getStringList(_key) ?? const []).toSet();
  }

  static Future<void> toggle(String title) async {
    final s = Set<String>.from(titles.value);
    if (!s.remove(title)) s.add(title);
    titles.value = s;
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, s.toList());
  }
}
