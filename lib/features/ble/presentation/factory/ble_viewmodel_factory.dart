import '../../data/ble_device_data_source.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../bloc/ble_bloc.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleViewModelFactory {
  static BleViewModel create() {
    // Set up BLE plugin instance
    final ble = FlutterReactiveBle();

    // Set up data source and repo
    final dataSource = BleDeviceDataSource(ble);

    // Set up use cases
    final scanUseCase = ScanBleDevicesUseCase(dataSource);
    final connectUseCase = ConnectToBleDeviceUseCase(dataSource);

    // Set up Bloc
    final bloc = BleBloc(scanUseCase, connectUseCase);

    // Return ViewModel
    return BleViewModel(bloc);
  }
}
