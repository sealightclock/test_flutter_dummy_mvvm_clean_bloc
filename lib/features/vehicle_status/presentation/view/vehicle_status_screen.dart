import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/vehicle_status_bloc.dart';
import '../bloc/vehicle_status_event.dart';
import '../bloc/vehicle_status_state.dart';

/// The VehicleStatusScreen displays the vehicle's location and speed.
class VehicleStatusScreen extends StatelessWidget {
  const VehicleStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VehicleStatusBloc()..add(VehicleStatusStartedEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle Status'),
          centerTitle: true, // to be consistent with app themes
        ),
        body: BlocBuilder<VehicleStatusBloc, VehicleStatusState>(
          builder: (context, state) {
            if (state is VehicleStatusPermissionDeniedState) {
              return const Center(child: Text('Location permission denied.\nPlease enable it in settings.'));
            } else if (state is VehicleStatusLoadSuccessState) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Latitude: ${state.status.latitude.toStringAsFixed(6)}'),
                    Text('Longitude: ${state.status.longitude.toStringAsFixed(6)}'),
                    Text('Speed: ${state.status.speedKmh.toStringAsFixed(1)} km/h'),
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
