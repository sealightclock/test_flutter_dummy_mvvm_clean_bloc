import '../../domain/entity/user_auth_entity.dart';

sealed class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final UserAuthEntity user;
  AuthAuthenticatedState({required this.user});
}

class AuthGuestLoginState extends AuthState {} // 👈 Add this class

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});
}
