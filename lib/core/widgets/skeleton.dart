import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton effekti har bir ekranda sessiya davomida faqat bir marta
/// ko'rsatiladi. Bir marta yuklangandan keyin qayta ochilganda chiqmaydi.
final Set<String> _shownSkeletons = <String>{};

/// Ma'lumot hozircha lokal (kod ichida) — kutadigan hech narsa yo'q.
/// Skeleton ko'rsatish faqat sun'iy kechikish bo'lardi va ilovani
/// haqiqatdan sekinroq qilib ko'rsatardi, shuning uchun o'chirilgan.
///
/// Backend (Firestore/API) ulanganda shuni `true` qiling — barcha
/// ekranlardagi skeleton mantiqi joyida turibdi va darhol ishlaydi.
const bool kUseSkeletons = false;

bool shouldShowSkeleton(String key) {
  if (!kUseSkeletons) return false;
  if (_shownSkeletons.contains(key)) return false;
  _shownSkeletons.add(key);
  return true;
}

class SkeletonShimmer extends StatelessWidget {
  final Widget child;
  const SkeletonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: dark ? const Color(0xFF1E293B) : Colors.grey[300]!,
      highlightColor: dark ? const Color(0xFF334155) : Colors.grey[100]!,
      child: child,
    );
  }
}

Widget skBox({double? w, double h = 16, double r = 8}) => Container(
      width: w ?? double.infinity,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
      ),
    );
