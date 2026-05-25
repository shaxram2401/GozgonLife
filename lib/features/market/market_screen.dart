import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/navigation/scaffold_with_nav.dart';
import '../../core/theme/app_theme.dart';

const _red = Color(0xFFDC2626);

class _Product {
  final String title, price, location, desc, category;
  final IconData icon;
  const _Product({
    required this.title,
    required this.price,
    required this.location,
    required this.desc,
    required this.category,
    required this.icon,
  });
}

const _products = [
  _Product(
    title: '2 xonali kvartira',
    price: "350 000 000 so'm",
    location: 'Marmarobod',
    desc: "Yangi qurilish, 2-qavat, 58 kv.m. Hammom, balkon bor. Hujjatlar tayyor.",
    category: "Ko'chmas mulk",
    icon: Icons.apartment_rounded,
  ),
  _Product(
    title: 'Samsung Galaxy S24',
    price: "12 500 000 so'm",
    location: "Bozor ko'chasi",
    desc: "8/256 GB, qora rang. Kafolat bor. Aksessuarlar komplekt.",
    category: 'Elektronika',
    icon: Icons.phone_android_rounded,
  ),
  _Product(
    title: 'Nexia 3, 2021 yil',
    price: "98 000 000 so'm",
    location: 'Avto bozor',
    desc: "1.5 dvigatel, konditsioner bor. Yaxshi holatda. Hujjatlar tayyor.",
    category: 'Avtomobil',
    icon: Icons.directions_car_rounded,
  ),
  _Product(
    title: 'Kir yuvish mashinasi',
    price: "4 200 000 so'm",
    location: 'Shayxon MFY',
    desc: "Samsung 7 kg, avtomatik. 2 yil ishlatilgan. Yaxshi ishlaydi.",
    category: 'Maishiy texnika',
    icon: Icons.local_laundry_service_rounded,
  ),
  _Product(
    title: 'Hovli uy, 6 sotix',
    price: "520 000 000 so'm",
    location: 'Tumar MFY',
    desc: "3 xona, suv va gaz ulangan. Hovli ko'kalamzorlashtrilgan.",
    category: "Ko'chmas mulk",
    icon: Icons.house_rounded,
  ),
  _Product(
    title: 'Televizor 55 dyuym',
    price: "3 800 000 so'm",
    location: "Bozor ko'chasi",
    desc: "LG Smart TV 4K. Kafolat muddat bor. Original quti bilan.",
    category: 'Elektronika',
    icon: Icons.tv_rounded,
  ),
];

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});
  @override
  State<MarketScreen> createState() => _State();
}

class _State extends State<MarketScreen> {
  final _search = TextEditingController();
  String _query = '';

  List<_Product> get _filtered => _query.isEmpty
      ? _products
      : _products
          .where((p) =>
              p.title.toLowerCase().contains(_query.toLowerCase()) ||
              p.category.toLowerCase().contains(_query.toLowerCase()) ||
              p.location.toLowerCase().contains(_query.toLowerCase()))
          .toList();

  @override
  void dispose() { _search.dispose(); super.dispose(); }

  void _showDetail(_Product p) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: _red.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(p.icon, size: 72, color: _red.withValues(alpha: 0.4)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(p.category,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _red)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(p.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(p.price,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _red)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_rounded, size: 14, color: AppTheme.textSecondary),
                const SizedBox(width: 4),
                Text(p.location, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Tavsif', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text(p.desc,
                style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary, height: 1.6)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.phone_rounded),
              label: const Text("Bog'lanish"),
            ),
          ],
        ),
      ),
    );
  }

  void _showPostForm() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(color: AppTheme.divider, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const Text("Mahsulot joylash",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  hintText: 'Nomi (masalan: iPhone 15)',
                  prefixIcon: Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: "Narxi (so'm)",
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Tavsif...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  titleCtrl.dispose();
                  priceCtrl.dispose();
                  descCtrl.dispose();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("E'lon joylashtirildi"),
                      backgroundColor: AppTheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text("E'lonni joylash"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: ScaffoldWithNav.openDrawer),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPostForm,
        backgroundColor: _red,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("Mahsulot joylash",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: _red,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showPostForm,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.asset(
                          'assets/images/market.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: "Mahsulot qidirish...",
                        prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.textSecondary),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: AppTheme.textSecondary),
                                onPressed: () { _search.clear(); setState(() => _query = ''); },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded, size: 56, color: AppTheme.textSecondary.withValues(alpha: 0.5)),
                    const SizedBox(height: 12),
                    Text("'$_query' bo'yicha hech narsa topilmadi",
                        style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.72,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) => _Card(product: items[i], onTap: () => _showDetail(items[i])),
              ),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final _Product product;
  final VoidCallback onTap;
  const _Card({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _red.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                ),
                child: Icon(product.icon, size: 48, color: _red.withValues(alpha: 0.4)),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.title,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 5),
                    Text(product.price,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _red)),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, size: 11, color: AppTheme.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(product.location,
                              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
