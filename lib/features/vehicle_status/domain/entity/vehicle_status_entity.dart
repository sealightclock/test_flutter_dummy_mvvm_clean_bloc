import 'package:equatable/equatable.dart';

/// Entity representing the current vehicle status.
/// Currently includes location and speed but designed to be expandable.
class VehicleStatusEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double speedKmh; // Speed in kilometers per hour

  const VehicleStatusEntity({
    required this.latitude,
    required this.longitude,
    required this.speedKmh,
  });

  @override
  List<Object?> get props => [latitude, longitude, speedKmh];
}
