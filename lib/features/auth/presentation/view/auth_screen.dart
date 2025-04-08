import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../my_string/presentation/view/my_string_home_screen.dart';
import '../bloc/auth_bloc.dart';
import '../viewmodel/auth_viewmodel.dart';

class AuthScreen extends StatefulWidget {
  final AuthViewModel viewModel;

  const AuthScreen({super.key, required this.viewModel});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showMoreOptions = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final user = await widget.viewModel.getUserAuthStatus();
    if (user != null && user.isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyStringHomeScreen()),
      );
    }
  }

  void _login() async {
    try {
      context.read<AuthCubit>().showLoading();
      await widget.viewModel.login(
        _usernameController.text,
        _passwordController.text,
      );
      context.read<AuthCubit>().authenticate();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyStringHomeScreen()),
      );
    } catch (e) {
      context.read<AuthCubit>().showError();
      _showError(e.toString());
    }
  }

  void _signUp() async {
    try {
      context.read<AuthCubit>().showLoading();
      await widget.viewModel.signUp(
        _usernameController.text,
        _passwordController.text,
      );
      context.read<AuthCubit>().authenticate();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyStringHomeScreen()),
      );
    } catch (e) {
      context.read<AuthCubit>().showError();
      _showError(e.toString());
    }
  }

  void _guestLogin() async {
    await widget.viewModel.guestLogin();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyStringHomeScreen()),
    );
  }

  void _showError(String errorMsg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMsg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Authentication'),
        ),
        body: SingleChildScrollView(
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
        ),
      ),
    );
  }
}
