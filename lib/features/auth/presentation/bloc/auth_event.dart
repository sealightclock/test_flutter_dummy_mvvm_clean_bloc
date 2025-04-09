import '../../domain/entity/user_auth_entity.dart';

sealed class AuthEvent {}

class AuthLoadingEvent extends AuthEvent {}

class AuthAuthenticatedEvent extends AuthEvent {
  final UserAuthEntity? user; // Nullable now
  AuthAuthenticatedEvent({this.user});
}

class AuthGuestLoginEvent extends AuthEvent {}

class AuthUnauthenticatedEvent extends AuthEvent {}

class AuthErrorEvent extends AuthEvent {
  final String message;
  AuthErrorEvent({required this.message});
}
