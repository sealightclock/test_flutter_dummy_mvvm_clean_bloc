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

/// Experimentation results:
///
/// id - It is not persistent even across scans, so is not a good ID.
/// name - It is usually empty or unknown, and occasionally it has the name
/// given by the user or manufacturer.
/// rssi - It is a negative integer.
/// manufacturerId - Most renowned devices have a manufacturer ID.
/// manufacturerHex - It is usually non-null, and can provide a raw data that
/// is usually persistent across boots with some rare exceptions. So this is
/// a better ID.