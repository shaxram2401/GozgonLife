import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _geminiUrl =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyDdThyjjJWnxZ8aY8cVZNihpaougQAqzlk';
const _system =
    "Sen G'ozg'on shahri bo'yicha aqlli yordamchisan. Foydalanuvchilarga shahar xizmatlari, yangiliklar, transport va boshqa savollar bo'yicha O'zbek tilida qisqa va aniq javob ber.";

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
  final _msgs = <_Msg>[
    const _Msg(
      "Assalomu alaykum! Men Zukkobek — G'ozg'on shahrining aqlli yordamchisiman 🤖\n\nSizga qanday yordam bera olaman?",
      isUser: false,
    ),
  ];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 60),
    ));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    _dio.close();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _loading) return;
    _ctrl.clear();
    setState(() {
      _msgs.add(_Msg(text, isUser: true));
      _loading = true;
      _error = null;
    });
    _scrollDown();

    try {
      final history = _msgs.sublist(1).map((m) => {
            'role': m.isUser ? 'user' : 'model',
            'parts': [{'text': m.text}],
          }).toList();

      final res = await _dio.post(
        _geminiUrl,
        data: {
          'system_instruction': {
            'parts': [{'text': _system}],
          },
          'contents': history,
          'generationConfig': {'maxOutputTokens': 1024},
        },
      );

      final reply = res.data['candidates'][0]['content']['parts'][0]['text'] as String;
      setState(() {
        _msgs.add(_Msg(reply, isUser: false));
        _loading = false;
      });
    } on DioException catch (e) {
      final msg = (e.response?.data?['error']?['message'] as String?) ??
          "Xatolik yuz berdi. Qayta urinib ko'ring.";
      setState(() {
        _msgs.add(_Msg(msg, isUser: false));
        _loading = false;
        _error = msg;
      });
    } catch (_) {
      setState(() {
        _msgs.add(_Msg("Xatolik yuz berdi. Qayta urinib ko'ring.", isUser: false));
        _loading = false;
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: ScaffoldWithNav.openDrawer,
        ),
        title: Row(
          children: [
            _ZukkobekAvatar(size: 36),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zukkobek AI',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  _loading ? 'Yozmoqda...' : 'Online',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Suhbatni tozalash',
            onPressed: () => setState(() {
              _msgs.removeRange(1, _msgs.length);
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_error != null) _ErrorBanner(message: _error!),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              itemCount: _msgs.length + (_loading ? 1 : 0),
              itemBuilder: (_, i) {
                if (i == _msgs.length) return const _TypingIndicator();
                return _Bubble(msg: _msgs[i]);
              },
            ),
          ),
          _InputBar(ctrl: _ctrl, onSend: _send, loading: _loading),
        ],
      ),
    );
  }
}

class _ZukkobekAvatar extends StatelessWidget {
  final double size;
  const _ZukkobekAvatar({required this.size});

  @override
  Widget build(BuildContext context) => CircleAvatar(
        radius: size / 2,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Image.asset(
            'assets/images/zukkobek.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Icon(
              Icons.smart_toy_rounded,
              color: AppTheme.primary,
              size: size * 0.6,
            ),
          ),
        ),
      );
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
  const _Bubble({required this.msg});

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
                  color: msg.isUser ? AppTheme.primary : Colors.white,
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
                child: Text(
                  msg.text,
                  style: TextStyle(
                    fontSize: 15,
                    color: msg.isUser ? Colors.white : AppTheme.textPrimary,
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
                color: Colors.white,
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
              color: AppTheme.textSecondary.withValues(alpha: 0.6),
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
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.fromLTRB(
          12,
          8,
          12,
          MediaQuery.of(context).padding.bottom + 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: ctrl,
                onSubmitted: (_) => onSend(),
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Zukkobek bilan gaplashing...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppTheme.background,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: loading ? null : onSend,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: loading ? AppTheme.divider : AppTheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: loading
                      ? null
                      : [
                          BoxShadow(
                            color: AppTheme.primary.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: loading
                    ? const Padding(
                        padding: EdgeInsets.all(13),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      );
}
