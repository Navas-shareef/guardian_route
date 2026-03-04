import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class LocationRepository {
  Future<void> startTracking();
  Future<void> stopTracking();
  Future<bool> isTrackingActive();
  Stream<bool> trackingStatusStream();
  Stream<LocationModel> locationStream();
}
