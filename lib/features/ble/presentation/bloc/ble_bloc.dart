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
  Timer? _connectionTimeoutTimer;
  bool _lastShowAll = false;
  String? _lastConnectedDeviceId;
  List<BleDeviceEntity> _lastDevices = [];

  BleBloc({BleViewModel? injectedViewModel})
      : viewModel = injectedViewModel ?? BleViewModelFactory.create(),
        super(BleInitialState()) {
    on<BleStartScanEvent>(_onStartScanEvent);
    on<BleStopScanEvent>(_onStopScanEvent);
    on<BleDeviceSelectedEvent>(_onDeviceSelectedEvent);
    on<BleDisconnectFromDeviceEvent>(_onDisconnectFromDeviceEvent);
    on<BleShowReconnectingEvent>(_onShowReconnectingEvent);
  }

  Future<void> _onStartScanEvent(BleStartScanEvent event, Emitter<BleState> emit) async {
    final granted = await viewModel.requestPermissions();
    if (!granted) {
      emit(BleErrorState("Permissions not granted"));
      return;
    }

    _lastShowAll = event.showAll;
    _lastDevices = [];

    emit(BleScanningState());

    await _scanSub?.cancel();
    _scanSub = viewModel.scanBleDevices(showAll: event.showAll).listen(
          (devices) {
        _lastDevices = devices;
        if (!emit.isDone) {
          emit(BleDevicesFoundState(devices));
        }
      },
      onError: (error) {
        if (!emit.isDone) {
          emit(BleErrorState("Scan failed: $error"));
        }
      },
    );
  }

  Future<void> _onStopScanEvent(BleStopScanEvent event, Emitter<BleState> emit) async {
    await _scanSub?.cancel();
    _scanSub = null;

    if (_lastDevices.isNotEmpty) {
      emit(BleDevicesFoundState(_lastDevices));
    } else {
      emit(BleInitialState());
    }
  }

  Future<void> _onDeviceSelectedEvent(BleDeviceSelectedEvent event, Emitter<BleState> emit) async {
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
              emit(BleConnectedState(event.deviceId, update: update));
            }
          } else if (update.connectionState == DeviceConnectionState.disconnected) {
            _cancelConnectionTimeoutTimer();
            if (update.failure != null) {
              emit(BleErrorState("Connection failed: ${update.failure!.code.name}"));
            } else {
              emit(BleDisconnectedState(event.deviceId, _lastDevices));
              _autoReconnectOrRescan();
            }
          } else {
            logger.e("TFDB: BleBloc: _onDeviceSelectedEvent: unexpected update.connectionState=[${update.connectionState}]");
          }
        } else {
          logger.w("TFDB: BleBloc: _onDeviceSelectedEvent: emit.isDone==true while update=[$update]");

          _handleConnectionUpdateOutsideEmit(update);
        }
      });
    } catch (e, stackTrace) {
      logger.e("TFDB: BleBloc: _onDeviceSelectedEvent: error=$e, stackTrace=$stackTrace");

      if (!emit.isDone) {
        emit(BleErrorState("Connection failed"));
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
      add(BleDisconnectFromDeviceEvent(deviceId));
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

      add(BleDisconnectFromDeviceEvent(_lastConnectedDeviceId!));
    } else if (update.connectionState == DeviceConnectionState.connecting) {
        _startConnectionTimeoutTimer(_lastConnectedDeviceId!);
    } else {
      logger.e("TFDB: BleBloc: "
          "_handleConnectionUpdateOutsideEmit: Unexpected connection state: "
          "${update.connectionState}");
    }
  }

  Future<void> _onDisconnectFromDeviceEvent(BleDisconnectFromDeviceEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: _onDisconnectFromDeviceEvent: event=[$event]");

    await _connectionSub?.cancel();
    _connectionSub = null;
    _cancelConnectionTimeoutTimer();
    emit(BleDisconnectedState(event.deviceId, _lastDevices));
    //JZ _autoReconnectOrRescan();
  }

  Future<void> _onShowReconnectingEvent(BleShowReconnectingEvent event, Emitter<BleState> emit) async {
    logger.d("TFDB: BleBloc: _onShowReconnectingEvent: event=[$event]");

    emit(BleReconnectingState(event.deviceId));
  }

  void _autoReconnectOrRescan() async {
    logger.d("TFDB: BleBloc: _autoReconnectOrRescan: Auto-reconnecting...");

    await Future.delayed(const Duration(seconds: 1));

    if (_lastConnectedDeviceId != null) {
      add(BleShowReconnectingEvent(_lastConnectedDeviceId!));
      add(BleDeviceSelectedEvent(_lastConnectedDeviceId!));
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
