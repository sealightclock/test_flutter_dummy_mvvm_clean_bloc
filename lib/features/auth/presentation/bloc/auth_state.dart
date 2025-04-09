import 'package:equatable/equatable.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Sealed class for Authentication States.
///
/// Only specific subclasses are allowed for type safety.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// State when authentication is in progress (loading spinner)
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// State when user is successfully authenticated
class AuthAuthenticated extends AuthState {
  final UserAuthEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when user is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// State when an authentication error occurs
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
