import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported app languages. Index order matches the translation table in strings.dart.
const supportedLanguages = [
  (code: 'uz', label: "O'zbekcha"),
  (code: 'ru', label: 'Русский'),
];

String languageLabel(String code) =>
    supportedLanguages.firstWhere((e) => e.code == code, orElse: () => supportedLanguages.first).label;

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('uz'));

  void init(String code) =>
      state = Locale(code == 'ru' ? 'ru' : 'uz');

  Future<void> setLanguage(String code) async {
    state = Locale(code);
    final p = await SharedPreferences.getInstance();
    await p.setString('locale', code);
  }
}
