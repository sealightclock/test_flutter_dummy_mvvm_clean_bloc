import 'package:flutter/material.dart';

enum AppTab {
  auth('Auth', Icons.lock, false),
  myString('MyString', Icons.storage, true),
  account('A/C', Icons.person, true),
  settings('Settings', Icons.settings, false),
  ble('BLE', Icons.bluetooth, true),
  status('Status', Icons.location_on, true);

  final String label;
  final IconData icon;
  final bool _protected;

  const AppTab(this.label, this.icon, this._protected);

  bool isProtected() => _protected;

  static AppTab fromString(String name) {
    return AppTab.values.firstWhere(
          (tab) => tab.name == name,
      orElse: () => AppTab.auth,
    );
  }

  // Optional: add more tab-specific metadata (hint text, color, etc.)
}
