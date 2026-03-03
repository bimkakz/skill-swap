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
}
