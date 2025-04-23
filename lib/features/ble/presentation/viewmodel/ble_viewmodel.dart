import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';

class BleViewModel {
  final BleBloc bloc;
  DateTime? lastScanTime;

  BleViewModel(this.bloc);

  void startScan() {
    lastScanTime = DateTime.now();
    bloc.add(StartScanEvent());
  }

  void connectToDevice(String id) {
    bloc.add(DeviceSelectedEvent(id));
  }

  void disconnect() {
    bloc.add(DisconnectFromDeviceEvent());
  }

  bool shouldAutoScan() {
    if (lastScanTime == null) return true;
    final age = DateTime.now().difference(lastScanTime!);
    return age > const Duration(seconds: 30);
  }
}
