import 'package:equatable/equatable.dart';

import '../../domain/entity/vehicle_status_entity.dart';

/// Sealed class for Bloc States.
sealed class VehicleStatusState extends Equatable {
  const VehicleStatusState();
  @override
  List<Object?> get props => [];
}

class BlocVehicleStatusInitial extends VehicleStatusState {}

class BlocVehicleStatusPermissionDenied extends VehicleStatusState {}

class BlocVehicleStatusLoadSuccess extends VehicleStatusState {
  final VehicleStatusEntity status;
  const BlocVehicleStatusLoadSuccess(this.status);

  @override
  List<Object?> get props => [status];
}
