import 'package:test_flutter_dummy_mvvm_clean_bloc/features/ble/data/ble_device_repository.dart';

import '../../data/ble_device_data_source.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../viewmodel/ble_viewmodel.dart';

class BleViewModelFactory {
  static BleViewModel create() {
    // Create BLE plugin instance
    final ble = FlutterReactiveBle();

    // Wire up data source and repository
    final dataSource = BleDeviceDataSource(ble);

    // Set up use cases
    final scanUseCase = ScanBleDevicesUseCase(dataSource as BleDeviceRepository);
    final connectUseCase = ConnectToBleDeviceUseCase(dataSource as BleDeviceRepository);

    // Return ViewModel (Bloc will now create its own instance of BleViewModel)
    return BleViewModel(scanUseCase, connectUseCase);
  }
}
