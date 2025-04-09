import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc for handling authentication-related events and states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitial()) {
    on<AuthLoadingEvent>((event, emit) async {
      emit(const AuthLoading());
    });

    on<AuthAuthenticatedEvent>((event, emit) async {
      emit(AuthAuthenticated(user: event.user));
    });

    on<AuthUnauthenticatedEvent>((event, emit) async {
      emit(const AuthUnauthenticated());
    });

    on<AuthErrorEvent>((event, emit) async {
      emit(AuthError(message: event.message));
    });
  }
}
