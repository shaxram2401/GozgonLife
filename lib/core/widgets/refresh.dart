/// Pastga tortib yangilash (pull-to-refresh) uchun umumiy javob.
///
/// Ma'lumot hozircha lokal — yangilanadigan narsa yo'q, lekin ishora
/// foydalanuvchi O'ZI so'ragan harakat: qisqa javob qaytarish
/// ("tekshirdim, yangilik yo'q") to'g'ri xulq. Indikator animatsiyasi
/// to'liq ko'rinishi uchun eng kam kechikish.
///
/// Backend ulanganda bu funksiya o'rniga haqiqiy so'rov qo'yiladi.
Future<void> refreshGesture() =>
    Future<void>.delayed(const Duration(milliseconds: 300));
