import 'package:flutter_bloc/flutter_bloc.dart';

import '../viewmodel/auth_viewmodel_factory.dart';
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
        case AuthStartEvent():
          if (state is! AuthLoadingState) {
            emit(const AuthLoadingState());
          }
          break;

        case AuthAuthenticatedEvent():
          if (state is! AuthAuthenticatedState) {
            emit(AuthAuthenticatedState(auth: event.auth));
          }
          break;

        case AuthGuestAuthenticatedEvent():
          if (state is! AuthGuestAuthenticatedState) {
            emit(const AuthGuestAuthenticatedState());
          }
          break;

        case AuthUnauthenticatedEvent():
          if (state is! AuthUnauthenticatedState) {
            emit(const AuthUnauthenticatedState());
          }
          break;

        case AuthErrorEvent():
          if (state is! AuthErrorState ||
              (state as AuthErrorState).message != event.message) {
            emit(AuthErrorState(message: event.message));
          }
          break;

        case AuthLogoutEvent():
          if (state is! AuthUnauthenticatedState) {
            emit(const AuthUnauthenticatedState());
          }
          break;
      }
    });
  }
}
