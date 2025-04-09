import 'package:equatable/equatable.dart';
import '../../domain/entity/user_auth_entity.dart';

/// States emitted by AuthBloc.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class AuthInitial extends AuthState {}

/// Loading state during signup, login or guest login.
class AuthLoading extends AuthState {}

/// Authenticated state with user details.
class AuthAuthenticated extends AuthState {
  final UserAuthEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state (no user logged in).
class AuthUnauthenticated extends AuthState {}

/// Error state with error message.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
