import '../repositories/location_repository.dart';

class StartTracking {
  final LocationRepository repository;

  StartTracking(this.repository);

  Future<void> call() async {
    return repository.startTracking();
  }
}
