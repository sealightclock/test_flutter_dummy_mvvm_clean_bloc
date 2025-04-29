import 'package:equatable/equatable.dart';

import '../../domain/entity/vehicle_status_entity.dart';

/// Sealed class for Bloc Events.
sealed class VehicleStatusEvent extends Equatable {
  const VehicleStatusEvent();
  @override
  List<Object?> get props => [];
}

class BlocVehicleStatusStarted extends VehicleStatusEvent {}

class BlocVehicleStatusPermissionChecked extends VehicleStatusEvent {
  final bool permissionGranted;
  const BlocVehicleStatusPermissionChecked(this.permissionGranted);

  @override
  List<Object?> get props => [permissionGranted];
}

class BlocVehicleStatusUpdated extends VehicleStatusEvent {
  final VehicleStatusEntity status;
  const BlocVehicleStatusUpdated(this.status);

  @override
  List<Object?> get props => [status];
}
