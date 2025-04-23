import '../bloc/ble_bloc.dart';
import '../bloc/ble_event.dart';

class BleViewModel {
  final BleBloc bloc;

  BleViewModel(this.bloc);

  void startScan() => bloc.add(StartScanEvent());
  void connectToDevice(String id) => bloc.add(DeviceSelectedEvent(id));
}
