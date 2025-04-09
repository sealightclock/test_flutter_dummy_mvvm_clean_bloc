// Imports the Bloc package that provides Bloc and event/state management features.
import 'package:flutter_bloc/flutter_bloc.dart';

// Imports Equatable, which allows for value comparison of events and states.
import 'package:equatable/equatable.dart';

// Logger for debugging purposes.
import 'package:logger/logger.dart';

// These `part` directives link this file to the event and state files.
// It makes their classes available to this file without separate imports.
part 'my_string_event.dart';
part 'my_string_state.dart';

// Global logger instance
final logger = Logger();

/// The main BLoC class for handling all business logic related to "my_string".
///
/// It reacts to incoming [MyStringEvent]s and emits [MyStringState]s based on the logic.
///
/// Think of BLoC like a state machine: it receives events, performs logic, and emits new states.
class MyStringBloc extends Bloc<MyStringEvent, MyStringState> {
  /// Constructor: sets the initial state and registers event handlers.
  MyStringBloc() : super(MyStringInitialState()) {
    // Important: Each event must have a handler, otherwise the app may crash.
    on<MyStringEvent>((event, emit) async {
      // Since MyStringEvent is sealed, we can use switch-case safely
      // No need for a default case.

      switch (event) {
        case LoadMyStringEvent():
        // 🚀 When loading data initially
          emit(MyStringLoadingState());
          break;

        case UpdateMyStringFromLocalEvent():
        // 🗂️ When loading data from local storage (e.g., SharedPreferences, Hive)
          emit(MyStringSuccessState(event.newValue));
          break;

        case UpdateMyStringFromUserEvent():
        // 👤 When the user updates the string manually
          emit(MyStringSuccessState(event.newValue));
          break;

        case UpdateMyStringFromServerEvent():
        // 🌐 When fetching string from backend server
          emit(MyStringLoadingState()); // Show loading spinner

          try {
            // Await the result from the provided fetch function
            final value = await event.fetchFromServer();

            if (value.isNotEmpty) {
              // Emit the successfully fetched value
              emit(MyStringSuccessState(value));
            } else {
              // Empty value from server is treated as an error
              emit(MyStringErrorState('Fetched value is empty.'));
            }
          } catch (e) {
            // Emit an error state with a user-friendly error message
            emit(MyStringErrorState('Failed to fetch from server: $e'));
          }
          break;
      }
    });
  }
}
