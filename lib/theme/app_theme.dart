import 'package:flutter/material.dart';
import 'app_styles.dart'; // Import shared styles for consistency

/// Shared App Theme
///
/// This ThemeData defines the look and feel of the entire app.
/// It uses the shared text styles and colors defined elsewhere.
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueAccent, // Main accent color
      ),
      scaffoldBackgroundColor: Colors.white, // Default background color
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
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
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        contentTextStyle: TextStyle(color: Colors.white),
      ),
      useMaterial3: true, // Enable Material 3 visuals
    );
  }
}
