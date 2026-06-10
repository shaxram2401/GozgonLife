import 'package:flutter/widgets.dart';

/// Fallback — qo'llab-quvvatlanmaydigan platformalar uchun.
Widget createYandexEmbed(String url) => const Center(
      child: Text('Map is not supported on this platform'),
    );
