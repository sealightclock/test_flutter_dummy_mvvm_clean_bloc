import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc that only handles UI state for Auth.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoadingEvent>((event, emit) => emit(AuthLoading()));
    on<AuthAuthenticatedEvent>((event, emit) => emit(AuthAuthenticated(user: event.user)));
    on<AuthUnauthenticatedEvent>((event, emit) => emit(AuthUnauthenticated()));
    on<AuthErrorEvent>((event, emit) => emit(AuthError(message: event.message)));
  }
}
