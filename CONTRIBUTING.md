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

🖼️ Visual Structure (for Complex Screens)

[ MyFeatureScreen (StatelessWidget) ]
         ↓ provides Bloc/ViewModel
[ MyFeatureScreenBody (StatefulWidget) ]
         ↓ manages lifecycle, user actions, listens to Bloc
[ Bloc / ViewModel / UseCase / Repository ]
