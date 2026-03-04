import '../repositories/location_repository.dart';

class StopTracking {
  final LocationRepository repository;

  StopTracking(this.repository);

  Future<void> call() async {
    return repository.stopTracking();
  }
}
