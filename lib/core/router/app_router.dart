import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ads/ads_screen.dart';
import '../../features/appeals/appeals_screen.dart';
import '../../features/auth/otp_screen.dart';
import '../../features/auth/phone_screen.dart';
import '../../features/auth/profile_setup_screen.dart';
import '../../features/auth/success_screen.dart';
import '../../features/auth/terms_screen.dart';
import '../../features/bank/bank_screen.dart';
import '../../features/contact/contact_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/mahalla/mahalla_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/market/market_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/profile/personal_info_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tourism/tourism_screen.dart';
import '../../features/transport/transport_screen.dart';
import '../../features/weather/weather_screen.dart';
import '../../features/zukkobek/zukkobek_screen.dart';
import '../navigation/scaffold_with_nav.dart';
import '../widgets/app_background.dart';

// Animatsiyasiz — bo'limlar bir zumda almashadi (eski ekran ko'rinmaydi).
NoTransitionPage<void> _slide(GoRouterState state, Widget child) =>
    NoTransitionPage<void>(
      key: state.pageKey,
      child: child,
    );

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    redirect: (_, state) => null,
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),
    routes: [
      GoRoute(path: '/splash', pageBuilder: (_, s) => _slide(s, const SplashScreen())),
      GoRoute(path: '/onboarding', pageBuilder: (_, s) => _slide(s, const OnboardingScreen())),
      GoRoute(path: '/auth/phone', pageBuilder: (_, s) => _slide(s, const PhoneScreen())),
      GoRoute(path: '/auth/otp', pageBuilder: (_, s) {
        final e = s.extra as Map<String, dynamic>? ?? const {};
        return _slide(s, OtpScreen(
          phone: e['phone'] as String? ?? '',
          isRegister: e['register'] as bool? ?? false,
        ));
      }),
      GoRoute(path: '/auth/profile', pageBuilder: (_, s) => _slide(s, const ProfileSetupScreen())),
      GoRoute(path: '/auth/terms', pageBuilder: (_, s) => _slide(s, const TermsScreen())),
      GoRoute(path: '/auth/success', pageBuilder: (_, s) => _slide(s, const SuccessScreen())),
      // Detal sahifalar nav shell TASHQARISIDA — pastki menyu/drawer'siz,
      // to'liq ekran. Shell ustiga push bo'ladi, faqat orqaga tugmasi qoladi.
      GoRoute(
        path: '/services/ads/detail',
        pageBuilder: (_, s) =>
            _slide(s, AppBackground(child: AdDetailPage(ad: s.extra as Ad))),
      ),
      GoRoute(
        path: '/market/detail',
        pageBuilder: (_, s) => _slide(
            s, AppBackground(child: MarketDetailPage(product: s.extra as Product))),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(path: '/home', pageBuilder: (_, s) => _slide(s, const HomeScreen())),
          GoRoute(
            path: '/services',
            pageBuilder: (_, s) => _slide(s, const ServicesScreen()),
            routes: [
              GoRoute(path: 'news', pageBuilder: (_, s) => _slide(s, NewsScreen(openKey: s.extra as String?))),
              GoRoute(path: 'appeals', pageBuilder: (_, s) => _slide(s, const AppealsScreen())),
              GoRoute(path: 'transport', pageBuilder: (_, s) => _slide(s, const TransportScreen())),
              GoRoute(path: 'bank', pageBuilder: (_, s) => _slide(s, const BankScreen())),
              GoRoute(path: 'ads', pageBuilder: (_, s) => _slide(s, const AdsScreen())),
              GoRoute(path: 'prayer', pageBuilder: (_, s) => _slide(s, const PrayerScreen())),
              GoRoute(path: 'map', pageBuilder: (_, s) => _slide(s, const MapScreen())),
              GoRoute(path: 'mahalla', pageBuilder: (_, s) => _slide(s, const MahallaScreen())),
              GoRoute(path: 'weather', pageBuilder: (_, s) => _slide(s, const WeatherScreen())),
              GoRoute(path: 'tourism', pageBuilder: (_, s) => _slide(s, const TourismScreen())),
              GoRoute(path: 'contact', pageBuilder: (_, s) => _slide(s, const ContactScreen())),
              GoRoute(path: 'personal-info', pageBuilder: (_, s) => _slide(s, const PersonalInfoScreen())),
              GoRoute(path: 'settings', pageBuilder: (_, s) => _slide(s, const SettingsScreen())),
            ],
          ),
          GoRoute(path: '/zukkobek', pageBuilder: (_, s) => _slide(s, const ZukkobekScreen())),
          GoRoute(path: '/market', pageBuilder: (_, s) => _slide(s, const MarketScreen())),
          GoRoute(path: '/profile', pageBuilder: (_, s) => _slide(s, const ProfileScreen())),
        ],
      ),
    ],
  );
});
