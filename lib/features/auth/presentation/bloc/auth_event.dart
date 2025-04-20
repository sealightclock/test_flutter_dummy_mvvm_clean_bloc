import 'package:equatable/equatable.dart';
import '../../domain/entity/auth_entity.dart';

/// Sealed class for Authentication Events
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start authentication loading
class AuthLoadingEvent extends AuthEvent {
  const AuthLoadingEvent();
}

/// Event when a real user has authenticated
class AuthAuthenticatedEvent extends AuthEvent {
  final AuthEntity user;

  const AuthAuthenticatedEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Event when guest login is successful
class AuthGuestAuthenticatedEvent extends AuthEvent {
  const AuthGuestAuthenticatedEvent();
}

/// Event when the user is unauthenticated
class AuthUnauthenticatedEvent extends AuthEvent {
  const AuthUnauthenticatedEvent();
}

/// Event when an authentication error occurs
class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Event when user requests logout
class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}
