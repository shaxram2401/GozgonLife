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
  Widget build(BuildContext context) => Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                'assets/images/bank.png',
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                Expanded(child: _RateCard(symbol: '\$', name: 'USD', value: '12 850', up: true)),
                const SizedBox(width: 10),
                Expanded(child: _RateCard(symbol: '€', name: 'EUR', value: '14 260', up: true)),
                const SizedBox(width: 10),
                Expanded(child: _RateCard(symbol: '₽', name: 'RUB', value: '160', up: false)),
              ],
            ),
          ),
        ],
      );
}

class _RateCard extends StatelessWidget {
  final String symbol, name, value;
  final bool up;
  const _RateCard({required this.symbol, required this.name, required this.value, required this.up});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Text(symbol, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(name, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            const SizedBox(height: 6),
            Text("$value so'm", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Icon(
              up ? Icons.trending_up_rounded : Icons.trending_down_rounded,
              size: 14,
              color: up ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ],
        ),
      );
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
