import 'package:flutter/material.dart';
import 'app_styles.dart';

/// Shared App Theme with dynamic font scaling and dark mode support.
class AppTheme {
  /// Default light theme
  static ThemeData get lightTheme => lightThemeWithFontSize(16.0);

  /// Default dark theme
  static ThemeData get darkTheme => darkThemeWithFontSize(16.0);

  /// Light theme with user-defined font size
  static ThemeData lightThemeWithFontSize(double fontSize) {
    final base = ThemeData.light(useMaterial3: true);
    return _baseThemeWithFontSize(base, fontSize);
  }

  /// Dark theme with user-defined font size
  static ThemeData darkThemeWithFontSize(double fontSize) {
    final base = ThemeData.dark(useMaterial3: true);
    return _baseThemeWithFontSize(base, fontSize).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black87,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.black54,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  /// Internal shared function to apply consistent text scaling and theme styling
  static ThemeData _baseThemeWithFontSize(ThemeData base, double fontSize) {
    final textTheme = base.textTheme;

    return base.copyWith(
      textTheme: textTheme.copyWith(
        bodySmall: textTheme.bodySmall?.copyWith(fontSize: fontSize - 2),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: fontSize),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: fontSize + 2),
        titleMedium: textTheme.titleMedium?.copyWith(fontSize: fontSize + 2),
      ),
      cardTheme: CardTheme(
        elevation: AppDimens.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cardCornerRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.cardCornerRadius),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
      // ✅ Material3 is already enabled via the constructor
    );
  }
}
