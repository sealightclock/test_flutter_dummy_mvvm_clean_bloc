import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc for handling authentication-related events and states.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthInitialState()) {
    on<AuthLoadingEvent>((event, emit) async {
      emit(const AuthLoadingState());
    });

    on<AuthAuthenticatedEvent>((event, emit) async {
      emit(AuthAuthenticatedState(user: event.user));
    });

    on<AuthUnauthenticatedEvent>((event, emit) async {
      emit(const AuthUnauthenticatedState());
    });

    on<AuthErrorEvent>((event, emit) async {
      emit(AuthErrorState(message: event.message));
    });
  }
}
