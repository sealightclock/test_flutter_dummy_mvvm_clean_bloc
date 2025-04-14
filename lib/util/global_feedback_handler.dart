import 'package:flutter/material.dart';

/// Global function to show user feedback messages consistently across the app.
///
/// Supports different [FeedbackType]s like error, warning, and info.
///
/// Usage:
/// ```dart
/// showFeedback(context, 'Something went wrong', FeedbackType.error);
/// showFeedback(context, 'Please check input', FeedbackType.warning);
/// showFeedback(context, 'Saved successfully', FeedbackType.info);
/// ```
void showFeedback(BuildContext context, String message, FeedbackType type) {
  Color backgroundColor;

  switch (type) {
    case FeedbackType.error:
      backgroundColor = Colors.redAccent;
      break;
    case FeedbackType.warning:
      backgroundColor = Colors.orangeAccent;
      break;
    case FeedbackType.info:
    default:
      backgroundColor = Colors.blueAccent;
      break;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ),
  );
}

/// Enum representing types of feedback messages.
enum FeedbackType {
  error,
  warning,
  info,
}
