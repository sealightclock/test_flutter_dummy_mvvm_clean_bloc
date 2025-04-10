import 'package:equatable/equatable.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Sealed class for Authentication Events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Loading authentication (e.g., during login/signup/guest login)
class AuthLoadingEvent extends AuthEvent {
  const AuthLoadingEvent();
}

/// Successful real user authentication
class AuthAuthenticatedEvent extends AuthEvent {
  final UserAuthEntity user;

  const AuthAuthenticatedEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Successful guest user authentication
class AuthGuestAuthenticatedEvent extends AuthEvent {
  const AuthGuestAuthenticatedEvent();
}

/// User not authenticated
class AuthUnauthenticatedEvent extends AuthEvent {
  const AuthUnauthenticatedEvent();
}

/// Authentication error
class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
