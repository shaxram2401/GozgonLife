import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_scaffold.dart';
import 'yandex_embed.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  // G'ozg'on shaharchasi markazi.
  static const _lat = 40.588217;
  static const _lng = 65.489448;
  static const _zoom = 15;

  @override
  Widget build(BuildContext context) {
    final lang =
        Localizations.localeOf(context).languageCode == 'ru' ? 'ru_RU' : 'uz_UZ';
    final url =
        'https://yandex.uz/map-widget/v1/?ll=$_lng%2C$_lat&z=$_zoom&pt=$_lng,$_lat,pm2rdm&lang=$lang';
    return PremiumScaffold(
      title: tr(context, 'c_map'),
      accent: const Color(0xFF37474F),
      showBar: true,
      body: yandexEmbed(url),
    );
  }
}
