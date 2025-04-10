import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';

/// HomeScreen manages the bottom navigation bar and switching between screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// GlobalKey to allow external control (ex: from AuthScreen)
  static final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _alreadyRedirected = false; // To prevent multiple redirects

  /// Public method to manually switch to MyString tab
  void switchToMyStringTab() {
    setState(() {
      _selectedIndex = 1;
      _alreadyRedirected = true; // Also mark redirected
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isAuthenticated = state is AuthAuthenticatedState;

        // Auto-switch to MyString tab if authenticated and still on Auth tab
        if (isAuthenticated && _selectedIndex == 0 && !_alreadyRedirected) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _selectedIndex = 1;
              _alreadyRedirected = true;
            });
          });
        }

        // Determine which screen to show based on selected tab
        Widget body;
        if (_selectedIndex == 0) {
          body = const AuthScreen();
        } else {
          if (isAuthenticated) {
            body = const MyStringScreen();
          } else {
            body = const Center(child: Text('Please log in first.'));
          }
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (index == 1 && !isAuthenticated) {
                // Prevent unauthenticated access to MyString
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in first')),
                );
              } else {
                setState(() {
                  _selectedIndex = index;
                  _alreadyRedirected = false; // Reset redirect flag when user manually navigates
                });
              }
            },
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Auth',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.storage),
                label: 'MyString',
              ),
            ],
          ),
        );
      },
    );
  }
}
