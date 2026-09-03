import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Namoz vaqti eslatmalari.
///
/// MUHIM: `flutter_local_notifications` VEB'ni qo'llab-quvvatlamaydi.
/// Shuning uchun veb'da barcha metodlar jimgina hech narsa qilmaydi —
/// ilova xato bermaydi, sozlama esa ko'rsatilmaydi.
class PrayerNotifications {
  PrayerNotifications._();

  static const _prefKey = 'prayer_notifications';
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _ready = false;

  /// Bu platformada umuman ishlaydimi.
  static bool get isSupported => !kIsWeb;

  static Future<bool> isEnabled() async {
    if (!isSupported) return false;
    final p = await SharedPreferences.getInstance();
    return p.getBool(_prefKey) ?? false;
  }

  static Future<void> _ensureInit() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    // G'ozg'on — Toshkent vaqt mintaqasi (UTC+5).
    tz.setLocalLocation(tz.getLocation('Asia/Tashkent'));

    await _plugin.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    ));
    _ready = true;
  }

  /// Ruxsat so'raydi. Rad etilsa `false` qaytaradi.
  static Future<bool> _requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return true;
  }

  /// Yoqadi yoki o'chiradi. Yoqilganda ruxsat so'raladi va vaqtlar
  /// rejalashtiriladi. Ruxsat berilmasa `false` qaytaradi.
  static Future<bool> setEnabled(bool on, List<(String, String)> times) async {
    if (!isSupported) return false;
    await _ensureInit();

    if (!on) {
      await _plugin.cancelAll();
      final p = await SharedPreferences.getInstance();
      await p.setBool(_prefKey, false);
      return true;
    }

    final granted = await _requestPermission();
    if (!granted) return false;

    await _plugin.cancelAll();
    for (var i = 0; i < times.length; i++) {
      final (name, hhmm) = times[i];
      final parts = hhmm.split(':');
      final h = int.tryParse(parts[0]) ?? 0;
      final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
      await _schedule(i, name, hhmm, h, m);
    }

    final p = await SharedPreferences.getInstance();
    await p.setBool(_prefKey, true);
    return true;
  }

  static Future<void> _schedule(
      int id, String name, String hhmm, int hour, int minute) async {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'prayer_times',
        'Namoz vaqtlari',
        channelDescription: 'Namoz vaqti kirganda eslatma',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    Future<void> put(AndroidScheduleMode mode) => _plugin.zonedSchedule(
          id,
          name,
          '$name vaqti kirdi — $hhmm',
          when,
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time, // har kuni
        );

    try {
      // Aniq vaqt — namoz uchun muhim.
      await put(AndroidScheduleMode.exactAllowWhileIdle);
    } catch (e) {
      // Android 12+ da "aniq signal" ruxsati bo'lmasa — taxminiy rejim.
      debugPrint('Aniq rejalashtirib bo\'lmadi ($name): $e');
      try {
        await put(AndroidScheduleMode.inexactAllowWhileIdle);
      } catch (e2) {
        debugPrint('Eslatmani rejalashtirib bo\'lmadi ($name): $e2');
      }
    }
  }
}
