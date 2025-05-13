import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import 'account_event.dart';
import 'account_state.dart';

/// Bloc to handle Account screen events and states
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  // TODO: We make use of AuthBloc so that we don't need to create a separate
  //   AccountViewModel. This is for simplicity and may need to be revisited.
  final AuthBloc authBloc;

  AccountBloc({required this.authBloc}) : super(const AccountInitialState()) {
    on<AccountLogoutEvent>((event, emit) async {
      // First, clear saved user auth data
      await authBloc.viewModel.clearAuth();

      // Then, emit unauthenticated state. Since there is already such an
      // event in feature "auth", let's DRY instead: using add():
      authBloc.add(const AuthUnauthenticatedEvent());
    });
  }
}
