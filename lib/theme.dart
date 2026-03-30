import 'package:flutter/material.dart';

class SkillSwapColors {
  static const primary = Color(0xFF4F46E5);
  static const secondary = Color(0xFF22C55E);
  static const accent = Color(0xFF06B6D4);
  static const background = Color(0xFFF9FAFB);
  static const surface = Colors.white;
  static const textHeader = Color(0xFF111827);
  static const textBody = Color(0xFF4B5563);
}

class SkillSwapTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SkillSwapColors.primary,
        primary: SkillSwapColors.primary,
        secondary: SkillSwapColors.secondary,
        surface: SkillSwapColors.surface,
        background: SkillSwapColors.background,
      ),
      scaffoldBackgroundColor: SkillSwapColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: SkillSwapColors.textHeader,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: SkillSwapColors.textHeader),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkillSwapColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: SkillSwapColors.primary.withOpacity(0.4),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: SkillSwapColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  static ThemeData get dark {
    const Color deepBlue = Color(0xFF0F172A);
    const Color raspberry = Color(0xFFF43F5E); // Modern Raspberry/Pink
    const Color surfaceBlue = Color(0xFF1E293B);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: raspberry,
        primary: raspberry,
        secondary: const Color(0xFFFB7185), // Lighter pink
        surface: surfaceBlue,
        background: deepBlue,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onPrimary: Colors.white,
      ),
      scaffoldBackgroundColor: deepBlue,
      cardColor: surfaceBlue,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFCBD5E1)), // Slate 300 for body
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: raspberry,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 8,
          shadowColor: raspberry.withOpacity(0.5),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceBlue,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white70),
      listTileTheme: const ListTileThemeData(
        iconColor: Colors.white70,
        textColor: Colors.white,
      ),
    );
  }
}
