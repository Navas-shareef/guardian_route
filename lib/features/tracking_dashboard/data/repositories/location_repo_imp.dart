import 'package:guardian_route/features/tracking_dashboard/data/data_sources/locationtracking_datasource.dart';

import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationTrackingDataSource locationTrackingService;

  LocationRepositoryImpl({required this.locationTrackingService});

  @override
  Future<void> startTracking() async {
    return locationTrackingService.startTracking();
  }

  @override
  Future<void> stopTracking() async {
    return locationTrackingService.stopTracking();
  }

  @override
  Future<bool> isTrackingActive() async {
    return locationTrackingService.isTrackingActive();
  }

  @override
  Stream<bool> trackingStatusStream() {
    return locationTrackingService.trackingStatusStream();
  }
}
