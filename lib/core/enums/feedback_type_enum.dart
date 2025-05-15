import 'package:flutter/material.dart';

/// Enum representing types of feedback messages.
enum FeedbackType {
  error,
  warning,
  info;

  /// Returns background color for each feedback type
  Color get color {
    switch (this) {
      case FeedbackType.error:
        return Colors.redAccent;
      case FeedbackType.warning:
        return Colors.orangeAccent;
      case FeedbackType.info:
        return Colors.blueAccent;
    }
  }
}

