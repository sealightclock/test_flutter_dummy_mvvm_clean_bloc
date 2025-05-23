import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:logger/logger.dart' as my_logger;

import '../../domain/entity/ble_device_entity.dart';
import '../viewmodel/ble_viewmodel_factory.dart';
import '../viewmodel/ble_viewmodel.dart';
import 'ble_event.dart';
import 'ble_state.dart';

final logger = my_logger.Logger();

class BleBloc extends Bloc<BleEvent, BleState> {
  final BleViewModel viewModel;

  StreamSubscription<List<BleDeviceEntity>>? _scanSub;
  StreamSubscription<ConnectionStateUpdate>? _connectionSub;
  Timer? _connectionTimeoutTimer;
  bool _lastShowAll = false;
  String? _lastConnectedDeviceId;
  List<BleDeviceEntity> _lastDevices = [];

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ?? BleViewModelFactory.create(),
        super(BleInitialState()) {
    on<BleStartScanEvent>(_onStartScanEvent);
    on<BleStopScanEvent>(_onStopScanEvent);
    on<BleSelectDeviceEvent>(_onDeviceSelectedEvent);
    on<BleDisconnectDeviceEvent>(_onDisconnectFromDeviceEvent);
    on<BleShowReconnectingDeviceEvent>(_onShowReconnectingEvent);
  }

  Future<void> _onStartScanEvent(BleStartScanEvent event, Emitter<BleState> emit) async {
    final granted = await viewModel.requestPermissions();
    if (!granted) {
      if (state is! BleErrorState ||
          (state as BleErrorState).message != "Permissions not granted") {
        emit(BleErrorState("Permissions not granted"));
      }
      return;
    }

    _lastShowAll = event.showAll;
    _lastDevices = [];

    if (state is! BleScanningState) {
      emit(BleScanningState());
    }

    await _scanSub?.cancel();
    _scanSub = viewModel.scanBleDevices(showAll: event.showAll).listen(
          (devices) {
        _lastDevices = devices;
        if (!emit.isDone) {
          if (state is! BleDevicesFoundState ||
              (state as BleDevicesFoundState).devices != devices) {
            emit(BleDevicesFoundState(devices));
          }
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          if (state is! BleErrorState ||
              (state as BleErrorState).message != "Scan failed: $error") {
            emit(BleErrorState("Scan failed: $error"));
          }
        }
      },
    );
  }

  Future<void> _onStopScanEvent(BleStopScanEvent event, Emitter<BleState> emit) async {
    await _scanSub?.cancel();
    _scanSub = null;

    if (_lastDevices.isNotEmpty) {
      if (state is! BleDevicesFoundState ||
          (state as BleDevicesFoundState).devices != _lastDevices) {
        emit(BleDevicesFoundState(_lastDevices));
      }
    } else {
      if (state is! BleInitialState) {
        emit(BleInitialState());
      }
    }
  }

  Future<void> _onDeviceSelectedEvent(BleSelectDeviceEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: DeviceSelectedEvent: event=[$event]");

    try {
      await _connectionSub?.cancel();
      _lastConnectedDeviceId = event.deviceId;
      _cancelConnectionTimeoutTimer();

      _connectionSub = viewModel.connectToDevice(event.deviceId).listen((update) async {
        if (!emit.isDone) {
          logger.t("TFDB: BleBloc: _onDeviceSelectedEvent: emit.isDone==false "
              "while update=[$update]");

          if (update.connectionState == DeviceConnectionState.connecting) {
            _startConnectionTimeoutTimer(event.deviceId);
          } else if (update.connectionState == DeviceConnectionState.connected) {
            _cancelConnectionTimeoutTimer();
            // Delay a little to wait for immediate disconnect
            await Future.delayed(const Duration(milliseconds: 500));

            if (!emit.isDone && update.failure == null) {
              if (state is! BleDeviceConnectedState ||
                  (state as BleDeviceConnectedState).deviceId != event.deviceId ||
                  (state as BleDeviceConnectedState).connectionStatusUpdate != update) {
                emit(BleDeviceConnectedState(event.deviceId, connectionStatusUpdate: update));
              }
            }
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            _cancelConnectionTimeoutTimer();
            if (update.failure != null) {
              if (state is! BleErrorState ||
                  (state as BleErrorState).message != "Connection failed: "
                      "${update.failure!.code.name}") {
                emit(BleErrorState(
                    "Connection failed: ${update.failure!.code.name}"));
              }
            } else {
              if (state is! BleDeviceDisconnectedState ||
                  (state as BleDeviceDisconnectedState).deviceId != event.deviceId ||
                  (state as BleDeviceDisconnectedState).devices != _lastDevices) {
                emit(BleDeviceDisconnectedState(event.deviceId, _lastDevices));
              }
              _autoReconnectOrRescan();
            }
          } else {
            logger.e(
                "TFDB: BleBloc: _onDeviceSelectedEvent: unexpected update.connectionState=[${update.connectionState}]");
          }
        } else {
          logger.w("TFDB: BleBloc: _onDeviceSelectedEvent: emit.isDone==true while update=[$update]");

          _handleConnectionUpdateOutsideEmit(update);
        }
      });
    } catch (e, stackTrace) {
      logger.e("TFDB: BleBloc: _onDeviceSelectedEvent: error=$e, stackTrace=$stackTrace");

      if (!emit.isDone) {
        if (state is! BleErrorState ||
            (state as BleErrorState).message != "Connection failed") {
          emit(BleErrorState("Connection failed"));
        }
      } else {
        logger.e("TFDB: BleBloc: _onDeviceSelectedEvent: emit.isDone==true");
      }
    }
  }

  void _startConnectionTimeoutTimer(String deviceId) {
    logger.w("TFDB: BleBloc: _startConnectionTimeoutTimer: "
        "deviceId=[$deviceId]: Connection "
        "timeout. Forcing disconnect...");

    _cancelConnectionTimeoutTimer();
    _connectionTimeoutTimer = Timer(const Duration(seconds: 10), () {
      add(BleDisconnectDeviceEvent(deviceId));
    });
  }

  void _cancelConnectionTimeoutTimer() {
    // logger.w("TFDB: BleBloc: _cancelConnectionTimeoutTimer: Cancelling "
    //     "connection timeout timer...");

    _connectionTimeoutTimer?.cancel();
    _connectionTimeoutTimer = null;
  }

  void _handleConnectionUpdateOutsideEmit(ConnectionStateUpdate update) {
    logger.w("TFDB: BleBloc: _handleConnectionUpdateOutsideEmit: "
        "update=[$update]");

    if (update.connectionState == DeviceConnectionState.disconnected) {
      if (update.failure != null) {
        logger.e("TFDB: BleBloc: "
            "_handleConnectionUpdateOutsideEmit: Disconnected with failure: "
            "${update.failure!
            .code.name}");
      } else {
        logger.w("TFDB: BleBloc: "
            "_handleConnectionUpdateOutsideEmit: Disconnected silently (no "
            "failure captured)");
      }

      add(BleDisconnectDeviceEvent(_lastConnectedDeviceId!));
    } else if (update.connectionState == DeviceConnectionState.connecting) {
      _startConnectionTimeoutTimer(_lastConnectedDeviceId!);
    } else {
      logger.e("TFDB: BleBloc: "
          "_handleConnectionUpdateOutsideEmit: Unexpected connection state: "
          "${update.connectionState}");
    }
  }

  Future<void> _onDisconnectFromDeviceEvent(BleDisconnectDeviceEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: _onDisconnectFromDeviceEvent: event=[$event]");

    await _connectionSub?.cancel();
    _connectionSub = null;
    _cancelConnectionTimeoutTimer();

    if (state is! BleDeviceConnectedState ||
        (state as BleDeviceConnectedState).deviceId != event.deviceId ||
        (state as BleDeviceConnectedState).devices != _lastDevices) {
      emit(BleDeviceDisconnectedState(event.deviceId, _lastDevices));
    }

    //JZ _autoReconnectOrRescan();
  }

  Future<void> _onShowReconnectingEvent(BleShowReconnectingDeviceEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: _onShowReconnectingEvent: event=[$event]");

    if (state is! BleDeviceReconnectingState ||
        (state as BleDeviceReconnectingState).deviceId != event.deviceId) {
      emit(BleDeviceReconnectingState(event.deviceId));
    }
  }

  void _autoReconnectOrRescan() async {
    logger.d("TFDB: BleBloc: _autoReconnectOrRescan: Auto-reconnecting...");

    await Future.delayed(const Duration(seconds: 1));

    if (_lastConnectedDeviceId != null) {
      add(BleShowReconnectingDeviceEvent(_lastConnectedDeviceId!));
      add(BleSelectDeviceEvent(_lastConnectedDeviceId!));
    } else {
      add(BleStartScanEvent(showAll: _lastShowAll));
    }
  }

  @override
  Future<void> close() {
    logger.d("TFDB: BleBloc: close: Closing...");

    _scanSub?.cancel();
    _connectionSub?.cancel();
    _cancelConnectionTimeoutTimer();

    return super.close();
  }
}
