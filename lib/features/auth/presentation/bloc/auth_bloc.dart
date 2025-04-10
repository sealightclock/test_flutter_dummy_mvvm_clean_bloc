import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc for handling authentication-related events and states
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitialState()) {
    on<AuthEvent>((event, emit) async {
      switch (event) {
        case AuthLoadingEvent():
          emit(const AuthLoadingState());
          break;

        case AuthAuthenticatedEvent():
          emit(AuthAuthenticatedState(user: event.user));
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
      }
    });
  }
}
