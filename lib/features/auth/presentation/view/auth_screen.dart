import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/feedback_type_enum.dart';
import '../../../../core/feedback/global_feedback_handler.dart';
import '../../../../core/result/result.dart';
import '../../../../root_screen.dart';
import '../../../../shared/util/enums/app_tab_enum.dart';
import '../../domain/entity/auth_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

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

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final result = await _bloc.viewModel.getAuth();

    switch (result) {
      case Success<AuthEntity>(:final data):
        if (data.isLoggedIn) {
          _bloc.add(AuthAuthenticatedEvent(auth: data));
        } else {
          _bloc.add(const AuthUnauthenticatedEvent());
          _showSnackBarMessage(
              'You are not authenticated.', FeedbackType.warning);
        }
        break;

      case Failure<AuthEntity>(:final message):
        _bloc.add(const AuthUnauthenticatedEvent());
        _showSnackBarMessage('Error checking authentication status: $message',
            FeedbackType.error);
        break;
    }

    if (mounted) { // This check appears to be needed, as detected by
      // app_test.dart
      setState(() {
        _checkingAuthStatus = false;
      });
    }
  }

  void _login() async {
    _showSnackBarMessage('You are logged in as a user. You should be able to use all '
        'features.', FeedbackType.info);

    _bloc.add(const AuthStartEvent());
    try {
      await _bloc.viewModel.login(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      final result = await _bloc.viewModel.getAuth();

      switch (result) {
        case Success<AuthEntity>(:final data):
          if (data.isLoggedIn) {
            _bloc.add(AuthAuthenticatedEvent(auth: data));
            RootScreen.homeScreenKey.currentState?.shouldAutoSwitchToMyString = true;
          } else {
            _bloc.add(const AuthUnauthenticatedEvent());
            _showSnackBarMessage(
                'You are not authenticated.', FeedbackType.warning);
            }
          break;

        case Failure<AuthEntity>(:final message):
          _bloc.add(const AuthUnauthenticatedEvent());
          _showSnackBarMessage('Error checking authentication status: $message',
              FeedbackType.error);
          break;
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _signUp() async {
    _showSnackBarMessage('You are signed up as a new user and logged in. You should be able to use all features.', FeedbackType.info);

    _bloc.add(const AuthStartEvent());
    try {
      await _bloc.viewModel.signUp(
        _usernameController.text.trim(),
        _passwordController.text.trim(),
      );

      final result = await _bloc.viewModel.getAuth();

      switch (result) {
        case Success<AuthEntity>(:final data):
          if (data.isLoggedIn) {
            _bloc.add(AuthAuthenticatedEvent(auth: data));
            RootScreen.homeScreenKey.currentState?.shouldAutoSwitchToMyString = true;
          } else {
            _bloc.add(const AuthUnauthenticatedEvent());
            _showSnackBarMessage(
                'You are not authenticated.', FeedbackType.warning);
            }
          break;

        case Failure<AuthEntity>(:final message):
          _bloc.add(const AuthUnauthenticatedEvent());
          _showSnackBarMessage('Error checking authentication status: $message',
              FeedbackType.error);
          break;
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _guestLogin() async {
    _showSnackBarMessage('You are logged in as a guest. Many features are disabled!', FeedbackType.warning);

    _bloc.add(const AuthStartEvent());
    try {
      await _bloc.viewModel.guestLogin();

      _bloc.add(const AuthGuestAuthenticatedEvent());

      // Set global flag before rebuilding RootScreen
      forceStartOnMyStringScreen = true;

      if (mounted) { // This check appears to be needed, as detected by
        // Replace RootScreen to immediately jump to MyString tab
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const RootScreen()),
        );
      }
    } catch (e) {
      _bloc.add(AuthErrorEvent(message: e.toString()));
    }
  }

  void _showSnackBarMessage(String message, FeedbackType type) {
    showFeedback(context, message, type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTab.auth.title),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            _showSnackBarMessage(state.message, FeedbackType.error);
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
                        // Do not check mounted for button callbacks.
                        setState(() {
                          _showMoreOptions = !_showMoreOptions;
                        });
                      //}
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
                            _showSnackBarMessage('Contact us at info@jbmobility.io', FeedbackType.info);
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
