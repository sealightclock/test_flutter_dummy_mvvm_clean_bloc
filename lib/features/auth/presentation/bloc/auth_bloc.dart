import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc for handling authentication-related events and states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitialState()) {
    // Handle all AuthEvent types in a single on<AuthEvent> handler
    on<AuthEvent>((event, emit) async {
      // Use switch/case because AuthEvent is a sealed class
      switch (event) {
        case AuthLoadingEvent():
          emit(const AuthLoadingState());
          break;
        case AuthAuthenticatedEvent(:final user):
          emit(AuthAuthenticatedState(user: user));
          break;
        case AuthUnauthenticatedEvent():
          emit(const AuthUnauthenticatedState());
          break;
        case AuthErrorEvent(:final message):
          emit(AuthErrorState(message: message));
          break;
      }
    });
  }
}
