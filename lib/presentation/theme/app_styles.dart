import 'package:flutter/material.dart';

/// Shared App Text Styles
///
/// These are used throughout the app to keep font sizes, colors, and weights consistent.
class AppTextStyles {
  static const TextStyle small = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle medium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle large = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: Colors.blueAccent,
  );

  static const TextStyle italicHint = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.grey,
  );

  static const TextStyle error = TextStyle(
    fontSize: 16,
    color: Colors.red,
  );
}

/// Shared App Dimensions
///
/// These constants define common padding, margins, radius used in the app.
class AppDimens {
  static const double screenPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double cardCornerRadius = 12.0;
  static const double buttonSpacing = 12.0;
}
