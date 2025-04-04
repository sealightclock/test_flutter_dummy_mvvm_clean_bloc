// This line allows this file to be a part of the 'my_string_bloc.dart' file.
// It's a Dart feature for organizing code across multiple files.
part of 'my_string_bloc.dart';

/// Sealed base class for all events that can be sent to MyStringBloc.
/// Events represent user actions or system triggers that should result in
/// state changes.
///
/// A sealed class allows the compiler to know all possible subclasses,
/// enabling better type safety and exhaustive checks.
sealed class MyStringEvent extends Equatable {
  // 'Equatable' helps with value comparison, which is useful when checking if two events are equal.
  // This is important for optimizing state management and preventing unnecessary rebuilds.

  const MyStringEvent(); // Constructor for base class.

  @override
  List<Object?> get props => [];
  // This empty list means two instances of MyStringEvent will be considered
  // equal by default.
  // Subclasses will override this to specify which fields matter for equality.
}

// There are 2 types of events for a UI view:
// - system events (e.g., app launch)
// - user events (e.g., button click)

/// Event: Triggered when the app needs to load the string value.
/// This might be called when the app starts or when the screen is opened.
final class LoadMyStringEvent extends MyStringEvent {
  const LoadMyStringEvent(); // Constructor with no parameters.

  // No additional data is needed for this event.
}

/// Event: Triggered when the app launches and needs to load the string value.
/// This is a system event.
final class UpdateMyStringFromLocalEvent extends MyStringEvent {
  final String newValue; // The new value retrieved from the local store.

  const UpdateMyStringFromLocalEvent(this.newValue); // Constructor to pass the local stored value.

  @override
  List<Object?> get props => [newValue];
  // Including 'newValue' in props allows Bloc to compare events based on local
  // value.
}

/// Event: Triggered when the user manually updates the string via text field
/// + "Update from User" button.
final class UpdateMyStringFromUserEvent extends MyStringEvent {
  final String newValue; // The new value entered by the user.

  const UpdateMyStringFromUserEvent(this.newValue); // Constructor to pass the user input.

  @override
  List<Object?> get props => [newValue];
  // Including 'newValue' in props allows Bloc to compare events based on user
  // input.
}

/// Event: Triggered when the user presses "Update from Server" button.
/// The fetchFromServer function simulates a network call and returns a
/// Future of type String.
final class UpdateMyStringFromServerEvent extends MyStringEvent {
  final Future<String> Function() fetchFromServer; // The function to fetch value from server.

  const UpdateMyStringFromServerEvent(this.fetchFromServer); // Constructor to pass in the fetch function.

  @override
  List<Object?> get props => [];
  // We leave props empty because functions (like fetchFromServer) cannot be
  // easily compared for equality.
  // If we added fetchFromServer to props, it could cause unexpected behavior.
}
