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
    on<VehicleStatusStartedEvent>(_onStarted);
    on<VehicleStatusPermissionCheckedEvent>(_onPermissionChecked);
    on<VehicleStatusUpdatedEvent>((event, emit) => emit(VehicleStatusLoadSuccessState(event.status)));
  }

  Future<void> _onStarted(VehicleStatusStartedEvent event, Emitter<VehicleStatusState> emit) async {
    final granted = await _viewModel.checkAndRequestLocationPermission();
    add(VehicleStatusPermissionCheckedEvent(granted));
  }

  void _onPermissionChecked(VehicleStatusPermissionCheckedEvent event, Emitter<VehicleStatusState> emit) {
    if (!event.permissionGranted) {
      emit(VehicleStatusPermissionDeniedState());
    } else {
      _subscription = _viewModel.vehicleStatusStream.listen((status) {
        add(VehicleStatusUpdatedEvent(status));
      });
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}
