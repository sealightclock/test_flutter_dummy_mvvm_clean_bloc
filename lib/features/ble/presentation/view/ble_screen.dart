import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';
import '../bloc/ble_state.dart';
import '../../../../util/global_feedback_handler.dart';
import '../../../../util/feedback_type_enum.dart';

enum BleDeviceConnectionStatus {
  available,
  connecting,
  connected,
  reconnecting,
  disconnected,
}

class BleScreen extends StatelessWidget {
  final BleBloc? injectedBloc;

  const BleScreen({super.key, this.injectedBloc});

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
  bool showAllDevices = false;
  String? connectedDeviceId;
  String? reconnectingDeviceId;
  int? connectedStatusCode;

  final Map<int, String> manufacturerIdToName = {
    0x0006: "Microsoft",
    0x000F: "Broadcom",
    0x0010: "Apple",
    0x0001: "Nordic Semiconductor",
    0x004C: "Apple, Inc.",
    0x0075: "Samsung Electronics",
    0x0133: "Google",
    0x014E: "Xiaomi",
    0x0171: "Fitbit",
    0x01DA: "Oppo",
    0x0157: "Sony",
    0x03DA: "Motorola",
    0xE000: "Custom",
  };

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
    connectedDeviceId = null;
    reconnectingDeviceId = null;
    connectedStatusCode = null;
    bloc.add(StartScanEvent(showAll: showAllDevices));
  }

  void _stopScan() {
    bloc.add(StopScanEvent());
  }

  void _connectToDevice(String id) {
    setState(() {
      connectedDeviceId = id;
      connectedStatusCode = null;
    });
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

  String _getConnectionStatus(String id, BleState state, [ConnectionError? code]) {
    if (state is BleReconnecting && state.deviceId == id) {
      return "Reconnecting...";
    } else if (state is BleConnected && state.deviceId == id) {
      if (code == null || code == ConnectionError.unknown) {
        return "Connected";
      } else {
        return "Disconnected (${code.name})";
      }
    } else if (connectedDeviceId == id) {
      return "Connecting...";
    } else {
      return "Available";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Devices')),
      body: BlocListener<BleBloc, BleState>(
        listener: (context, state) {
          if (state is BleReconnecting) {
            reconnectingDeviceId = state.deviceId;
            showFeedback(context, "Reconnecting to last device...", FeedbackType.info);
          } else if (state is BleConnected) {
            setState(() {
              connectedDeviceId = state.deviceId;
              connectedStatusCode = state.update?.failure?.code.index;
            });
          } else if (state is BleDisconnected) {
            setState(() => connectedDeviceId = null);
          }
        },
        child: BlocBuilder<BleBloc, BleState>(
          builder: (context, state) {
            final isScanning = state is BleScanning;

            return Column(
              children: [
                SwitchListTile(
                  title: const Text("Show all devices"),
                  value: showAllDevices,
                  onChanged: isScanning ? null : (value) => setState(() => showAllDevices = value),
                ),
                if (lastScanTime != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Last scanned: ${_formatTime(lastScanTime!)}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                if (state is BleDevicesFound)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Devices found: ${state.devices.length}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                Expanded(
                  child: _buildBody(state, isScanning),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: BlocBuilder<BleBloc, BleState>(
        builder: (context, state) {
          final isScanning = state is BleScanning;
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: "refresh",
                onPressed: isScanning ? null : _startScan,
                tooltip: "Start Scan",
                child: const Icon(Icons.refresh),
              ),
              const SizedBox(width: 12),
              FloatingActionButton(
                heroTag: "stop",
                onPressed: isScanning ? _stopScan : null,
                tooltip: "Stop Scan",
                child: const Icon(Icons.stop),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BleState state, bool isScanning) {
    if (isScanning) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is BleDevicesFound) {
      return ListView.builder(
        itemCount: state.devices.length,
        itemBuilder: (_, index) {
          final device = state.devices[index];
          final manuId = device.manufacturerId;
          final manuName = manuId != null ? manufacturerIdToName[manuId] ?? "Unknown" : null;
          final connectionStatus = _getConnectionStatus(device.id, state);

          return ListTile(
            title: Text("ID: ${device.id}"),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${device.name}"),
                if (manuId != null)
                  Text("Manufacturer: 0x${manuId.toRadixString(16).toUpperCase()} ($manuName)"),
                Text("RSSI: ${device.rssi}"),
                Text("Status: $connectionStatus"),
              ],
            ),
            onTap: () => _connectToDevice(device.id),
          );
        },
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
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _startScan,
              child: const Text("Scan Again"),
            ),
          ],
        ),
      );
    } else if (state is BleError) {
      return Center(child: Text("Error: ${state.message}"));
    } else {
      return Center(
        child: ElevatedButton(
          onPressed: _startScan,
          child: const Text("Start BLE Scan"),
        ),
      );
    }
  }
}
