import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Bosiladigan kartalar uchun umumiy o'rovchi — haptik javob, ripple
/// (InkWell) va bosishda kichrayish animatsiyasi. `CategoryTile`dagi
/// bosish retseptining umumiy varianti — ro'yxat/karta elementlarida
/// bir xil "sezuvchan" his beradi.
class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final BorderRadius? borderRadius;

  const PressableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.borderRadius,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        borderRadius: widget.borderRadius,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onTap();
          },
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: widget.child,
        ),
      ),
    );
  }
}
