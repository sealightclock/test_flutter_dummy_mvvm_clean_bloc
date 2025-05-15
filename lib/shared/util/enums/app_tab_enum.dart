import 'package:flutter/material.dart';

enum AppTab {
  auth('Auth', 'Authentication', Icons.lock, false),
  myString('MyString', 'Flutter MVVM Clean + Bloc', Icons.storage, true),
  account('A/C', 'Account Info', Icons.person, true),
  settings('Settings', 'App Settings', Icons.settings, false),
  ble('BLE', 'Bluetooth Devices', Icons.bluetooth, true),
  status('Status', 'Vehicle Status', Icons.location_on, true);

  final String label;     // For BottomNavigationBar
  final String title;     // For AppBar
  final IconData icon;    // Icon for nav bar
  final bool _protected;  // Access control

  const AppTab(this.label, this.title, this.icon, this._protected);

  bool isProtected() => _protected;

  static AppTab fromString(String name) {
    return AppTab.values.firstWhere(
          (tab) => tab.name == name,
      orElse: () => AppTab.auth,
    );
  }

  // Optional: add more tab-specific metadata (hint text, color, etc.)
}
