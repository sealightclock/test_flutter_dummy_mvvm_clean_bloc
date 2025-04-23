import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/ble_bloc.dart';
import '../bloc/ble_state.dart';
import '../viewmodel/ble_viewmodel.dart';

class BleScreen extends StatefulWidget {
  final BleViewModel viewModel;

  const BleScreen({super.key, required this.viewModel});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.viewModel.shouldAutoScan()) {
      widget.viewModel.startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.viewModel.bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('BLE Devices'),
        ),
        body: BlocBuilder<BleBloc, BleState>(
          builder: (context, state) {
            if (state is BleScanning) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BleDevicesFound) {
              final lastScanTime = widget.viewModel.lastScanTime;
              return Column(
                children: [
                  if (lastScanTime != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Last scanned: ${_formatTime(lastScanTime)}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.devices.length,
                      itemBuilder: (_, index) {
                        final device = state.devices[index];
                        return ListTile(
                          title: Text(device.name.isNotEmpty ? device.name : "Unnamed"),
                          subtitle: Text(device.id),
                          onTap: () => widget.viewModel.connectToDevice(device.id),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else if (state is BleConnected) {
              return const Center(child: Text("Connected!"));
            } else if (state is BleError) {
              return Center(child: Text("Error: ${state.message}"));
            }

            return Center(
              child: ElevatedButton(
                onPressed: widget.viewModel.startScan,
                child: const Text("Start BLE Scan"),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.viewModel.startScan,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final duration = now.difference(time);
    if (duration.inSeconds < 60) {
      return "${duration.inSeconds}s ago";
    } else if (duration.inMinutes < 60) {
      return "${duration.inMinutes}m ago";
    } else {
      return "${duration.inHours}h ago";
    }
  }
}
