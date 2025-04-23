import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';
import '../bloc/ble_state.dart';

class BleScreen extends StatelessWidget {
  final BleBloc? injectedBloc;

  const BleScreen({
    super.key,
    this.injectedBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BleBloc>(
      create: (_) => injectedBloc ?? BleBloc(),
      child: const BleScreenBody(),
    );
  }
}

class BleScreenBody extends StatefulWidget {
  const BleScreenBody({super.key});

  @override
  State<BleScreenBody> createState() => _BleScreenBodyState();
}

class _BleScreenBodyState extends State<BleScreenBody> {
  late BleBloc bloc;
  DateTime? lastScanTime;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<BleBloc>(context);
    _initBlePermissionsAndScan();
  }

  Future<void> _initBlePermissionsAndScan() async {
    final granted = await _requestPermissions();
    if (granted && _shouldAutoScan()) {
      _startScan();
    }
  }

  Future<bool> _requestPermissions() async {
    final result = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    return result.values.every((status) => status.isGranted);
  }

  bool _shouldAutoScan() {
    if (lastScanTime == null) return true;
    final age = DateTime.now().difference(lastScanTime!);
    return age > const Duration(seconds: 30);
  }

  void _startScan() {
    lastScanTime = DateTime.now();
    bloc.add(StartScanEvent());
  }

  void _connectToDevice(String id) {
    bloc.add(DeviceSelectedEvent(id));
  }

  void _disconnect() {
    bloc.add(DisconnectFromDeviceEvent());
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final duration = now.difference(time);
    if (duration.inSeconds < 60) return "${duration.inSeconds}s ago";
    if (duration.inMinutes < 60) return "${duration.inMinutes}m ago";
    return "${duration.inHours}h ago";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Devices')),
      body: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          if (state is BleScanning) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BleDevicesFound) {
            return Column(
              children: [
                if (lastScanTime != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Last scanned: ${_formatTime(lastScanTime!)}',
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
                        onTap: () => _connectToDevice(device.id),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is BleConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Connected to: ${state.deviceId}"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _disconnect,
                    child: const Text("Disconnect"),
                  ),
                ],
              ),
            );
          } else if (state is BleDisconnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Disconnected"),
                  ElevatedButton(
                    onPressed: _startScan,
                    child: const Text("Scan Again"),
                  ),
                ],
              ),
            );
          } else if (state is BleError) {
            return Center(child: Text("Error: ${state.message}"));
          }

          return Center(
            child: ElevatedButton(
              onPressed: _startScan,
              child: const Text("Start BLE Scan"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScan,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
