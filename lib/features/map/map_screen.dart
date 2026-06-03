import 'package:flutter/material.dart';

import '../../core/navigation/scaffold_with_nav.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xarita'),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: ScaffoldWithNav.openDrawer,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Xarita tez orada',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
