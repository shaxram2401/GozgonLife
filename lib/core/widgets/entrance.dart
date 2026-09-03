import 'package:flutter/material.dart';

/// Ekranga BIRINCHI marta kirilganini sessiya davomida bir marta
/// qaytaradi — kirish animatsiyasi faqat bir marta o'ynashi uchun.
/// Har safar takrorlansa, ilova sekin va bezovta ko'rinardi.
final Set<String> _visited = <String>{};

bool isFirstVisit(String key) {
  if (_visited.contains(key)) return false;
  _visited.add(key);
  return true;
}

/// Ketma-ket (staggered) paydo bo'lish — pastdan yengil siljib, shaffofdan
/// to'liq ko'rinishga. `CategoryTile`dagi bilan bir xil "his".
///
/// [index] — elementning ro'yxatdagi tartibi, kechikish shunga qarab
/// hisoblanadi. [enabled] false bo'lsa animatsiya umuman bo'lmaydi.
class EntranceFade extends StatefulWidget {
  final Widget child;
  final int index;
  final bool enabled;

  const EntranceFade({
    super.key,
    required this.child,
    this.index = 0,
    this.enabled = true,
  });

  @override
  State<EntranceFade> createState() => _EntranceFadeState();
}

class _EntranceFadeState extends State<EntranceFade>
    with SingleTickerProviderStateMixin {
  late final AnimationController _in;

  @override
  void initState() {
    super.initState();
    _in = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    if (!widget.enabled) {
      _in.value = 1;
      return;
    }
    Future.delayed(Duration(milliseconds: 60 + widget.index * 55), () {
      if (mounted) _in.forward();
    });
  }

  @override
  void dispose() {
    _in.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _in,
      builder: (context, child) {
        final v = _in.value.clamp(0.0, 1.0);
        final slide = Curves.easeOutCubic.transform(v);
        final fade = Curves.easeOut.transform(v);
        return Opacity(
          opacity: fade,
          child: Transform.translate(
            offset: Offset(0, (1 - slide) * 18),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Matnni harflab "terib" chiqaradi — AI yordamchining javobi jonli
/// ko'rinishi uchun. [enabled] false bo'lsa matn darhol to'liq chiqadi.
class TypewriterText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool enabled;

  /// Bitta harf orasidagi vaqt.
  final Duration speed;

  const TypewriterText({
    super.key,
    required this.text,
    this.style,
    this.enabled = true,
    this.speed = const Duration(milliseconds: 18),
  });

  @override
  State<TypewriterText> createState() => _TypewriterTextState();
}

class _TypewriterTextState extends State<TypewriterText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<int> _chars;

  @override
  void initState() {
    super.initState();
    final total = widget.text.characters.length;
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.speed * total,
    );
    _chars = StepTween(begin: 0, end: total).animate(_ctrl);
    if (widget.enabled) {
      // Ekran ochilib ulgurishi uchun qisqa pauza.
      Future.delayed(const Duration(milliseconds: 280), () {
        if (mounted) _ctrl.forward();
      });
    } else {
      _ctrl.value = 1;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return Text(widget.text, style: widget.style);
    return AnimatedBuilder(
      animation: _chars,
      builder: (context, _) {
        final shown = widget.text.characters.take(_chars.value).toString();
        return Text(shown, style: widget.style);
      },
    );
  }
}
