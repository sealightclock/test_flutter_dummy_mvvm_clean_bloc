import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import 'account_event.dart';
import 'account_state.dart';

/// Bloc to handle Account screen events and states
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AuthBloc authBloc;

  AccountBloc({required this.authBloc}) : super(const AccountInitialState()) {
    on<AccountLogoutRequestedEvent>((event, emit) async {
      // 🛠️ First, clear saved user auth data
      await authBloc.viewModel.clearAuth();

      // Then, emit unauthenticated state
      authBloc.add(const AuthUnauthenticatedEvent());
    });
  }
}
