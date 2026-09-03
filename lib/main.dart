import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/l10n/locale_provider.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/widgets/offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('dark_mode') ?? false;
  final lang = prefs.getString('locale') ?? 'uz';
  runApp(ProviderScope(
    overrides: [
      themeProvider.overrideWith((ref) => isDark),
      localeProvider.overrideWith((ref) => LocaleNotifier()..init(lang)),
    ],
    child: const GozgonApp(),
  ));
}

class GozgonApp extends ConsumerWidget {
  const GozgonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      title: "G'ozg'on Life",
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      // Tema almashganda silliq o'tish (sakrashsiz).
      themeAnimationDuration: const Duration(milliseconds: 400),
      themeAnimationCurve: Curves.easeInOut,
      locale: locale,
      supportedLocales: const [Locale('uz'), Locale('ru')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      scrollBehavior: const _DragScrollBehavior(),
      // Transparent scaffoldlar orqasiga tayanch fon chizadi — aks holda
      // nav shell'dan tashqaridagi ekranlar (onboarding, auth, otp, success)
      // telefonda qop-qora ko'rinardi.
      builder: (context, child) => DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppTheme.bgGradient(
              Theme.of(context).brightness == Brightness.dark),
        ),
        // Internet uzilganda barcha ekranlar ustida ogohlantirish.
        child: OfflineBanner(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}

/// Sichqoncha bilan ham gorizontal/vertikal surishni yoqadi (web/desktop).
class _DragScrollBehavior extends MaterialScrollBehavior {
  const _DragScrollBehavior();
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
