class BleDeviceEntity {
  final String id;
  final String name;
  final int rssi;
  final int? manufacturerId;
  final String? manufacturerHex;

  BleDeviceEntity({
    required this.id,
    required this.name,
    required this.rssi,
    this.manufacturerId,
    this.manufacturerHex,
  });
}
