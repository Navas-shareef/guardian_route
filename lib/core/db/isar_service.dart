import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  static Isar? _isar;

  static Future<void> init() async {
    if (_isar != null) return;

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [LocationModelSchema],
      directory: dir.path,
      name: 'guardian_route_db',
    );
  }

  static Isar get isar {
    if (_isar == null) {
      throw Exception(
        "Isar not initialized. Call IsarService.init() before accessing the database.",
      );
    }
    return _isar!;
  }

  static Future<void> saveLocation(double lat, double lng) async {
    final location = LocationModel(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );

    await _isar!.writeTxn(() async {
      await isar.locationModels.put(location);
    });
  }
}
