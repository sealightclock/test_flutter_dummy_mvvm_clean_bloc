import 'package:flutter/material.dart';

/// Shared App Text Styles
///
/// These styles are used throughout the core to keep font sizes, colors, and weights consistent.
/// NOTE: These are static and not Theme-dependent yet, so they remain the same in Light/Dark mode.
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
    fontWeight: FontWeight.w600,
    color: Colors.blueAccent,
  );

  static const TextStyle italicHint = TextStyle(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: Colors.grey,
  );

  static const TextStyle error = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.red,
  );
}

/// Shared App Dimensions
///
/// These constants define common padding, margins, radius used in the core.
class AppDimens {
  static const double screenPadding = 16.0;
  static const double cardElevation = 4.0;
  static const double cardCornerRadius = 12.0;
  static const double buttonSpacing = 12.0;
}
