import 'package:flutter/material.dart';

/// Global function to show user feedback messages consistently across the app.
///
/// Supports different [FeedbackType]s like error, warning, and info.
/// Ensures only the latest feedback is shown to avoid outdated messages from queue.
///
/// Usage:
/// ```dart
/// showFeedback(context, 'Something went wrong', FeedbackType.error);
/// showFeedback(context, 'Please check input', FeedbackType.warning);
/// showFeedback(context, 'Saved successfully', FeedbackType.info);
/// ```
void showFeedback(BuildContext context, String message, FeedbackType type) {
  final messenger = ScaffoldMessenger.of(context);

  // ✅ Important: Clear any previously shown or queued SnackBars
  // This avoids showing outdated feedback when user presses multiple tabs quickly
  messenger.clearSnackBars();

  // Choose background color based on feedback type
  Color backgroundColor;
  switch (type) {
    case FeedbackType.error:
      backgroundColor = Colors.redAccent;
      break;
    case FeedbackType.warning:
      backgroundColor = Colors.orangeAccent;
      break;
    case FeedbackType.info:
      backgroundColor = Colors.blueAccent;
      break;
    // no default — let analyzer catch unhandled values in the future
  }

  // Show the feedback message with appropriate color and duration
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
    ),
  );
}

/// Enum representing types of feedback messages.
enum FeedbackType {
  error,
  warning,
  info,
}
