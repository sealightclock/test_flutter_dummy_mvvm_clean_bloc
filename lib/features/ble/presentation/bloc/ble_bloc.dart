import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../domain/usecase/scan_ble_devices_usecase.dart';
import '../../domain/usecase/connect_to_ble_device_usecase.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final ScanBleDevicesUseCase scanUseCase;
  final ConnectToBleDeviceUseCase connectUseCase;

  StreamSubscription<ConnectionStateUpdate>? _connectionSub;

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
        _connectionSub?.cancel();

        final stream = connectUseCase.connect(event.deviceId); // returns
        // Stream<ConnectionStateUpdate>

        _connectionSub = stream.listen((update) {
          if (update.connectionState == DeviceConnectionState.connected) {
            add(_emitConnected(event.deviceId));
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            add(DisconnectFromDeviceEvent());
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

    on<ConnectedInternally>((event, emit) {
      emit(BleConnected(event.deviceId));
    });
  }

  BleEvent _emitConnected(String deviceId) {
    return ConnectedInternally(deviceId); // defined below
  }

  @override
  Future<void> close() {
    _connectionSub?.cancel();
    return super.close();
  }
}

