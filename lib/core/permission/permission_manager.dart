import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

/// Abstract list of permissions that can be requested by app features.
///
/// This keeps feature logic decoupled from platform-specific Permission enums.
enum AppPermission {
  location,
  bluetooth,
}

/// A centralized permission handler that abstracts platform-specific logic.
///
/// - Uses geolocator on iOS for location permission (for proper dialog triggering).
/// - Uses permission_handler on Android for BLE and location.
/// - Returns `true` if all requested permissions are granted.
/// - Keeps permission logic out of Bloc, ViewModel, and Domain layers.
class PermissionManager {
  /// Checks and requests all permissions in the given list.
  ///
  /// Returns true only if **all permissions are granted**.
  Future<bool> checkAndRequest(List<AppPermission> permissions) async {
    for (final permission in permissions) {
      final granted = await _handle(permission);
      if (!granted) return false;
    }
    return true;
  }

  /// Internal handler for each AppPermission.
  ///
  /// Maps high-level permission types to platform-specific logic.
  Future<bool> _handle(AppPermission permission) async {
    switch (permission) {
      case AppPermission.location:
        return await _checkLocationPermission();

      case AppPermission.bluetooth:
        return await _checkBluetoothPermissions();

    // If new AppPermissions are added in the future,
    // this switch ensures compile-time enforcement.
    }
  }

  /// Platform-aware logic for location permission:
  /// - iOS: Uses geolocator to trigger native dialog.
  /// - Android: Uses permission_handler.
  Future<bool> _checkLocationPermission() async {
    if (Platform.isIOS) {
      final status = await Geolocator.checkPermission();
      if (status == LocationPermission.denied) {
        final result = await Geolocator.requestPermission();
        return result == LocationPermission.whileInUse || result == LocationPermission.always;
      }
      return status == LocationPermission.whileInUse || status == LocationPermission.always;
    } else {
      final status = await Permission.location.status;
      if (status.isGranted) return true;
      final result = await Permission.location.request();
      return result.isGranted;
    }
  }

  /// Handles BLE-related permissions for Android.
  /// - iOS does not require runtime Bluetooth permissions.
  Future<bool> _checkBluetoothPermissions() async {
    if (!Platform.isAndroid) return true;

    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ];

    // Request all at once to avoid multiple dialogs.
    final statuses = await permissions.request();

    return statuses.values.every((status) => status.isGranted);
  }
}
