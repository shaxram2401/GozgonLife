import 'package:flutter/widgets.dart';

/// Faol tab ikonkasi qayta bosilganda ekranni eng yuqoriga suradi.
///
/// Ekran o'z [ScrollController]'ini tab yo'li (masalan `/home`, `/market`)
/// kaliti bilan ro'yxatdan o'tkazadi; pastki nav o'sha kalit bo'yicha
/// [scrollToTop] chaqiradi.
class TabScrollTop {
  TabScrollTop._();

  static final Map<String, ScrollController> _controllers = {};

  static void register(String key, ScrollController c) =>
      _controllers[key] = c;

  static void unregister(String key, ScrollController c) {
    if (_controllers[key] == c) _controllers.remove(key);
  }

  static void scrollToTop(String key) {
    final c = _controllers[key];
    if (c != null && c.hasClients) {
      c.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }
}
