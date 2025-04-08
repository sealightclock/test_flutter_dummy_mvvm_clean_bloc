import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Bloc that manages authentication states by calling ViewModel methods.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late AuthViewModel _viewModel;

  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignUpRequested>(_onSignUpRequested);
    on<LoginRequested>(_onLoginRequested);
    on<GuestLoginRequested>(_onGuestLoginRequested);
  }

  /// Allow ViewModel injection after Bloc creation
  void attachViewModel(AuthViewModel viewModel) {
    _viewModel = viewModel;
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    try {
      final user = await _viewModel.getUserAuthStatus();
      if (user != null && user.isLoggedIn) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _viewModel.signUp(event.username, event.password);
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _viewModel.login(event.username, event.password);
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onGuestLoginRequested(GuestLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _viewModel.guestLogin();
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
