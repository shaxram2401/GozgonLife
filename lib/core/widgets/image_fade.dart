import 'package:flutter/material.dart';

/// Rasm yuklanib bo'lgach "sakrab" paydo bo'lmasligi uchun silliq
/// ochilish effekti.
///
/// `Image.asset(..., frameBuilder: fadeInFrame)` ko'rinishida ishlatiladi.
/// Rasm keshdan darhol kelsa (`wasSynchronouslyLoaded`) — animatsiya
/// o'tkazib yuboriladi, aks holda ekranga qaytganda keraksiz "miltillash"
/// bo'lardi.
Widget fadeInFrame(
  BuildContext context,
  Widget child,
  int? frame,
  bool wasSynchronouslyLoaded,
) {
  if (wasSynchronouslyLoaded) return child;
  return AnimatedOpacity(
    opacity: frame == null ? 0 : 1,
    duration: const Duration(milliseconds: 280),
    curve: Curves.easeOut,
    child: child,
  );
}
