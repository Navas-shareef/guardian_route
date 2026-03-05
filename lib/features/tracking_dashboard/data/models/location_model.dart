import 'package:geolocator/geolocator.dart';
import 'package:isar/isar.dart';
import '../../domain/entities/location_entity.dart';

part 'location_model.g.dart';

@collection
class LocationModel extends LocationEntity {
  Id id = Isar.autoIncrement;

  LocationModel({
    double? latitude,
    double? longitude,
    String? status,
    String? errorMessage,
    required DateTime timestamp,
  }) : super(
         latitude: latitude,
         longitude: longitude,
         status: status,
         errorMessage: errorMessage,
         timestamp: timestamp,
       );

  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      status: "success",
      timestamp: position.timestamp,
    );
  }

  factory LocationModel.gpsDisabled() {
    return LocationModel(
      latitude: null,
      longitude: null,
      status: "gps_off",
      errorMessage: "GPS is disabled",
      timestamp: DateTime.now(),
    );
  }

  factory LocationModel.permissionDenied() {
    return LocationModel(
      latitude: null,
      longitude: null,
      status: "permission_denied",
      errorMessage: "Location permission denied",
      timestamp: DateTime.now(),
    );
  }
}
