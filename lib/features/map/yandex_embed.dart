import 'package:flutter/widgets.dart';

import 'yandex_embed_stub.dart'
    if (dart.library.io) 'yandex_embed_io.dart'
    if (dart.library.html) 'yandex_embed_web.dart';

/// Yandex xarita embed'ini joriy platforma uchun quradi
/// (mobil — WebView, web — iframe).
Widget yandexEmbed(String url) => createYandexEmbed(url);
