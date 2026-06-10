import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_scaffold.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PremiumScaffold(
      title: tr(context, 'c_map'),
      accent: const Color(0xFF37474F),
      showBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.map_outlined, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              tr(context, 'map_soon'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
