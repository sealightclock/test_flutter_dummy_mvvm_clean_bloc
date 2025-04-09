import 'package:equatable/equatable.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Sealed class for Authentication Events.
///
/// Only specific subclasses are allowed for type safety.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event when authentication process starts (loading indicator)
class AuthLoadingEvent extends AuthEvent {
  const AuthLoadingEvent();
}

/// Event when user successfully authenticates
class AuthAuthenticatedEvent extends AuthEvent {
  final UserAuthEntity user;

  const AuthAuthenticatedEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Event when user is not authenticated
class AuthUnauthenticatedEvent extends AuthEvent {
  const AuthUnauthenticatedEvent();
}

/// Event when there is an authentication error
class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
