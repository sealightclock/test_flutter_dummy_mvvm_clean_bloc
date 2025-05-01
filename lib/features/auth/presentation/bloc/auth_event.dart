import '../../domain/entity/auth_entity.dart';

/// Sealed class for Authentication Events
sealed class AuthEvent {
  const AuthEvent();
}

/// Event to start authentication
class AuthStartEvent extends AuthEvent {
  const AuthStartEvent();
}

/// Event when a real user has authenticated
class AuthAuthenticatedEvent extends AuthEvent {
  final AuthEntity auth;

  const AuthAuthenticatedEvent({required this.auth});
}

/// Event when guest login is successful
class AuthGuestAuthenticatedEvent extends AuthEvent {
  const AuthGuestAuthenticatedEvent();
}

/// Event when user/guest is unauthenticated
class AuthUnauthenticatedEvent extends AuthEvent {
  const AuthUnauthenticatedEvent();
}

/// Event when an authentication error occurs
class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({required this.message});
}

/// Event when user requests logout
class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
