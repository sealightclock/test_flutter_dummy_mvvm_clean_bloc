// This line marks this file as part of 'my_string_bloc.dart'.
// It allows splitting the BLoC code into multiple organized files.
part of 'my_string_bloc.dart';

/// Base class for all states emitted by MyStringBloc.
///
/// Bloc emits one state at a time, and the UI reacts to state changes.
/// Subclasses of this class represent specific states in the state machine.
abstract class MyStringState extends Equatable {
  @override
  List<Object?> get props => [];
  // This allows state comparisons based on data instead of object references.
  // Subclasses override this to include their relevant fields.
}

// Typical states of a UI data:
// - Initial state
// - Loading state
// - Loaded state
// - Error state

/// Initial state of the BLoC (e.g., when the app or screen first loads).
///
/// Typically used before any data is loaded or interaction happens.
class MyStringInitialState extends MyStringState {}

/// State when a loading process is in progress (e.g., fetching from server).
///
/// UI can show a loading spinner or disabled buttons during this state.
class MyStringLoadingState extends MyStringState {}

/// State when the string has been successfully loaded (from user or server).
///
/// This state carries the actual string value.
class MyStringLoadedState extends MyStringState {
  final String value; // The current value of the string

  MyStringLoadedState(this.value); // Constructor to initialize the value

  @override
  List<Object?> get props => [value];
  // This allows Bloc to compare two MyStringLoaded states
  // and know if the value has changed, which triggers UI rebuild.
}

/// State when something goes wrong (e.g., network error, invalid data).
///
/// Carries an error message to show to the user or log.
class MyStringErrorState extends MyStringState {
  final String message; // Description of what went wrong

  MyStringErrorState(this.message); // Constructor to initialize the error message

  @override
  List<Object?> get props => [message];
  // Ensures error states can be compared by their message content.
}
