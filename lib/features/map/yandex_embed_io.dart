import 'package:flutter/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Mobil (Android/iOS) — Yandex embed'ini WebView orqali ko'rsatadi.
Widget createYandexEmbed(String url) => _IoYandexEmbed(url: url);

class _IoYandexEmbed extends StatefulWidget {
  final String url;
  const _IoYandexEmbed({required this.url});

  @override
  State<_IoYandexEmbed> createState() => _IoYandexEmbedState();
}

class _IoYandexEmbedState extends State<_IoYandexEmbed> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}
