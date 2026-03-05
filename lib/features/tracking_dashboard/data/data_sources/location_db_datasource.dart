import 'package:geolocator/geolocator.dart';
import 'package:guardian_route/core/db/isar_service.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:isar/isar.dart';

abstract class LocationLocalDataSource {
  Future<void> saveLocation(Position position);
  Stream<List<LocationModel>> watchLocations();
  Future<void> saveGpsDisabled();
  Future<void> savePermissionDenied();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  @override
  Future<void> saveLocation(Position position) async {
    final location = LocationModel.fromPosition(position);

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

  @override
  Future<void> saveGpsDisabled() async {
    final location = LocationModel.gpsDisabled();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.locationModels.put(location);
    });
  }

  @override
  Future<void> savePermissionDenied() async {
    final location = LocationModel.permissionDenied();

    await IsarService.isar.writeTxn(() async {
      await IsarService.isar.locationModels.put(location);
    });
  }
}
