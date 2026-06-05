import 'package:flutter/widgets.dart';

/// Translate [key] into the current locale.
/// Table values are ordered: [uz, ru, en].
String tr(BuildContext context, String key) {
  final code = Localizations.localeOf(context).languageCode;
  final idx = code == 'ru' ? 1 : (code == 'en' ? 2 : 0);
  final entry = kStrings[key];
  if (entry == null) {
    assert(false, 'Missing translation key: $key');
    return key;
  }
  return entry[idx];
}

/// key: [uz, ru, en]
const Map<String, List<String>> kStrings = {
  // ── Common ──────────────────────────────────────────────
  'all': ['Barchasi →', 'Все →', 'All →'],
  'cancel': ['Bekor', 'Отмена', 'Cancel'],
  'save': ['Saqlash', 'Сохранить', 'Save'],
  'send': ['Yuborish', 'Отправить', 'Send'],
  'search': ['Qidirish', 'Поиск', 'Search'],
  'loading': ['Yuklanmoqda...', 'Загрузка...', 'Loading...'],
  'retry': ['Qayta urinish', 'Повторить', 'Retry'],
  'next': ['Keyingi', 'Далее', 'Next'],
  'back': ['Orqaga', 'Назад', 'Back'],
  'confirm': ['Tasdiqlash', 'Подтвердить', 'Confirm'],
  'close': ['Yopish', 'Закрыть', 'Close'],

  // ── Bottom navigation ───────────────────────────────────
  'nav_home': ['Bosh', 'Главная', 'Home'],
  'nav_services': ['Xizmatlar', 'Услуги', 'Services'],
  'nav_zukkobek': ['Zukkobek', 'Зуккобек', 'Zukkobek'],
  'nav_market': ['Market', 'Маркет', 'Market'],
  'nav_profile': ['Profil', 'Профиль', 'Profile'],

  // ── Drawer ──────────────────────────────────────────────
  'd_home': ['Bosh sahifa', 'Главная', 'Home'],
  'd_news': ['Yangiliklar', 'Новости', 'News'],
  'd_weather': ['Ob-havo', 'Погода', 'Weather'],
  'd_appeals': ['Murojatlar', 'Обращения', 'Appeals'],
  'd_ads': ["E'lonlar", 'Объявления', 'Ads'],
  'd_bank': ['Bank', 'Банк', 'Bank'],
  'd_tourism': ['Turizm', 'Туризм', 'Tourism'],
  'd_contact': ['Aloqa', 'Контакты', 'Contact'],
  'd_settings': ['Sozlamalar', 'Настройки', 'Settings'],
  'night_mode': ['Tungi rejim', 'Ночной режим', 'Dark mode'],
  'language': ['Til', 'Язык', 'Language'],
  'choose_language': ['Tilni tanlang', 'Выберите язык', 'Choose language'],
  'logout': ['Chiqish', 'Выход', 'Log out'],
  'logout_confirm': ['Hisobdan chiqmoqchimisiz?', 'Выйти из аккаунта?', 'Log out of your account?'],

  // ── Home ────────────────────────────────────────────────
  'home_greeting_sub': ['Bugun qanday yordam bera olamiz?', 'Чем можем помочь сегодня?', 'How can we help you today?'],
  'categories': ['Kategoriyalar', 'Категории', 'Categories'],
  'news': ['Yangiliklar', 'Новости', 'News'],
  'w_location': ["G'ozg'on, Qashqadaryo", 'Газган, Кашкадарья', 'Gazgan, Qashqadaryo'],
  'w_sunny': ['Quyoshli', 'Солнечно', 'Sunny'],
  'w_humidity': ['Namlik', 'Влажность', 'Humidity'],
  'w_wind': ['Shamol', 'Ветер', 'Wind'],
  'w_night': ['Kechasi', 'Ночью', 'Night'],

  // ── Category / service tiles ────────────────────────────
  'c_news': ['Yangiliklar', 'Новости', 'News'],
  'c_appeals': ['Murojatlar', 'Обращения', 'Appeals'],
  'c_transport': ['Qatnov', 'Транспорт', 'Transport'],
  'c_bank': ['MyBank', 'Мой банк', 'My Bank'],
  'c_bank_short': ['Bank', 'Банк', 'Bank'],
  'c_ads': ["E'lonlar", 'Объявления', 'Ads'],
  'c_prayer': ['Namoz', 'Намаз', 'Prayer'],
  'c_map': ['Xarita', 'Карта', 'Map'],
  'c_mahalla': ['Mahallam', 'Махалля', 'Mahalla'],
  'c_tourism': ['Turizm', 'Туризм', 'Tourism'],

  // ── Tags ────────────────────────────────────────────────
  'tag_sport': ['Sport', 'Спорт', 'Sport'],
  'tag_city': ['Shahar', 'Город', 'City'],
  'tag_social': ['Ijtimoiy', 'Социальное', 'Social'],

  // ── Sample news ─────────────────────────────────────────
  'news1_title': [
    "G'ozg'onda yangi sport majmuasi qurilishi boshlandi",
    'В Газгане началось строительство нового спорткомплекса',
    'Construction of a new sports complex has begun in Gazgan',
  ],
  'news2_title': [
    "Shahar markazida ko'cha ta'mirlash ishlari yakunlandi",
    'В центре города завершён ремонт улиц',
    'Street repairs completed in the city center',
  ],
  'news3_title': [
    "Yangi ijtimoiy loyihalar e'lon qilindi",
    'Объявлены новые социальные проекты',
    'New social projects announced',
  ],

  // ── News screen (uz-keyed) ──────────────────────────────
  'Barchasi': ['Barchasi', 'Все', 'All'],
  'Shahar': ['Shahar', 'Город', 'City'],
  'Sport': ['Sport', 'Спорт', 'Sport'],
  'Hokimiyat': ['Hokimiyat', 'Власть', 'Government'],
  'Tadbir': ['Tadbir', 'Мероприятие', 'Event'],
  'Mahalliy': ['Mahalliy', 'Местное', 'Local'],
  'Yangiliklar topilmadi': ['Yangiliklar topilmadi', 'Новости не найдены', 'No news found'],
  "G'ozg'onda yangi zamonaviy sport majmuasi qurilishi boshlandi": [
    "G'ozg'onda yangi zamonaviy sport majmuasi qurilishi boshlandi",
    'В Газгане началось строительство нового современного спорткомплекса',
    'Construction of a new modern sports complex has begun in Gazgan',
  ],
  "Hokimiyat aholiga yangi raqamli kommunal xizmatlar taqdim etdi": [
    "Hokimiyat aholiga yangi raqamli kommunal xizmatlar taqdim etdi",
    'Власти предоставили жителям новые цифровые коммунальные услуги',
    'The administration introduced new digital utility services for residents',
  ],
  "Shahar markazida ko'cha ta'mirlash ishlari muvaffaqiyatli yakunlandi": [
    "Shahar markazida ko'cha ta'mirlash ishlari muvaffaqiyatli yakunlandi",
    'В центре города успешно завершён ремонт улиц',
    'Street repair works in the city center were successfully completed',
  ],
  "Yoshlar madaniyat festivali mingdan ortiq ishtirokchi bilan o'tkazildi": [
    "Yoshlar madaniyat festivali mingdan ortiq ishtirokchi bilan o'tkazildi",
    'Молодёжный фестиваль культуры собрал более тысячи участников',
    'The youth culture festival was held with over a thousand participants',
  ],
  "Mahalliy dehqonlar va fermerlar mahsulotlari ko'rgazmasi ochildi": [
    "Mahalliy dehqonlar va fermerlar mahsulotlari ko'rgazmasi ochildi",
    'Открылась выставка продукции местных дехкан и фермеров',
    'An exhibition of local farmers\' produce has opened',
  ],

  // ── Ads screen (uz-keyed) ───────────────────────────────
  'Savdo': ['Savdo', 'Торговля', 'Trade'],
  'Restoranlar': ['Restoranlar', 'Рестораны', 'Restaurants'],
  'Xizmatlar': ['Xizmatlar', 'Услуги', 'Services'],
  "Ish o'rinlari": ["Ish o'rinlari", 'Вакансии', 'Jobs'],
  'Aksiyalar': ['Aksiyalar', 'Акции', 'Promotions'],
  'call': ["Qo'ng'iroq", 'Позвонить', 'Call'],
  "Yangi qurilish materiallari ulgurji narxda": [
    'Yangi qurilish materiallari ulgurji narxda',
    'Новые стройматериалы по оптовым ценам',
    'New construction materials at wholesale prices',
  ],
  "Osh va milliy taomlar kafesi": [
    'Osh va milliy taomlar kafesi',
    'Кафе плова и национальных блюд',
    'Pilaf and national cuisine cafe',
  ],
  "Santexnik — tezkor xizmat": [
    'Santexnik — tezkor xizmat',
    'Сантехник — срочный выезд',
    'Plumber — fast service',
  ],
  "Kassir kerak, ish haqi yuqori": [
    'Kassir kerak, ish haqi yuqori',
    'Требуется кассир, высокая зарплата',
    'Cashier wanted, high salary',
  ],
  "Kiyimlar 50% chegirma hafta oxiri": [
    'Kiyimlar 50% chegirma hafta oxiri',
    'Одежда -50% в выходные',
    'Clothing 50% off this weekend',
  ],
  "Telefon va aksessuarlar do'koni": [
    "Telefon va aksessuarlar do'koni",
    'Магазин телефонов и аксессуаров',
    'Phone and accessories store',
  ],
  "Avtomobil ta'mirlash ustaxonasi": [
    "Avtomobil ta'mirlash ustaxonasi",
    'Автомастерская по ремонту',
    'Car repair workshop',
  ],
  "Sushi va fast food yetkazib berish": [
    'Sushi va fast food yetkazib berish',
    'Доставка суши и фастфуда',
    'Sushi and fast food delivery',
  ],

  // ── Market screen ───────────────────────────────────────
  'm_search': ['Mahsulot qidirish...', 'Поиск товаров...', 'Search products...'],
  'm_post': ['Mahsulot joylash', 'Разместить товар', 'Post a product'],
  'm_desc_label': ['Tavsif', 'Описание', 'Description'],
  'm_contact': ["Bog'lanish", 'Связаться', 'Contact'],
  'm_hint_name': ['Nomi (masalan: iPhone 15)', 'Название (например: iPhone 15)', 'Title (e.g. iPhone 15)'],
  'm_hint_price': ["Narxi (so'm)", 'Цена (сум)', 'Price (soum)'],
  'm_hint_desc': ['Tavsif...', 'Описание...', 'Description...'],
  'm_posted': ["E'lon joylashtirildi", 'Объявление размещено', 'Ad posted'],
  'm_publish': ["E'lonni joylash", 'Опубликовать', 'Publish ad'],
  'm_nothing': ["'{q}' bo'yicha hech narsa topilmadi", 'По «{q}» ничего не найдено', "Nothing found for '{q}'"],
  // product categories
  "Ko'chmas mulk": ["Ko'chmas mulk", 'Недвижимость', 'Real estate'],
  'Elektronika': ['Elektronika', 'Электроника', 'Electronics'],
  'Avtomobil': ['Avtomobil', 'Автомобиль', 'Car'],
  'Maishiy texnika': ['Maishiy texnika', 'Бытовая техника', 'Home appliances'],
  // product titles
  '2 xonali kvartira': ['2 xonali kvartira', '2-комнатная квартира', '2-room apartment'],
  'Samsung Galaxy S24': ['Samsung Galaxy S24', 'Samsung Galaxy S24', 'Samsung Galaxy S24'],
  'Nexia 3, 2021 yil': ['Nexia 3, 2021 yil', 'Nexia 3, 2021 г.', 'Nexia 3, 2021'],
  'Kir yuvish mashinasi': ['Kir yuvish mashinasi', 'Стиральная машина', 'Washing machine'],
  'Hovli uy, 6 sotix': ['Hovli uy, 6 sotix', 'Частный дом, 6 соток', 'House, 6 sotka'],
  'Televizor 55 dyuym': ['Televizor 55 dyuym', 'Телевизор 55 дюймов', '55-inch TV'],
  // prices
  "350 000 000 so'm": ["350 000 000 so'm", '350 000 000 сум', '350,000,000 soum'],
  "12 500 000 so'm": ["12 500 000 so'm", '12 500 000 сум', '12,500,000 soum'],
  "98 000 000 so'm": ["98 000 000 so'm", '98 000 000 сум', '98,000,000 soum'],
  "4 200 000 so'm": ["4 200 000 so'm", '4 200 000 сум', '4,200,000 soum'],
  "520 000 000 so'm": ["520 000 000 so'm", '520 000 000 сум', '520,000,000 soum'],
  "3 800 000 so'm": ["3 800 000 so'm", '3 800 000 сум', '3,800,000 soum'],
  // locations
  'Marmarobod': ['Marmarobod', 'Мармаробод', 'Marmarobod'],
  "Bozor ko'chasi": ["Bozor ko'chasi", 'ул. Базар', 'Bazaar Street'],
  'Avto bozor': ['Avto bozor', 'Авторынок', 'Car market'],
  'Shayxon MFY': ['Shayxon MFY', 'МФЙ Шайхон', 'Shaykhon MFY'],
  'Tumar MFY': ['Tumar MFY', 'МФЙ Тумар', 'Tumar MFY'],
  // descriptions
  "Yangi qurilish, 2-qavat, 58 kv.m. Hammom, balkon bor. Hujjatlar tayyor.": [
    "Yangi qurilish, 2-qavat, 58 kv.m. Hammom, balkon bor. Hujjatlar tayyor.",
    'Новостройка, 2-й этаж, 58 кв.м. Есть ванная, балкон. Документы готовы.',
    'New build, 2nd floor, 58 sq.m. Bathroom, balcony. Documents ready.',
  ],
  "8/256 GB, qora rang. Kafolat bor. Aksessuarlar komplekt.": [
    "8/256 GB, qora rang. Kafolat bor. Aksessuarlar komplekt.",
    '8/256 ГБ, чёрный. Есть гарантия. Аксессуары в комплекте.',
    '8/256 GB, black. Warranty included. Accessories in the box.',
  ],
  "1.5 dvigatel, konditsioner bor. Yaxshi holatda. Hujjatlar tayyor.": [
    "1.5 dvigatel, konditsioner bor. Yaxshi holatda. Hujjatlar tayyor.",
    'Двигатель 1.5, есть кондиционер. В хорошем состоянии. Документы готовы.',
    '1.5L engine, air conditioning. Good condition. Documents ready.',
  ],
  "Samsung 7 kg, avtomatik. 2 yil ishlatilgan. Yaxshi ishlaydi.": [
    "Samsung 7 kg, avtomatik. 2 yil ishlatilgan. Yaxshi ishlaydi.",
    'Samsung 7 кг, автомат. Использовалась 2 года. Работает хорошо.',
    'Samsung 7 kg, automatic. Used for 2 years. Works well.',
  ],
  "3 xona, suv va gaz ulangan. Hovli ko'kalamzorlashtrilgan.": [
    "3 xona, suv va gaz ulangan. Hovli ko'kalamzorlashtrilgan.",
    '3 комнаты, подключены вода и газ. Двор озеленён.',
    '3 rooms, water and gas connected. Landscaped yard.',
  ],
  "LG Smart TV 4K. Kafolat muddat bor. Original quti bilan.": [
    "LG Smart TV 4K. Kafolat muddat bor. Original quti bilan.",
    'LG Smart TV 4K. Есть гарантия. С оригинальной коробкой.',
    'LG Smart TV 4K. Warranty valid. With original box.',
  ],

  // ── Weather screen ──────────────────────────────────────
  'wx_sunny': ['Quyoshli', 'Солнечно', 'Sunny'],
  'wx_mostly_sunny': ['Asosan quyoshli', 'Преимущественно солнечно', 'Mostly sunny'],
  'wx_cloudy': ['Bulutli', 'Облачно', 'Cloudy'],
  'wx_fog': ['Tumanli', 'Туман', 'Foggy'],
  'wx_rain': ["Yomg'ir", 'Дождь', 'Rain'],
  'wx_snow': ['Qor', 'Снег', 'Snow'],
  'wx_thunder': ['Momaqaldiroq', 'Гроза', 'Thunderstorm'],
  'wx_today': ['Bugun', 'Сегодня', 'Today'],
  'wx_tomorrow': ['Ertaga', 'Завтра', 'Tomorrow'],
  'wx_now': ['Hozir', 'Сейчас', 'Now'],
  'wd_1': ['Du', 'Пн', 'Mon'],
  'wd_2': ['Se', 'Вт', 'Tue'],
  'wd_3': ['Ch', 'Ср', 'Wed'],
  'wd_4': ['Pa', 'Чт', 'Thu'],
  'wd_5': ['Ju', 'Пт', 'Fri'],
  'wd_6': ['Sh', 'Сб', 'Sat'],
  'wd_7': ['Ya', 'Вс', 'Sun'],
  'wx_hourly': ['Soatlik prognoz', 'Почасовой прогноз', 'Hourly forecast'],
  'wx_7day': ['7 kunlik prognoz', 'Прогноз на 7 дней', '7-day forecast'],
  'wx_city': ["G'ozg'on shahri", 'город Газган', 'Gazgan city'],
  'wx_min': ['Min', 'Мин', 'Min'],
  'wx_error': ["Ma'lumot yuklanmadi", 'Не удалось загрузить данные', 'Failed to load data'],

  'continue': ['Davom etish', 'Продолжить', 'Continue'],
  'ob_skip': ["O'tkazib yuborish", 'Пропустить', 'Skip'],
  'ob_start': ['Boshlash', 'Начать', 'Start'],

  // ── Auth: profile setup ─────────────────────────────────
  'ps_title': ['Profilingiz', 'Ваш профиль', 'Your profile'],
  'ps_sub': ["Ma'lumotlaringizni kiriting", 'Введите свои данные', 'Enter your details'],

  // ── Auth: terms ─────────────────────────────────────────
  'tm_heading': [
    'Foydalanish shartlari va maxfiylik siyosati',
    'Условия использования и политика конфиденциальности',
    'Terms of use and privacy policy',
  ],
  'tm_accept': [
    "Foydalanish shartlari va maxfiylik siyosatini o'qidim va qabul qilaman",
    'Я прочитал и принимаю условия использования и политику конфиденциальности',
    'I have read and accept the terms of use and privacy policy',
  ],
  'tm_s1_t': ['1. Umumiy qoidalar', '1. Общие положения', '1. General provisions'],
  'tm_s1_b': [
    "G'ozg'on Life ilovasi foydalanuvchilarga shahar xizmatlari, yangiliklar, ma'lumotlar va boshqa xizmatlardan foydalanish imkonini beradi. Ilovadan foydalanish ushbu shartlarga rozilikni bildiradi.",
    'Приложение Газган Life предоставляет доступ к городским услугам, новостям, информации и другим сервисам. Использование приложения означает согласие с этими условиями.',
    'The Gazgan Life app gives users access to city services, news, information and other services. Using the app means agreeing to these terms.',
  ],
  'tm_s2_t': ["2. Shaxsiy ma'lumotlar", '2. Личные данные', '2. Personal data'],
  'tm_s2_b': [
    "Siz tomonidan kiritilgan ma'lumotlar (ism, familiya, telefon raqam, tug'ilgan sana) faqat xizmat ko'rsatish maqsadida ishlatiladi va uchinchi shaxslarga berilmaydi. Ma'lumotlaringiz himoyalangan serverda saqlanadi.",
    'Введённые вами данные (имя, фамилия, телефон, дата рождения) используются только для оказания услуг и не передаются третьим лицам. Данные хранятся на защищённом сервере.',
    'The data you enter (name, surname, phone, date of birth) is used only to provide services and is not shared with third parties. It is stored on a secure server.',
  ],
  'tm_s3_t': ['3. Maxfiylik siyosati', '3. Политика конфиденциальности', '3. Privacy policy'],
  'tm_s3_b': [
    "Ma'lumotlaringiz xavfsizligi ta'minlanadi. Har qanday axborot almashinuvi shifrlangan kanallar orqali amalga oshiriladi. Biz siz haqingizda to'plangan ma'lumotlarni marketing maqsadlarida foydalanmaymiz.",
    'Безопасность ваших данных гарантируется. Обмен информацией осуществляется по зашифрованным каналам. Мы не используем собранные данные в маркетинговых целях.',
    'The security of your data is ensured. Information exchange is carried out over encrypted channels. We do not use your data for marketing purposes.',
  ],
  'tm_s4_t': ['4. Foydalanuvchi majburiyatlari', '4. Обязанности пользователя', '4. User obligations'],
  'tm_s4_b': [
    "Siz ilovadan qonunga xilof maqsadlarda foydalanmaslik, boshqa foydalanuvchilar huquqlarini hurmat qilish va noto'g'ri ma'lumot kiritmaslik majburiyatini olasiz.",
    'Вы обязуетесь не использовать приложение в незаконных целях, уважать права других пользователей и не вводить недостоверную информацию.',
    'You undertake not to use the app for unlawful purposes, to respect other users\' rights, and not to enter false information.',
  ],
  'tm_s5_t': ['5. Cookie va tahlil', '5. Cookie и аналитика', '5. Cookies and analytics'],
  'tm_s5_b': [
    "Ilovani yaxshilash maqsadida foydalanish statistikasi to'planadi. Bu ma'lumotlar shaxsiylashtirilmagan holda qayta ishlanadi.",
    'Для улучшения приложения собирается статистика использования. Эти данные обрабатываются в обезличенном виде.',
    'Usage statistics are collected to improve the app. This data is processed in an anonymized form.',
  ],
  'tm_s6_t': ["6. Shartlar o'zgarishi", '6. Изменение условий', '6. Changes to terms'],
  'tm_s6_b': [
    "G'ozg'on Life xizmat shartlarini istalgan vaqtda o'zgartirish huquqini saqlab qoladi. O'zgarishlar haqida ilova orqali xabar beriladi.",
    'Газган Life оставляет за собой право изменять условия в любое время. Об изменениях сообщается через приложение.',
    'Gazgan Life reserves the right to change the terms at any time. Changes will be announced through the app.',
  ],

  // ── Auth: phone ─────────────────────────────────────────
  'au_phone_sub': [
    "SMS tasdiqlash kodi yuborish uchun\nraqamingizni kiriting",
    'Введите номер, чтобы получить\nкод подтверждения по SMS',
    'Enter your number to receive\nan SMS confirmation code',
  ],
  'au_send_sms': ['SMS yuborish', 'Отправить SMS', 'Send SMS'],
  // ── Auth: OTP ───────────────────────────────────────────
  'au_verify': ['Tasdiqlash', 'Подтверждение', 'Verification'],
  'au_enter_code': ['SMS kodni kiriting', 'Введите код из SMS', 'Enter the SMS code'],
  'au_code_sent': ['Kod yuborildi: ', 'Код отправлен: ', 'Code sent: '],
  'au_resend_in': ['Qayta yuborish: {n} s', 'Повторная отправка: {n} с', 'Resend in: {n} s'],
  'au_resend': ['Kodni qayta yuborish', 'Отправить код повторно', 'Resend code'],
  // ── Auth: success ───────────────────────────────────────
  'au_success': ['Muvaffaqiyatli!', 'Успешно!', 'Success!'],
  'au_success_sub': [
    "Profilingiz muvaffaqiyatli yaratildi.\nBosh sahifaga yo'naltirilmoqda...",
    'Ваш профиль успешно создан.\nПереходим на главную...',
    'Your profile has been created.\nRedirecting to home...',
  ],

  // ── Profile screen ──────────────────────────────────────
  'pr_user': ['Foydalanuvchi', 'Пользователь', 'User'],
  'pr_logout_confirm': ['Chiqishni tasdiqlaysizmi?', 'Подтвердите выход?', 'Confirm logout?'],
  'pr_help': ["Yordam va qo'llab-quvvatlash", 'Помощь и поддержка', 'Help & support'],
  'pr_about_v': ['Ilova haqida v1.0.0', 'О приложении v1.0.0', 'About v1.0.0'],
  'pr_my_ads': ["E'lonlarim", 'Мои объявления', 'My ads'],
  'pr_saved': ['Saqlangan', 'Сохранённые', 'Saved'],
  'pr_my_appeals': ['Murojaatlarim', 'Мои обращения', 'My appeals'],

  // ── Personal info screen ────────────────────────────────
  'pi_title': ["Shaxsiy ma'lumotlar", 'Личные данные', 'Personal info'],
  'pi_first': ['Ism', 'Имя', 'First name'],
  'pi_last': ['Familiya', 'Фамилия', 'Last name'],
  'pi_phone': ['Telefon raqam', 'Номер телефона', 'Phone number'],
  'pi_birth': ["Tug'ilgan sana", 'Дата рождения', 'Date of birth'],
  'pi_pick_date': ['Sanani tanlang', 'Выберите дату', 'Choose date'],
  'pi_saved': ["Ma'lumotlar saqlandi", 'Данные сохранены', 'Information saved'],

  // ── Mahalla screen ──────────────────────────────────────
  'mh_list': ["MFY ro'yxati", 'Список МФЙ', 'List of MFYs'],
  'Marmarobod MFY': ['Marmarobod MFY', 'МФЙ Мармаробод', 'Marmarobod MFY'],
  'Guliston MFY': ['Guliston MFY', 'МФЙ Гулистон', 'Guliston MFY'],
  "Marmarobod ko'chasi 12": ["Marmarobod ko'chasi 12", 'ул. Мармаробод 12', 'Marmarobod St. 12'],
  "Mustaqillik ko'chasi 34": ["Mustaqillik ko'chasi 34", 'ул. Мустакиллик 34', 'Mustaqillik St. 34'],
  "Amir Temur ko'chasi 7": ["Amir Temur ko'chasi 7", 'ул. Амира Темура 7', 'Amir Temur St. 7'],
  "Bog'ishamol ko'chasi 18": ["Bog'ishamol ko'chasi 18", 'ул. Богишамол 18', 'Bogishamol St. 18'],
  'mh_women': ['{n} xotin-qiz', '{n} женщин', '{n} women'],

  // ── Zukkobek (AI chat) ──────────────────────────────────
  'zk_typing': ['Yozmoqda...', 'Печатает...', 'Typing...'],
  'zk_online': ['Online', 'Онлайн', 'Online'],
  'zk_clear': ['Suhbatni tozalash', 'Очистить чат', 'Clear chat'],
  'zk_hint': ['Zukkobek bilan gaplashing...', 'Напишите Зуккобеку...', 'Chat with Zukkobek...'],
  'zk_error': ["Xatolik yuz berdi. Qayta urinib ko'ring.", 'Произошла ошибка. Попробуйте снова.', 'An error occurred. Please try again.'],
  'zk_greeting': [
    "Assalomu alaykum! Men Zukkobek — G'ozg'on shahrining aqlli yordamchisiman 🤖\n\nSizga qanday yordam bera olaman?",
    'Здравствуйте! Я Зуккобек — умный помощник города Газган 🤖\n\nЧем могу помочь?',
    "Hello! I'm Zukkobek — the smart assistant of Gazgan city 🤖\n\nHow can I help you?",
  ],
  'zk_system': [
    "Sen G'ozg'on shahri bo'yicha aqlli yordamchisan. Foydalanuvchilarga shahar xizmatlari, yangiliklar, transport va boshqa savollar bo'yicha O'zbek tilida qisqa va aniq javob ber.",
    'Ты умный помощник по городу Газган. Отвечай пользователям кратко и точно на русском языке по вопросам городских услуг, новостей, транспорта и других тем.',
    'You are a smart assistant for Gazgan city. Answer users briefly and clearly in English about city services, news, transport and other questions.',
  ],

  // ── Map / Messages ──────────────────────────────────────
  'map_soon': ['Xarita tez orada', 'Карта скоро', 'Map coming soon'],
  'msg_title': ['Xabarlar', 'Сообщения', 'Messages'],
  'msg_empty': ["Xabarlar yo'q", 'Нет сообщений', 'No messages'],

  // ── Tourism screen ──────────────────────────────────────
  'tr_attractions': ['Diqqatga sazovor joylar', 'Достопримечательности', 'Attractions'],
  'tr_places_count': ['{n} joy', '{n} мест', '{n} places'],
  'tr_hero_title': ["G'ozg'on Turizmi", 'Туризм Газгана', 'Gazgan Tourism'],
  'tr_hero_sub': ['Tabiat va tarix — bir joyda kashf eting', 'Природа и история — в одном месте', 'Nature and history — in one place'],
  'tr_directions': ["Yo'l ko'rsatish", 'Маршрут', 'Directions'],
  'Tabiat': ['Tabiat', 'Природа', 'Nature'],
  "Tog'": ["Tog'", 'Горы', 'Mountains'],
  'Tarix': ['Tarix', 'История', 'History'],
  'Madaniyat': ['Madaniyat', 'Культура', 'Culture'],
  "Shodmon Ko'li": ["Shodmon Ko'li", 'Озеро Шодмон', 'Shodmon Lake'],
  'Qashqadaryo Vodiysi': ['Qashqadaryo Vodiysi', 'Кашкадарьинская долина', 'Qashqadaryo Valley'],
  "Kumushkent Qal'asi": ["Kumushkent Qal'asi", 'Крепость Кумушкент', 'Kumushkent Fortress'],
  "Bodom Bog'i": ["Bodom Bog'i", 'Миндальный сад', 'Almond Garden'],
  'Tarixiy Masjid': ['Tarixiy Masjid', 'Историческая мечеть', 'Historic Mosque'],
  "Amir Temur Ko'chasi": ["Amir Temur Ko'chasi", 'улица Амира Темура', 'Amir Temur Street'],
  '8 km shimol': ['8 km shimol', '8 км к северу', '8 km north'],
  '15 km sharq': ['15 km sharq', '15 км к востоку', '15 km east'],
  "3 km g'arb": ["3 km g'arb", '3 км к западу', '3 km west'],
  '5 km janub': ['5 km janub', '5 км к югу', '5 km south'],
  'Shahar markazi': ['Shahar markazi', 'Центр города', 'City center'],
  "Tog' etaklarida joylashgan sokin ko'l. Piknik va dam olish uchun ideal joy. Toza havo va ajoyib manzara.": [
    "Tog' etaklarida joylashgan sokin ko'l. Piknik va dam olish uchun ideal joy. Toza havo va ajoyib manzara.",
    'Тихое озеро у подножия гор. Идеальное место для пикника и отдыха. Чистый воздух и прекрасные виды.',
    'A calm lake at the foot of the mountains. Ideal for picnics and rest. Fresh air and great views.',
  ],
  "Baland tog' dovonlari va yashil vodiylar. Piyoda sayohat va trekkingga mukammal marshrut.": [
    "Baland tog' dovonlari va yashil vodiylar. Piyoda sayohat va trekkingga mukammal marshrut.",
    'Высокие горные перевалы и зелёные долины. Идеальный маршрут для походов и треккинга.',
    'High mountain passes and green valleys. A perfect route for hiking and trekking.',
  ],
  "XIV asrga oid tarixiy qal'a xarobalari. O'rta asr arxitekturasi va boy tarix bilan tanishing.": [
    "XIV asrga oid tarixiy qal'a xarobalari. O'rta asr arxitekturasi va boy tarix bilan tanishing.",
    'Руины исторической крепости XIV века. Познакомьтесь со средневековой архитектурой и историей.',
    'Ruins of a 14th-century fortress. Explore medieval architecture and rich history.',
  ],
  "Bahorda gullab-yashnagan bodom bog'lari. Mart-aprel oylarida ajoyib manzara hosil bo'ladi.": [
    "Bahorda gullab-yashnagan bodom bog'lari. Mart-aprel oylarida ajoyib manzara hosil bo'ladi.",
    'Миндальные сады, цветущие весной. В марте-апреле открывается прекрасный вид.',
    'Almond gardens blooming in spring. A wonderful view appears in March-April.',
  ],
  "Shahrimizning eng qadimiy binosi. Noyob naqsh va muqarnas bezaklar bilan bezatilgan.": [
    "Shahrimizning eng qadimiy binosi. Noyob naqsh va muqarnas bezaklar bilan bezatilgan.",
    'Древнейшее здание нашего города. Украшено уникальными узорами и мукарнасами.',
    'The oldest building in our city. Decorated with unique ornaments and muqarnas.',
  ],
  "Shaharning asosiy ko'chasi. Restoran, do'kon va madaniy markazlar bilan to'la.": [
    "Shaharning asosiy ko'chasi. Restoran, do'kon va madaniy markazlar bilan to'la.",
    'Главная улица города. Полна ресторанов, магазинов и культурных центров.',
    "The city's main street. Full of restaurants, shops and cultural centers.",
  ],

  // ── Transport screen ────────────────────────────────────
  'Taksi': ['Taksi', 'Такси', 'Taxi'],
  'Avtobus': ['Avtobus', 'Автобус', 'Bus'],
  'Poyezdlar': ['Poyezdlar', 'Поезда', 'Trains'],
  'tp_available': ['Xizmat mavjud', 'Услуга доступна', 'Service available'],
  'Taksi chaqirish': ['Taksi chaqirish', 'Вызвать такси', 'Call a taxi'],
  "Jadvalini ko'rish": ["Jadvalini ko'rish", 'Смотреть расписание', 'View schedule'],
  'Chipta sotib olish': ['Chipta sotib olish', 'Купить билет', 'Buy ticket'],
  "Shahar ichida va tashqarisida qulay taksi xizmati. Bir necha daqiqada yo'lingizga yo'ldosh.": [
    "Shahar ichida va tashqarisida qulay taksi xizmati. Bir necha daqiqada yo'lingizga yo'ldosh.",
    'Удобное такси по городу и за его пределами. В пути за несколько минут.',
    'Convenient taxi service in and out of the city. On your way in a few minutes.',
  ],
  "Shahar marshrutlari va jadval. Barcha yo'nalishlar va to'xtash nuqtalari.": [
    "Shahar marshrutlari va jadval. Barcha yo'nalishlar va to'xtash nuqtalari.",
    'Городские маршруты и расписание. Все направления и остановки.',
    'City routes and schedule. All routes and stops.',
  ],
  "Viloyatlararo va xalqaro poyezd chiptalari. Qulay narx va jadval.": [
    "Viloyatlararo va xalqaro poyezd chiptalari. Qulay narx va jadval.",
    'Межобластные и международные ж/д билеты. Удобные цены и расписание.',
    'Interregional and international train tickets. Good prices and schedule.',
  ],

  // ── Appeals screen ──────────────────────────────────────
  'Qabulda': ['Qabulda', 'Принято', 'Received'],
  'Jarayonda': ['Jarayonda', 'В процессе', 'In progress'],
  'Yakunlangan': ['Yakunlangan', 'Завершено', 'Completed'],
  "Yo'l va transport": ["Yo'l va transport", 'Дороги и транспорт', 'Roads & transport'],
  'Kommunal xizmatlar': ['Kommunal xizmatlar', 'Коммунальные услуги', 'Utilities'],
  'Tibbiyot': ['Tibbiyot', 'Медицина', 'Healthcare'],
  'Soliq': ['Soliq', 'Налоги', 'Taxes'],
  "Ko'kalamzorlashtirish": ["Ko'kalamzorlashtirish", 'Озеленение', 'Landscaping'],
  'Boshqa masalalar': ['Boshqa masalalar', 'Другие вопросы', 'Other issues'],
  'ap_new': ['Yangi murojaat', 'Новое обращение', 'New appeal'],
  'ap_mine': ['Mening murojaatlarim', 'Мои обращения', 'My appeals'],
  'ap_categories': ['Murojaat kategoriyalari', 'Категории обращений', 'Appeal categories'],
  'ap_subject': ['Murojaat mavzusi', 'Тема обращения', 'Appeal subject'],
  'ap_detail': ['Muammoni batafsil yozing...', 'Опишите проблему подробно...', 'Describe the problem in detail...'],
  "Ko'chada chuqurlar ta'mirlanmagan": ["Ko'chada chuqurlar ta'mirlanmagan", 'Ямы на дороге не отремонтированы', 'Potholes on the road not repaired'],
  "Suv ta'minoti uzilgan, 3 kundan beri suv yo'q": ["Suv ta'minoti uzilgan, 3 kundan beri suv yo'q", 'Отключено водоснабжение, воды нет 3 дня', 'Water cut off, no water for 3 days'],
  'Mahalliy klinikada navbat muammosi': ['Mahalliy klinikada navbat muammosi', 'Проблема с очередью в местной клинике', 'Queue problem at the local clinic'],
  "Soliq to'lovida texnik xatolik": ["Soliq to'lovida texnik xatolik", 'Техническая ошибка при оплате налога', 'Technical error in tax payment'],
  "Ruxsatsiz qurilish ob'ekti": ["Ruxsatsiz qurilish ob'ekti", 'Незаконный строительный объект', 'Unauthorized construction site'],
  "Bog'da daraxtlar kesilgan": ["Bog'da daraxtlar kesilgan", 'В парке вырубили деревья', 'Trees cut down in the park'],
  "Mahalla yig'iniga chaqiruv bo'yicha savol": ["Mahalla yig'iniga chaqiruv bo'yicha savol", 'Вопрос по приглашению на собрание махалли', 'Question about the mahalla meeting'],

  // ── Prayer screen ───────────────────────────────────────
  'prayer_title': ['Namoz Vaqti', 'Время намаза', 'Prayer Times'],
  'Bomdod': ['Bomdod', 'Бомдод', 'Fajr'],
  'Quyosh': ['Quyosh', 'Восход', 'Sunrise'],
  'Peshin': ['Peshin', 'Пешин', 'Dhuhr'],
  'Asr': ['Asr', 'Аср', 'Asr'],
  'Shom': ['Shom', 'Шом', 'Maghrib'],
  'Xufton': ['Xufton', 'Хуфтон', 'Isha'],

  // ── Bank screen ─────────────────────────────────────────
  'soum': ["so'm", 'сум', 'soum'],
  'bank_list': ["Banklar ro'yxati", 'Список банков', 'List of banks'],
  "O'zmilliybank": ["O'zmilliybank", 'Узмиллийбанк', 'Uzmilliybank'],
  'Xalq Banki': ['Xalq Banki', 'Халк Банк', 'Xalq Bank'],
  'Sanoat Qurilish Bank': ['Sanoat Qurilish Bank', 'Саноат Курилиш Банк', 'Sanoat Qurilish Bank'],
  'Agrobank': ['Agrobank', 'Агробанк', 'Agrobank'],
  'Kredit': ['Kredit', 'Кредит', 'Loan'],
  'Depozit': ['Depozit', 'Депозит', 'Deposit'],
  'Karta': ['Karta', 'Карта', 'Card'],
  'Ipoteka': ['Ipoteka', 'Ипотека', 'Mortgage'],
  "Pul o'tkazma": ["Pul o'tkazma", 'Переводы', 'Transfers'],
  'Qurilish': ['Qurilish', 'Строительство', 'Construction'],
  "Qishloq xo'jaligi": ["Qishloq xo'jaligi", 'Сельское хозяйство', 'Agriculture'],

  // ── Contact screen ──────────────────────────────────────
  'emergency_numbers': ['Favqulodda raqamlar', 'Экстренные номера', 'Emergency numbers'],
  'social_networks': ['Ijtimoiy tarmoqlar', 'Социальные сети', 'Social networks'],
  'contact_sub': [
    "G'ozg'on shahri xizmatlari va favqulodda raqamlar",
    'Услуги города Газган и экстренные номера',
    'Gazgan city services and emergency numbers',
  ],
  'Tez yordam': ['Tez yordam', 'Скорая помощь', 'Ambulance'],
  "Yong'in xizmati": ["Yong'in xizmati", 'Пожарная служба', 'Fire service'],
  'Militsiya': ['Militsiya', 'Милиция', 'Police'],
  'Gaz xizmati': ['Gaz xizmati', 'Газовая служба', 'Gas service'],
  'Elektr xizmati': ['Elektr xizmati', 'Электросеть', 'Electricity service'],
  "Suv ta'minoti": ["Suv ta'minoti", 'Водоснабжение', 'Water supply'],
  'Ijtimoiy yordam': ['Ijtimoiy yordam', 'Социальная помощь', 'Social aid'],
  'Bank xizmati': ['Bank xizmati', 'Банковская служба', 'Bank service'],
  "Yo'l yordam": ["Yo'l yordam", 'Дорожная помощь', 'Road assistance'],

  // ── Settings screen ─────────────────────────────────────
  'set_notifications': ['Bildirishnomalar', 'Уведомления', 'Notifications'],
  'set_push': ['Push bildirishnomalar', 'Push-уведомления', 'Push notifications'],
  'set_push_sub': ['Yangiliklar va xizmatlar haqida xabar', 'Уведомления о новостях и услугах', 'News and service updates'],
  'set_appearance': ["Ko'rinish", 'Внешний вид', 'Appearance'],
  'set_dark_on': ['Yoqilgan', 'Включён', 'On'],
  'set_dark_off': ["O'chirilgan", 'Выключен', 'Off'],
  'set_ui_lang': ['Interfeys tili', 'Язык интерфейса', 'Interface language'],
  'set_about': ['Ilova haqida', 'О приложении', 'About'],
  'set_version': ['Versiya', 'Версия', 'Version'],
  'set_developer': ['Dasturchi', 'Разработчик', 'Developer'],
  'set_dev_name': ["G'ozg'on IT", 'Газган IT', 'Gazgan IT'],
  'set_legal': ['Huquqiy', 'Правовое', 'Legal'],
  'set_privacy': ['Maxfiylik siyosati', 'Политика конфиденциальности', 'Privacy policy'],
  'set_terms': ['Foydalanish shartlari', 'Условия использования', 'Terms of use'],
  'set_privacy_body': [
    "G'ozg'on Life ilovasi foydalanuvchi ma'lumotlarini himoya qilishga sodiqdir.\n\n"
        "To'plangan ma'lumotlar: ism, familiya, telefon raqam, tug'ilgan sana.\n\n"
        "Ma'lumotlaringiz uchinchi shaxslarga berilmaydi va faqat xizmat ko'rsatish maqsadida ishlatiladi.\n\n"
        "Barcha axborot almashinuvi shifrlangan kanallar orqali amalga oshiriladi.\n\n"
        "Savollar uchun: support@gozgon.uz",
    'Приложение Газган Life привержено защите данных пользователей.\n\n'
        'Собираемые данные: имя, фамилия, номер телефона, дата рождения.\n\n'
        'Ваши данные не передаются третьим лицам и используются только для оказания услуг.\n\n'
        'Весь обмен информацией осуществляется по зашифрованным каналам.\n\n'
        'Вопросы: support@gozgon.uz',
    'Gazgan Life is committed to protecting user data.\n\n'
        'Data collected: first name, last name, phone number, date of birth.\n\n'
        'Your data is not shared with third parties and is used only to provide services.\n\n'
        'All information exchange is carried out over encrypted channels.\n\n'
        'Questions: support@gozgon.uz',
  ],
  'set_terms_body': [
    "G'ozg'on Life ilovasidan foydalanish ushbu shartlarga rozilikni bildiradi.\n\n"
        "1. Ilovadan faqat qonuniy maqsadlarda foydalaning.\n\n"
        "2. Boshqa foydalanuvchilar huquqlarini hurmat qiling.\n\n"
        "3. Noto'g'ri yoki yolg'on ma'lumot kiritmang.\n\n"
        "4. Ilova xavfsizligiga zarar yetkazuvchi harakatlardan saqlaning.\n\n"
        "5. Shartlar o'zgarishi haqida ilova orqali xabar beriladi.",
    'Использование приложения Газган Life означает согласие с настоящими условиями.\n\n'
        '1. Используйте приложение только в законных целях.\n\n'
        '2. Уважайте права других пользователей.\n\n'
        '3. Не вводите неверную или ложную информацию.\n\n'
        '4. Воздерживайтесь от действий, наносящих вред безопасности приложения.\n\n'
        '5. Об изменении условий будет сообщено через приложение.',
    'Using the Gazgan Life app means you agree to these terms.\n\n'
        '1. Use the app only for lawful purposes.\n\n'
        '2. Respect the rights of other users.\n\n'
        '3. Do not enter incorrect or false information.\n\n'
        '4. Refrain from actions that harm the security of the app.\n\n'
        '5. You will be notified of any changes to the terms via the app.',
  ],
};
