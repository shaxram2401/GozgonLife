// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';

final Set<String> _registered = {};

/// Web — Yandex embed'ini <iframe> orqali ko'rsatadi.
Widget createYandexEmbed(String url) {
  final viewType = 'yandex-map-${url.hashCode}';
  if (!_registered.contains(viewType)) {
    _registered.add(viewType);
    ui_web.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = url
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..allow = 'geolocation';
      return iframe;
    });
  }
  return HtmlElementView(viewType: viewType);
}
