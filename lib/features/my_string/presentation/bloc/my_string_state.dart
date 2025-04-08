// This line marks this file as part of 'my_string_bloc.dart'.
// It allows splitting the BLoC code into multiple organized files.
part of 'my_string_bloc.dart';

/// Sealed base class for all states emitted by MyStringBloc.
///
/// Bloc emits one state at a time, and the UI reacts to state changes.
/// Subclasses of this class represent specific states in the state machine.
///
/// A sealed class allows the compiler to know all possible subclasses,
/// enabling better type safety and exhaustive checks.
sealed class MyStringState extends Equatable {
  const MyStringState(); // Base constructor

  @override
  List<Object?> get props => [];
// This allows state comparisons based on data instead of object references.
// Subclasses override this to include their relevant fields.
}

// Typical states of a UI data:
// - Initial state
// - Loading state
// - Success (Loaded) state
// - Error state

/// Initial state of the BLoC (e.g., when the app or screen first loads).
///
/// Typically used before any data is loaded or interaction happens.
final class MyStringInitialState extends MyStringState {
  // TODO: Add "const" to the constructor to make it compile-time constant.
  //   But the body must be empty.
  MyStringInitialState() {
    logger.d('TFDB: MyStringInitialState: MyStringInitialState');
  }
}

/// State when a loading process is in progress (e.g., fetching from server).
///
/// UI can show a loading spinner or disabled buttons during this state.
final class MyStringLoadingState extends MyStringState {
  MyStringLoadingState() {
    logger.d('TFDB: MyStringLoadingState: MyStringLoadingState');
  }
}

/// State when the string has been successfully loaded (either from user or server).
///
/// This state carries the actual string value.
final class MyStringSuccessState extends MyStringState {
  final String value; // The current value of the string

  MyStringSuccessState(this.value) {
    logger.d('TFDB: MyStringSuccessState: MyStringSuccessState: $value');
  }

  @override
  List<Object?> get props => [value];
// This allows Bloc to compare two MyStringSuccess states
// and know if the value has changed, which triggers UI rebuild.
}

/// State when something goes wrong (e.g., network error, invalid data).
///
/// Carries an error message to show to the user or log.
final class MyStringErrorState extends MyStringState {
  final String message; // Description of what went wrong

  MyStringErrorState(this.message) {
    logger.d('TFDB: MyStringErrorState: MyStringErrorState: $message');
  }

  @override
  List<Object?> get props => [message];
// Ensures error states can be compared by their message content.
}
