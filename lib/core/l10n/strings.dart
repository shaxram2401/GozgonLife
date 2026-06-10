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
  'app_tagline': ['Shahar super-ilovasi', 'Городское супер-приложение', 'City super-app'],
  'd_grp_menu': ['Menyu', 'Меню', 'Menu'],
  'd_loc': ["G'ozg'on, Navoiy", 'Гузгон, Навои', 'Gozgon, Navoiy'],
  'news_intro_hint': [
    'Davom etish uchun bosing',
    'Нажмите, чтобы продолжить',
    'Tap to continue'
  ],

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
  'news_bozor_title': [
    "G'ozg'onda zamonaviy Dehqon bozori bunyod etilmoqda",
    'В Газгане строится современный Дехканский рынок',
    'A modern Dehqon market is being built in Gazgan',
  ],
  'news_bozor_body': [
    "Ayni paytda G'ozg'on shahar \"Tumar\" mahallasida barpo etilayotgan yangi Dehqon bozori qurilishi jarayoni jadal suratlarda davom etmoqda. Savdo do'konlarining tashqi qismiga mahalliy xomashyo hisoblangan tabiiy marmardan foydalanilmoqda.\n\nQurilish ishlari shahar hokimi Nurali Jo'rayev tomonidan doimiy nazoratga olingan bo'lib, obyektni zamonaviy va qulay ko'rinishda barpo etish bo'yicha tegishli mutasaddilarga zarur topshiriqlar berilmoqda.\n\nMa'lumot o'rnida, yangi Dehqon bozori hududida jami 34 ta savdo do'koni qurib bitkazilishi rejalashtirilgan. Mazkur bozor foydalanishga topshirilgach, aholiga sifatli xizmat ko'rsatish hamda tadbirkorlar uchun qulay savdo sharoitlari yaratishga xizmat qiladi.",
    "В настоящее время строительство нового Дехканского рынка в махалле \"Тумар\" города Газган ведётся ускоренными темпами. Для внешней отделки торговых павильонов используется местный природный мрамор.\n\nСтроительные работы находятся под постоянным контролем хокима города Нурали Жураева, которым даны соответствующие поручения по возведению объекта в современном и удобном виде.\n\nДля справки: на территории нового Дехканского рынка планируется построить в общей сложности 34 торговых павильона. После сдачи рынка в эксплуатацию он будет служить обеспечению качественного обслуживания населения и созданию удобных торговых условий для предпринимателей.",
    "Currently, the construction of the new Dehqon market in the Tumar neighborhood of Gazgan city is progressing at a rapid pace. Local natural marble is being used for the exterior of the shops.\n\nConstruction is under the constant supervision of city mayor Nurali Jurayev, who has given relevant instructions to build the facility in a modern and convenient manner.\n\nFor reference, a total of 34 shops are planned to be built on the territory of the new Dehqon market. Once the market is commissioned, it will serve to provide quality service to the public and create convenient trading conditions for entrepreneurs.",
  ],
  'news_h_title': [
    "Qutlug' ayyom oldidan obodonlashtirish ishlari olib borildi",
    'Накануне праздника проведены работы по благоустройству',
    'Landscaping works carried out on the eve of the holiday',
  ],
  'news_h_body': [
    "🌙 Yaqinlashib kelayotgan muborak Qurbon hayiti munosabati bilan G'ozg'on shahridagi umumxalq qabristonlarida keng ko'lamli ommaviy hashar tashkil etildi.\n\n➡️ Hashar davomida qabriston hududlari begona o'tlardan tozalanib, daraxtlar oqlanib, yo'laklar tartibga keltirildi hamda obodonlashtirish ishlari amalga oshirildi. Tadbirda shahar tashkilotlari xodimlari, mahalla faollari, yoshlar va keng jamoatchilik vakillari faol ishtirok etdi.\n\n✅ Bunday ezgu amallar xalqimizning mehr-oqibat, birdamlik va ajdodlar xotirasiga hurmat kabi qadriyatlarini yanada mustahkamlashga xizmat qilmoqda.",
    "🌙 По случаю приближающегося священного Курбан-хайита в общественных кладбищах города Газган был организован масштабный общенародный хашар.\n\n➡️ В ходе хашара территории кладбищ были очищены от сорняков, деревья побелены, дорожки приведены в порядок и проведены работы по благоустройству. В мероприятии активно участвовали сотрудники городских организаций, активисты махалли, молодёжь и представители широкой общественности.\n\n✅ Такие благородные дела служат дальнейшему укреплению таких ценностей нашего народа, как доброта, единство и уважение к памяти предков.",
    "🌙 On the occasion of the approaching blessed Eid al-Adha, a large-scale public community cleanup was organized at the public cemeteries of Gazgan city.\n\n➡️ During the cleanup, cemetery grounds were cleared of weeds, trees were whitewashed, pathways were tidied up and landscaping works were carried out. Employees of city organizations, neighborhood activists, youth and representatives of the wider public actively participated in the event.\n\n✅ Such noble deeds serve to further strengthen values of our people such as kindness, solidarity and respect for the memory of ancestors.",
  ],
  'news_ib_title': [
    "Ummatovlar oilasiga \"Ibratli oila\" ko'krak nishoni topshirildi",
    'Семье Умматовых вручён нагрудный знак «Образцовая семья»',
    'The Ummatov family was awarded the "Exemplary Family" badge',
  ],
  'news_ib_body': [
    "🔴 15-may — Xalqaro oila kuni munosabati bilan G'ozg'on shahar hokimi Nurali Jo'rayev hamda tegishli tashkilot rahbarlari \"Marmarobod\" MFY da istiqomat qiluvchi Ummatovlar xonadoniga tashrif buyurib Sharipov Ummat bobo va Shodmongul ayaga \"Ibratli oila\" ko'krak nishoni topshirildi.\n\n🎀 65 yil davomida birga ahil va totuv hayot kechirgan ushbu oila nafaqat farzandlari, balki mahalla ahli uchun ham o'zining samimiyligi, mehnatsevarligi va tarbiyadagi ibrati bilan katta hurmat qozongan.\n\n♥️ Tadbir davomida nuroniylarga ezgu tilaklar bildirilib, oilaviy qadriyatlarni asrab-avaylash borasidagi xizmatlari alohida e'tirof etildi.",
    "🔴 15 мая, по случаю Международного дня семьи, хоким города Газган Нурали Жураев и руководители соответствующих организаций посетили дом семьи Умматовых, проживающей в МФЙ «Мармаробод», и вручили дедушке Шарипову Уммату и бабушке Шодмонгул нагрудный знак «Образцовая семья».\n\n🎀 Эта семья, прожившая 65 лет в дружбе и согласии, заслужила большое уважение не только своих детей, но и жителей махалли своей искренностью, трудолюбием и примером в воспитании.\n\n♥️ В ходе мероприятия ветеранам были высказаны добрые пожелания, а их заслуги в сохранении семейных ценностей были особо отмечены.",
    "🔴 On May 15, on the occasion of International Family Day, Gazgan city mayor Nurali Jurayev and heads of relevant organizations visited the Ummatov family home in Marmarobod MFY and presented the \"Exemplary Family\" badge to grandfather Sharipov Ummat and grandmother Shodmongul.\n\n🎀 This family, who have lived together in harmony and unity for 65 years, have earned great respect not only from their children but also from the neighborhood community for their sincerity, hard work and exemplary upbringing.\n\n♥️ During the event, good wishes were expressed to the elders, and their services in preserving family values were specially recognized.",
  ],
  'news_sy_title': [
    "G'ozg'on shahrida sayyor qabul bo'lib o'tdi",
    'В городе Газган состоялся выездной приём граждан',
    'A mobile reception was held in Gazgan city',
  ],
  'news_sy_body': [
    "🫥 Bugun G'ozg'on shahar hokimi Nurali Jo'rayev rahbarligida Shayxon mahalla fuqarolar yig'ini binosida navbatdagi sayyor qabul o'tkazildi.\n\n➡️ Sayyor qabul jarayonida mahalla aholisi tomonidan turli yo'nalishlardagi murojaatlar — ijtimoiy muammolar, ichimlik suvi ta'minoti, bandlik, ish bilan ta'minlash, uy-joy bilan bog'liq murojaatlar hamda boshqa dolzarb masalalar bo'yicha taklif va tashvishlar tinglandi.\n\n➡️ Fuqarolarning har bir murojaati atroflicha ko'rib chiqildi. Ayrim masalalar bo'yicha joyning o'zida tegishli mutasaddilarga topshiriqlar berilib, muammolarni zudlik bilan hal qilish chorasi ko'rildi. Qolgan murojaatlar esa tegishli tashkilot va idoralar tomonidan o'rganish uchun nazorat rejasiga kiritildi.",
    "🫥 Сегодня под руководством хокима города Газган Нурали Жураева в здании схода граждан махалли Шайхон состоялся очередной выездной приём.\n\n➡️ В ходе выездного приёма были выслушаны обращения жителей махалли по различным направлениям — социальные проблемы, водоснабжение питьевой водой, занятость, трудоустройство, жилищные вопросы и другие актуальные проблемы.\n\n➡️ Каждое обращение граждан было тщательно рассмотрено. По ряду вопросов на месте были даны поручения ответственным лицам и приняты меры по оперативному решению проблем. Остальные обращения были внесены в план контроля для изучения соответствующими организациями и ведомствами.",
    "🫥 Today, under the leadership of Gazgan city mayor Nurali Jurayev, the next mobile reception was held at the Shaykhon neighborhood citizens' assembly building.\n\n➡️ During the mobile reception, appeals from neighborhood residents on various issues were heard — social problems, drinking water supply, employment, job provision, housing-related appeals and other pressing matters.\n\n➡️ Each citizen's appeal was thoroughly reviewed. For some issues, instructions were given to relevant officials on the spot and measures were taken to resolve problems promptly. The remaining appeals were included in the monitoring plan for review by relevant organizations and agencies.",
  ],
  'news_bl_title': [
    "G'ozg'onda yangi \"Buloqi nav\" loyihasi qurilishi jadallik bilan davom etmoqda",
    'В Газгане продолжается активное строительство нового проекта «Булоки нав»',
    'Construction of the new "Buloqi nav" project in Gazgan is progressing rapidly',
  ],
  'news_bl_body': [
    "💠 Ayni damda G'ozg'on shahar hokimi Nurali Jo'rayev hamda tegishli mas'ullar \"Guliston\" mahallasida bunyod etilayotgan \"Buloqi nav\" loyihasining qurilish jarayoni bilan tanishishdi.\n\n➡️ O'rganish davomida qurilish ishlarining borishi, obyekt sifati hamda belgilangan muddatlarda foydalanishga topshirish masalalariga alohida e'tibor qaratildi.\n\n✅ Ta'kidlanganidek, loyiha doirasidagi qurilish ishlari jadal suratlarda olib borilmoqda. Tegishli mutasaddilarga ishlarni sifatli va belgilangan talablar asosida davom ettirish yuzasidan topshiriqlar berildi.",
    "💠 В настоящее время хоким города Газган Нурали Жураев и ответственные лица ознакомились с ходом строительства проекта «Булоки нав», возводимого в махалле «Гулистон».\n\n➡️ В ходе изучения особое внимание было уделено ходу строительных работ, качеству объекта и вопросам сдачи в эксплуатацию в установленные сроки.\n\n✅ Как было отмечено, строительные работы в рамках проекта ведутся ускоренными темпами. Ответственным лицам даны поручения по качественному продолжению работ в соответствии с установленными требованиями.",
    "💠 Currently, Gazgan city mayor Nurali Jurayev and relevant officials familiarized themselves with the construction process of the \"Buloqi nav\" project being built in the \"Guliston\" neighborhood.\n\n➡️ During the inspection, special attention was paid to the progress of construction work, the quality of the facility, and issues of commissioning within the set deadlines.\n\n✅ As noted, construction work within the project is being carried out at a rapid pace. Relevant officials were given instructions to continue work with quality and in accordance with established requirements.",
  ],
  'news_ysh_title': [
    "Yoshlar kuni munosabati bilan ishlayotgan yosh xotin-qizlar bilan ochiq muloqot o'tkazildi",
    'По случаю Дня молодёжи проведён открытый диалог с работающими девушками',
    'An open dialogue was held with working young women on the occasion of Youth Day',
  ],
  'news_ysh_body': [
    "🔴 Bugun Payshanba — Yoshlar kuni deb belgilanganligi munosabati bilan G'ozg'on shahar hokimi Nurali Jo'rayev \"Sardoba Textile\" MCHJ da mehnat faoliyati olib borayotgan yosh xotin-qizlar bilan ochiq muloqot o'tkazdi.\n\n➡️ Muloqot davomida yoshlarning mehnat sharoitlari, bandligini ta'minlash, kasb-hunar o'rganish, tadbirkorlikni qo'llab-quvvatlash hamda ularni qiynayotgan masalalar yuzasidan fikr va takliflar tinglandi.\n\n✅ Shuningdek, yosh xotin-qizlarning tashabbuslarini qo'llab-quvvatlash, ularning jamiyatdagi faolligini oshirish va munosib mehnat qilishi uchun zarur sharoitlar yaratish borasidagi ishlar izchil davom ettirilishi ta'kidlandi.",
    "🔴 Сегодня, в связи с тем, что четверг объявлен Днём молодёжи, хоким города Газган Нурали Жураев провёл открытый диалог с молодыми девушками, работающими в ООО «Sardoba Textile».\n\n➡️ В ходе диалога были выслушаны мнения и предложения по вопросам условий труда молодёжи, обеспечения занятости, освоения профессии, поддержки предпринимательства, а также проблемам, которые их волнуют.\n\n✅ Также было подчёркнуто, что работа по поддержке инициатив молодых девушек, повышению их активности в обществе и созданию необходимых условий для достойного труда будет последовательно продолжена.",
    "🔴 Today, in connection with Thursday being designated as Youth Day, Gazgan city mayor Nurali Jurayev held an open dialogue with young women working at Sardoba Textile LLC.\n\n➡️ During the dialogue, opinions and suggestions were heard on issues of youth working conditions, ensuring employment, learning a profession, supporting entrepreneurship, and problems that concern them.\n\n✅ It was also emphasized that work to support the initiatives of young women, increase their activity in society and create the necessary conditions for decent work will continue consistently.",
  ],
  'news_chp_title': [
    "Shahar hokimligi jamoasi — \"Shahar hokimi kubogi\" chempioni!",
    'Команда хокимията — чемпион Кубка хокима города!',
    'City administration team — champion of the City Mayor\'s Cup!',
  ],
  'news_chp_body': [
    "⚽ Bugun G'ozg'on shahrida o'tkazilgan \"Shahar hokimi kubogi\" futbol musobaqasining final uchrashuvi futbol muxlislariga ko'tarinki kayfiyat ulashdi.\n\n✅ Final bahsida Shahar hokimligi jamoasi hamda Tumar jamoalari maydonga tushib, chempionlik uchun murosasiz kurash olib borishdi. Uchrashuv davomida har ikki jamoa faol va hujumkor o'yin namoyish etdi. Asosiy taym yakunida hisob 1:1 ko'rinishida qayd etildi.\n\n✅ G'olib nomi penaltilar seriyasida aniqlandi. Unda Shahar hokimligi jamoasi raqibini 3:2 hisobida mag'lub etib, musobaqaning bosh sovrinini qo'lga kiritdi hamda \"Shahar hokimi kubogi\" chempioniga aylandi.\n\n✅ Musobaqa yakunida G'ozg'on shahar hokimi Nurali Jo'rayev so'zga chiqib, turnir davomida faol ishtirok etgan barcha jamoalarni tabrikladi. Shuningdek, sportni rivojlantirish va yoshlarni sog'lom turmush tarziga keng jalb etish borasidagi bunday musobaqalarning ahamiyatini alohida ta'kidladi.\n\n✅ Tadbir davomida g'olib va sovrindor jamoalarga tashakkurnoma hamda esdalik sovg'alari topshirildi.\n\n⚽ Musobaqa davomida barcha jamoalar yuqori kayfiyat va sportga bo'lgan qiziqish bilan ishtirok etishdi. Final uchrashuvi esa haqiqiy futbol bayramiga aylandi.\n\n🥇 G'olib jamoani munosib g'alaba bilan tabriklaymiz!",
    "⚽ Сегодня финальный матч футбольного турнира «Кубок хокима города», прошедшего в Газгане, подарил болельщикам праздничное настроение.\n\n✅ В финальном поединке на поле вышли команды хокимията города и «Тумар», ведя бескомпромиссную борьбу за чемпионство. В ходе встречи обе команды показали активную и атакующую игру. По итогам основного времени счёт составил 1:1.\n\n✅ Победитель был определён в серии пенальти. Команда хокимията города одолела соперника со счётом 3:2, завоевала главный приз турнира и стала чемпионом «Кубка хокима города».\n\n✅ По завершении турнира хоким города Газган Нурали Жураев выступил с речью и поздравил все команды, активно участвовавшие в турнире. Также он особо подчеркнул значение подобных соревнований для развития спорта и широкого привлечения молодёжи к здоровому образу жизни.\n\n✅ В ходе мероприятия победителям и призёрам были вручены благодарственные письма и памятные подарки.\n\n⚽ В ходе соревнований все команды участвовали с высоким настроением и интересом к спорту. Финальный матч превратился в настоящий футбольный праздник.\n\n🥇 Поздравляем команду-победителя с заслуженной победой!",
    "⚽ Today, the final match of the City Mayor's Cup football tournament held in Gazgan lifted the spirits of football fans.\n\n✅ In the final match, the City Administration team and the Tumar team took to the field, competing fiercely for the championship. Both teams displayed active and attacking play throughout the match. The score at the end of regular time was 1:1.\n\n✅ The winner was determined in a penalty shootout. The City Administration team defeated their opponents 3:2, claimed the main prize of the tournament and became the champion of the City Mayor's Cup.\n\n✅ At the end of the tournament, Gazgan city mayor Nurali Jurayev spoke and congratulated all teams that actively participated in the tournament. He also especially emphasized the importance of such competitions for developing sport and widely involving youth in a healthy lifestyle.\n\n✅ During the event, letters of appreciation and commemorative gifts were presented to the winning and prize-winning teams.\n\n⚽ Throughout the competition, all teams participated with high spirits and enthusiasm for sport. The final match turned into a true football celebration.\n\n🥇 We congratulate the winning team on their well-deserved victory!",
  ],
  'news_qrb_title': [
    "Qurbon hayiti arafasida 108 ta oilaga bayram sovg'alari topshirilmoqda",
    'Накануне Курбан-хайита 108 семьям вручаются праздничные подарки',
    '108 families receive holiday gifts on the eve of Eid al-Adha',
  ],
  'news_qrb_body': [
    "🟥 O'zbekiston Respublikasi Prezidentining \"Muborak Qurbon hayiti munosabati bilan aholini davlat tomonidan qo'llab-quvvatlash va mehr-saxovat tadbirlarini samarali tashkil etish to'g'risida\"gi qaroriga asosan, yurtimiz bo'ylab ehtiyojmand oilalar, yakka yolg'iz keksalar hamda bemor fuqarolar holidan xabar olinib, ularga amaliy yordamlar ko'rsatilmoqda.\n\n➡️ Mazkur ezgu tashabbus doirasida G'ozg'on shahrida ham xayriya va mehr-saxovat tadbirlari tashkil etildi. Jumladan, shahar hokimi Nurali Jo'rayev hamda tegishli mas'ullar tomonidan 108 ta oilaga Qurbon hayiti munosabati bilan Prezident qarori asosida \"Vaqf\" xayriya jamoat fondi tomonidan tayyorlangan oziq-ovqat mahsulotlari topshirilmoqda.\n\n✅ Tashrif davomida shahar hokimi xonadon egalari bilan samimiy suhbat qurib, ularni yaqinlashib kelayotgan muborak Qurbon hayiti bilan tabrikladi hamda ularning holidan xabar oldi.\n\n➡️ Bunday e'tibor va g'amxo'rlik yurtdoshlarimiz qalbida mehr-oqibat, birdamlik va shukronalik tuyg'ularini yanada mustahkamlamoqda.",
    "🟥 В соответствии с постановлением Президента Республики Узбекистан «Об эффективной организации государственной поддержки населения и мероприятий милосердия по случаю священного Курбан-хайита», по всей стране ведётся работа с нуждающимися семьями, одинокими пожилыми людьми и больными гражданами, им оказывается практическая помощь.\n\n➡️ В рамках этой благородной инициативы в городе Газган также были организованы благотворительные акции. В частности, хоким города Нурали Жураев и ответственные лица вручают 108 семьям продовольственные наборы, подготовленные благотворительным общественным фондом «Вакф» на основании постановления Президента по случаю Курбан-хайита.\n\n✅ В ходе визита хоким города провёл душевные беседы с хозяевами домов, поздравил их с приближающимся праздником Курбан-хайит и поинтересовался их состоянием.\n\n➡️ Такое внимание и забота ещё больше укрепляют в сердцах наших соотечественников чувства доброты, единства и благодарности.",
    "🟥 In accordance with the Decree of the President of the Republic of Uzbekistan on effectively organizing state support for the population and charity events on the occasion of the blessed Eid al-Adha, needy families, lonely elderly people and sick citizens throughout the country are being visited and given practical assistance.\n\n➡️ As part of this noble initiative, charitable and humanitarian events were also organized in Gazgan city. In particular, city mayor Nurali Jurayev and relevant officials are presenting food packages prepared by the \"Vaqf\" charitable public fund, based on the President's decree, to 108 families on the occasion of Eid al-Adha.\n\n✅ During the visit, the city mayor held sincere conversations with the heads of households, congratulated them on the approaching blessed Eid al-Adha and inquired about their well-being.\n\n➡️ Such attention and care further strengthens feelings of kindness, solidarity and gratitude in the hearts of our fellow citizens.",
  ],
  'news_bk_title': [
    "\"Yangi O'zbekistonning baxtiyor bolalari\" shiori ostida bayram tadbiri tashkil etildi",
    'Состоялся праздник под девизом «Счастливые дети Нового Узбекистана»',
    'A festive event was held under the motto "Happy children of New Uzbekistan"',
  ],
  'news_bk_body': [
    "✨ 1-iyun – Xalqaro bolalarni himoya qilish kuni munosabati bilan G'ozg'on shahar 4-son hamda 1-son Davlat maktabgacha ta'lim tashkilotlarida \"Yangi O'zbekistonning baxtiyor bolalari\" shiori ostida ko'tarinki ruhdagi bayram tadbirlari bo'lib o'tdi.\n\n🔹 Bayram dasturi bolajonlarning quvnoq kuy-qo'shiqlari, milliy va zamonaviy raqslari bilan boshlandi. Tadbir davomida tarbiyalanuvchilar tomonidan Vatan, tinchlik, do'stlik va baxtli bolalikni tarannum etuvchi she'rlar o'qildi, qiziqarli sahna ko'rinishlari namoyish etildi.\n\n🔹 Tadbirda ishtirok etgan ota-onalar hamda mehmonlar kichkintoylarning ijodiy qobiliyatlari, iste'dodi va sahna madaniyatini yuqori baholadilar. Ayniqsa, bolalarning samimiy va jo'shqin chiqishlari barchaga bayramona kayfiyat ulashdi.\n\n✅ Shuningdek, bayram davomida turli qiziqarli o'yinlar, sport musobaqalari va ko'ngilochar dasturlar tashkil etilib, faol ishtirokchilar munosib rag'batlantirildi. Tadbir bolalarning quvonchli kulgulari, beg'ubor shodiyonasi va unutilmas taassurotlarga boy tarzda o'tdi.",
    "✨ 1 июня, по случаю Международного дня защиты детей, в государственных дошкольных образовательных организациях №4 и №1 города Газган под девизом «Счастливые дети Нового Узбекистана» прошли праздничные мероприятия в приподнятой атмосфере.\n\n🔹 Праздничная программа началась с весёлых песен, национальных и современных танцев малышей. В ходе мероприятия воспитанники читали стихи о Родине, мире, дружбе и счастливом детстве, показывали интересные сценки.\n\n🔹 Родители и гости, участвовавшие в мероприятии, высоко оценили творческие способности, талант и сценическую культуру малышей. Особенно искренние и задорные выступления детей подарили всем праздничное настроение.\n\n✅ Кроме того, в ходе праздника были организованы различные интересные игры, спортивные соревнования и развлекательные программы, активные участники были достойно поощрены. Мероприятие прошло в атмосфере радостного смеха детей, беззаботного веселья и незабываемых впечатлений.",
    "✨ On June 1, in honor of International Children's Day, festive events were held under the motto \"Happy Children of New Uzbekistan\" at State Preschool Education Organizations No. 4 and No. 1 in Gazgan city, in a high-spirited atmosphere.\n\n🔹 The festive program began with cheerful songs, national and modern dances by the children. During the event, pupils recited poems about the Homeland, peace, friendship and happy childhood, and performed interesting theatrical scenes.\n\n🔹 Parents and guests who attended the event highly praised the children's creative abilities, talent and stage culture. In particular, the sincere and lively performances of the children shared a festive mood with everyone.\n\n✅ In addition, various interesting games, sports competitions and entertainment programs were organized during the celebration, and active participants were duly rewarded. The event was rich with children's joyful laughter, carefree fun and unforgettable impressions.",
  ],
  'news_sq_title': [
    "Yuksak ma'rifatli avlod — Uchinchi Renessans poydevori",
    'Высокообразованное поколение — основа Третьего Ренессанса',
    'Highly educated generation — the foundation of the Third Renaissance',
  ],
  'news_sq_body': [
    "🔔 Bugun G'ozg'on shahridagi 2-sonli umumta'lim maktabida bitiruvchilar uchun unutilmas va hayajonli \"So'nggi qo'ng'iroq\" tadbiri bo'lib o'tdi. \"Yuksak ma'rifatli avlod — Uchinchi Renessans poydevori\" shiori ostida tashkil etilgan ushbu bayram tadbiri ko'tarinki ruh va samimiy muhitda o'tdi.\n\n✅ Tadbir O'zbekiston Respublikasi Davlat madhiyasi sadolari ostida boshlandi. Unda shahar hokimi Nurali Jo'rayev so'zga chiqib, O'zbekiston Respublikasi Prezidenti tomonidan maktab bitiruvchilariga yo'llangan samimiy tabrik va ezgu tilaklarni o'qib eshittirdi.\n\n✅ Shuningdek, ta'lim tizimida fidokorona mehnat qilayotgan bir guruh ustoz va o'quvchi yoshlarga shahar hokimining faxriy yorliq hamda tashakkurnomalari topshirildi. Bu esa tadbirga yanada tantanavor ruh bag'ishladi.\n\n✅ Bayram tadbirida davlat va jamoat tashkilotlari vakillari, ota-onalar, nuroniylar hamda pedagoglar ishtirok etib, bitiruvchi yoshlarga kelgusidagi o'qish va mehnat faoliyatida omad, yuksak marralar va ulkan zafarlar tiladilar.",
    "🔔 Сегодня в школе №2 города Газган прошёл незабываемый и волнующий \"Последний звонок\" для выпускников. Праздничное мероприятие под девизом \"Высокообразованное поколение — основа Третьего Ренессанса\" прошло в приподнятой и искренней атмосфере.\n\n✅ Мероприятие началось под звуки Государственного гимна Республики Узбекистан. Хоким города Нурали Жураев зачитал искренние поздравления и добрые пожелания Президента Республики Узбекистан выпускникам.\n\n✅ Кроме того, группе учителей и учащихся, самоотверженно трудящихся в сфере образования, были вручены почётные грамоты и благодарственные письма хокима города, что придало мероприятию ещё более торжественный характер.\n\n✅ В праздничном мероприятии приняли участие представители государственных и общественных организаций, родители, ветераны и педагоги, пожелавшие выпускникам удачи, высоких достижений и громких побед в учёбе и труде.",
    "🔔 Today, an unforgettable and exciting \"Last Bell\" ceremony was held for graduates at School No. 2 in Gazgan city. The festive event, held under the motto \"Highly Educated Generation — the Foundation of the Third Renaissance,\" took place in a high-spirited and sincere atmosphere.\n\n✅ The event began to the sounds of the State Anthem of the Republic of Uzbekistan. City mayor Nurali Jurayev read out the sincere congratulations and good wishes of the President of the Republic of Uzbekistan to the graduates.\n\n✅ In addition, honorary certificates and letters of appreciation from the city mayor were presented to a group of teachers and students who work dedicatedly in the field of education, adding an even more ceremonial spirit to the event.\n\n✅ The festive event was attended by representatives of state and public organizations, parents, veterans and educators, who wished the graduates success, high achievements and great victories in their studies and work.",
  ],
  // ── News screen (uz-keyed) ──────────────────────────────
  'Barchasi': ['Barchasi', 'Все', 'All'],
  'Shahar': ['Shahar', 'Город', 'City'],
  'Sport': ['Sport', 'Спорт', 'Sport'],
  'Hokimiyat': ['Hokimiyat', 'Власть', 'Government'],
  'Tadbir': ['Tadbir', 'Мероприятие', 'Event'],
  'Mahalliy': ['Mahalliy', 'Местное', 'Local'],
  'Yangiliklar topilmadi': ['Yangiliklar topilmadi', 'Новости не найдены', 'No news found'],
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
  'mh_count': ['Mahalla', 'Махалля', 'Mahallas'],
  'mh_women_total': ['Xotin-qizlar', 'Женщины', 'Women'],
  'mh_call': ["Qo'ng'iroq", 'Звонок', 'Call'],

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
  'tp_types': ['Transport turlari', 'Виды транспорта', 'Transport types'],
  'tp_taxi_a': ['24/7 xizmat', 'Круглосуточно', '24/7 service'],
  'tp_taxi_b': ['Tez yetib kelish', 'Быстрая подача', 'Fast pickup'],
  'tp_bus_a': ['Shahar marshrutlari', 'Городские маршруты', 'City routes'],
  'tp_bus_b': ['Jadval bo‘yicha', 'По расписанию', 'On schedule'],
  'tp_train_a': ['Onlayn chipta', 'Онлайн билет', 'Online ticket'],
  'tp_train_b': ['Viloyatlararo', 'Межобластные', 'Intercity'],
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
