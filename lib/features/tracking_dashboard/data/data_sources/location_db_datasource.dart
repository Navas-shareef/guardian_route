import 'package:guardian_route/core/db/isar_service.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:isar/isar.dart';

abstract class LocationLocalDataSource {
  Future<void> saveLocation(double lat, double lng);
  Stream<List<LocationModel>> watchLocations();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<void> saveLocation(double lat, double lng) async {
    final location = LocationModel(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.locationModels.put(location);

      final count = await IsarService.isar.locationModels.count();

      if (count > 10) {
        final oldRecords = await IsarService.isar.locationModels
            .where()
            .sortByTimestamp()
            .limit(count - 10)
            .findAll();

        await IsarService.isar.locationModels.deleteAll(
          oldRecords.map((e) => e.id).toList(),
        );
      }
    });
  }

  @override
  Stream<List<LocationModel>> watchLocations() {
    return IsarService.isar.locationModels.where().sortByTimestampDesc().watch(
      fireImmediately: true,
    );
  }
}
