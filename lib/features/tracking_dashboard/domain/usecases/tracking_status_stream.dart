import '../repositories/location_repository.dart';

class TrackingStatusStream {
  final LocationRepository repository;

  TrackingStatusStream(this.repository);

  Stream<bool> call() {
    return repository.trackingStatusStream();
  }
}
