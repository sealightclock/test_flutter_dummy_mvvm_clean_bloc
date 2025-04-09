import 'package:bloc_test/bloc_test.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_event.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_state.dart';

/// Fake Bloc for testing AuthScreen
class FakeAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}
