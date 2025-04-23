import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/ble/data/ble_device_repository.dart';

import '../../data/ble_filtered_device_data_source.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleViewModel viewModel;
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ?? BleViewModel(
    ScanBleDevicesUseCase(BleFilteredDeviceDataSource(FlutterReactiveBle()) as BleDeviceRepository),
    ConnectToBleDeviceUseCase(BleFilteredDeviceDataSource(FlutterReactiveBle()) as BleDeviceRepository),
  ),
        super(BleInitial()) {
    on<StartScanEvent>((event, emit) async {
      emit(BleScanning());
      await emit.forEach(
        viewModel.scanBleDevices(),
        onData: (devices) => BleDevicesFound(devices),
        onError: (_, __) => BleError("Scan failed"),
      );
    });

    on<DeviceSelectedEvent>((event, emit) async {
      try {
        _connectionSub?.cancel();
        _connectionSub = viewModel.connectToDevice(event.deviceId).listen((update) {
          if (update.connectionState == DeviceConnectionState.connected) {
            emit(BleConnected(event.deviceId));
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            emit(BleDisconnected());
          }
        });
      } catch (_) {
        emit(BleError("Connection failed"));
      }
    });

    on<DisconnectFromDeviceEvent>((event, emit) async {
      await _connectionSub?.cancel();
      _connectionSub = null;
      emit(BleDisconnected());
    });
  }

  @override
  Future<void> close() {
    _connectionSub?.cancel();
    return super.close();
  }
}
