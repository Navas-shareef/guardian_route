import '../../domain/entities/location_entity.dart';

class LocationModel extends LocationEntity {
  LocationModel({
    required super.latitude,
    required super.longitude,
    required super.timestamp,
  });

  factory LocationModel.fromPosition(position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );
  }
}
