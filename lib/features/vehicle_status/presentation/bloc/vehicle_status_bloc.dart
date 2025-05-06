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

  VehicleStatusBloc() : _viewModel = VehicleStatusViewModelFactory.create(), super(VehicleStatusInitialState()) {
    on<VehicleStatusStartEvent>(_onStarted);
    on<VehicleStatusHandlePermissionEvent>(_onPermissionChecked);
    on<VehicleStatusLoadEvent>((event, emit) => emit(VehicleStatusLoadedState(event.vehicleStatus)));
  }

  /// Called when Bloc is started.
  /// Requests location permission through ViewModel and acts accordingly.
  Future<void> _onStarted(VehicleStatusStartEvent event, Emitter<VehicleStatusState> emit) async {
    final granted = await _viewModel.checkAndRequestLocationPermission();
    add(VehicleStatusHandlePermissionEvent(granted!));
  }

  /// Called after checking permission.
  void _onPermissionChecked(VehicleStatusHandlePermissionEvent event, Emitter<VehicleStatusState> emit) {
    if (!event.permissionGranted) {
      if (state is! VehicleStatusPermissionDeniedState) {
        emit(VehicleStatusPermissionDeniedState());
      }
    } else {
      _subscription = _viewModel.getVehicleStatusStream().listen((status) {
        add(VehicleStatusLoadEvent(status));
      });
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
