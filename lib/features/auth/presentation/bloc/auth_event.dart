import 'package:equatable/equatable.dart';
import '../../domain/entity/user_auth_entity.dart';

/// Events that drive Auth UI state.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Show loading spinner
class AuthLoadingEvent extends AuthEvent {}

/// Show authenticated user
class AuthAuthenticatedEvent extends AuthEvent {
  final UserAuthEntity user;

  const AuthAuthenticatedEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Show unauthenticated state
class AuthUnauthenticatedEvent extends AuthEvent {}

/// Show error message
class AuthErrorEvent extends AuthEvent {
  final String message;

  const AuthErrorEvent({required this.message});

  @override
  List<Object?> get props => [message];
}
