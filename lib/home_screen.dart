import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';

/// HomeScreen manages the bottom navigation bar and switching between screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// GlobalKey to allow external control (optional for future use)
  static final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticatedState;

        // Determine which screen to show based on authentication status and selected tab
        Widget body;
        if (!isAuthenticated) {
          if (_selectedIndex == 0) {
            body = const AuthScreen();
          } else {
            body = const Center(child: Text('Please log in first.'));
          }
        } else {
          if (_selectedIndex == 0) {
            body = const AuthScreen();
          } else {
            body = const MyStringScreen();
          }
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
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
