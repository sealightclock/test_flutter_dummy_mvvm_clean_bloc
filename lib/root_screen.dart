import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart' as my_logger;

import 'app/core/storage/app_hive_data_source.dart';
import 'app/util/constants/app_constants.dart';
import 'app/util/enums/app_tab_enum.dart';
import 'app/util/enums/feedback_type_enum.dart';
import 'app/util/feedback/global_feedback_handler.dart';
import 'features/account/presentation/view/account_screen.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/view/auth_screen.dart';
import 'features/ble/presentation/view/ble_screen.dart';
import 'features/my_string/presentation/view/my_string_screen.dart';
import 'features/settings/presentation/view/settings_screen.dart';
import 'features/vehicle_status/presentation/view/vehicle_status_screen.dart';

final logger = my_logger.Logger();

/// Global flag to force opening MyString screen (used by tests or special flows)
bool forceStartOnMyStringScreen = false;

/// Extension for tab metadata like label, icon, and protection
extension AppTabExtension on AppTab {
  String get label {
    switch (this) {
      case AppTab.auth:
        return AppConstants.authLabel;
      case AppTab.myString:
        return AppConstants.myStringLabel;
      case AppTab.account:
        return AppConstants.accountLabel;
      case AppTab.settings:
        return AppConstants.settingsLabel;
      case AppTab.ble:
        return AppConstants.bleLabel;
      case AppTab.status:
        return AppConstants.statusLabel;
      // TODO: Add more tabs here
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
      case AppTab.settings:
        return Icons.settings;
      case AppTab.ble:
        return Icons.bluetooth;
      case AppTab.status:
        return Icons.location_on;
      // TODO: Add more tabs here
    }
  }

  bool isProtected() => this == AppTab.myString || this == AppTab.account;

  static AppTab fromString(String name) {
    return AppTab.values.firstWhere(
          (tab) => tab.name == name,
      orElse: () => AppTab.auth,
    );
  }
}

/// RootScreen shows the main bottom navigation bar and manages screen switching
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  static final GlobalKey<RootScreenState> homeScreenKey = GlobalKey<RootScreenState>();

  @override
  State<RootScreen> createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
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
    } else {
      // Try restoring the last seen screen from Hive
      _restoreLastSeenTab();
    }
  }

  /// Asynchronously restore last selected tab from Hive
  void _restoreLastSeenTab() async {
    final restoredTab = await AppHiveDataSource.getLastSeenTab();
    if (mounted) {
      setState(() {
        _selectedTab = restoredTab;
      });
    }
  }

  /// Persist current selected tab when changed
  void _saveLastSeenTab(AppTab tab) {
    AppHiveDataSource.saveLastSeenTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isAuthenticated = state is AuthAuthenticatedState || state is AuthGuestAuthenticatedState;

        if (shouldAutoSwitchToMyString) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) { // TODO: This check may not be needed.
              setState(() {
                _selectedTab = AppTab.myString;
                shouldAutoSwitchToMyString = false;
              });
            }
          });
        }

        if (state is AuthUnauthenticatedState && _selectedTab.isProtected()) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) { // TODO: This check may not be needed.
              setState(() {
                _selectedTab = AppTab.auth;
              });
            }
          });
        }

        Widget body;

        logger.t('TFDB: RootScreen: build: _selectedTab: $_selectedTab');

        switch (_selectedTab) {
          case AppTab.auth:
            body = const AuthScreen();
            break;
          case AppTab.myString:
            body = isAuthenticated
                ? const MyStringScreen()
                : const Center(child: Text('Please log in first.'));
            break;
          case AppTab.account:
            body = isAuthenticated
                ? const AccountScreen()
                : const Center(child: Text('Please log in first.'));
            break;
          case AppTab.settings:
            body = const SettingsScreen();
            break;
          case AppTab.ble:
            body = isAuthenticated
                ? BleScreen()
                : const Center(child: Text('Please log in first.'));
            break;
          case AppTab.status:
            body = isAuthenticated
                ? VehicleStatusScreen()
                : const Center(child: Text('Please log in first.'));
            break;
          // TODO: Add more tabs here
        }

        return Scaffold(
          body: body,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedTab.index,
            onTap: (index) {
              final tappedTab = AppTab.values[index];
              if (!isAuthenticated && tappedTab.isProtected()) {
                showFeedback(context, 'Please log in first', FeedbackType.warning);
                return;
              }
              if (mounted) { // TODO: This check may not be needed.
                setState(() {
                  _selectedTab = tappedTab;
                });
              }
              _saveLastSeenTab(tappedTab);
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
