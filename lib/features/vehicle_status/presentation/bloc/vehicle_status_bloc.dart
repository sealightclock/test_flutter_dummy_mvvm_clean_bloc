import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../factory/vehicle_status_viewmodel_factory.dart';
import '../viewmodel/vehicle_status_viewmodel.dart';
import 'vehicle_status_event.dart';
import 'vehicle_status_state.dart';

/// Bloc responsible for handling vehicle status events and states.
/// It owns a ViewModel internally and listens to vehicle status stream.
class VehicleStatusBloc extends Bloc<VehicleStatusEvent, VehicleStatusState> {
  final VehicleStatusViewModel _viewModel;
  StreamSubscription? _subscription;

  VehicleStatusBloc() : _viewModel = VehicleStatusViewModelFactory.create(), super(BlocVehicleStatusInitial()) {
    on<BlocVehicleStatusStarted>((event, emit) => _startListening(emit));
    on<BlocVehicleStatusUpdated>((event, emit) => emit(BlocVehicleStatusLoadSuccess(event.status)));
  }

  void _startListening(Emitter<VehicleStatusState> emit) {
    _subscription = _viewModel.vehicleStatusStream.listen((status) {
      add(BlocVehicleStatusUpdated(status));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
