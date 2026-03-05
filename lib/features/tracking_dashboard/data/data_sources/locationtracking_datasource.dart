import 'dart:async';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class LocationTrackingDataSource {
  Future<void> startTracking();
  Future<void> stopTracking();
  Stream<bool> trackingStatusStream();
  Future<bool> isTrackingActive();
  void dispose();
}

class LocationTrackingDataSourceImpl implements LocationTrackingDataSource {
  final FlutterBackgroundService _service = FlutterBackgroundService();

  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  StreamSubscription? _readySubscription;
  StreamSubscription? _stopSubscription;

  final StreamController<LocationModel> _locationController =
      StreamController.broadcast();

  StreamSubscription? _locationSubscription;

  LocationTrackingDataSourceImpl() {
    _listenServiceEvents();
    _listenLocationEvents();
  }

  void _listenServiceEvents() {
    _readySubscription = _service.on("serviceReady").listen((_) {
      _statusController.add(true);
    });

    _stopSubscription = _service.on("serviceStopped").listen((_) {
      _statusController.add(false);
    });
  }

  void _listenLocationEvents() {
    _locationSubscription = _service.on("locationUpdated").listen((event) {
      final location = LocationModel(
        latitude: event?["lat"],
        longitude: event?["lng"],
        timestamp: DateTime.parse(event?["time"]),
      );

      _locationController.add(location);
    });
  }

  @override
  Future<void> startTracking() async {
    bool running = await _service.isRunning();
    if (!running) {
      await _service.startService();
    }
  }

  @override
  Future<void> stopTracking() async {
    _service.invoke("stopService");
  }

  @override
  Stream<bool> trackingStatusStream() {
    return _statusController.stream;
  }

  @override
  Future<bool> isTrackingActive() async {
    return await _service.isRunning();
  }

  @override
  void dispose() {
    _readySubscription?.cancel();
    _stopSubscription?.cancel();
    _locationSubscription?.cancel();
    _locationController.close();
    _statusController.close();
  }
}
