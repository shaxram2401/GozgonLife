import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Skeleton effekti har bir ekranda sessiya davomida faqat bir marta
/// ko'rsatiladi. Bir marta yuklangandan keyin qayta ochilganda chiqmaydi.
final Set<String> _shownSkeletons = <String>{};

bool shouldShowSkeleton(String key) {
  if (_shownSkeletons.contains(key)) return false;
  _shownSkeletons.add(key);
  return true;
}

class SkeletonShimmer extends StatelessWidget {
  final Widget child;
  const SkeletonShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: child,
      );
}

Widget skBox({double? w, double h = 16, double r = 8}) => Container(
      width: w ?? double.infinity,
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(r),
      ),
    );
