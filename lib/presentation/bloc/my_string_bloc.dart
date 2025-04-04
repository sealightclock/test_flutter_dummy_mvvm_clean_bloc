// Imports the Bloc package that provides Bloc and event/state management features.
import 'package:flutter_bloc/flutter_bloc.dart';

// Imports Equatable, which allows for value comparison of events and states.
import 'package:equatable/equatable.dart';

import 'package:logger/logger.dart';

// These `part` directives link this file to the event and state files.
// It makes their classes available to this file without separate imports.
part 'my_string_event.dart';
part 'my_string_state.dart';

final logger = Logger();

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
          emit(MyStringLoadedState(event.newValue));
          break;
        case UpdateMyStringFromUserEvent():
          emit(MyStringLoadedState(event.newValue));
          break;
        case UpdateMyStringFromServerEvent():
          emit(MyStringLoadingState()); // Start with loading state
          try {
            // Await the result from the provided fetch function
            final value = await event.fetchFromServer();

            // Emit the successfully loaded value
            emit(MyStringLoadedState(value));
          } catch (e) {
            // Emit an error state with a user-friendly error message
            emit(MyStringErrorState('Failed to fetch from server: $e'));
          }
          break;
      }
    });
  }
}
