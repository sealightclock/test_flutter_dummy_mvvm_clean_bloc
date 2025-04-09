import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../util/result.dart';
import '../../../my_string/presentation/bloc/my_string_bloc.dart';
import '../../../my_string/presentation/view/my_string_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../factory/auth_viewmodel_factory.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  final AuthViewModel? injectedViewModel;
  final AuthBloc? injectedBloc;

  const AuthScreen({
    super.key,
    this.injectedViewModel,
    this.injectedBloc,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with WidgetsBindingObserver {
  late final AuthViewModel _viewModel;
  late final AuthBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _viewModel = widget.injectedViewModel ?? AuthViewModelFactory.create();
    _bloc = widget.injectedBloc ?? AuthBloc();

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final result = await _viewModel.getUserAuthStatus();

    if (result?.isLoggedIn == true) {
      _navigateToMyStringScreen();
    }
  }

  void _navigateToMyStringScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => BlocProvider<MyStringBloc>(
          create: (_) => MyStringBloc(),
          child: const MyStringScreen(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
          centerTitle: true,
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthAuthenticatedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _navigateToMyStringScreen();
              });
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthErrorState) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return _buildAuthOptions();
            }
          },
        ),
      ),
    );
  }

  Widget _buildAuthOptions() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () async {
              _bloc.add(AuthLoadingEvent());
              final result = await _viewModel.login('test_user', 'password');
              await _handleResult(result);
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              _bloc.add(AuthLoadingEvent());
              final result = await _viewModel.signUp('test_user', 'password');
              await _handleResult(result);
            },
            child: const Text('Sign Up'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              _bloc.add(AuthLoadingEvent());
              final result = await _viewModel.guestLogin();
              await _handleResult(result);
            },
            child: const Text('More Options'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleResult(Result<void> result) async {
    if (result is Success) {
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      }
    } else if (result is Failure) {
      _bloc.add(AuthErrorEvent(message: result.message));
    }
  }
}
