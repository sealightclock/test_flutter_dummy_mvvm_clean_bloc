import 'package:equatable/equatable.dart';

import '../../domain/entity/vehicle_status_entity.dart';

/// Sealed class for Bloc States.
sealed class VehicleStatusState extends Equatable {
  const VehicleStatusState();

  @override
  List<Object?> get props => [];
}

class VehicleStatusInitialState extends VehicleStatusState {}

class VehicleStatusPermissionDeniedState extends VehicleStatusState {}

class VehicleStatusLoadedState extends VehicleStatusState {
  final VehicleStatusEntity vehicleStatus;

  const VehicleStatusLoadedState(this.vehicleStatus);

  @override
  List<Object?> get props => [vehicleStatus];
}
