import 'package:guardian_route/features/tracking_dashboard/data/data_sources/location_db_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/locationtracking_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/entities/location_entity.dart';

import '../../domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationTrackingDataSource locationTrackingService;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({
    required this.locationTrackingService,
    required this.localDataSource,
  });

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

  @override
  Stream<List<LocationEntity>> watchLocations() {
    return localDataSource.watchLocations();
  }
}
