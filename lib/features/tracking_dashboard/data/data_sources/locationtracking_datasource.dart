import 'dart:async';
import 'package:flutter_background_service/flutter_background_service.dart';

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

  LocationTrackingDataSourceImpl() {
    _listenServiceEvents();
  }

  void _listenServiceEvents() {
    _readySubscription = _service.on("serviceReady").listen((_) {
      _statusController.add(true);
    });

    _stopSubscription = _service.on("serviceStopped").listen((_) {
      _statusController.add(false);
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
    _statusController.close();
  }
}
