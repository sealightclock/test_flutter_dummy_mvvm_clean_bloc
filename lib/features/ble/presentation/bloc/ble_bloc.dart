import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../factory/ble_viewmodel_factory.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'ble_event.dart';
import 'ble_state.dart';

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleViewModel viewModel;
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  bool _lastShowAll = false;
  String? _lastConnectedDeviceId;

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ?? BleViewModelFactory.create(),
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
        viewModel.scanBleDevices(showAll: event.showAll),
        onData: (devices) => BleDevicesFound(devices),
        onError: (_, __) => BleError("Scan failed"),
      );
    });

    on<DeviceSelectedEvent>((event, emit) async {
      try {
        await _connectionSub?.cancel();
        _lastConnectedDeviceId = event.deviceId;

        _connectionSub = viewModel.connectToDevice(event.deviceId).listen((update) async {
          if (!emit.isDone) {
            if (update.connectionState == DeviceConnectionState.connected) {
              emit(BleConnected(event.deviceId));
            } else if (update.connectionState == DeviceConnectionState.disconnected) {
              emit(BleDisconnected());
              _autoReconnectOrRescan();
            }
          }
        });
      } catch (_) {
        if (!emit.isDone) {
          emit(BleError("Connection failed"));
        }
      }
    });

    on<DisconnectFromDeviceEvent>((event, emit) async {
      await _connectionSub?.cancel();
      _connectionSub = null;
      emit(BleDisconnected());
      _autoReconnectOrRescan();
    });

    on<ShowReconnectingEvent>((event, emit) {
      emit(BleReconnecting(event.deviceId));
    });
  }

  void _autoReconnectOrRescan() async {
    await Future.delayed(const Duration(seconds: 1));

    if (_lastConnectedDeviceId != null) {
      add(ShowReconnectingEvent(_lastConnectedDeviceId!));
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
