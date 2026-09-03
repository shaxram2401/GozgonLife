import 'dart:ui' show ImageFilter;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/entrance.dart';
import '../../core/widgets/pressable_card.dart';

const _geminiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyDdThyjjJWnxZ8aY8cVZNihpaougQAqzlk';

class _Msg {
  final String text;
  final bool isUser;
  const _Msg(this.text, {required this.isUser});
}

class ZukkobekScreen extends StatefulWidget {
  const ZukkobekScreen({super.key});
  @override
  State<ZukkobekScreen> createState() => _State();
}

class _State extends State<ZukkobekScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  late final Dio _dio;
  final _msgs = <_Msg>[];
  bool _loading = false;
  String? _error;

  /// Sessiyada birinchi marta kirilyaptimi — salomlashish matni harflab
  /// terilib chiqishi uchun (keyingi kirishlarda darhol ko'rsatiladi).
  late final bool _firstVisit;

  @override
  void initState() {
    super.initState();
    _firstVisit = isFirstVisit('zukkobek');
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Seed (and refresh on language change) the greeting message.
    final greeting = _Msg(tr(context, 'zk_greeting'), isUser: false);
    if (_msgs.isEmpty) {
      _msgs.add(greeting);
    } else if (!_msgs.first.isUser) {
      _msgs[0] = greeting;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _send([String? preset]) async {
    final text = (preset ?? _ctrl.text).trim();
    if (text.isEmpty || _loading) return;
    _ctrl.clear();
    setState(() {
      _msgs.add(_Msg(text, isUser: true));
      _loading = true;
      _error = null;
    });
    _scrollDown();

    // Matnlar `await`dan OLDIN olinadi — keyin `context`ga murojaat qilish
    // xavfli (widget o'chib ketgan bo'lishi mumkin).
    final errFallback = tr(context, 'zk_error');
    final systemPrompt = tr(context, 'zk_system');

    try {
      final history = _msgs.sublist(1).map((m) => {
            'role': m.isUser ? 'user' : 'model',
            'parts': [{'text': m.text}],
          }).toList();

      final res = await _dio.post(
        _geminiUrl,
        data: {
          'system_instruction': {
            'parts': [{'text': systemPrompt}],
          },
          'contents': history,
          'generationConfig': {'maxOutputTokens': 1024},
        },
      );

      final reply = res.data['candidates'][0]['content']['parts'][0]['text'] as String;
      if (!mounted) return;
      setState(() {
        _msgs.add(_Msg(reply, isUser: false));
        _loading = false;
      });
    } catch (e) {
      // Xizmatning xom (inglizcha, texnik) xato matni foydalanuvchiga
      // ko'rsatilmaydi — u faqat ishlab chiquvchi uchun logga yoziladi.
      debugPrint('Zukkobek so\'rovi muvaffaqiyatsiz: $e');
      if (!mounted) return;
      setState(() {
        _msgs.add(_Msg(errFallback, isUser: false));
        _loading = false;
        _error = errFallback;
      });
    }
    _scrollDown();
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Chat ekrani — boshqa ekranlar kabi shishasimon (glass) panel,
          // lekin yig'ilmaydi (avatar/status doim ko'rinib turishi kerak).
          _GlassHeader(
            loading: _loading,
            onClear: () => setState(() {
              _msgs.removeRange(1, _msgs.length);
            }),
          ),
          if (_error != null) _ErrorBanner(message: _error!),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _msgs.length + (_loading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _msgs.length) return const _TypingIndicator();
                // Faqat birinchi kirishdagi salomlashish teriladi.
                return _Bubble(
                  msg: _msgs[i],
                  typewriter: _firstVisit && i == 0 && !_msgs[i].isUser,
                );
              },
            ),
          ),
          if (_msgs.length <= 1 && !_loading)
            _Suggestions(onTap: (t) => _send(t)),
          _InputBar(ctrl: _ctrl, onSend: _send, loading: _loading),
        ],
      ),
    );
  }
}

/// Shishasimon (glass) sarlavha paneli — boshqa ekranlardagi
/// `PremiumScaffold` bilan bir xil vizual til (blur, pastki yumaloq
/// burchak, gradient), lekin avatar+holat qatorini ko'rsatish uchun
/// maxsus tarkib bilan (shared komponent buni qo'llab-quvvatlamaydi).
class _GlassHeader extends StatelessWidget {
  final bool loading;
  final VoidCallback onClear;
  const _GlassHeader({required this.loading, required this.onClear});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    const toolbar = 56.0;
    final barH = topPad + toolbar;
    const accent = AppTheme.primary;
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(26)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: barH,
          padding: EdgeInsets.only(top: topPad, left: 12, right: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [accent, Color.lerp(accent, Colors.black, 0.22)!],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.38),
                blurRadius: 20,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Row(
            children: [
              const _ZukkobekAvatar(size: 38, status: true),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Row(
                      children: [
                        Text(
                          'Zukkobek AI',
                          style: TextStyle(
                              fontSize: AppFontSize.title,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.verified_rounded,
                            size: 15, color: Color(0xFF93C5FD)),
                      ],
                    ),
                    Row(
                      children: [
                        if (!loading)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          loading
                              ? tr(context, 'zk_typing')
                              : tr(context, 'zk_online'),
                          style: const TextStyle(
                              fontSize: AppFontSize.caption,
                              color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PremiumBarAction(
                icon: Icons.delete_outline_rounded,
                onTap: onClear,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Boshlang'ich tezkor savol chiplari — premium tartib.
class _Suggestions extends StatelessWidget {
  final ValueChanged<String> onTap;
  const _Suggestions({required this.onTap});

  static const _items = [
    (icon: Icons.wb_sunny_rounded, key: 'zk_suggest1', color: Color(0xFFF59E0B)),
    (icon: Icons.directions_bus_rounded, key: 'zk_suggest2', color: Color(0xFF3B82F6)),
    (icon: Icons.newspaper_rounded, key: 'zk_suggest3', color: Color(0xFF10B981)),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome_rounded,
                  size: 14, color: Color(0xFF3B82F6)),
              const SizedBox(width: 6),
              Text(
                tr(context, 'zk_suggest_title'),
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.ts(context)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final it in _items)
                PressableCard(
                  onTap: () => onTap(tr(context, it.key)),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppTheme.card(context),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      border: Border.all(
                        color: dark
                            ? Colors.white.withValues(alpha: 0.08)
                            : it.color.withValues(alpha: 0.22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: dark ? 0.25 : 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(it.icon, size: 16, color: it.color),
                        const SizedBox(width: 7),
                        Text(
                          tr(context, it.key),
                          style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.tp(context)),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Zukkobek mascot avatar — dumaloq gradient ramka ichida `zigi.png` rasmi.
class _ZukkobekAvatar extends StatelessWidget {
  final double size;
  final bool status; // online nuqtasi ko'rsatilsinmi
  const _ZukkobekAvatar({required this.size, this.status = false});

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF60A5FA), Color(0xFF3B82F6), Color(0xFF1E3A8A)],
        ),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.45),
            blurRadius: size * 0.28,
            spreadRadius: size * 0.02,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * 0.07),
      child: ClipOval(
        child: Image.asset(
          'assets/images/icons/zigi.png',
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Icon(Icons.auto_awesome,
              color: Colors.white, size: size * 0.5),
        ),
      ),
    );
    if (!status) return avatar;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: size * 0.30,
            height: size * 0.30,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF152C66), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: const Color(0xFFFEF3C7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 12, color: Color(0xFF92400E)),
              ),
            ),
          ],
        ),
      );
}

class _Bubble extends StatelessWidget {
  final _Msg msg;

  /// Matn harflab terilib chiqadimi (faqat birinchi salomlashish uchun).
  final bool typewriter;
  const _Bubble({required this.msg, this.typewriter = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment:
              msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!msg.isUser) ...[
              _ZukkobekAvatar(size: 28),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg.isUser ? AppTheme.primary : AppTheme.card(context),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(msg.isUser ? 18 : 4),
                    bottomRight: Radius.circular(msg.isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.07),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TypewriterText(
                  text: msg.text,
                  enabled: typewriter,
                  style: TextStyle(
                    fontSize: 15,
                    color: msg.isUser ? Colors.white : AppTheme.tp(context),
                    height: 1.45,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _ZukkobekAvatar(size: 28),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.07),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Dot(delay: 0),
                  SizedBox(width: 4),
                  _Dot(delay: 180),
                  SizedBox(width: 4),
                  _Dot(delay: 360),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});
  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = Tween<double>(begin: 0, end: -5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _anim,
        builder: (_, _) => Transform.translate(
          offset: Offset(0, _anim.value),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.ts(context).withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
}

class _InputBar extends StatelessWidget {
  final TextEditingController ctrl;
  final VoidCallback onSend;
  final bool loading;
  const _InputBar({required this.ctrl, required this.onSend, required this.loading});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final fieldBg = dark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF1F4F9);
    return Container(
      padding: EdgeInsets.fromLTRB(
        12,
        8,
        12,
        MediaQuery.of(context).padding.bottom + 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.30 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: fieldBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: dark
                      ? Colors.white.withValues(alpha: 0.10)
                      : AppTheme.primary.withValues(alpha: 0.14),
                ),
              ),
              child: TextField(
                controller: ctrl,
                onSubmitted: (_) => onSend(),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: tr(context, 'zk_hint'),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: loading ? null : onSend,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: loading
                    ? null
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF60A5FA), AppTheme.primary],
                      ),
                color: loading ? AppTheme.divider : null,
                shape: BoxShape.circle,
                boxShadow: loading
                    ? null
                    : [
                        BoxShadow(
                          color: AppTheme.primary.withValues(alpha: 0.45),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: loading
                  ? const Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 21),
            ),
          ),
        ],
      ),
    );
  }
}
