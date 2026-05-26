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
import '../../features/profile/personal_info_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/bank/bank_screen.dart';
import '../../features/contact/contact_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/mahalla/mahalla_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/market/market_screen.dart';
import '../../features/news/news_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/prayer/prayer_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/tourism/tourism_screen.dart';
import '../../features/transport/transport_screen.dart';
import '../../features/weather/weather_screen.dart';
import '../../features/zukkobek/zukkobek_screen.dart';
import '../navigation/scaffold_with_nav.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    // DEV SHORTCUT: initialLocation: '/splash',
    initialLocation: '/home',
    redirect: (_, state) {
      // DEV SHORTCUT: if (state.uri.path == '/') return '/splash';
      return null;
    },
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/auth/phone', builder: (_, _) => const PhoneScreen()),
      GoRoute(path: '/auth/otp', builder: (_, state) => OtpScreen(phone: state.extra as String? ?? '')),
      GoRoute(path: '/auth/profile', builder: (_, _) => const ProfileSetupScreen()),
      GoRoute(path: '/auth/terms', builder: (_, _) => const TermsScreen()),
      GoRoute(path: '/auth/success', builder: (_, _) => const SuccessScreen()),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNav(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: '/services',
            builder: (_, _) => const ServicesScreen(),
            routes: [
              GoRoute(path: 'news', builder: (_, _) => const NewsScreen()),
              GoRoute(path: 'appeals', builder: (_, _) => const AppealsScreen()),
              GoRoute(path: 'transport', builder: (_, _) => const TransportScreen()),
              GoRoute(path: 'bank', builder: (_, _) => const BankScreen()),
              GoRoute(path: 'ads', builder: (_, _) => const AdsScreen()),
              GoRoute(path: 'prayer', builder: (_, _) => const PrayerScreen()),
              GoRoute(path: 'map', builder: (_, _) => const MapScreen()),
              GoRoute(path: 'mahalla', builder: (_, _) => const MahallaScreen()),
              GoRoute(path: 'weather', builder: (_, _) => const WeatherScreen()),
              GoRoute(path: 'tourism', builder: (_, _) => const TourismScreen()),
              GoRoute(path: 'contact', builder: (_, _) => const ContactScreen()),
              GoRoute(path: 'personal-info', builder: (_, _) => const PersonalInfoScreen()),
              GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen()),
            ],
          ),
          GoRoute(path: '/zukkobek', builder: (_, _) => const ZukkobekScreen()),
          GoRoute(path: '/market', builder: (_, _) => const MarketScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
  );
});
