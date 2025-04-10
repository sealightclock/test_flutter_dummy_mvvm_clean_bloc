import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';

/// HomeScreen manages the bottom navigation bar and switching between screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  /// GlobalKey to allow external control
  static final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool shouldAutoSwitchToMyString = false; // Auto-switch after login or guest login

  // Color constants
  static const Color strongColor = Colors.blueAccent;
  static const Color mediumColor = Colors.blueGrey;
  static const Color lightColor = Colors.grey;

  /// Public method to immediately jump to MyString tab
  void jumpToMyStringTabImmediately() {
    setState(() {
      _selectedIndex = 1;
      shouldAutoSwitchToMyString = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticatedState;

        // Auto-switch to MyString tab if needed (safety check)
        if (shouldAutoSwitchToMyString) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedIndex = 1;
                shouldAutoSwitchToMyString = false;
              });
            }
          });
        }

        // Determine which screen to show
        Widget body;
        if (_selectedIndex == 0) {
          body = const AuthScreen();
        } else if (_selectedIndex == 1) {
          if (isAuthenticated) {
            body = const MyStringScreen();
          } else {
            body = const Center(child: Text('Please log in first.'));
          }
        } else {
          body = const SizedBox.shrink();
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              if (!isAuthenticated && index == 1) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in first')),
                );
                return;
              }
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: [
              _buildBottomNavigationBarItem(
                index: 0,
                label: 'Auth',
                iconData: Icons.lock,
                enabled: true,
              ),
              _buildBottomNavigationBarItem(
                index: 1,
                label: 'MyString',
                iconData: Icons.storage,
                enabled: isAuthenticated,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Helper to build a BottomNavigationBarItem with dynamic color
  BottomNavigationBarItem _buildBottomNavigationBarItem({
    required int index,
    required String label,
    required IconData iconData,
    required bool enabled,
  }) {
    final bool isSelected = _selectedIndex == index;

    Color color;
    if (!enabled) {
      color = lightColor;
    } else if (isSelected) {
      color = strongColor;
    } else {
      color = mediumColor;
    }

    return BottomNavigationBarItem(
      icon: Icon(
        iconData,
        color: color,
      ),
      label: label,
    );
  }
}
