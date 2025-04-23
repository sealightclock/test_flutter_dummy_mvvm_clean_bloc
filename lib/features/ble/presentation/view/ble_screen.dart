// features/ble/presentation/view/ble_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ble_bloc.dart';
import '../bloc/ble_state.dart';
import '../viewmodel/ble_viewmodel.dart';

class BleScreen extends StatelessWidget {
  final BleViewModel viewModel;

  const BleScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel.bloc,
      child: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          if (state is BleScanning) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BleDevicesFound) {
            return ListView.builder(
              itemCount: state.devices.length,
              itemBuilder: (_, index) {
                final device = state.devices[index];
                return ListTile(
                  title: Text(device.name.isNotEmpty ? device.name : "Unnamed"),
                  subtitle: Text(device.id),
                  onTap: () => viewModel.connectToDevice(device.id),
                );
              },
            );
          } else if (state is BleConnected) {
            return const Center(child: Text("Connected!"));
          } else if (state is BleError) {
            return Center(child: Text("Error: ${state.message}"));
          }
          return Center(
            child: ElevatedButton(
              onPressed: viewModel.startScan,
              child: const Text("Start BLE Scan"),
            ),
          );
        },
      ),
    );
  }
}
