class BleDeviceFilterUtils {
  static const knownKeywords = {
    'phone', 'watch', 'galaxy', 'samsung', 'pixel',
    'moto', 'xiaomi', 'oneplus', 'oppo', 'iphone',
    'ipad', 'iwatch',
  };

  static const knownManufacturerIds = {
    0x004C, // Apple
    0x000F, // CSR (Qualcomm)
    0x0006, // Microsoft
    0x0075, // Samsung
    0x00E0, // Google
    0x015D, // Xiaomi
    0x0131, // Huawei
    0x0174, // OnePlus
    0x017C, // Oppo
    0x0171, // Realtek
    0x0152, // Motorola
  };

  static bool isLikelyPhoneOrWatch(String name, int? manufacturerId) {
    final lower = name.toLowerCase();
    final hasKeyword = knownKeywords.any(lower.contains);
    final isKnownId = manufacturerId != null && knownManufacturerIds.contains(manufacturerId);
    return hasKeyword || isKnownId;
  }
}
