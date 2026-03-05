import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_route/core/db/isar_service.dart' show IsarService;
import 'package:guardian_route/core/services/notification_service.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/location_db_datasource.dart';

class BackgroundServiceInitializer {
  static Future<void> initialize() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: LocationBackgroundService.onStart,
        isForegroundMode: true,
        autoStart: false,
        notificationChannelId: "guardian_route",
        initialNotificationTitle: "Guardian Route",
        initialNotificationContent: "Tracking location...",
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: LocationBackgroundService.onStart,
        onBackground: LocationBackgroundService.onIosBackground,
      ),
    );
  }
}

@pragma('vm:entry-point')
class LocationBackgroundService {
  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    await IsarService.init();
    await NotificationService.initialize();
    debugPrint("Background service started");
    await NotificationService.updateTrackingNotification(
      0,
      0,
      isFirstNotification: true,
    );
    service.invoke("serviceReady");

    service.on("stopService").listen((event) async {
      service.invoke("serviceStopped");
      debugPrint("Background service stopped");
      NotificationService.removeTrackingNotification();
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('$permission');

      if (permission == LocationPermission.denied) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      service.invoke("locationUpdated", {
        "lat": position.latitude,
        "lng": position.longitude,
        "time": DateTime.now().toIso8601String(),
      });
      //  await IsarService.saveLocation(position.latitude, position.longitude);
      debugPrint("Latitude: ${position.latitude}");
      debugPrint("Longitude: ${position.longitude}");

      final localDataSource = LocationLocalDataSourceImpl();
      await localDataSource.saveLocation(position.latitude, position.longitude);

      await NotificationService.updateTrackingNotification(
        position.latitude,
        position.longitude,
        isFirstNotification: false,
      );
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
