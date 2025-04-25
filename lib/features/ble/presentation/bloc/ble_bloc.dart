import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

import '../../domain/entity/ble_device_entity.dart';
import '../factory/ble_viewmodel_factory.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'ble_event.dart';
import 'ble_state.dart';
import 'package:logger/logger.dart' as my_logger;

final logger = my_logger.Logger();

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleViewModel viewModel;
  StreamSubscription<List<BleDeviceEntity>>? _scanSub;
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  bool _lastShowAll = false;
  String? _lastConnectedDeviceId;
  List<BleDeviceEntity> _lastDevices = [];

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ?? BleViewModelFactory.create(),
        super(BleInitial()) {
    on<StartScanEvent>(_onStartScanEvent);
    on<StopScanEvent>(_onStopScanEvent);
    on<DeviceSelectedEvent>(_onDeviceSelectedEvent);
    on<DisconnectFromDeviceEvent>(_onDisconnectFromDeviceEvent);
    on<ShowReconnectingEvent>(_onShowReconnectingEvent);
  }

  Future<void> _onStartScanEvent(StartScanEvent event, Emitter<BleState> emit) async {
    final granted = await viewModel.requestPermissions();
    if (!granted) {
      emit(BleError("Permissions not granted"));
      return;
    }

    _lastShowAll = event.showAll;
    _lastDevices = [];

    emit(BleScanning());

    await _scanSub?.cancel();
    _scanSub = viewModel.scanBleDevices(showAll: event.showAll).listen(
          (devices) {
        _lastDevices = devices;
        if (!emit.isDone) {
          emit(BleDevicesFound(devices));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          emit(BleError("Scan failed: $error"));
        }
      },
    );
  }

  Future<void> _onStopScanEvent(StopScanEvent event, Emitter<BleState> emit) async {
    await _scanSub?.cancel();
    _scanSub = null;

    // Preserve the device list so user can still see results
    if (_lastDevices.isNotEmpty) {
      emit(BleDevicesFound(_lastDevices));
    } else {
      emit(BleInitial());
    }
  }

  Future<void> _onDeviceSelectedEvent(DeviceSelectedEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: DeviceSelectedEvent: event=[$event]");
    try {
      await _connectionSub?.cancel();
      _lastConnectedDeviceId = event.deviceId;

      _connectionSub = viewModel.connectToDevice(event.deviceId).listen((update) async {
        if (!emit.isDone) {
          if (update.connectionState == DeviceConnectionState.connected) {
            emit(BleConnected(event.deviceId, update: update));
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            emit(BleDisconnected(update));
            _autoReconnectOrRescan();
          }
        }
      });
    } catch (_) {
      if (!emit.isDone) {
        emit(BleError("Connection failed"));
      }
    }
  }

  Future<void> _onDisconnectFromDeviceEvent(DisconnectFromDeviceEvent event, Emitter<BleState> emit) async {
    await _connectionSub?.cancel();
    _connectionSub = null;
    emit(BleDisconnected(null));
    _autoReconnectOrRescan();
  }

  Future<void> _onShowReconnectingEvent(ShowReconnectingEvent event, Emitter<BleState> emit) async {
    emit(BleReconnecting(event.deviceId));
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
    _scanSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
