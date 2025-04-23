import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../data/ble_filtered_device_data_source.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleViewModel viewModel;
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  bool _lastShowAll = false;
  String? _lastConnectedDeviceId;

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ??
      BleViewModel(
        ScanBleDevicesUseCase(BleFilteredDeviceDataSource(FlutterReactiveBle())),
        ConnectToBleDeviceUseCase(BleFilteredDeviceDataSource(FlutterReactiveBle())),
      ),
        super(BleInitial()) {
    on<StartScanEvent>((event, emit) async {
      final granted = await viewModel.requestPermissions();
      if (!granted) {
        emit(BleError("Permissions not granted"));
        return;
      }
      _lastShowAll = event.showAll;
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
        _lastConnectedDeviceId = event.deviceId;

        _connectionSub = viewModel.connectToDevice(event.deviceId).listen((update) {
          if (update.connectionState == DeviceConnectionState.connected) {
            emit(BleConnected(event.deviceId));
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            emit(BleDisconnected());
            _autoReconnectOrRescan();
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
      _autoReconnectOrRescan();
    });
  }

  void _autoReconnectOrRescan() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_lastConnectedDeviceId != null) {
      emit(BleReconnecting(_lastConnectedDeviceId!));
      add(DeviceSelectedEvent(_lastConnectedDeviceId!));
    } else {
      add(StartScanEvent(showAll: _lastShowAll));
    }
  }

  @override
  Future<void> close() {
    _connectionSub?.cancel();
    return super.close();
  }
}
