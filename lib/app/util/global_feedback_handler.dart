import 'package:flutter/material.dart';
import 'feedback_type_enum.dart'; // Updated to use inline enum methods

/// Global function to show user feedback messages consistently across the app.
void showFeedback(BuildContext context, String message, FeedbackType type) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars(); // Prevents queueing multiple messages

  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: type.color, // Using inline color getter
      duration: const Duration(seconds: 3),
    ),
  );
}
