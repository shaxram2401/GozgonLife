import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';

/// Bildirishnomalar ro'yxati — yangi (o'qilmagan) xabarlar tepada,
/// ko'k nuqta va accent kontur bilan ajralib turadi.
const _items = [
  (
    title: 'Sayyor qabul — Tumar MFY',
    body:
        "15-iyun kuni soat 10:00 da Tumar MFY binosida tuman hokimi ishtirokida sayyor qabul o'tkaziladi. Murojaatingiz bo'lsa, shaxsan kelishingiz mumkin.",
    time: 'Bugun, 09:12',
    icon: Icons.event_available_rounded,
    color: Color(0xFF2563EB),
    unread: true,
  ),
  (
    title: "Suv ta'minoti vaqtincha to'xtaydi",
    body:
        "13-iyun 09:00–14:00 oralig'ida Marmarobod ko'chasida ta'mirlash ishlari sababli ichimlik suvi vaqtincha uziladi.",
    time: 'Kecha, 18:40',
    icon: Icons.water_drop_rounded,
    color: Color(0xFFF59E0B),
    unread: true,
  ),
  (
    title: 'Ilova yangilandi',
    body:
        "G'ozg'on Life yangi premium dizayn bilan yangilandi — Market va Zukkobek bo'limlarini sinab ko'ring.",
    time: '08.06.2026',
    icon: Icons.auto_awesome_rounded,
    color: Color(0xFF10B981),
    unread: false,
  ),
];

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.paddingOf(context).top;
    final newCount = _items.where((n) => n.unread).length;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // ── Header: orqaga + sarlavha + yangi xabarlar soni ──
          Padding(
            padding:
                EdgeInsets.only(top: topPad + 6, left: 8, right: 16, bottom: 4),
            child: SizedBox(
              height: 50,
              child: Row(
                children: [
                  InkResponse(
                    onTap: () => context.pop(),
                    radius: 24,
                    child: SizedBox(
                      width: 46,
                      height: 46,
                      child: Icon(Icons.arrow_back_rounded,
                          color: AppTheme.tp(context), size: 26),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Bildirishnomalar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: AppTheme.tp(context),
                        ),
                      ),
                    ),
                  ),
                  // Yangi xabarlar soni
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF1E3A8A)]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2563EB)
                              .withValues(alpha: 0.40),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '$newCount yangi',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              itemCount: _items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (_, i) => _NotifCard(n: _items[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final ({
    String title,
    String body,
    String time,
    IconData icon,
    Color color,
    bool unread,
  }) n;
  const _NotifCard({required this.n});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.card(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: n.unread
              ? n.color.withValues(alpha: dark ? 0.55 : 0.40)
              : (dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.05)),
          width: n.unread ? 1.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.28 : 0.07),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ikonka plitkasi
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  n.color.withValues(alpha: 0.20),
                  n.color.withValues(alpha: 0.10),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(n.icon, color: n.color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        n.title,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight:
                              n.unread ? FontWeight.w800 : FontWeight.w700,
                          letterSpacing: -0.2,
                          color: AppTheme.tp(context),
                        ),
                      ),
                    ),
                    if (n.unread)
                      Container(
                        width: 9,
                        height: 9,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: n.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: n.color.withValues(alpha: 0.55),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  n.body,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppTheme.ts(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        size: 12, color: AppTheme.ts(context)),
                    const SizedBox(width: 4),
                    Text(
                      n.time,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ts(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
