import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/util/enums/app_tab_enum.dart';
import '../../../../core/util/enums/feedback_type_enum.dart';
import '../../../../core/util/feedback/global_feedback_handler.dart';
import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';
import '../bloc/ble_state.dart';

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
  bool _permissionDenied = false;
  String? connectedDeviceId;
  String? reconnectingDeviceId;
  ConnectionError? lastConnectionError;

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
    if (!granted) {
      setState(() {
        _permissionDenied = true; // <-- NEW
      });
      return;
    }

    setState(() {
      _permissionDenied = false; // In case of retry success
    });

    if (_shouldAutoScan()) {
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
    bloc.add(BleStartScanEvent(showAll: showAllDevices));
  }

  void _stopScan() {
    bloc.add(BleStopScanEvent());
  }

  void _connectToDevice(String id) {
    setState(() {
      connectedDeviceId = id;
    });
    bloc.add(BleSelectDeviceEvent(id));
  }

  void _disconnect(String deviceId) {
    bloc.add(BleDisconnectDeviceEvent(deviceId));
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final duration = now.difference(time);
    if (duration.inSeconds < 60) return "${duration.inSeconds}s ago";
    if (duration.inMinutes < 60) return "${duration.inMinutes}m ago";
    return "${duration.inHours}h ago";
  }

  String _getConnectionStatus(String id, BleState state) {
    if (state is BleDeviceReconnectingState && state.deviceId == id) {
      return "Re-connecting...Wait for 10s";
    }

    if (state is BleDeviceConnectedState && state.deviceId == id) {
      return "Connected";
    }

    if (state is BleDeviceDisconnectedState && state.deviceId == id) {
      return "Disconnected";
    }

    if (state is BleErrorState) {
      return "Error: ${state.message}";
    }

    if (connectedDeviceId == id) {
      return "Connecting...Wait for 10s";
    }

    return "Available";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppTab.ble.title),
          centerTitle: true,
      ),
      body: BlocListener<BleBloc, BleState>(
        listener: (context, state) {
          if (state is BleDeviceReconnectingState) {
            reconnectingDeviceId = state.deviceId;
            showFeedback(context, "Reconnecting to last device...", FeedbackType.info);
          } else if (state is BleDeviceConnectedState) {
            setState(() => connectedDeviceId = state.deviceId);
          } else if (state is BleDeviceDisconnectedState) {
            setState(() => connectedDeviceId = null);
          }
        },
        child: BlocBuilder<BleBloc, BleState>(
          builder: (context, state) {
            final isScanning = state is BleScanningState;

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
                    child: Text('Last scanned: ${_formatTime(lastScanTime!)}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ),
                if (state.devices != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('Devices found: ${state.devices.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
          final isScanning = state is BleScanningState;
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
    if (_permissionDenied) {
      // <-- NEW: Show warning message if permission not granted
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            "Precise location permission is required for BLE scanning.\n\n"
                "Please go to Android Settings -> Apps -> YourApp -> Permissions, "
                "and set Location access to 'Precise'.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    } else if (isScanning) {
      return const Center(child: CircularProgressIndicator());
    // TODO: For now, let's just show the devices for the last scan.
    } else if (state is BleDevicesFoundState || state is BleDeviceDisconnectedState) {
      return ListView.builder(
        itemCount: state.devices.length,
        itemBuilder: (_, index) {
          final device = state.devices[index];
          final manuId = device.manufacturerId;
          final manuName = manuId != null ? manufacturerIdToName[manuId] ?? "Unknown" : null;
          final connectionStatus = _getConnectionStatus(device.id, state);

          final manuHexLength = device.manufacturerHex?.length ?? 0;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: InkWell(
              onTap: () => _connectToDevice(device.id),
              
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (device.manufacturerHex != null) ?
                      "Raw: ${device.manufacturerHex?.substring(0, min
                              (manuHexLength, 20))}" :
                      "Raw: null"
                    ),
                    Text("ID: ${device.id}"),
                    Text("Name: ${device.name}"),
                    if (manuId != null)
                      Text("Manufacturer: 0x${manuId.toRadixString(16)
                       .toUpperCase()} ($manuName)"),
                    Text("RSSI: ${device.rssi}"),
                    Text("Status: $connectionStatus"),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (state is BleDeviceConnectedState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Connected to: ${state.deviceId}"),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _disconnect(state.deviceId),
              child: const Text("Disconnect"),
            ),
          ],
        ),
      );
    // TODO: This case is not used for now.
    } else if (state is BleDeviceDisconnectedState) {
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
    } else if (state is BleErrorState) {
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
