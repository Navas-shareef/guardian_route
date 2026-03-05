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
    service.invoke("serviceReady");
    service.on("stopService").listen((event) async {
      service.invoke("serviceStopped");
      debugPrint("Background service stopped");
      NotificationService.removeTrackingNotification();
      service.stopSelf();
    });
    final localDataSource = LocationLocalDataSourceImpl();
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        await localDataSource.saveGpsDisabled();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        await localDataSource.savePermissionDenied();
        return;
      }
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

      debugPrint("Latitude: ${position.latitude}");
      debugPrint("Longitude: ${position.longitude}");

      await localDataSource.saveLocation(position);

      if (service is AndroidServiceInstance) {
        service.setForegroundNotificationInfo(
          title: "Guardian Route Tracking",
          content: "Lat: ${position.latitude}, Lng: ${position.longitude}",
        );
      } else {
        await NotificationService.updateTrackingNotification(
          position.latitude,
          position.longitude,
        );
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
