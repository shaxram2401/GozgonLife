import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr(context, 'msg_title'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_rounded, size: 64, color: AppTheme.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text(tr(context, 'msg_empty'), style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}
