// This line allows this file to be a part of the 'my_string_bloc.dart' file.
// It's a Dart feature for organizing code across multiple files.
part of 'my_string_bloc.dart';

/// Base class for all events that can be sent to MyStringBloc.
/// Events represent user actions or system triggers that should result in
/// state changes.
abstract class MyStringEvent extends Equatable {
  // 'Equatable' helps with value comparison, which is useful when checking if two events are equal.
  // This is important for optimizing state management and preventing unnecessary rebuilds.

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
class LoadMyStringEvent extends MyStringEvent {
  // No additional data is needed for this event.
}

/// Event: Triggered when the app launches and needs to load the string value.
/// This is a system event.
class UpdateMyStringFromLocalEvent extends MyStringEvent {
  final String newValue; // The new value retrieved from the local store.

  UpdateMyStringFromLocalEvent(this.newValue); // Constructor to pass the local
  // stored value

  @override
  List<Object?> get props => [newValue];
// Including 'newValue' in props allows Bloc to compare events based on local
// value.
}

/// Event: Triggered when the user manually updates the string via text field
/// + "Update from User" button.
class UpdateMyStringFromUserEvent extends MyStringEvent {
  final String newValue; // The new value entered by the user.

  UpdateMyStringFromUserEvent(this.newValue); // Constructor to pass the user input.

  @override
  List<Object?> get props => [newValue];
  // Including 'newValue' in props allows Bloc to compare events based on user
  // input.
}

/// Event: Triggered when the user presses "Update from Server" button.
/// The fetchFromServer function simulates a network call and returns a
/// Future String.
class UpdateMyStringFromServerEvent extends MyStringEvent {
  final Future<String> Function() fetchFromServer;

  UpdateMyStringFromServerEvent(this.fetchFromServer); // Constructor to pass in the fetch function.

  @override
  List<Object?> get props => [];
  // We leave props empty because functions (like fetchFromServer) cannot be
  // easily compared for equality.
  // If we added fetchFromServer to props, it could cause unexpected behavior.
}
