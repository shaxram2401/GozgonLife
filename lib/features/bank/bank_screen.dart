import 'package:flutter/material.dart';
import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _rates = [
  ('USD', '\$', '12 114', '+0.3%', true),
  ('EUR', '€', '14 260', '+0.1%', true),
  ('RUB', '₽', '162', '-0.2%', false),
];

const _banks = [
  (
    name: "O'zmilliybank",
    short: 'OMB',
    phone: '+998 71 256 10 00',
    color: Color(0xFF1E3A8A),
    services: ['Kredit', 'Depozit', 'Karta'],
  ),
  (
    name: 'Xalq Banki',
    short: 'XB',
    phone: '+998 71 200 10 00',
    color: Color(0xFF065F46),
    services: ['Ipoteka', 'Karta', 'Pul o\'tkazma'],
  ),
  (
    name: 'Sanoat Qurilish Bank',
    short: 'SQB',
    phone: '+998 71 252 73 73',
    color: Color(0xFF7C2D12),
    services: ['Qurilish', 'Kredit', 'Depozit'],
  ),
  (
    name: 'Agrobank',
    short: 'AB',
    phone: '+998 71 207 20 07',
    color: Color(0xFF064E3B),
    services: ['Qishloq xo\'jaligi', 'Kredit', 'Karta'],
  ),
];

class BankScreen extends StatelessWidget {
  const BankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RatesHeader(),
            _section('Banklar ro\'yxati'),
            ..._banks.map((b) => _BankCard(bank: b)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

Widget _section(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
    );

class _RatesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF065F46), Color(0xFF059669)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.trending_up_rounded, color: Colors.white70, size: 14),
                          SizedBox(width: 4),
                          Text('Valyuta kurslari', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '21 may 2026',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: _rates.map((r) => Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: r.$1 != 'RUB' ? 10 : 0),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                r.$2,
                                style: const TextStyle(color: Colors.white54, fontSize: 13),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                r.$1,
                                style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            r.$3,
                            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: (r.$5 ? const Color(0xFF34D399) : const Color(0xFFF87171)).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              r.$4,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: r.$5 ? const Color(0xFF6EE7B7) : const Color(0xFFFCA5A5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 12),
                const Text(
                  "* So'mda ko'rsatilgan. Manba: O'zbekiston Markaziy banki",
                  style: TextStyle(color: Colors.white38, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final ({String name, String short, String phone, Color color, List<String> services}) bank;
  const _BankCard({required this.bank});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: bank.color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        bank.short,
                        style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bank.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.phone_outlined, size: 13, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text(bank.phone, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: bank.color.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.phone_rounded, color: bank.color, size: 18),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: bank.services.map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: bank.color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    s,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: bank.color),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      );
}
