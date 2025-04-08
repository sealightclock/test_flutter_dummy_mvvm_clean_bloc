import 'package:equatable/equatable.dart';

/// Events that AuthBloc will handle.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check existing user authentication status.
class CheckAuthStatus extends AuthEvent {}

/// Event triggered when user requests signup.
class SignUpRequested extends AuthEvent {
  final String username;
  final String password;

  const SignUpRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// Event triggered when user requests login.
class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

/// Event triggered when user requests guest login.
class GuestLoginRequested extends AuthEvent {}
