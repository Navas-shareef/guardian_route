import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

import '../repositories/location_repository.dart';

class LocationUpdatesStream {
  final LocationRepository repository;

  LocationUpdatesStream(this.repository);

  Stream<LocationModel> call() {
    return repository.locationStream();
  }
}
