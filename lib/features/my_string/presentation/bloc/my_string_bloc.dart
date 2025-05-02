import 'package:flutter_bloc/flutter_bloc.dart';

import '../factory/my_string_viewmodel_factory.dart';
import '../viewmodel/my_string_viewmodel.dart';
import 'my_string_event.dart';
import 'my_string_state.dart';

/// The main BLoC class for handling all business logic related to "my_string".
///
/// It reacts to incoming [MyStringEvent]s and emits [MyStringState]s based on logic.
///
/// BLoC is like a state machine: it receives events, performs logic, and emits new states.
class MyStringBloc extends Bloc<MyStringEvent, MyStringState> {
  // Use ViewModel to communicate with UseCase.
  // It could change to DI. So don't make it final.
  late MyStringViewModel viewModel;

  // Constructor: sets the initial state and registers event handlers.
  MyStringBloc() : super(MyStringInitialState()) {
    viewModel = MyStringViewModelFactory.create();

    // Important: Each event must have a handler, otherwise the app may crash.
    on<MyStringEvent>((event, emit) async {
      // With MyStringEvent as a sealed class:
      // 1. You don't need to write a default case;
      // 2. You can't miss any events.

      switch (event) {
        case MyStringLoadEvent():
        // Emit loading only if current state is not already loading
          if (state is! MyStringLoadingState) {
            emit(MyStringLoadingState());
          }
          break;

        case MyStringUpdateFromLocalEvent():
          if (state is! MyStringSuccessState ||
              (state as MyStringSuccessState).value != event.value) {
            emit(MyStringSuccessState(event.value));
          }
          break;

        case MyStringUpdateFromUserEvent():
          if (state is! MyStringSuccessState ||
              (state as MyStringSuccessState).value != event.value) {
            emit(MyStringSuccessState(event.value));
          }
          break;

        case MyStringUpdateFromServerEvent():
          if (state is! MyStringLoadingState) {
            emit(MyStringLoadingState());
          }

          try {
            // Await the result from the provided fetch function
            final value = await event.fetchFromServer();

            if (value.isNotEmpty) {
              if (state is! MyStringSuccessState ||
                  (state as MyStringSuccessState).value != value) {
                emit(MyStringSuccessState(value));
              }
            } else {
              // Only emit error if it's not the same message
              final message = 'Fetched value is empty.';
              if (state is! MyStringErrorState ||
                  (state as MyStringErrorState).message != message) {
                emit(MyStringErrorState(message));
              }
            }
          } catch (e) {
            final message = 'Failed to fetch from server: $e';
            if (state is! MyStringErrorState ||
                (state as MyStringErrorState).message != message) {
              emit(MyStringErrorState(message));
            }
          }
          break;
      }
    });
  }
}
