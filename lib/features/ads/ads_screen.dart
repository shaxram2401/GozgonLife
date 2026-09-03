import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/strings.dart';
import '../../core/widgets/premium_page.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/image_fade.dart';
import '../../core/theme/design_tokens.dart';
import '../../core/widgets/refresh.dart';
import '../../core/widgets/skeleton.dart';

const _amber = AppColors.ads;

/// Manba rasm haqiqiy ko'rinishdan ancha katta bo'lishi mumkin — dekodlashni
/// haqiqiy karta kengligiga cheklab, CPU/xotirani tejaydi.
int _cacheW(BuildContext context, [double fraction = 1.0]) => (MediaQuery.sizeOf(context).width *
        MediaQuery.devicePixelRatioOf(context) *
        fraction)
    .round();

const _catColors = <String, Color>{
  'Savdo':         Color(0xFFF59E0B),
  'Restoranlar':   Color(0xFFEF4444),
  'Xizmatlar':     Color(0xFF0EA5E9),
  "Ish o'rinlari": Color(0xFF10B981),
  'Aksiyalar':     Color(0xFF8B5CF6),
};

const _catGradients = <String, List<Color>>{
  'Savdo':         [Color(0xFFF59E0B), Color(0xFFD97706)],
  'Restoranlar':   [Color(0xFFEF4444), Color(0xFFF97316)],
  'Xizmatlar':     [Color(0xFF0EA5E9), Color(0xFF0369A1)],
  "Ish o'rinlari": [Color(0xFF10B981), Color(0xFF059669)],
  'Aksiyalar':     [Color(0xFF8B5CF6), Color(0xFFEC4899)],
};

const _catIcons = <String, IconData>{
  'Barchasi':      Icons.apps_rounded,
  'Savdo':         Icons.storefront_rounded,
  'Restoranlar':   Icons.restaurant_rounded,
  'Xizmatlar':     Icons.home_repair_service_rounded,
  "Ish o'rinlari": Icons.work_rounded,
  'Aksiyalar':     Icons.local_offer_rounded,
};

const _allCats = [
  'Barchasi',
  'Savdo',
  'Restoranlar',
  'Xizmatlar',
  "Ish o'rinlari",
  'Aksiyalar',
];

/// Faqat haqiqatan e'loni bor kategoriyalar ko'rsatiladi — bo'sh filtrni
/// bosgan foydalanuvchi quruq ro'yxatga duch kelmasligi uchun.
final List<String> _cats = [
  'Barchasi',
  ..._allCats.skip(1).where((c) => kAds.any((a) => a.cat == c)),
];

const _catRu = <String, String>{
  'Barchasi': 'Все',
  'Savdo': 'Торговля',
  'Restoranlar': 'Рестораны',
  'Xizmatlar': 'Услуги',
  "Ish o'rinlari": 'Работа',
  'Aksiyalar': 'Акции',
};

String _catLabel(BuildContext c, String cat) =>
    _ru(c) ? (_catRu[cat] ?? cat) : cat;

class Ad {
  final String title, cat, phone, desc;
  final String? titleRu, descRu, price, image;
  final bool isTop;
  const Ad({
    required this.title,
    required this.cat,
    required this.phone,
    required this.desc,
    this.titleRu,
    this.descRu,
    this.price,
    this.image,
    this.isTop = false,
  });

  String t(BuildContext c) =>
      _ru(c) && titleRu != null ? titleRu! : title;
  String d(BuildContext c) => _ru(c) && descRu != null ? descRu! : desc;
}

bool _ru(BuildContext c) => Localizations.localeOf(c).languageCode == 'ru';

const kAds = [
  Ad(
    title: "Marmarobod — yangi ish o'rinlari",
    titleRu: "Мраморобод — новые рабочие места",
    cat: "Ish o'rinlari",
    phone: '+998 1234567',
    isTop: true,
    desc: "📢 Marmarobod MCHJ yangi bo'sh ish o'rinlarini e'lon qiladi!\n\nSiz barqaror va istiqbolli ish qidiryapsizmi? Unda jamoamiz safiga qo'shiling!\n\nMarmarobod MCHJ mas'uliyatli, intiluvchan va o'z ustida ishlashga tayyor nomzodlarni yangi bo'sh ish o'rinlariga taklif etadi.\n\n✅ Rasmiy ishga qabul qilish\n✅ O'z vaqtida va barqaror ish haqi\n✅ Tushlik (abet) bilan ta'minlanadi\n✅ Qulay va xavfsiz mehnat sharoiti\n✅ Ahil va qo'llab-quvvatlovchi jamoa\n✅ Kasbiy rivojlanish va karyera o'sishi imkoniyati\n✅ Tajriba orttirish va malaka oshirish imkoniyati\n\nBiz bilan siz nafaqat ish, balki o'z kelajagingizni qurish imkoniyatiga ega bo'lasiz. Har bir xodimning mehnati qadrlanadi va rivojlanishi uchun sharoit yaratiladi.\n\n📞 Batafsil ma'lumot olish uchun ko'rsatilgan telefon raqamiga qo'ng'iroq qiling.\n\n📩 Rezyumeni Telegram orqali yuborishingiz mumkin.\n\nMarmarobod MCHJ — barqaror ish, ishonchli kelajak va yangi imkoniyatlar sari birgalikda!",
    descRu: "📢 ООО «Мраморобод» объявляет о новых вакансиях!\n\nИщете стабильную и перспективную работу? Тогда присоединяйтесь к нашей команде!\n\nООО «Мраморобод» приглашает ответственных, целеустремлённых кандидатов на новые рабочие места.\n\n✅ Официальное трудоустройство\n✅ Своевременная и стабильная зарплата\n✅ Обеспечивается обед\n✅ Удобные и безопасные условия труда\n✅ Дружный и поддерживающий коллектив\n✅ Возможность профессионального и карьерного роста\n✅ Возможность получить опыт и повысить квалификацию\n\nС нами вы получаете не просто работу, а возможность построить своё будущее. Труд каждого сотрудника ценится.\n\n📞 Для подробной информации позвоните по указанному номеру.\n\n📩 Резюме можно отправить через Telegram.\n\nООО «Мраморобод» — стабильная работа и надёжное будущее!",
    image: 'assets/images/marmarobod.jpg',
  ),
  Ad(
    title: "Oltin Baliqcha kafe — Qurbon Hayiti aksiyasi",
    titleRu: "Кафе «Олтин Баличча» — акция к Курбан-хайиту",
    cat: 'Restoranlar',
    phone: '+998 90 777 77 77',
    isTop: true,
    desc: "🐟 OLTIN BALIQCHA KAFE\n\n🎉 Qurbon Hayiti munosabati bilan maxsus aksiya!\n\nAziz mehmonlar, bayram kunlarida sizlarni Oltin Baliqcha kafesida kutib qolamiz.\n\n✅ Milliy va yevropa taomlari\n✅ Shinam oilaviy muhit\n✅ Tabiat qo'ynidagi dam olish maskani\n✅ Fontan va go'zal ichki hovli\n\n🎁 Qurbon Hayiti munosabati bilan barcha taomlarga 30% CHEGIRMA!\n\nOltin Baliqcha kafe — bayramni yaqinlaringiz bilan mazali o'tkazing!",
    descRu: "🐟 КАФЕ «ОЛТИН БАЛИЧЧА»\n\n🎉 Специальная акция к празднику Курбан-хайит!\n\nДорогие гости, в праздничные дни мы ждём вас в кафе «Олтин Баличча».\n\n✅ Национальные и европейские блюда\n✅ Уютная семейная атмосфера\n✅ Зона отдыха на природе\n✅ Фонтан и красивый внутренний двор\n\n🎁 К празднику Курбан-хайит СКИДКА 30% на все блюда!\n\nКафе «Олтин Баличча» — проведите праздник вкусно с близкими!",
    image: 'assets/images/oltin.png',
  ),
  Ad(
    title: "Sarvar Barbershop — sartaroshlik xizmatlari",
    titleRu: "Sarvar Barbershop — парикмахерские услуги",
    cat: 'Xizmatlar',
    phone: '+998 222 22 22',
    desc: "💈 SARVAR BARBERSHOP 💈\n\nZamonaviy va sifatli sartaroshlik xizmatlari endi sizga yanada yaqin!\n\n✂️ Soch olish\n✂️ Soch turmaklash\n✂️ Soqol olish va dizayn berish\n✂️ Bolalar uchun soch olish\n✂️ Zamonaviy va klassik uslublar\n\n✅ Tajribali ustalar\n✅ Qulay va shinam muhit\n✅ Toza va sifatli xizmat\n✅ Hamyonbop narxlar\n✅ Har bir mijozga alohida e'tibor\n\n🎉 Maxsus aksiya!\nG'ozg'on Life ilovasi foydalanuvchilari uchun barcha xizmatlarga 30% chegirma!\n\n📍 Manzil: G'ozg'on shahri\n📞 Batafsil ma'lumot va navbat band qilish uchun telefon orqali bog'laning.",
    descRu: "💈 SARVAR BARBERSHOP 💈\n\nСовременные и качественные парикмахерские услуги теперь ещё ближе к вам!\n\n✂️ Стрижка\n✂️ Укладка\n✂️ Бритьё и моделирование бороды\n✂️ Детская стрижка\n✂️ Современные и классические стили\n\n✅ Опытные мастера\n✅ Уютная атмосфера\n✅ Чистый и качественный сервис\n✅ Доступные цены\n✅ Индивидуальный подход к каждому клиенту\n\n🎉 Специальная акция!\nДля пользователей приложения G'ozg'on Life скидка 30% на все услуги!\n\n📍 Адрес: город Гузгон\n📞 Для записи и подробностей свяжитесь по телефону.",
    image: 'assets/images/sarvar.png',
  ),
  Ad(
    title: "Havas kafe — bepul yetkazib berish",
    titleRu: "Кафе «Havas» — бесплатная доставка",
    cat: 'Restoranlar',
    phone: '+998 90 888 88 88',
    desc: "🍽️ HAVAS KAFE\n\nMazali taomlar va sifatli xizmat endi yanada yaqin!\n\n✅ Milliy taomlar\n✅ Kabob va tandir taomlari\n✅ Salatlar va ichimliklar\n✅ Oilaviy va do'stlar davrasi uchun qulay joy\n\n🚚 Yetkazib berish xizmati mutlaqo BEPUL!\n\nSevimli taomlaringizni uydan chiqmasdan buyurtma qiling.\n\nHAVAS KAFE — lazzatli taomlar maskani! 🍴",
    descRu: "🍽️ КАФЕ «HAVAS»\n\nВкусные блюда и качественный сервис теперь ещё ближe!\n\n✅ Национальные блюда\n✅ Шашлык и блюда из тандыра\n✅ Салаты и напитки\n✅ Удобное место для семьи и друзей\n\n🚚 Доставка совершенно БЕСПЛАТНО!\n\nЗакажите любимые блюда не выходя из дома.\n\nКАФЕ «HAVAS» — обитель вкусных блюд! 🍴",
    image: 'assets/images/havas.png',
  ),
  Ad(
    title: "Yuk mashinasi xizmati — ishonchli yetkazib berish",
    titleRu: "Грузоперевозки — надёжная доставка",
    cat: 'Xizmatlar',
    phone: '+998 666 66 66',
    desc: "🚚 YUK MASHINASI XIZMATI\n\nHar qanday yuklarni manzilga yetkazib beramiz.\n\n✅ Uy ko'chirish\n✅ Qurilish materiallari\n✅ Mebel va maishiy texnika\n✅ Shahar va qishloqlarga yetkazib berish\n\nIshonchli, tezkor va qulay xizmat!",
    descRu: "🚚 ГРУЗОПЕРЕВОЗКИ\n\nДоставим любой груз по адресу.\n\n✅ Квартирные переезды\n✅ Строительные материалы\n✅ Мебель и бытовая техника\n✅ Доставка по городу и сёлам\n\nНадёжный, быстрый и удобный сервис!",
    image: 'assets/images/yuk.png',
  ),
  Ad(
    title: "Basseynlar sotiladi — uy va hovlilar uchun",
    titleRu: "Бассейны в продаже — для домов и дворов",
    cat: 'Savdo',
    phone: '+998 555 55 55',
    desc: "💦 BASSEYNLAR SOTILADI\n\nUy va hovlilar uchun zamonaviy basseynlar.\n\n✅ Turli o'lcham va modellar\n✅ O'rnatish bo'yicha maslahat\n✅ Sifatli materiallar\n✅ Hamyonbop narxlar\n\nYozgi dam olish uchun ajoyib tanlov!",
    descRu: "💦 БАССЕЙНЫ В ПРОДАЖЕ\n\nСовременные бассейны для домов и дворов.\n\n✅ Разные размеры и модели\n✅ Консультация по установке\n✅ Качественные материалы\n✅ Доступные цены\n\nОтличный выбор для летнего отдыха!",
    image: 'assets/images/bs.png',
  ),
  Ad(
    title: "Marmar terish xizmati — tajribali ustalar",
    titleRu: "Укладка мрамора — опытные мастера",
    cat: 'Xizmatlar',
    phone: '+998 444 44 44',
    desc: "🏛 MARMAR TERISH XIZMATI\n\nHar qanday turdagi marmar va granit ishlari.\n\n✅ Pol va zinapoyalar\n✅ Hovli va fasad ishlari\n✅ Sifatli va mustahkam o'rnatish\n✅ Tajribali ustalar\n\nIsh sifati — bizning ustuvorligimiz!",
    descRu: "🏛 УКЛАДКА МРАМОРА\n\nЛюбые работы с мрамором и гранитом.\n\n✅ Полы и лестницы\n✅ Дворовые и фасадные работы\n✅ Качественная и надёжная укладка\n✅ Опытные мастера\n\nКачество работы — наш приоритет!",
    image: 'assets/images/mrmr.png',
  ),
  Ad(
    title: "Santexnika xizmati — professional ustalar",
    titleRu: "Сантехнические услуги — профессиональные мастера",
    cat: 'Xizmatlar',
    phone: '+998 333 33 33',
    desc: "🔧 SANTEXNIKA XIZMATI\n\nUy va ofislar uchun professional santexnika xizmatlari.\n\n✅ Kran o'rnatish va ta'mirlash\n✅ Quvur almashtirish\n✅ Suv va kanalizatsiya ishlari\n✅ Tezkor xizmat\n\n⚡ Tez yetib borish va kafolatli xizmat!",
    descRu: "🔧 САНТЕХНИЧЕСКИЕ УСЛУГИ\n\nПрофессиональные сантехнические услуги для домов и офисов.\n\n✅ Установка и ремонт кранов\n✅ Замена труб\n✅ Водопровод и канализация\n✅ Оперативный сервис\n\n⚡ Быстрый выезд и гарантия качества!",
    image: 'assets/images/santexnik.png',
  ),
  Ad(
    title: "Kashtachilik ustaxonasi — sifatli buyurtmalar",
    titleRu: "Вышивальная мастерская — качественные заказы",
    cat: 'Xizmatlar',
    phone: '+998 22 222 22 22',
    desc: "🧵 KASHTACHILIK USTAXONASI\n\nKashta tikish xizmatlari!\nMilliy va zamonaviy naqshlar asosida sifatli kashtalar tayyorlaymiz.\n\n✅ Har qanday murakkablikdagi buyurtmalar\n✅ Sifatli va tezkor xizmat\n✅ Zamonaviy kashta uskunalari\n✅ Hamyonbop narxlar",
    descRu: "🧵 ВЫШИВАЛЬНАЯ МАСТЕРСКАЯ\n\nУслуги вышивки!\nИзготавливаем качественную вышивку по национальным и современным узорам.\n\n✅ Заказы любой сложности\n✅ Качественно и быстро\n✅ Современное оборудование\n✅ Доступные цены",
    image: 'assets/images/kashta.png',
  ),
];

// ─────────────────────────────────────────────────────────────
class AdsScreen extends StatefulWidget {
  const AdsScreen({super.key});
  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  String _cat = 'Barchasi';
  bool _loading = true;
  String _query = '';
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final show = shouldShowSkeleton('ads');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 700),
          () { if (mounted) setState(() => _loading = false); });
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<Ad> get _filtered {
    var list = _cat == 'Barchasi'
        ? [...kAds]
        : kAds.where((a) => a.cat == _cat).toList();
    final q = _query.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((a) =>
              a.title.toLowerCase().contains(q) ||
              a.cat.toLowerCase().contains(q))
          .toList();
    }
    list.sort((a, b) => (b.isTop ? 1 : 0) - (a.isTop ? 1 : 0));
    return list;
  }

  void _openDetail(Ad ad) => context.push('/services/ads/detail', extra: ad);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'd_ads'),
        accent: _amber,
        showBar: false,
        floatingButton: false,
        body: Column(
          children: [
            PremiumHeader(title: tr(context, 'd_ads'), accent: _amber),
            const Expanded(child: _AdsSkeleton()),
          ],
        ),
      );
    }

    final list = _filtered;
    final bannerImg = _ru(context)
        ? 'assets/images/elonru.png'
        : 'assets/images/elonuz.png';
    return PremiumScaffold(
      title: tr(context, 'd_ads'),
      accent: _amber,
      showBar: false,
      floatingButton: false,
      body: Column(
        children: [
          PremiumHeader(title: tr(context, 'd_ads'), accent: _amber),
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshGesture,
              color: _amber,
              child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // ── Premium banner (asosiy markaziy element) ──
                SliverToBoxAdapter(
                    child: PremiumBanner(
                        image: bannerImg, aspectRatio: 1672 / 941)),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                // ── Search ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextField(
                      controller: _search,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: _ru(context)
                            ? 'Поиск объявлений...'
                            : "E'lon qidirish...",
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded),
                                onPressed: () {
                                  _search.clear();
                                  setState(() => _query = '');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                // ── Kategoriya kartalari ──
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 98,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _cats.length,
                      separatorBuilder: (_, i) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final cat = _cats[i];
                        return FilterCard(
                          icon: _catIcons[cat] ?? Icons.apps_rounded,
                          label: _catLabel(context, cat),
                          selected: cat == _cat,
                          color: _catColors[cat] ?? _amber,
                          onTap: () => setState(() => _cat = cat),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                // ── Kontent sarlavhasi ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                    child: Text(
                      _ru(context)
                          ? 'Рекомендуемые объявления'
                          : "Tavsiya etilgan e'lonlar",
                      style: TextStyle(
                        fontSize: AppFontSize.title,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.tp(context),
                      ),
                    ),
                  ),
                ),
                // ── Grid yoki bo'sh holat ──
                if (list.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.campaign_outlined,
                              size: 64,
                              color: AppTheme.ts(context)
                                  .withValues(alpha: 0.35)),
                          const SizedBox(height: 14),
                          Text(
                            _ru(context)
                                ? 'В этой категории нет объявлений'
                                : "Bu kategoriyada e'lon yo'q",
                            style: TextStyle(
                                fontSize: AppFontSize.body,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.ts(context)),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.1,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (_, i) => _AdCard(
                            ad: list[i], onTap: () => _openDetail(list[i])),
                        childCount: list.length,
                      ),
                    ),
                  ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ad card ───────────────────────────────────────────────────
class _AdCard extends StatefulWidget {
  final Ad ad;
  final VoidCallback onTap;
  const _AdCard({required this.ad, required this.onTap});
  @override
  State<_AdCard> createState() => _AdCardState();
}

class _AdCardState extends State<_AdCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = _catColors[widget.ad.cat] ?? _amber;
    final grads = _catGradients[widget.ad.cat] ??
        [c, Color.lerp(c, Colors.black, 0.3)!];
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card(context),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.25 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 130,
                      width: double.infinity,
                      child: widget.ad.image != null
                          ? Image.asset(widget.ad.image!,
                              fit: BoxFit.cover,
                              frameBuilder: fadeInFrame, cacheWidth: _cacheW(context, 0.5))
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: grads,
                                ),
                              ),
                              child: Icon(
                                  _catIcons[widget.ad.cat] ??
                                      Icons.apps_rounded,
                                  size: 36,
                                  color:
                                      Colors.white.withValues(alpha: 0.85)),
                            ),
                    ),
                    if (widget.ad.isTop)
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFF38BDF8),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Text('TOP',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: AppFontSize.tiny,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5)),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ad.t(context),
                      style: TextStyle(
                          fontSize: AppFontSize.caption,
                          fontWeight: FontWeight.w700,
                          height: 1.3,
                          color: AppTheme.tp(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.ad.price != null) ...[
                      const SizedBox(height: 4),
                      Text("${widget.ad.price} so'm",
                          style: TextStyle(
                              fontSize: AppFontSize.caption,
                              fontWeight: FontWeight.w700,
                              color: c)),
                    ],
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB45309),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_forward_rounded,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(_ru(context) ? 'Подробнее' : 'Batafsil',
                              style: const TextStyle(
                                  fontSize: AppFontSize.bodySmall,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail page ───────────────────────────────────────────────
class AdDetailPage extends StatelessWidget {
  final Ad ad;
  const AdDetailPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    const c = _amber;
    final grads = [_amber, Color(0xFFD97706)];

    return PremiumScaffold(
      title: _catLabel(context, ad.cat),
      accent: _amber,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: ad.image != null
                    ? Image.asset(ad.image!,
                        fit: BoxFit.cover, frameBuilder: fadeInFrame, cacheWidth: _cacheW(context))
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: grads,
                          ),
                        ),
                        child: Icon(
                            _catIcons[ad.cat] ?? Icons.apps_rounded,
                            size: 90,
                            color: Colors.white.withValues(alpha: 0.9)),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Text(ad.t(context),
                style: TextStyle(
                    fontSize: AppFontSize.h1,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    color: AppTheme.tp(context))),
            if (ad.price != null) ...[
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: c.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("${ad.price} so'm",
                    style: TextStyle(
                        fontSize: AppFontSize.h2,
                        fontWeight: FontWeight.w800,
                        color: c)),
              ),
            ],
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.panel(context, c),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 15, color: c),
                      const SizedBox(width: 6),
                      Text(_ru(context) ? 'Подробная информация' : "Batafsil ma'lumot",
                          style: TextStyle(
                              fontSize: AppFontSize.bodySmall,
                              fontWeight: FontWeight.w700,
                              color: c)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(ad.d(context),
                      style: TextStyle(
                          fontSize: AppFontSize.body,
                          color: AppTheme.tp(context),
                          height: 1.65)),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppTheme.card(context),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.dv(context)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: c.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.phone_rounded, color: c, size: 21),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_ru(context) ? 'Контактный номер' : 'Aloqa raqami',
                          style: TextStyle(
                              fontSize: AppFontSize.caption,
                              color: AppTheme.ts(context),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 3),
                      Text(ad.phone,
                          style: TextStyle(
                              fontSize: AppFontSize.h2,
                              fontWeight: FontWeight.w800,
                              color: AppTheme.tp(context))),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: c,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: () => launchUrl(Uri.parse('tel:${ad.phone}')),
                icon: const Icon(Icons.phone_in_talk_rounded),
                label: Text(_ru(context) ? 'Позвонить' : "Qo'ng'iroq qilish",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: AppFontSize.title)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────
class _AdsSkeleton extends StatelessWidget {
  const _AdsSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              skBox(h: 200, r: 28),
              const SizedBox(height: 10),
              Row(
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: skBox(w: 85, h: 34, r: 20),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (int r = 0; r < 3; r++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    2,
                    (i) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            skBox(h: 100, r: 16),
                            const SizedBox(height: 8),
                            skBox(h: 11),
                            const SizedBox(height: 5),
                            skBox(h: 11, w: 60),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
}
