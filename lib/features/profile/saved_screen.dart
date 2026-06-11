import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/saved_products.dart';
import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../market/market_screen.dart';

/// Saqlangan mahsulotlar ro'yxati — profil "Saqlangan" statidan ochiladi.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SavedProducts.ensureLoaded();
    return PremiumScaffold(
      title: tr(context, 'pr_saved'),
      showBar: true,
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: SavedProducts.titles,
        builder: (context, saved, _) {
          final items =
              kProducts.where((p) => saved.contains(p.title)).toList();
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border_rounded,
                      size: 56, color: AppTheme.ts(context)),
                  const SizedBox(height: 12),
                  Text(
                    "Saqlangan mahsulotlar yo'q",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.ts(context)),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: items.length,
            itemBuilder: (_, i) => _SavedRow(p: items[i]),
          );
        },
      ),
    );
  }
}

class _SavedRow extends StatelessWidget {
  final Product p;
  const _SavedRow({required this.p});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final imgBg = dark ? const Color(0xFF0F172A) : const Color(0xFFF1F3F6);
    final c = productColor(p.category);
    return GestureDetector(
      onTap: () => context.push('/market/detail', extra: p),
      child: Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.05),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.25 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 64,
                height: 64,
                child: p.image != null
                    ? Container(
                        color: imgBg,
                        child: Image.asset(p.image!, fit: BoxFit.contain),
                      )
                    : Container(
                        color: c,
                        child: Icon(p.icon,
                            size: 28,
                            color: Colors.white.withValues(alpha: 0.85)),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.t(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: AppTheme.tp(context)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.p(context),
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: dark
                            ? const Color(0xFF93C5FD)
                            : const Color(0xFF1E3A8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Saqlanganlardan o'chirish
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => SavedProducts.toggle(p.title),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_rounded,
                    size: 17, color: Color(0xFFEF4444)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
