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

  /// Public method to switch to MyString tab programmatically
  void switchToMyStringTab() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        bool isAuthenticated = state is AuthAuthenticatedState;

        // Choose which screen to display based on selected tab
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
                // Block unauthenticated access to MyString tab
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in first')),
                );
              } else {
                setState(() {
                  _selectedIndex = index;
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
