import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../my_string/presentation/view/my_string_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../factory/auth_viewmodel_factory.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthViewModel _viewModel;
  late AuthBloc _bloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showMoreOptions = false;

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModelFactory.create();
    _bloc = AuthBloc();

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final user = await _viewModel.getUserAuthStatus();
      if (user != null && user.isLoggedIn) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      } else {
        _bloc.add(AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthUnauthenticatedEvent());
    }
  }

  void _login() async {
    _bloc.add(AuthLoadingEvent());
    try {
      await _viewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      } else {
        _bloc.add(AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _signUp() async {
    _bloc.add(AuthLoadingEvent());
    try {
      await _viewModel.signUp(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      } else {
        _bloc.add(AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _guestLogin() async {
    _bloc.add(AuthLoadingEvent());
    try {
      await _viewModel.guestLogin();
      final user = await _viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      } else {
        _bloc.add(AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _showError(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MyStringScreen()),
              );
            } else if (state is AuthError) {
              _showError(state.message);
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                    ),
                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: _signUp,
                      child: const Text('Sign Up'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showMoreOptions = !_showMoreOptions;
                        });
                      },
                      child: const Text('More Options'),
                    ),
                    if (_showMoreOptions)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: _guestLogin,
                            child: const Text('Guest Login'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _showError('Contact us at support@example.com');
                            },
                            child: const Text('Contact Us'),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
