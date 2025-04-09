import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc that only handles UI state for Auth.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoadingEvent>((event, emit) => emit(AuthLoadingState()));

    on<AuthAuthenticatedEvent>((event, emit) {
      if (event.user != null) {
        emit(AuthAuthenticatedState(user: event.user!));
      } else {
        emit(AuthGuestLoginState());
      }
    });

    on<AuthGuestLoginEvent>((event, emit) => emit(AuthGuestLoginState()));
    on<AuthUnauthenticatedEvent>((event, emit) => emit(AuthUnauthenticatedState()));
    on<AuthErrorEvent>((event, emit) => emit(AuthErrorState(message: event.message)));
  }
}
