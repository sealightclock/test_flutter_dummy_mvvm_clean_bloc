import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/view/auth_screen.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/data/repository/auth_repository.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/usecase/login_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/usecase/signup_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/usecase/guest_login_use_case.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/auth/domain/usecase/get_user_auth_status_use_case.dart';
import 'features/my_string/presentation/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Testability for integration testing
    // Use RootRestorationScope to support widget lifecycle restore
    return RootRestorationScope(
      restorationId: 'root',
      child: MaterialApp(
        title: 'MVVM Clean + Bloc Demo',
        restorationScopeId: 'app', // Unique ID for restoration
        theme: AppTheme.lightTheme, // Shared app theme (light mode for now)

        // Set the initial screen as AuthScreen
        home: BlocProvider(
          create: (_) => AuthCubit(),
          child: AuthScreen(
            viewModel: AuthViewModel(
              loginUseCase: LoginUseCase(AuthRepository()),
              signUpUseCase: SignUpUseCase(AuthRepository()),
              guestLoginUseCase: GuestLoginUseCase(AuthRepository()),
              getUserAuthStatusUseCase: GetUserAuthStatusUseCase(AuthRepository()),
            ),
          ),
        ),
      ),
    );
  }
}
