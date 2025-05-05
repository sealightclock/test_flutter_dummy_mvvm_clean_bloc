import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/result.dart';
import '../../domain/entity/my_string_entity.dart';
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
  // This is not final to allow test injection if needed.
  late MyStringViewModel viewModel;

  MyStringBloc() : super(MyStringInitialState()) {
    viewModel = MyStringViewModelFactory.create();

    on<MyStringEvent>((event, emit) async {
      switch (event) {
        case MyStringLoadEvent():
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
            final value = await event.fetchFromServer();
            if (value.isNotEmpty) {
              if (state is! MyStringSuccessState ||
                  (state as MyStringSuccessState).value != value) {
                emit(MyStringSuccessState(value));
              }
            } else {
              const message = 'Fetched value is empty.';
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

  // ---------------------------------------------------------------------------
  // ✅ Wrapper methods to be used by the View instead of directly calling ViewModel
  // These are called in initState(), lifecycle, and button callbacks.
  // These wrappers are for widget unit testing purposes, not for production.
  // ---------------------------------------------------------------------------

  /// Wrapper for loading the string from local storage
  Future<Result<MyStringEntity>> getMyStringFromLocal() async {
    return await viewModel.getMyStringFromLocal();
  }

  /// Wrapper for saving the string to local storage
  Future<Result<void>> storeMyStringToLocal(String value) async {
    return await viewModel.storeMyStringToLocal(value);
  }

  /// Wrapper for simulating a remote fetch
  Future<Result<MyStringEntity>> getMyStringFromRemote() async {
    return await viewModel.getMyStringFromRemote();
  }
}
