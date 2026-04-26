import 'package:flutter/material.dart';

class SkillSwapColors {
  // Brand Colors
  static const primary = Color(0xFF4F46E5);
  static const secondary = Color(0xFF22C55E);
  static const raspberry = Color(0xFFF43F5E);
  static const accent = Color(0xFF06B6D4);
  
  // Light Theme (Original Names for Compatibility)
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const textHeader = Color(0xFF0F172A);
  static const textBody = Color(0xFF475569);
  
  // Explicit names
  static const backgroundLight = background;
  static const surfaceLight = surface;
  static const textHeaderLight = textHeader;
  static const textBodyLight = textBody;
  
  // Dark Theme
  static const backgroundDark = Color(0xFF0F172A);
  static const surfaceDark = Color(0xFF1E293B);
  static const textHeaderDark = Colors.white;
  static const textBodyDark = Color(0xFF94A3B8);
}

class SkillSwapTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SkillSwapColors.primary,
        brightness: Brightness.light,
        surface: SkillSwapColors.background,
        onSurface: SkillSwapColors.textBody,
        primary: SkillSwapColors.primary,
        secondary: SkillSwapColors.secondary,
      ),
      scaffoldBackgroundColor: SkillSwapColors.backgroundLight,
      cardColor: SkillSwapColors.surfaceLight,
      dividerColor: Colors.grey.shade200,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: SkillSwapColors.textHeaderLight,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: SkillSwapColors.textHeaderLight),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: SkillSwapColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: SkillSwapColors.primary.withOpacity(0.4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: SkillSwapColors.raspberry,
        primary: SkillSwapColors.raspberry,
        secondary: const Color(0xFFFB7185),
        surface: SkillSwapColors.surfaceDark,
        surfaceContainerHighest: SkillSwapColors.backgroundDark,
        onSurface: SkillSwapColors.textHeaderDark,
      ),
      scaffoldBackgroundColor: SkillSwapColors.backgroundDark,
      cardColor: SkillSwapColors.surfaceDark,
      dividerColor: Colors.white10,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: SkillSwapColors.textBodyDark),
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
          backgroundColor: SkillSwapColors.raspberry,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          shadowColor: SkillSwapColors.raspberry.withOpacity(0.5),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: SkillSwapColors.surfaceDark,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

