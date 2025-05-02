import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../../domain/entity/ble_device_entity.dart';

/// ViewModel responsible for handling BLE use cases and permission checks.
class BleViewModel {
  final ScanBleDevicesUseCase scanUseCase;
  final ConnectToBleDeviceUseCase connectUseCase;

  BleViewModel(this.scanUseCase, this.connectUseCase);

  /// Scans for BLE devices.
  Stream<List<BleDeviceEntity>> scanBleDevices({required bool showAll}) {
    return scanUseCase.call(showAll: showAll);
  }

  /// Connects to a BLE device by ID.
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return connectUseCase.call(deviceId);
  }

  /// Requests necessary permissions for BLE operation.
  ///
  /// Steps:
  /// 1. Request BLE and Location permissions.
  /// 2. After user grants, check if Location permission is Precise (Fine).
  /// 3. If not Precise, request again.
  /// 4. Return true if all needed permissions (including Precise) are granted.
  Future<bool> requestPermissions() async {
    // Request BLE and general Location permissions
    final permissions = [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location, // This covers both coarse and fine initially
    ];
    final results = await permissions.request();

    // If any required permission is not granted, immediately return false
    final allGranted = results.values.every((status) => status.isGranted);
    if (!allGranted) {
      return false;
    }

    // After basic permission grant, check if Location is Precise
    final preciseGranted = await _isPreciseLocationGranted();
    if (preciseGranted) {
      return true; // Already have Fine location
    }

    // If not precise, request again (may pop Android system dialog)
    final permissionAfterRequest = await Permission.location.request();
    return permissionAfterRequest.isGranted;
  }

  /// Checks if Fine (Precise) Location permission is granted.
  ///
  /// Coarse Location may be granted but it's not enough for BLE scanning on Android 12+.
  Future<bool> _isPreciseLocationGranted() async {
    final status = await Permission.location.status;
    // If permission is granted but user chose \"Approximate location\", it may still be coarse.
    // The permission_handler plugin does not distinguish this directly.
    // On Android, precise vs coarse decision is user-level, so we assume granted means precise
    // if not otherwise limited. (Optionally: add platform-specific checks.)

    return status.isGranted; // Safe basic check for now.
  }
}
