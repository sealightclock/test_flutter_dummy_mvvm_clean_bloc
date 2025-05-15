/// Sealed base class for all events that can be sent to MyStringBloc.
/// Events represent user actions or system triggers that should result in
/// state changes.
///
/// A sealed class allows the compiler to know all possible subclasses,
/// enabling better type safety and exhaustive checks.
sealed class MyStringEvent {
  const MyStringEvent(); // Constructor for base class.
}

// There are 2 types of events for a UI view:
// - system events (e.g., core launch)
// - user events (e.g., button click)

/// Event: Triggered when the core needs to load the string value.
/// This might be called when the core starts or when the screen is opened.
final class MyStringLoadEvent extends MyStringEvent {
  const MyStringLoadEvent(); // Constructor with no parameters.

  // No additional data is needed for this event.
}

/// Event: Triggered when the core launches and needs to load the string value.
/// This is a system event.
final class MyStringUpdateFromLocalEvent extends MyStringEvent {
  final String value; // The new value retrieved from the local store.

  const MyStringUpdateFromLocalEvent(this.value); // Constructor to pass the local stored value.
}

/// Event: Triggered when the user manually updates the string via text field
/// + "Update from User" button.
final class MyStringUpdateFromUserEvent extends MyStringEvent {
  final String value; // The new value entered by the user.

  const MyStringUpdateFromUserEvent(this.value); // Constructor to pass the user input.
}

/// Event: Triggered when the user presses "Update from Server" button.
final class MyStringUpdateFromServerEvent extends MyStringEvent {
  final Future<String> Function() fetchFromServer; // The function to fetch value from server.

  const MyStringUpdateFromServerEvent(this.fetchFromServer); // Constructor to pass in the fetch function.
}
