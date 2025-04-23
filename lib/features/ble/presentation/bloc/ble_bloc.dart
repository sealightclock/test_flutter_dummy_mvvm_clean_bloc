import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final ScanBleDevicesUseCase scanUseCase;
  final ConnectToBleDeviceUseCase connectUseCase;

  BleBloc(this.scanUseCase, this.connectUseCase) : super(BleInitial()) {
    on<StartScanEvent>((event, emit) async {
      emit(BleScanning());
      await emit.forEach(
        scanUseCase.execute(),
        onData: (devices) => BleDevicesFound(devices),
        onError: (_, __) => BleError("Scan failed"),
      );
    });

    on<DeviceSelectedEvent>((event, emit) async {
      try {
        await connectUseCase.execute(event.deviceId);
        emit(BleConnected());
      } catch (e) {
        emit(BleError("Connection failed"));
      }
    });
  }
}
