import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../../../core/core/permission/permission_manager.dart';
import '../../data/datasource/platform/ble_device_data_source.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../viewmodel/ble_viewmodel.dart';

/// Factory for creating a BLE ViewModel with proper dependencies.
///
/// Used by Bloc to instantiate a feature-specific ViewModel.
class BleViewModelFactory {
  static BleViewModel create() {
    // Create BLE plugin instance (or API)
    final bleApi = FlutterReactiveBle();

    // Set up data source
    final dataSource = BleDeviceDataSource(bleApi);

    // TODO: Since we don't need multiple data sources, we can just use the
    //   single data source for the repository:
    final repository = dataSource;

    // Set up use cases
    final scanBleDevicesUseCase = ScanBleDevicesUseCase(repository: repository);
    final connectToBleDeviceUseCase = ConnectToBleDeviceUseCase(repository: repository);

    // Return ViewModel (Bloc will now create its own instance of BleViewModel)
    return BleViewModel(
      scanBleDevicesUseCase: scanBleDevicesUseCase,
      connectToBleDeviceUseCase: connectToBleDeviceUseCase,
      permissionManager: PermissionManager(), // centralized permission handling
    );
  }
}
