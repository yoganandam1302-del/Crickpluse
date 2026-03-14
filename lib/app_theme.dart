import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFFF6F8F2);
  static const Color backgroundAlt = Color(0xFFEEF3E6);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F4EA);
  static const Color primary = Color(0xFF9AFD00);
  static const Color primaryDeep = Color(0xFF76D700);
  static const Color text = Color(0xFF101828);
  static const Color textSoft = Color(0xFF667085);
  static const Color textMuted = Color(0xFF98A2B3);
  static const Color border = Color(0xFFDCE3D1);
  static const Color success = Color(0xFF12B76A);
  static const Color danger = Color(0xFFE5484D);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF9FBF5), Color(0xFFF1F5E9)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB7FF4A), Color(0xFF85F000)],
  );

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: primaryDeep,
        surface: surface,
        onPrimary: text,
        onSecondary: text,
        onSurface: text,
      ),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: text,
        centerTitle: false,
      ),
      dividerColor: border,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceMuted,
        hintStyle: const TextStyle(color: textMuted, fontSize: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: primaryDeep, width: 1.4),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: text,
          elevation: 0,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: border),
        ),
      ),
    );
  }

  static BoxDecoration softCardDecoration({
    bool glow = false,
    double radius = 28,
  }) {
    return BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: border),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF101828).withOpacity(0.05),
          blurRadius: 28,
          offset: const Offset(0, 16),
        ),
        if (glow)
          BoxShadow(
            color: primary.withOpacity(0.18),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
      ],
    );
  }
}
