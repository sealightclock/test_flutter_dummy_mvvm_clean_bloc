import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Service providing raw GPS stream.
/// Assumes permissions are already granted.
class VehicleStatusDataSource {
  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;

  /// Returns a raw [Stream] of [Position] updates (potentially very frequent, e.g., every 100ms).
  Stream<Position> getPositionStreamRaw() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0, // meters
    );
    return _geolocator.getPositionStream(locationSettings: locationSettings);
  }
}
