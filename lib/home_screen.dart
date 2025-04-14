import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';
import 'features/account/presentation/view/account_screen.dart'; // 🆕 Import AccountScreen

/// Global flag to control initial tab when HomeScreen is rebuilt
bool forceStartOnMyStringScreen = false;

/// HomeScreen manages the bottom navigation bar and switching between screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool shouldAutoSwitchToMyString = false;

  static const Color strongColor = Colors.blueAccent;
  static const Color mediumColor = Colors.blueGrey;
  static const Color lightColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    // If forced by Guest Login, start directly on MyString tab
    if (forceStartOnMyStringScreen) {
      _selectedIndex = 1;
      forceStartOnMyStringScreen = false; // reset after using it
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticatedState || state is AuthGuestAuthenticatedState;

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

        // 🛠️ NEW: Handle logout -> move back to Auth tab
        if (state is AuthUnauthenticatedState && _selectedIndex != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedIndex = 0;
              });
            }
          });
        }

        Widget body;
        if (_selectedIndex == 0) {
          body = const AuthScreen();
        } else if (_selectedIndex == 1) {
          if (isAuthenticated) {
            body = const MyStringScreen();
          } else {
            body = const Center(child: Text('Please log in first.'));
          }
        } else if (_selectedIndex == 2) {
          if (isAuthenticated) {
            body = const AccountScreen();
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
              if (!isAuthenticated && (index == 1 || index == 2)) {
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
              _buildBottomNavigationBarItem(
                index: 2,
                label: 'Account',
                iconData: Icons.person,
                enabled: isAuthenticated,
              ),
            ],
          ),
        );
      },
    );
  }

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
