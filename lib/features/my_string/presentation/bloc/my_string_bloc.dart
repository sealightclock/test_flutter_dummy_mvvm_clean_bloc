// Imports the Bloc package that provides Bloc and event/state management features.
import 'package:flutter_bloc/flutter_bloc.dart';

import 'my_string_event.dart';
import 'my_string_state.dart';

/// The main BLoC class for handling all business logic related to "my_string".
///
/// It reacts to incoming [MyStringEvent]s and emits [MyStringState]s based on logic.
///
/// BLoC is like a state machine: it receives events, performs logic, and emits new states.
class MyStringBloc extends Bloc<MyStringEvent, MyStringState> {
  // Constructor: sets the initial state and registers event handlers.
  MyStringBloc() : super(MyStringInitialState()) {

    // Important: Each event must have a handler, otherwise the app may crash.
    on<MyStringEvent>((event, emit) async {
      // With MyStringEvent as a sealed class:
      // 1. You don't need to write a default case;
      // 2. You can't miss any events.

      switch (event) {
        case LoadMyStringEvent():
          emit(MyStringLoadingState());
          break;

        case UpdateMyStringFromLocalEvent():
        // Local event already contains the new value.
          emit(MyStringSuccessState(event.newValue));
          break;

        case UpdateMyStringFromUserEvent():
        // User event already contains the new value.
          emit(MyStringSuccessState(event.newValue));
          break;

        case UpdateMyStringFromServerEvent():
        // For server fetch, we simulate a network call.
          emit(MyStringLoadingState()); // Start with loading state

          try {
            // Await the result from the provided fetch function
            final value = await event.fetchFromServer();

            if (value.isNotEmpty) {
              // Emit the successfully loaded value
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
