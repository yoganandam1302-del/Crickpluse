import 'package:flutter/material.dart';
import 'package:cricpluse/app_theme.dart';
import 'package:cricpluse/screens/splash_screen.dart';

// Global notifier for the app theme
final ValueNotifier<ThemeMode> appThemeNotifier = ValueNotifier<ThemeMode>(
  ThemeMode.light,
);

void main() {
  runApp(const CricPulseApp());
}

class CricPulseApp extends StatelessWidget {
  const CricPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'CricPulse',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.lightTheme(),
          home: const SplashScreen(),
        );
      },
    );
  }
}
