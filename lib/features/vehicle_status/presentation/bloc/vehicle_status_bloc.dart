import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/vehicle_status/presentation/bloc/vehicle_status_event.dart';
import 'package:test_flutter_dummy_mvvm_clean_bloc/features/vehicle_status/presentation/bloc/vehicle_status_state.dart';

import '../factory/vehicle_status_viewmodel_factory.dart';
import '../viewmodel/vehicle_status_viewmodel.dart';

/// Bloc responsible for handling vehicle status events and states.
/// It owns a ViewModel internally and listens to vehicle status stream.
class VehicleStatusBloc extends Bloc<VehicleStatusEvent, VehicleStatusState> {
  final VehicleStatusViewModel _viewModel;
  StreamSubscription? _subscription;

  VehicleStatusBloc() : _viewModel = VehicleStatusViewModelFactory.create(), super(BlocVehicleStatusInitial()) {
    on<BlocVehicleStatusStarted>(_onStarted);
    on<BlocVehicleStatusPermissionChecked>(_onPermissionChecked);
    on<BlocVehicleStatusUpdated>((event, emit) => emit(BlocVehicleStatusLoadSuccess(event.status)));
  }

  Future<void> _onStarted(BlocVehicleStatusStarted event, Emitter<VehicleStatusState> emit) async {
    final granted = await _viewModel.checkAndRequestLocationPermission();
    add(BlocVehicleStatusPermissionChecked(granted));
  }

  void _onPermissionChecked(BlocVehicleStatusPermissionChecked event, Emitter<VehicleStatusState> emit) {
    if (!event.permissionGranted) {
      emit(BlocVehicleStatusPermissionDenied());
    } else {
      _subscription = _viewModel.vehicleStatusStream.listen((status) {
        add(BlocVehicleStatusUpdated(status));
      });
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
