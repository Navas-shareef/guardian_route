abstract class LocationRepository {
  Future<void> startTracking();
  Future<void> stopTracking();
  Future<bool> isTrackingActive();
  Stream<bool> trackingStatusStream();
}
