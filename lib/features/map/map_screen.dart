import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/navigation/scaffold_with_nav.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'c_map')),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: ScaffoldWithNav.openDrawer,
        ),
      ),
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
