import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../l10n/strings.dart';

/// Internet uzilganda ekran tepasida paydo bo'ladigan ogohlantirish.
///
/// Ilovaning ko'p qismi lokal ma'lumot bilan ishlaydi, lekin Zukkobek AI,
/// Ob-havo va Xarita tarmoqqa bog'liq — ular jimgina xato berish o'rniga,
/// foydalanuvchi sababini darhol bilgani ma'qul.
class OfflineBanner extends StatefulWidget {
  final Widget child;
  const OfflineBanner({super.key, required this.child});

  @override
  State<OfflineBanner> createState() => _OfflineBannerState();
}

class _OfflineBannerState extends State<OfflineBanner> {
  StreamSubscription<List<ConnectivityResult>>? _sub;
  bool _offline = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final now = await Connectivity().checkConnectivity();
      if (mounted) setState(() => _offline = _isOffline(now));
      _sub = Connectivity().onConnectivityChanged.listen((r) {
        if (mounted) setState(() => _offline = _isOffline(r));
      });
    } catch (e) {
      // Platforma qo'llab-quvvatlamasa — ogohlantirish shunchaki
      // ko'rsatilmaydi, ilova normal ishlayveradi.
      debugPrint('Ulanishni kuzatib bo\'lmadi: $e');
    }
  }

  bool _isOffline(List<ConnectivityResult> r) =>
      r.isEmpty || r.every((e) => e == ConnectivityResult.none);

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: IgnorePointer(
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOut,
              offset: _offline ? Offset.zero : const Offset(0, -1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _offline ? 1 : 0,
                child: Material(
                  color: Colors.transparent,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF334155),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off_rounded,
                              color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              tr(context, 'no_internet'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
