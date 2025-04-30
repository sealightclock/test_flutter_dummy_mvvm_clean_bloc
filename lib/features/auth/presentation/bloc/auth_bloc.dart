import 'package:flutter_bloc/flutter_bloc.dart';
import '../factory/auth_viewmodel_factory.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc for handling authentication-related events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // Use ViewModel to communicate with UseCase.
  // It could change to DI. So don't make it final.
  late AuthViewModel viewModel;

  AuthBloc() : super(const AuthInitialState()) {
    viewModel = AuthViewModelFactory.create();

    on<AuthEvent>((event, emit) async {
      switch (event) {
        case AuthLoadingEvent():
          emit(const AuthLoadingState());
          break;

        case AuthAuthenticatedEvent():
          emit(AuthAuthenticatedState(user: event.auth));
          break;

        case AuthGuestAuthenticatedEvent():
          emit(const AuthGuestAuthenticatedState());
          break;

        case AuthUnauthenticatedEvent():
          emit(const AuthUnauthenticatedState());
          break;

        case AuthErrorEvent():
          emit(AuthErrorState(message: event.message));
          break;

        case AuthLogoutEvent():
          emit(const AuthUnauthenticatedState());
          break;
      }
    });
  }
}

