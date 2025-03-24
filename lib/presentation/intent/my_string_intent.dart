/// Make the parent class "sealed" to prevent subclasses from being created.
/// Intent classes for MVI pattern.
sealed class MyStringIntent {}

//  We already know the new value when creating this Intent class object, so we
//  can use it right away.

/// Intent: Update the value manually from user input.
class UpdateFromUserIntent extends MyStringIntent {
  final String newValue;

  UpdateFromUserIntent(this.newValue);
}

//  We don't know the new value when creating this Intent class object, so we
//  just send the request to ViewModel, and let the latter to get the new
//  value from the backend server.

/// Intent: Request a new value from the backend server.
class UpdateFromServerIntent extends MyStringIntent {}
