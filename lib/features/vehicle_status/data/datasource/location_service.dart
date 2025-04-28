import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Service class responsible for providing raw location data using GPS.
/// This class initializes its own dependencies internally to avoid polluting top-level code.
class LocationService {
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
