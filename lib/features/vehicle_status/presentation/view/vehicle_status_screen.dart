import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/util/enums/app_tab_enum.dart';
import '../bloc/vehicle_status_bloc.dart';
import '../bloc/vehicle_status_event.dart';
import '../bloc/vehicle_status_state.dart';

/// The VehicleStatusScreen displays the vehicle's location and speed.
class VehicleStatusScreen extends StatelessWidget {
  const VehicleStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleStatusBloc()..add(VehicleStatusStartEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppTab.status.title),
          centerTitle: true, // to be consistent with app themes
        ),
        body: BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
          builder: (context, state) {
            if (state is VehicleStatusPermissionDeniedState) {
              return const Center(child: Text('Location permission denied.\nPlease enable it in settings.'));
            } else if (state is VehicleStatusLoadedState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Latitude: ${state.vehicleStatus.latitude.toStringAsFixed(6)}'),
                    Text('Longitude: ${state.vehicleStatus.longitude.toStringAsFixed(6)}'),
                    Text('Speed: ${state.vehicleStatus.speedKmh.toStringAsFixed(1)} km/h'),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
