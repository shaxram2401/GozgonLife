import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gozgon_life/main.dart';

void main() {
  setUp(() {
    // SharedPreferences plagini testda mavjud emas — mock qiymat beriladi.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Ilova ishga tushadi va splash ekrani ko\'rinadi',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: GozgonApp()));

    expect(find.byType(MaterialApp), findsOneWidget);

    // Splash 2 soniya turadi, keyin onboarding'ga o'tadi. Taymer test
    // tugashidan oldin ishlab bo'lishi uchun vaqtni oldinga suramiz.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  testWidgets('Token yo\'q bo\'lsa onboarding ochiladi',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ProviderScope(child: GozgonApp()));
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Onboarding ekranida "boshlash" tugmasi bo'ladi.
    expect(find.byType(PageView), findsWidgets);
  });
}
