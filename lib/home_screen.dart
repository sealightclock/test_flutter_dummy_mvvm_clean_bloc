import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/account/presentation/view/account_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';

/// Global flag to control initial tab when HomeScreen is rebuilt
bool forceStartOnMyStringScreen = false;

/// Enum for each tab in the BottomNavigationBar
enum AppTab { auth, myString, account }

/// Extension to provide metadata for each tab
extension AppTabExtension on AppTab {
  String get label {
    switch (this) {
      case AppTab.auth:
        return 'Auth';
      case AppTab.myString:
        return 'MyString';
      case AppTab.account:
        return 'Account';
    }
  }

  IconData get icon {
    switch (this) {
      case AppTab.auth:
        return Icons.lock;
      case AppTab.myString:
        return Icons.storage;
      case AppTab.account:
        return Icons.person;
    }
  }

  bool isProtected() => this == AppTab.myString || this == AppTab.account;
}

/// HomeScreen manages the bottom navigation bar and switching between screens.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  AppTab _selectedTab = AppTab.auth;
  bool shouldAutoSwitchToMyString = false;

  static const Color strongColor = Colors.blueAccent;
  static const Color mediumColor = Colors.blueGrey;
  static const Color lightColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    if (forceStartOnMyStringScreen) {
      _selectedTab = AppTab.myString;
      forceStartOnMyStringScreen = false;
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
                _selectedTab = AppTab.myString;
                shouldAutoSwitchToMyString = false;
              });
            }
          });
        }

        if (state is AuthUnauthenticatedState && _selectedTab != AppTab.auth) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedTab = AppTab.auth;
              });
            }
          });
        }

        Widget body;
        switch (_selectedTab) {
          case AppTab.auth:
            body = const AuthScreen();
            break;
          case AppTab.myString:
            body = isAuthenticated ? const MyStringScreen() : const Center(child: Text('Please log in first.'));
            break;
          case AppTab.account:
            body = isAuthenticated ? const AccountScreen() : const Center(child: Text('Please log in first.'));
            break;
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedTab.index,
            onTap: (index) {
              final tappedTab = AppTab.values[index];
              if (!isAuthenticated && tappedTab.isProtected()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please log in first')),
                );
                return;
              }
              setState(() {
                _selectedTab = tappedTab;
              });
            },
            type: BottomNavigationBarType.fixed,
            elevation: 10,
            items: AppTab.values.map((tab) => _buildBottomNavigationBarItem(tab, isAuthenticated)).toList(),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(AppTab tab, bool isAuthenticated) {
    final bool isSelected = _selectedTab == tab;
    final bool enabled = !tab.isProtected() || isAuthenticated;

    Color color;
    if (!enabled) {
      color = lightColor;
    } else if (isSelected) {
      color = strongColor;
    } else {
      color = mediumColor;
    }

    return BottomNavigationBarItem(
      icon: Icon(tab.icon, color: color),
      label: tab.label,
    );
  }
}
