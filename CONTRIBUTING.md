🏗️ UI Layer Contribution Guideline

When adding or refactoring screens, please follow:
	•	Small/simple screens (login, settings, etc.):
➔ Use a single StatefulWidget.
➔ Example: AuthScreen.
	•	Feature/complex screens (expected to grow):
➔ Create a StatelessWidget wrapper to provide Bloc/ViewModel.
➔ Move the real logic into a StatefulWidget body.
➔ Example: MyStringScreen + MyStringScreenBody.
	•	Why:
➔ Cleaner separation of concerns, easier lifecycle management, and much easier widget testing.

✅ Tip:
Even if a screen starts small, prefer the split if you expect it to expand over time.


📢 User Feedback Guidelines
•	Use the global feedback handler located at lib/util/global_feedback_handler.dart.
•	Always call:
showFeedback(context, message, FeedbackType.type);
•	Supported FeedbackType values:
•	error: For critical issues.
•	warning: For recoverable problems.
•	info: For normal user notifications.

✅ This ensures consistent Snackbar behavior, styling, and UX across the app.