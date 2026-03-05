import 'package:guardian_route/features/tracking_dashboard/domain/entities/location_entity.dart';

abstract class LocationRepository {
  Future<void> startTracking();
  Future<void> stopTracking();
  Future<bool> isTrackingActive();
  Stream<bool> trackingStatusStream();
  Stream<List<LocationEntity>> watchLocations();
}
