import 'package:equatable/equatable.dart';
import '../../domain/entity/auth_entity.dart';

/// Sealed class for Authentication States
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state when app starts
class AuthInitialState extends AuthState {
  const AuthInitialState();
}

/// State when authentication is in progress
class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

/// State when a real user is successfully authenticated
class AuthAuthenticatedState extends AuthState {
  final AuthEntity user;

  const AuthAuthenticatedState({required this.user});

  @override
  List<Object?> get props => [user];
}

/// State when a guest user is authenticated
class AuthGuestAuthenticatedState extends AuthState {
  const AuthGuestAuthenticatedState();
}

/// State when user is not authenticated
class AuthUnauthenticatedState extends AuthState {
  const AuthUnauthenticatedState();
}

/// State when an authentication error occurs
class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
