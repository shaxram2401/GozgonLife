import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/l10n/strings.dart';
import '../../core/navigation/scroll_to_top.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/premium_scaffold.dart';
import '../../core/widgets/skeleton.dart';

const _red = Color(0xFFDC2626);
const _darkRed = Color(0xFF991B1B);

Color productColor(String cat) => switch (cat) {
      "Ko'chmas mulk"   => const Color(0xFF1E40AF),
      'Avtomobil'       => const Color(0xFF059669),
      'Maishiy texnika' => const Color(0xFFD97706),
      'Elektronika'     => const Color(0xFF7C3AED),
      _ /* Boshqa */    => const Color(0xFF475569),
    };

IconData productIcon(String cat) => switch (cat) {
      "Ko'chmas mulk"   => Icons.apartment_rounded,
      'Avtomobil'       => Icons.directions_car_rounded,
      'Maishiy texnika' => Icons.kitchen_rounded,
      'Elektronika'     => Icons.devices_rounded,
      _ /* Boshqa */    => Icons.category_rounded,
    };

const _cats = [
  'Barchasi',
  "Ko'chmas mulk",
  'Avtomobil',
  'Maishiy texnika',
  'Elektronika',
  'Boshqa',
];

class Product {
  final String title, price, desc, category, phone;
  final IconData icon;
  final String? titleRu, descRu, image;
  final BoxFit fit;
  const Product({
    required this.title,
    required this.price,
    required this.desc,
    required this.category,
    required this.icon,
    this.titleRu,
    this.descRu,
    this.phone = '+998 99 999 99 99',
    this.image,
    this.fit = BoxFit.contain,
  });

  String t(BuildContext c) => _ru(c) && titleRu != null ? titleRu! : title;
  String d(BuildContext c) => _ru(c) && descRu != null ? descRu! : desc;
  String p(BuildContext c) => _ru(c)
      ? price.replaceAll("so'mdan", 'сум/мес').replaceAll("so'm", 'сум')
      : price;
}

bool _ru(BuildContext c) => Localizations.localeOf(c).languageCode == 'ru';

const _catRu = <String, String>{
  'Barchasi': 'Все',
  "Ko'chmas mulk": 'Недвижимость',
  'Avtomobil': 'Авто',
  'Maishiy texnika': 'Бытовая техника',
  'Elektronika': 'Электроника',
  'Boshqa': 'Другое',
};

String catLabel(BuildContext c, String cat) =>
    _ru(c) ? (_catRu[cat] ?? cat) : cat;

const _olx = 'assets/images/olx/';

const kProducts = [
  // ── Boshqa ──
  Product(
    title: 'Alabay ovchi it sotiladi',
    titleRu: 'Продаётся алабай — охотничья собака',
    price: "5 000 000 so'm",
    category: 'Boshqa',
    icon: Icons.pets_rounded,
    image: '${_olx}alabay.png',
    desc: "Alabay zotli ovchi it sotiladi. Juda hushyor, kuchli va baquvvat. Uy, hovli hamda chorva mollarini qo'riqlash uchun juda mos. Qishloq sharoitida boqilgan. Ovga qiziqishi yuqori. Yaxshi parvarish qilingan. Jiddiy xaridorlar murojaat qilsin.\n\nXususiyatlari:\n• Zoti: Alabay\n• Jinsi: Erkak\n• Yoshi: 2 yosh\n• Qo'riqlash uchun mos\n• Ovga mos\n• Baquvvat va faol\n• Qishloq sharoitida boqilgan",
    descRu: "Продаётся охотничья собака породы алабай. Очень бдительный, сильный и крепкий. Отлично подходит для охраны дома, двора и скота. Выращен в сельских условиях. Высокий охотничий инстинкт. Ухоженный. Просьба обращаться серьёзным покупателям.\n\nХарактеристики:\n• Порода: Алабай\n• Пол: Самец\n• Возраст: 2 года\n• Подходит для охраны\n• Подходит для охоты\n• Крепкий и активный\n• Выращен в сельских условиях",
  ),
  Product(
    title: 'Futbol butsasi sotiladi',
    titleRu: 'Продаются футбольные бутсы',
    price: "265 000 so'm",
    category: 'Boshqa',
    icon: Icons.sports_soccer_rounded,
    image: '${_olx}butsa.png',
    desc: "Zamonaviy futbol butsasi sotiladi. Mashg'ulotlar va o'yinlar uchun qulay. Yengil va mustahkam materialdan tayyorlangan. Oyoqqa qulay o'tiradi, yugurish va harakatlanishda noqulaylik tug'dirmaydi. Havaskor va professional futbolchilar uchun mos.\n\nXususiyatlari:\n• Turi: Futbol butsasi\n• Rang: Moviy\n• Material: Sun'iy charm\n• Yengil va qulay\n• Mustahkam taglik\n• Futbol maydonlari uchun mos",
    descRu: "Продаются современные футбольные бутсы. Удобны для тренировок и игр. Изготовлены из лёгкого и прочного материала. Хорошо сидят на ноге, не мешают при беге и движении. Подходят любителям и профессионалам.\n\nХарактеристики:\n• Тип: Футбольные бутсы\n• Цвет: Синий\n• Материал: Искусственная кожа\n• Лёгкие и удобные\n• Прочная подошва\n• Подходят для футбольных полей",
  ),
  Product(
    title: 'Chorpoya sotiladi',
    titleRu: 'Продаётся чорпая (топчан)',
    price: "4 500 000 so'm",
    category: 'Boshqa',
    icon: Icons.weekend_rounded,
    image: '${_olx}chorpoya.png',
    desc: "Katta hajmdagi sifatli yog'och chorpoya sotiladi. Hovli, bog' va dam olish maskanlari uchun ajoyib tanlov. Bir vaqtning o'zida ko'pchilik o'tirishi mumkin. Mustahkam va uzoq muddat foydalanishga mo'ljallangan. Oila davralari, mehmon kutish va dam olish uchun juda qulay.\n\nXususiyatlari:\n• Turi: Katta chorpoya\n• Material: Sifatli yog'och\n• Sig'imi: 10–15 kishi\n• Hovli va bog' uchun mos\n• Mustahkam konstruktsiya\n• Zamonaviy va chiroyli ko'rinish",
    descRu: "Продаётся большой качественный деревянный топчан (чорпая). Отличный выбор для двора, сада и зон отдыха. Одновременно может разместиться много людей. Прочный и рассчитан на долгий срок. Удобен для семейных посиделок, приёма гостей и отдыха.\n\nХарактеристики:\n• Тип: Большой топчан\n• Материал: Качественное дерево\n• Вместимость: 10–15 человек\n• Подходит для двора и сада\n• Прочная конструкция\n• Современный и красивый вид",
  ),
  Product(
    title: "Italia idishlar to'plami sotiladi",
    titleRu: 'Продаётся набор посуды Italia',
    price: "850 000 so'm",
    category: 'Boshqa',
    icon: Icons.restaurant_rounded,
    image: '${_olx}idish.png',
    desc: "Italia brendiga mansub sifatli idishlar to'plami sotiladi. Oila uchun mo'ljallangan bo'lib, kundalik foydalanish va mehmon kutish uchun juda qulay. Nafis dizayni va mustahkam materiali bilan ajralib turadi. Oshxonangizga chiroyli ko'rinish va qulaylik baxsh etadi.\n\nXususiyatlari:\n• Brend: Italia\n• Turi: Idishlar to'plami\n• Material: Sifatli keramika\n• Chashka, kosa va likopchalardan iborat\n• Nafis va zamonaviy dizayn\n• Kundalik foydalanish uchun mos",
    descRu: "Продаётся качественный набор посуды бренда Italia. Рассчитан на семью, удобен для повседневного использования и приёма гостей. Отличается изящным дизайном и прочным материалом. Придаёт вашей кухне красивый вид и удобство.\n\nХарактеристики:\n• Бренд: Italia\n• Тип: Набор посуды\n• Материал: Качественная керамика\n• Состоит из чашек, пиал и тарелок\n• Изящный и современный дизайн\n• Подходит для повседневного использования",
  ),

  // ── Avtomobil ──
  Product(
    title: 'Matiz sotiladi',
    titleRu: 'Продаётся Matiz',
    price: "32 000 000 so'm",
    category: 'Avtomobil',
    icon: Icons.directions_car_rounded,
    image: '${_olx}matiz.png',
    desc: "Oq rangli Matiz sotiladi. Kundalik foydalanish uchun qulay va tejamkor avtomobil. Motor, karobka va yurish qismi yaxshi holatda. Oilaviy foydalanishda bo'lgan. Hujjatlari joyida.\n\nXususiyatlari:\n• Marka: Chevrolet Matiz\n• Kuzov turi: Xetchbek\n• Rang: Oq\n• Yili: 2015\n• Probeg: 145 000 km\n• Yoqilg'i turi: Benzin\n• Uzatma: Mexanika\n• Holati: Yaxshi",
    descRu: "Продаётся Matiz белого цвета. Удобный и экономичный автомобиль для повседневного использования. Двигатель, коробка и ходовая в хорошем состоянии. Был в семейном пользовании. Документы в порядке.\n\nХарактеристики:\n• Марка: Chevrolet Matiz\n• Тип кузова: Хетчбек\n• Цвет: Белый\n• Год: 2015\n• Пробег: 145 000 км\n• Топливо: Бензин\n• Коробка: Механика\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Yuk motosikli sotiladi',
    titleRu: 'Продаётся грузовой мотоцикл',
    price: "12 000 000 so'm",
    category: 'Avtomobil',
    icon: Icons.two_wheeler_rounded,
    image: '${_olx}mura.png',
    desc: "3 g'ildirakli yuk tashish motosikli sotiladi. Qishloq xo'jaligi va yuk tashish ishlari uchun juda qulay. Texnik holati yaxshi, ishlashida muammo yo'q.\n\nXususiyatlari:\n• Turi: Yuk motosikli\n• Rang: Qizil\n• Yili: 2022\n• Probeg: 18 000 km\n• Yoqilg'i turi: Benzin\n• Yuk tashish uchun mos\n• Holati: Yaxshi",
    descRu: "Продаётся трёхколёсный грузовой мотоцикл. Очень удобен для сельского хозяйства и перевозки грузов. Техническое состояние хорошее, в работе проблем нет.\n\nХарактеристики:\n• Тип: Грузовой мотоцикл\n• Цвет: Красный\n• Год: 2022\n• Пробег: 18 000 км\n• Топливо: Бензин\n• Подходит для перевозки грузов\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Nexia 2 sotiladi',
    titleRu: 'Продаётся Nexia 2',
    price: "75 000 000 so'm",
    category: 'Avtomobil',
    icon: Icons.directions_car_rounded,
    image: '${_olx}nexia.png',
    desc: "Ko'k metalik rangli Nexia 2 sotiladi. Avtomobil yaxshi saqlangan, motor va yurish qismida muammo yo'q. Oilaviy foydalanilgan. Hujjatlari to'liq.\n\nXususiyatlari:\n• Marka: Chevrolet Nexia 2\n• Kuzov turi: Sedan\n• Rang: Ko'k metalik\n• Yili: 2014\n• Probeg: 168 000 km\n• Yoqilg'i turi: Metan\n• Uzatma: Mexanika\n• Holati: Yaxshi",
    descRu: "Продаётся Nexia 2 цвета синий металлик. Автомобиль хорошо сохранён, проблем с двигателем и ходовой нет. Был в семейном пользовании. Документы полные.\n\nХарактеристики:\n• Марка: Chevrolet Nexia 2\n• Тип кузова: Седан\n• Цвет: Синий металлик\n• Год: 2014\n• Пробег: 168 000 км\n• Топливо: Метан\n• Коробка: Механика\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Spark sotiladi',
    titleRu: 'Продаётся Spark',
    price: "80 000 000 so'm",
    category: 'Avtomobil',
    icon: Icons.directions_car_rounded,
    image: '${_olx}spark.png',
    desc: "Qora rangli Spark sotiladi. Shahar va qishloq sharoitida foydalanish uchun qulay. Tejamkor va ishonchli avtomobil. Texnik ko'rikdan o'tgan, yurishga tayyor.\n\nXususiyatlari:\n• Marka: Chevrolet Spark\n• Kuzov turi: Xetchbek\n• Rang: Qora\n• Yili: 2018\n• Probeg: 12 000 km\n• Yoqilg'i turi: Metan\n• Uzatma: Mexanika\n• Holati: A'lo",
    descRu: "Продаётся Spark чёрного цвета. Удобен для города и села. Экономичный и надёжный автомобиль. Прошёл техосмотр, готов к эксплуатации.\n\nХарактеристики:\n• Марка: Chevrolet Spark\n• Тип кузова: Хетчбек\n• Цвет: Чёрный\n• Год: 2018\n• Пробег: 12 000 км\n• Топливо: Метан\n• Коробка: Механика\n• Состояние: Отличное",
  ),

  // ── Maishiy texnika ──
  Product(
    title: 'Artel blender sotiladi',
    titleRu: 'Продаётся блендер Artel',
    price: "350 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.blender_rounded,
    image: '${_olx}blender.png',
    fit: BoxFit.contain,
    desc: "Artel blender sotiladi. Meva sharbatlari, kokteyl va turli mahsulotlarni maydalash uchun qulay. Uy sharoitida foydalanilgan. Barcha funksiyalari ishlaydi.\n\nXususiyatlari:\n• Brend: Artel\n• Quvvati: 500 W\n• Hajmi: 1.5 litr\n• Rang: Kumushrang\n• Holati: Yaxshi",
    descRu: "Продаётся блендер Artel. Удобен для приготовления фруктовых соков, коктейлей и измельчения продуктов. Использовался в домашних условиях. Все функции работают.\n\nХарактеристики:\n• Бренд: Artel\n• Мощность: 500 Вт\n• Объём: 1.5 литра\n• Цвет: Серебристый\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Zamonaviy gaz plita sotiladi',
    titleRu: 'Продаётся современная газовая плита',
    price: "2 800 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.local_fire_department_rounded,
    image: '${_olx}gaz.png',
    desc: "Duxovkali zamonaviy gaz plita sotiladi. Katta oila uchun mos. Barcha gaz ko'zlari va duxovkasi soz holatda ishlaydi.\n\nXususiyatlari:\n• Brend: IMMER\n• Turi: Duxovkali gaz plita\n• Ko'zlari: 4 ta\n• Rang: Oq\n• Holati: Yaxshi",
    descRu: "Продаётся современная газовая плита с духовкой. Подходит для большой семьи. Все конфорки и духовка работают исправно.\n\nХарактеристики:\n• Бренд: IMMER\n• Тип: Газовая плита с духовкой\n• Конфорок: 4\n• Цвет: Белый\n• Состояние: Хорошее",
  ),
  Product(
    title: 'LG kir yuvish mashinasi sotiladi',
    titleRu: 'Продаётся стиральная машина LG',
    price: "3 900 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.local_laundry_service_rounded,
    image: '${_olx}lg.png',
    desc: "LG avtomat kir yuvish mashinasi sotiladi. Barcha dasturlari ishlaydi. Tejamkor va ishonchli model.\n\nXususiyatlari:\n• Brend: LG\n• Sig'imi: 7 kg\n• Turi: Avtomat\n• Rang: Oq\n• Holati: Yaxshi",
    descRu: "Продаётся автоматическая стиральная машина LG. Все программы работают. Экономичная и надёжная модель.\n\nХарактеристики:\n• Бренд: LG\n• Загрузка: 7 кг\n• Тип: Автомат\n• Цвет: Белый\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Shivaki xolodilnik sotiladi',
    titleRu: 'Продаётся холодильник Shivaki',
    price: "2 700 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.kitchen_rounded,
    image: '${_olx}oq.png',
    fit: BoxFit.contain,
    desc: "Shivaki xolodilnik sotiladi. Sovutish va muzlatish tizimi yaxshi ishlaydi. Oila uchun qulay hajmga ega.\n\nXususiyatlari:\n• Brend: Shivaki\n• Rang: Oq\n• Kameralar soni: 2 ta\n• Hajmi: 280 litr\n• Holati: Yaxshi",
    descRu: "Продаётся холодильник Shivaki. Система охлаждения и заморозки работает хорошо. Удобный объём для семьи.\n\nХарактеристики:\n• Бренд: Shivaki\n• Цвет: Белый\n• Количество камер: 2\n• Объём: 280 литров\n• Состояние: Хорошее",
  ),
  Product(
    title: 'Samsung xolodilnik sotiladi',
    titleRu: 'Продаётся холодильник Samsung',
    price: "5 500 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.kitchen_rounded,
    image: '${_olx}qora.png',
    fit: BoxFit.contain,
    desc: "Samsung qora rangli xolodilnik sotiladi. Zamonaviy dizayn va katta sig'imga ega. Elektr energiyasini kam sarflaydi.\n\nXususiyatlari:\n• Brend: Samsung\n• Rang: Qora\n• Kameralar soni: 2 ta\n• Hajmi: 420 litr\n• No Frost tizimi\n• Holati: A'lo",
    descRu: "Продаётся холодильник Samsung чёрного цвета. Современный дизайн и большой объём. Потребляет мало электроэнергии.\n\nХарактеристики:\n• Бренд: Samsung\n• Цвет: Чёрный\n• Количество камер: 2\n• Объём: 420 литров\n• Система No Frost\n• Состояние: Отличное",
  ),
  Product(
    title: 'Multivarka sotiladi',
    titleRu: 'Продаётся мультиварка',
    price: "450 000 so'm",
    category: 'Maishiy texnika',
    icon: Icons.soup_kitchen_rounded,
    image: '${_olx}varka.png',
    desc: "Multivarka sotiladi. Palov, sho'rva, bo'tqa va boshqa ko'plab taomlarni tayyorlash imkoniyati mavjud. Oshxonada juda qulay yordamchi.\n\nXususiyatlari:\n• Turi: Multivarka\n• Hajmi: 5 litr\n• Dasturlari: 12 ta\n• Rang: Kumushrang\n• Holati: Yaxshi",
    descRu: "Продаётся мультиварка. Возможность готовить плов, суп, кашу и множество других блюд. Очень удобный помощник на кухне.\n\nХарактеристики:\n• Тип: Мультиварка\n• Объём: 5 литров\n• Программ: 12\n• Цвет: Серебристый\n• Состояние: Хорошее",
  ),

  // ── Ko'chmas mulk ──
  Product(
    title: '6 sotixli uy-joy sotiladi',
    titleRu: 'Продаётся дом на 6 соток',
    price: "280 000 000 so'm",
    category: "Ko'chmas mulk",
    icon: Icons.house_rounded,
    image: '${_olx}uy1.png',
    desc: "6 sotix yer maydonida joylashgan uy-joy sotiladi. Uy yashash uchun tayyor holatda. Hovlisi keng va ozoda. Tinch va qulay hududda joylashgan. Oila uchun barcha sharoitlar mavjud.\n\nXususiyatlari:\n• Yer maydoni: 6 sotix\n• Xonalar soni: 4 ta\n• Elektr, gaz va suv mavjud\n• Hovlisi keng\n• Qulay joylashuv\n• Hujjatlari joyida",
    descRu: "Продаётся дом на земельном участке 6 соток. Дом готов для проживания. Двор просторный и чистый. Расположен в тихом и удобном районе. Все условия для семьи.\n\nХарактеристики:\n• Площадь участка: 6 соток\n• Количество комнат: 4\n• Есть электричество, газ и вода\n• Просторный двор\n• Удобное расположение\n• Документы в порядке",
  ),
  Product(
    title: '16 sotixli uy-joy sotiladi',
    titleRu: 'Продаётся дом на 16 соток',
    price: "650 000 000 so'm",
    category: "Ko'chmas mulk",
    icon: Icons.house_rounded,
    image: '${_olx}uy2.png',
    desc: "16 sotix yer maydonida joylashgan katta uy-joy sotiladi. Keng hovli, bog' uchun joy va qo'shimcha qurilish qilish imkoniyati mavjud. Katta oila uchun juda mos variant.\n\nXususiyatlari:\n• Yer maydoni: 16 sotix\n• Xonalar soni: 6 ta\n• Elektr, gaz va suv mavjud\n• Keng hovli va tomorqa\n• Qulay kirish yo'li\n• Hujjatlari joyida",
    descRu: "Продаётся большой дом на земельном участке 16 соток. Просторный двор, место для сада и возможность дополнительного строительства. Отличный вариант для большой семьи.\n\nХарактеристики:\n• Площадь участка: 16 соток\n• Количество комнат: 6\n• Есть электричество, газ и вода\n• Просторный двор и огород\n• Удобный въезд\n• Документы в порядке",
  ),
  Product(
    title: "Do'konlar ijaraga beriladi",
    titleRu: 'Сдаются магазины в аренду',
    price: "Oyiga 1 500 000 so'mdan",
    category: "Ko'chmas mulk",
    icon: Icons.store_rounded,
    image: '${_olx}dk.png',
    desc: "Yangi qurilgan savdo do'konlari uzoq muddatli ijaraga beriladi. Savdo, xizmat ko'rsatish va ofis faoliyati uchun mos. Joylashuvi qulay, mijozlar oqimi yaxshi hududda joylashgan.\n\nXususiyatlari:\n• Maydoni: 20–50 m²\n• Yangi ta'mirlangan\n• Elektr energiyasi mavjud\n• Alohida kirish eshigi\n• Avtoturargoh mavjud\n• Savdo va xizmat ko'rsatish uchun mos",
    descRu: "Новопостроенные торговые магазины сдаются в долгосрочную аренду. Подходят для торговли, услуг и офисной деятельности. Удобное расположение, район с хорошим потоком клиентов.\n\nХарактеристики:\n• Площадь: 20–50 м²\n• Новый ремонт\n• Есть электричество\n• Отдельный вход\n• Есть парковка\n• Подходят для торговли и услуг",
  ),

  // ── Elektronika ──
  Product(
    title: 'Artel 32 televizor sotiladi',
    titleRu: 'Продаётся телевизор Artel 32',
    price: "1 600 000 so'm",
    category: 'Elektronika',
    icon: Icons.tv_rounded,
    image: '${_olx}artel.png',
    desc: "Artel 32 dyuymli televizor sotiladi. Tasvir sifati yaxshi, ovozi tiniq. Uy sharoitida foydalanilgan. Barcha funksiyalari ishlaydi.\n\nXususiyatlari:\n• Brend: Artel\n• Ekran: 32 dyuym\n• LED ekran\n• HDMI va USB mavjud\n• Rang: Qora",
    descRu: "Продаётся телевизор Artel 32 дюйма. Хорошее качество изображения, чистый звук. Использовался дома. Все функции работают.\n\nХарактеристики:\n• Бренд: Artel\n• Экран: 32 дюйма\n• LED экран\n• Есть HDMI и USB\n• Цвет: Чёрный",
  ),
  Product(
    title: 'Shivaki 43 televizor sotiladi',
    titleRu: 'Продаётся телевизор Shivaki 43',
    price: "2 700 000 so'm",
    category: 'Elektronika',
    icon: Icons.tv_rounded,
    image: '${_olx}shivaki.png',
    desc: "Shivaki 43 dyuymli televizor sotiladi. Katta ekran va sifatli tasvirga ega. Oila davrasida film va telekanallar tomosha qilish uchun juda qulay.\n\nXususiyatlari:\n• Brend: Shivaki\n• Ekran: 43 dyuym\n• Full HD\n• HDMI va USB mavjud\n• Rang: Qora",
    descRu: "Продаётся телевизор Shivaki 43 дюйма. Большой экран и качественное изображение. Очень удобен для просмотра фильмов и телеканалов в кругу семьи.\n\nХарактеристики:\n• Бренд: Shivaki\n• Экран: 43 дюйма\n• Full HD\n• Есть HDMI и USB\n• Цвет: Чёрный",
  ),
  Product(
    title: 'iPhone 13 sotiladi',
    titleRu: 'Продаётся iPhone 13',
    price: "4 800 000 so'm",
    category: 'Elektronika',
    icon: Icons.phone_iphone_rounded,
    image: '${_olx}iphone.png',
    desc: "iPhone 13 sotiladi. Kamera sifati yuqori, barcha funksiyalari soz ishlaydi. Kundalik foydalanish uchun ajoyib smartfon.\n\nXususiyatlari:\n• Xotira: 128 GB\n• Rang: Oq\n• Face ID mavjud\n• Batareya holati: 86%\n• iOS tizimi",
    descRu: "Продаётся iPhone 13. Высокое качество камеры, все функции работают исправно. Отличный смартфон для повседневного использования.\n\nХарактеристики:\n• Память: 128 ГБ\n• Цвет: Белый\n• Есть Face ID\n• Состояние батареи: 86%\n• Система iOS",
  ),
  Product(
    title: 'Samsung A16 sotiladi',
    titleRu: 'Продаётся Samsung A16',
    price: "2 100 000 so'm",
    category: 'Elektronika',
    icon: Icons.phone_android_rounded,
    image: '${_olx}samsung.png',
    desc: "Samsung A16 smartfoni sotiladi. Tezkor ishlaydi, internet va ijtimoiy tarmoqlar uchun qulay. Batareyasi uzoq muddat xizmat qiladi.\n\nXususiyatlari:\n• Xotira: 128 GB\n• Operativ xotira: 6 GB\n• Rang: Moviy\n• Batareya: 5000 mAh\n• 2 ta SIM-karta",
    descRu: "Продаётся смартфон Samsung A16. Работает быстро, удобен для интернета и соцсетей. Батарея держит долго.\n\nХарактеристики:\n• Память: 128 ГБ\n• Оперативная память: 6 ГБ\n• Цвет: Синий\n• Батарея: 5000 мА·ч\n• 2 SIM-карты",
  ),
  Product(
    title: 'Poco F3 sotiladi',
    titleRu: 'Продаётся Poco F3',
    price: "2 600 000 so'm",
    category: 'Elektronika',
    icon: Icons.phone_android_rounded,
    image: '${_olx}poco.png',
    desc: "Poco F3 sotiladi. Kuchli protsessor va sifatli ekran bilan jihozlangan. O'yinlar va kundalik foydalanish uchun juda mos.\n\nXususiyatlari:\n• Xotira: 128 GB\n• Operativ xotira: 6 GB\n• AMOLED ekran\n• 5G qo'llab-quvvatlaydi\n• Rang: Qora",
    descRu: "Продаётся Poco F3. Оснащён мощным процессором и качественным экраном. Отлично подходит для игр и повседневного использования.\n\nХарактеристики:\n• Память: 128 ГБ\n• Оперативная память: 6 ГБ\n• AMOLED экран\n• Поддержка 5G\n• Цвет: Чёрный",
  ),
  Product(
    title: 'Asus noutbuk sotiladi',
    titleRu: 'Продаётся ноутбук Asus',
    price: "3 900 000 so'm",
    category: 'Elektronika',
    icon: Icons.laptop_rounded,
    image: '${_olx}noutbuk.png',
    desc: "Asus noutbuk sotiladi. O'qish, ish va internet uchun qulay. Batareyasi yaxshi ushlaydi, texnik holati yaxshi.\n\nXususiyatlari:\n• Brend: Asus\n• Ekran: 15.6 dyuym\n• Operativ xotira: 8 GB\n• SSD: 256 GB\n• Rang: Kulrang",
    descRu: "Продаётся ноутбук Asus. Удобен для учёбы, работы и интернета. Батарея держит хорошо, техническое состояние хорошее.\n\nХарактеристики:\n• Бренд: Asus\n• Экран: 15.6 дюйма\n• Оперативная память: 8 ГБ\n• SSD: 256 ГБ\n• Цвет: Серый",
  ),
  Product(
    title: 'Personal kompyuter sotiladi',
    titleRu: 'Продаётся персональный компьютер',
    price: "5 500 000 so'm",
    category: 'Elektronika',
    icon: Icons.desktop_windows_rounded,
    image: '${_olx}pc.png',
    desc: "To'liq komplekt personal kompyuter sotiladi. Monitor, sistemnik, klaviatura va sichqoncha bilan birga beriladi. Ish, o'qish va o'yinlar uchun mos.\n\nXususiyatlari:\n• Intel Core i5 protsessor\n• Operativ xotira: 16 GB\n• SSD: 512 GB\n• Monitor: 24 dyuym\n• To'liq komplekt",
    descRu: "Продаётся персональный компьютер в полной комплектации. Монитор, системный блок, клавиатура и мышь в комплекте. Подходит для работы, учёбы и игр.\n\nХарактеристики:\n• Процессор Intel Core i5\n• Оперативная память: 16 ГБ\n• SSD: 512 ГБ\n• Монитор: 24 дюйма\n• Полный комплект",
  ),
  Product(
    title: 'AirPods Air sotiladi',
    titleRu: 'Продаются наушники AirPods',
    price: "180 000 so'm",
    category: 'Elektronika',
    icon: Icons.headphones_rounded,
    image: '${_olx}naush.png',
    desc: "Simsiz quloqchin sotiladi. Musiqa tinglash, qo'ng'iroqlar va kundalik foydalanish uchun qulay. Zaryad qutisi bilan birga beriladi.\n\nXususiyatlari:\n• Turi: Simsiz quloqchin\n• Bluetooth ulanish\n• Zaryad qutisi mavjud\n• Rang: Oq\n• Sensorli boshqaruv",
    descRu: "Продаются беспроводные наушники. Удобны для прослушивания музыки, звонков и повседневного использования. Поставляются с зарядным кейсом.\n\nХарактеристики:\n• Тип: Беспроводные наушники\n• Подключение Bluetooth\n• Есть зарядный кейс\n• Цвет: Белый\n• Сенсорное управление",
  ),
  Product(
    title: 'Smart Watch sotiladi',
    titleRu: 'Продаются смарт-часы',
    price: "250 000 so'm",
    category: 'Elektronika',
    icon: Icons.watch_rounded,
    image: '${_olx}watch.png',
    desc: "Smart Watch aqlli soati sotiladi. Telefon bilan sinxron ishlaydi. Qadamlar soni, yurak urishi va boshqa ko'rsatkichlarni kuzatib boradi.\n\nXususiyatlari:\n• Sensorli ekran\n• Bluetooth ulanish\n• Android va iPhone bilan ishlaydi\n• Sport rejimlari mavjud\n• Rang: Qora",
    descRu: "Продаются смарт-часы. Синхронизируются с телефоном. Отслеживают количество шагов, пульс и другие показатели.\n\nХарактеристики:\n• Сенсорный экран\n• Подключение Bluetooth\n• Работают с Android и iPhone\n• Есть спортивные режимы\n• Цвет: Чёрный",
  ),
];

// E'lon joylangan taxminiy sanalar — tepada yangi (01.06.2026), pastda eski (01.03.2026).
const _productDates = <String, String>{
  'Alabay ovchi it sotiladi': '01.06.2026',
  'Futbol butsasi sotiladi': '28.05.2026',
  'Chorpoya sotiladi': '25.05.2026',
  "Italia idishlar to'plami sotiladi": '22.05.2026',
  'Matiz sotiladi': '18.05.2026',
  'Yuk motosikli sotiladi': '15.05.2026',
  'Nexia 2 sotiladi': '12.05.2026',
  'Spark sotiladi': '08.05.2026',
  'Artel blender sotiladi': '05.05.2026',
  'Zamonaviy gaz plita sotiladi': '01.05.2026',
  'LG kir yuvish mashinasi sotiladi': '27.04.2026',
  'Shivaki xolodilnik sotiladi': '24.04.2026',
  'Samsung xolodilnik sotiladi': '20.04.2026',
  'Multivarka sotiladi': '16.04.2026',
  '6 sotixli uy-joy sotiladi': '13.04.2026',
  '16 sotixli uy-joy sotiladi': '09.04.2026',
  "Do'konlar ijaraga beriladi": '06.04.2026',
  'Artel 32 televizor sotiladi': '02.04.2026',
  'Shivaki 43 televizor sotiladi': '29.03.2026',
  'iPhone 13 sotiladi': '25.03.2026',
  'Samsung A16 sotiladi': '21.03.2026',
  'Poco F3 sotiladi': '18.03.2026',
  'Asus noutbuk sotiladi': '14.03.2026',
  'Personal kompyuter sotiladi': '10.03.2026',
  'AirPods Air sotiladi': '06.03.2026',
  'Smart Watch sotiladi': '01.03.2026',
};

/// Mahsulot e'loni sanasi (DD.MM.YYYY — tildan mustaqil format).
String productDate(BuildContext c, Product p) => _productDates[p.title] ?? '';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});
  @override
  State<MarketScreen> createState() => _State();
}

class _State extends State<MarketScreen> {
  final _search = TextEditingController();
  final _scrollCtrl = ScrollController();
  String _query = '';
  String _selCat = 'Barchasi';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    TabScrollTop.register('/market', _scrollCtrl);
    final show = shouldShowSkeleton('market');
    _loading = show;
    if (show) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    TabScrollTop.unregister('/market', _scrollCtrl);
    _scrollCtrl.dispose();
    _search.dispose();
    super.dispose();
  }

  List<Product> get _filtered => kProducts.where((p) {
        final catOk = _selCat == 'Barchasi' || p.category == _selCat;
        final q = _query.toLowerCase();
        final searchOk = q.isEmpty ||
            p.title.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q);
        return catOk && searchOk;
      }).toList();

  void _showDetail(Product p) =>
      context.push('/market/detail', extra: p);

  void _showPostForm() {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.card(ctx),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.dv(ctx),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.add_business_rounded,
                        color: _red, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(tr(ctx, 'm_post'),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleCtrl,
                decoration: InputDecoration(
                  hintText: tr(ctx, 'm_hint_name'),
                  prefixIcon: const Icon(Icons.title_rounded),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: tr(ctx, 'm_hint_price'),
                  prefixIcon: const Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: tr(ctx, 'm_hint_desc'),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.description_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  titleCtrl.dispose();
                  priceCtrl.dispose();
                  descCtrl.dispose();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(tr(context, 'm_posted')),
                      backgroundColor: _red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                child: Text(tr(ctx, 'm_publish')),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return PremiumScaffold(
        title: tr(context, 'nav_market'),
        accent: _red,
        useDrawer: true,
        immersive: true,
        body: const _MarketSkeleton(),
      );
    }
    final items = _filtered;
    return PremiumScaffold(
      title: tr(context, 'nav_market'),
      accent: _red,
      useDrawer: true,
      immersive: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showPostForm,
        backgroundColor: _red,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(tr(context, 'm_post'),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: _red,
        child: CustomScrollView(
          controller: _scrollCtrl,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Banner
            SliverToBoxAdapter(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(28)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                      _ru(context)
                          ? 'assets/images/marketru.png'
                          : 'assets/images/marketuz.png',
                      fit: BoxFit.cover),
                ),
              ),
            ),
            // Search
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: tr(context, 'm_search'),
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
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0, horizontal: 16),
                  ),
                ),
              ),
            ),
            // Category chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 52,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  itemCount: _cats.length,
                  separatorBuilder: (_, i) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = _cats[i];
                    final sel = cat == _selCat;
                    const color = _red;
                    return GestureDetector(
                      onTap: () => setState(() => _selCat = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel ? color : AppTheme.card(context),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: sel ? color : AppTheme.dv(context),
                          ),
                          boxShadow: sel
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.35),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              cat == 'Barchasi'
                                  ? Icons.apps_rounded
                                  : productIcon(cat),
                              size: 13,
                              color:
                                  sel ? Colors.white : AppTheme.ts(context),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              catLabel(context, cat),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: sel
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: sel
                                    ? Colors.white
                                    : AppTheme.ts(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Grid or empty state
            if (items.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off_rounded,
                          size: 56,
                          color:
                              AppTheme.ts(context).withValues(alpha: 0.4)),
                      const SizedBox(height: 12),
                      Text(
                        tr(context, 'm_nothing').replaceAll('{q}', _query),
                        style: TextStyle(color: AppTheme.ts(context)),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 100),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.82,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => _Card(
                        product: items[i],
                        onTap: () => _showDetail(items[i])),
                    childCount: items.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Product card ─────────────────────────────────────────────
class _Card extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  const _Card({required this.product, required this.onTap});
  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = productColor(widget.product.category);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.card(context),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: dark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? 0.35 : 0.10),
                blurRadius: 20,
                spreadRadius: -2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image zone
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: widget.product.image != null
                            ? Container(
                                color: dark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF1F3F6),
                                child: Image.asset(widget.product.image!,
                                    fit: widget.product.fit),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      c,
                                      Color.lerp(c, Colors.black, 0.30)!
                                    ],
                                  ),
                                ),
                                child: Icon(widget.product.icon,
                                    size: 48,
                                    color: Colors.white
                                        .withValues(alpha: 0.85)),
                              ),
                      ),
                      // Category badge — frosted
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                    Colors.white.withValues(alpha: 0.25)),
                          ),
                          child: Text(
                            catLabel(context, widget.product.category),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              // Info
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 4, 10, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule_rounded,
                            size: 11,
                            color: AppTheme.ts(context).withValues(alpha: 0.8)),
                        const SizedBox(width: 4),
                        Text(
                          productDate(context, widget.product),
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.1,
                            color: AppTheme.ts(context).withValues(alpha: 0.85),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.product.t(context),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -0.2,
                        color: AppTheme.tp(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.p(context),
                            style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.3,
                                color: dark
                                    ? const Color(0xFFF87171)
                                    : _darkRed),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [_red, _darkRed],
                            ),
                            borderRadius: BorderRadius.circular(11),
                            boxShadow: [
                              BoxShadow(
                                color: _red.withValues(alpha: 0.40),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.arrow_outward_rounded,
                              size: 18, color: Colors.white),
                        ),
                      ],
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

// ── Detail page ──────────────────────────────────────────────
class MarketDetailPage extends StatelessWidget {
  final Product product;
  const MarketDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const c = _red;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final priceColor = dark ? const Color(0xFFF87171) : _darkRed;
    final hasImg = product.image != null && product.image!.isNotEmpty;

    return PremiumScaffold(
      title: catLabel(context, product.category),
      accent: c,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: double.infinity,
                height: 240,
                child: hasImg
                    ? Container(
                        color: AppTheme.card(context),
                        child: Image.asset(product.image!, fit: product.fit),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [c, Color.lerp(c, Colors.black, 0.3)!],
                          ),
                        ),
                        child: Icon(product.icon,
                            size: 90,
                            color: Colors.white.withValues(alpha: 0.9)),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.schedule_rounded,
                    size: 14, color: AppTheme.ts(context)),
                const SizedBox(width: 6),
                Text(
                  productDate(context, product),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.ts(context)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(product.t(context),
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    color: AppTheme.tp(context))),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: c.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(product.p(context),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: priceColor)),
            ),
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
                      const Icon(Icons.info_outline_rounded,
                          size: 15, color: c),
                      const SizedBox(width: 6),
                      Text(_ru(context) ? 'Подробная информация' : "Batafsil ma'lumot",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: c)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(product.d(context),
                      style: TextStyle(
                          fontSize: 14,
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
                    child: const Icon(Icons.phone_rounded, color: c, size: 21),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_ru(context) ? 'Контактный номер' : 'Aloqa raqami',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.ts(context),
                              fontWeight: FontWeight.w500)),
                      const SizedBox(height: 3),
                      Text(product.phone,
                          style: TextStyle(
                              fontSize: 18,
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
                onPressed: () =>
                    launchUrl(Uri.parse('tel:${product.phone}')),
                icon: const Icon(Icons.phone_in_talk_rounded),
                label: Text(_ru(context) ? 'Позвонить' : "Qo'ng'iroq qilish",
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton ─────────────────────────────────────────────────
class _MarketSkeleton extends StatelessWidget {
  const _MarketSkeleton();

  @override
  Widget build(BuildContext context) => SkeletonShimmer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              skBox(h: 200, r: 28),
              const SizedBox(height: 12),
              skBox(h: 48, r: 14),
              const SizedBox(height: 10),
              Row(
                children: List.generate(
                  4,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: skBox(h: 34, w: 90, r: 20),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              for (int r = 0; r < 3; r++) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    2,
                    (_) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            skBox(h: 110, r: 16),
                            const SizedBox(height: 8),
                            skBox(h: 11),
                            const SizedBox(height: 5),
                            skBox(h: 11, w: 80),
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
