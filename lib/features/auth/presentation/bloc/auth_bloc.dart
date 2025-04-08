import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState.initial);

  void showLoading() => emit(AuthState.loading);

  void authenticate() => emit(AuthState.authenticated);

  void unauthenticate() => emit(AuthState.unauthenticated);

  void showError() => emit(AuthState.error);
}
