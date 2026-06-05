import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _State();
}

class _State extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), _navigate);
  }

  Future<void> _navigate() async {
    final results = await Future.wait([
      SharedPreferences.getInstance(),
      Future.delayed(const Duration(seconds: 2)),
    ]);
    if (!mounted) return;
    final p = results[0] as SharedPreferences;
    if ((p.getString('auth_token') ?? '').isNotEmpty) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/first.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
