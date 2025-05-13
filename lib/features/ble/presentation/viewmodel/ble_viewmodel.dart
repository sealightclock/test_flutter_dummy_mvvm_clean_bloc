import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../../../app/core/permission/permission_manager.dart';
import '../../domain/entity/ble_device_entity.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';

/// ViewModel responsible for handling BLE use cases and permission checks.
///
/// This ViewModel is owned by the Bloc and used to coordinate BLE logic,
/// including scanning and connecting, and permission validation.
class BleViewModel {
  final ScanBleDevicesUseCase scanBleDevicesUseCase;
  final ConnectToBleDeviceUseCase connectToBleDeviceUseCase;
  final PermissionManager permissionManager;

  BleViewModel({
    required this.scanBleDevicesUseCase,
    required this.connectToBleDeviceUseCase,
    required this.permissionManager,
  });

  /// Starts scanning for BLE devices.
  ///
  /// This stream will emit a list of discovered [BleDeviceEntity]s.
  Stream<List<BleDeviceEntity>> scanBleDevices({required bool showAll}) {
    return scanBleDevicesUseCase.call(showAll: showAll);
  }

  /// Connects to a BLE device by its unique ID.
  ///
  /// This stream emits updates about the connection status.
  Stream<ConnectionStateUpdate> connectToDevice(String deviceId) {
    return connectToBleDeviceUseCase.call(deviceId);
  }

  /// Requests necessary BLE and Location permissions using the centralized PermissionManager.
  ///
  /// BLE requires bluetoothScan, bluetoothConnect, and precise (fine) location.
  /// This method delegates permission logic and platform safety to the shared manager.
  Future<bool> requestPermissions() async {
    return await permissionManager.checkAndRequest([
      AppPermission.bluetooth,
      AppPermission.location, // location is handled using geolocator on iOS
    ]);
  }
}
