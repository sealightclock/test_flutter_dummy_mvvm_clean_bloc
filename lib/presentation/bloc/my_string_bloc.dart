// Imports the Bloc package that provides Bloc and event/state management features.
import 'package:flutter_bloc/flutter_bloc.dart';

// Imports Equatable, which allows for value comparison of events and states.
import 'package:equatable/equatable.dart';

// These `part` directives link this file to the event and state files.
// It makes their classes available to this file without separate imports.
part 'my_string_event.dart';
part 'my_string_state.dart';

/// The main BLoC class for handling all business logic related to "my_string".
///
/// It reacts to incoming [MyStringEvent]s and emits [MyStringState]s based on logic.
///
/// BLoC is like a state machine: it receives events, performs logic, and emits new states.
class MyStringBloc extends Bloc<MyStringEvent, MyStringState> {
  // Constructor: sets the initial state and registers event handlers.
  MyStringBloc() : super(MyStringInitialState()) {
    // Important: Each event must have a handler, otherwise

    // Handler for LoadMyString event.
    // When triggered, it simply emits a loading state.
    // In real apps, this could trigger loading from shared preferences or cache.
    on<LoadMyStringEvent>((event, emit) {
      emit(MyStringLoadingState());
    });

    // Handler for UpdateMyStringFromLocal event.
    // Immediately emits a loaded state with the local value.
    on<UpdateMyStringFromLocalEvent>((event, emit) {
      emit(MyStringLoadedState(event.newValue));
    });

    // Handler for UpdateMyStringFromUser event.
    // Immediately emits a loaded state with the new user-provided value.
    on<UpdateMyStringFromUserEvent>((event, emit) {
      emit(MyStringLoadedState(event.newValue));
    });

    // Handler for UpdateMyStringFromServer event.
    // Emits a loading state, then tries to fetch the value from the server.
    // If successful, emits a loaded state with the fetched value.
    // If an error occurs, emits an error state.
    on<UpdateMyStringFromServerEvent>((event, emit) async {
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
    });
  }
}
