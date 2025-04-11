import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../home_screen.dart'; // Import HomeScreen
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../factory/auth_viewmodel_factory.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  late AuthBloc _bloc;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showMoreOptions = false;
  bool _checkingAuthStatus = true;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AuthBloc>(context);
    _bloc.viewModel = AuthViewModelFactory.create();

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final user = await _bloc.viewModel.getUserAuthStatus();
      if (user != null && user.isLoggedIn) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
      } else {
        _bloc.add(const AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(const AuthUnauthenticatedEvent());
    } finally {
      setState(() {
        _checkingAuthStatus = false;
      });
    }
  }

  void _login() async {
    _bloc.add(const AuthLoadingEvent());
    try {
      await _bloc.viewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      final user = await _bloc.viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
        HomeScreen.homeScreenKey.currentState?.shouldAutoSwitchToMyString = true;
      } else {
        _bloc.add(const AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _signUp() async {
    _bloc.add(const AuthLoadingEvent());
    try {
      await _bloc.viewModel.signUp(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );
      final user = await _bloc.viewModel.getUserAuthStatus();
      if (user != null) {
        _bloc.add(AuthAuthenticatedEvent(user: user));
        HomeScreen.homeScreenKey.currentState?.shouldAutoSwitchToMyString = true;
      } else {
        _bloc.add(const AuthUnauthenticatedEvent());
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _guestLogin() async {
    _bloc.add(const AuthLoadingEvent());
    try {
      await _bloc.viewModel.guestLogin();

      _bloc.add(const AuthGuestAuthenticatedEvent());

      // Set global flag before rebuilding HomeScreen
      forceStartOnMyStringScreen = true;

      if (!mounted) return; // Check if the widget is still mounted)

      // Replace HomeScreen to immediately jump to MyString tab
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            _showError(state.message);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (_checkingAuthStatus) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthLoadingState) {
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
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showMoreOptions = !_showMoreOptions;
                      });
                    },
                    child: Text(_showMoreOptions ? 'Fewer Options' : 'More Options'),
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
    );
  }
}
