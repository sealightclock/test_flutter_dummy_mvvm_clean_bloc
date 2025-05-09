import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

/// Enum representing app-level abstract permissions.
///
/// Features can request a combination of these without knowing platform details.
enum AppPermission {
  location,         // Fine or coarse location
  bluetooth,        // Bluetooth scan + connect
}

/// A centralized permission manager to abstract platform permission handling.
///
/// This helps features avoid duplicating permission logic.
/// Uses permission_handler for Android and geolocator on iOS for location.
class PermissionManager {
  /// Checks and requests a list of app permissions.
  ///
  /// Returns true only if **all requested permissions are granted**.
  Future<bool> checkAndRequest(List<AppPermission> permissions) async {
    for (final permission in permissions) {
      final granted = await _handle(permission);
      if (!granted) return false;
    }
    return true;
  }

  /// Internal dispatcher to handle each AppPermission type.
  Future<bool> _handle(AppPermission permission) async {
    switch (permission) {
      case AppPermission.location:
        return Platform.isIOS
            ? _checkGeolocatorLocation()
            : _checkPermissionHandler(Permission.location);

      case AppPermission.bluetooth:
        return await _checkPermissionHandler(Permission.bluetoothScan) &&
            await _checkPermissionHandler(Permission.bluetoothConnect);
    }
  }

  /// Uses permission_handler to check and request Android permissions.
  Future<bool> _checkPermissionHandler(Permission permission) async {
    final status = await permission.status;
    if (status.isGranted) return true;

    final result = await permission.request();
    return result.isGranted;
  }

  /// Uses geolocator for iOS location permission checks.
  ///
  /// Needed because permission_handler does not trigger iOS dialog reliably.
  Future<bool> _checkGeolocatorLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      final newStatus = await Geolocator.requestPermission();
      return newStatus == LocationPermission.always ||
          newStatus == LocationPermission.whileInUse;
    }
    return status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
  }
}
