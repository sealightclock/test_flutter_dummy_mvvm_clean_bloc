class BleDeviceEntity {
  final String id;
  final String name;
  final int rssi;
  final int? manufacturerId;     // NEW: Manufacturer ID
  final String? manufacturerHex; // NEW: Manufacturer raw hex string

  BleDeviceEntity({
    required this.id,
    required this.name,
    required this.rssi,
    this.manufacturerId,
    this.manufacturerHex,
  });
}
