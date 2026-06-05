import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/strings.dart';
import '../../core/theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});
  @override
  State<TermsScreen> createState() => _State();
}

class _State extends State<TermsScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(tr(context, 'set_terms')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.card(context),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.divider),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tr(context, 'tm_heading'),
                            style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: AppTheme.primary),
                          ),
                          const SizedBox(height: 16),
                          _section(tt, tr(context, 'tm_s1_t'), tr(context, 'tm_s1_b')),
                          _section(tt, tr(context, 'tm_s2_t'), tr(context, 'tm_s2_b')),
                          _section(tt, tr(context, 'tm_s3_t'), tr(context, 'tm_s3_b')),
                          _section(tt, tr(context, 'tm_s4_t'), tr(context, 'tm_s4_b')),
                          _section(tt, tr(context, 'tm_s5_t'), tr(context, 'tm_s5_b')),
                          _section(tt, tr(context, 'tm_s6_t'), tr(context, 'tm_s6_b')),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => setState(() => _accepted = !_accepted),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _accepted ? AppTheme.primary.withValues(alpha: 0.06) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _accepted ? AppTheme.primary : AppTheme.divider,
                            width: _accepted ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: _accepted ? AppTheme.primary : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: _accepted ? AppTheme.primary : AppTheme.ts(context),
                                  width: 2,
                                ),
                              ),
                              child: _accepted
                                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tr(context, 'tm_accept'),
                                style: tt.bodyMedium?.copyWith(
                                  color: _accepted ? AppTheme.tp(context) : AppTheme.ts(context),
                                  fontWeight: _accepted ? FontWeight.w600 : FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _accepted ? () => context.go('/auth/success') : null,
              child: Text(tr(context, 'continue')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(TextTheme tt, String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: AppTheme.tp(context))),
          const SizedBox(height: 4),
          Text(body, style: tt.bodySmall?.copyWith(color: AppTheme.ts(context), height: 1.6)),
        ],
      ),
    );
  }
}
