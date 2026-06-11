import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF1E3A8A);
  static const secondary = Color(0xFF3B82F6);
  static const accent = Color(0xFFF59E0B);
  // Light — yengil ko'kimtir premium fon.
  static const background = Color(0xFFF4F9FF);
  static const surface = Colors.white;
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF64748B);
  static const divider = Color(0xFFE6EDF7);

  // Dark — premium qorong'i tema.
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkTextPrimary = Color(0xFFF8FAFC);
  static const darkTextSecondary = Color(0xFF94A3B8);
  static const darkDivider = Color(0xFF334155);

  /// Dark kartalar uchun yupqa border — rgba(255,255,255,0.05).
  static const darkCardBorder = Color(0x0DFFFFFF);

  // ── Theme-aware helpers (resolve by current brightness) ──
  static bool _dark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  /// Sahifa foni — yengil ko'kimtir gradient (light) / chuqur navy (dark).
  static LinearGradient bgGradient(bool dark) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: dark
            ? const [Color(0xFF0F172A), Color(0xFF0B1120)]
            : const [Color(0xFFF4F9FF), Color(0xFFFFFFFF)],
      );

  /// Card / panel background.
  static Color card(BuildContext c) => _dark(c) ? darkSurface : Colors.white;

  /// Primary (high-emphasis) text color.
  static Color tp(BuildContext c) => _dark(c) ? darkTextPrimary : textPrimary;

  /// Secondary (muted) text color.
  static Color ts(BuildContext c) => _dark(c) ? darkTextSecondary : textSecondary;

  /// Divider / border color — dark'da yupqa oq border.
  static Color dv(BuildContext c) => _dark(c) ? darkCardBorder : divider;

  /// Colored panel that adapts: light tint in light mode, dark tint in dark mode.
  static Color panel(BuildContext c, Color hue) => _dark(c)
      ? Color.alphaBlend(hue.withValues(alpha: 0.30), const Color(0xFF161616))
      : Color.alphaBlend(hue.withValues(alpha: 0.12), Colors.white);

  // Panel hues per section.
  static const hueRed = Color(0xFFDC2626);
  static const hueAmber = Color(0xFFF59E0B);
  static const hueGreen = Color(0xFF10B981);
  static const huePurple = Color(0xFF7C3AED);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: secondary,
          surface: surface,
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.outfitTextTheme().apply(
          bodyColor: textPrimary,
          displayColor: textPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          surfaceTintColor: Colors.transparent,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            side: const BorderSide(color: primary),
            textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: divider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: GoogleFonts.outfit(color: textSecondary, fontSize: 15),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          elevation: 8,
          shadowColor: Colors.black12,
          indicatorColor: primary.withValues(alpha: 0.12),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500, color: textPrimary),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(color: selected ? primary : textSecondary, size: 24);
          }),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerTheme: const DividerThemeData(color: divider, space: 1),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: primary.withValues(alpha: 0.1),
          labelStyle: GoogleFonts.outfit(fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: const BorderSide(color: divider),
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: secondary,
          brightness: Brightness.dark,
          primary: secondary,
          secondary: secondary,
          surface: darkSurface,
          error: const Color(0xFFEF4444),
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: darkTextPrimary,
          displayColor: darkTextPrimary,
        ),
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          scrolledUnderElevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: secondary,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            side: const BorderSide(color: secondary),
            textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: darkSurface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: darkDivider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: darkDivider),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: secondary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFEF4444)),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: GoogleFonts.outfit(color: darkTextSecondary, fontSize: 15),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: darkSurface,
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: darkSurface,
          elevation: 8,
          shadowColor: Colors.black38,
          indicatorColor: secondary.withValues(alpha: 0.2),
          labelTextStyle: WidgetStateProperty.all(
            GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            final selected = states.contains(WidgetState.selected);
            return IconThemeData(color: selected ? secondary : darkTextSecondary, size: 24);
          }),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: darkSurface),
        listTileTheme: ListTileThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        dividerTheme: const DividerThemeData(color: darkDivider, space: 1),
        chipTheme: ChipThemeData(
          backgroundColor: darkSurface,
          selectedColor: secondary.withValues(alpha: 0.2),
          labelStyle: GoogleFonts.outfit(fontSize: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: const BorderSide(color: darkDivider),
        ),
      );
}
