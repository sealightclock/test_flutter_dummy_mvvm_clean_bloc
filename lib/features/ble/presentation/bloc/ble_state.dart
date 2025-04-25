import 'package:equatable/equatable.dart';
import 'package:reactive_ble_platform_interface/src/model/connection_state_update.dart';
import '../../domain/entity/ble_device_entity.dart';

abstract class BleState extends Equatable {
  const BleState();
  @override
  List<Object?> get props => [];
}

class BleInitial extends BleState {}

class BleScanning extends BleState {}

class BleDevicesFound extends BleState {
  final List<BleDeviceEntity> devices;
  const BleDevicesFound(this.devices);

  @override
  List<Object?> get props => [devices];
}

class BleConnected extends BleState {
  final String deviceId;
  final ConnectionStateUpdate? update;

  BleConnected(this.deviceId, {this.update});

  @override
  List<Object?> get props => [deviceId, update];
}

class BleDisconnected extends BleState {
  final ConnectionStateUpdate? update;
  const BleDisconnected(this.update);

  @override
  List<Object?> get props => [update];
}

class BleReconnecting extends BleState {
  final String deviceId;
  const BleReconnecting(this.deviceId);

  @override
  List<Object?> get props => [deviceId];
}

class BleError extends BleState {
  final String message;
  const BleError(this.message);

  @override
  List<Object?> get props => [message];
}
