import 'package:flutter/material.dart';

/// Nav shell tashqarisidagi (top-level) ekranlar uchun to'liq ekran fon.
///
/// Detal sahifalar shaffof [Scaffold] ishlatadi; ular nav shell ustiga
/// push qilinganda, shell (va uning pastki menyusi) ostidan ko'rinib
/// qolmasligi uchun butun ekranni qoplaydigan marmar/qorong'i fon chiziladi.
class AppBackground extends StatelessWidget {
  final Widget child;
  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            dark ? 'assets/images/dark_bg.png' : 'assets/images/marble_bg.png',
            fit: BoxFit.cover,
            cacheWidth: 800,
          ),
        ),
        child,
      ],
    );
  }
}
