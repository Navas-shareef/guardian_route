import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<void> startTracking();
  Future<void> stopTracking();
  Future<bool> isTrackingActive();
  Stream<bool> trackingStatusStream();
  Stream<LocationModel> locationStream();
  Future<void> saveLocation(double lat, double lng);
  Stream<List<LocationEntity>> watchLocations();
}
