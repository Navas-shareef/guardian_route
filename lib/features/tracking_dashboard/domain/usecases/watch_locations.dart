import 'package:guardian_route/features/tracking_dashboard/domain/entities/location_entity.dart';

import '../repositories/location_repository.dart';

class WatchLocations {
  final LocationRepository repository;

  WatchLocations(this.repository);

  Stream<List<LocationEntity>> call() {
    return repository.watchLocations();
  }
}
