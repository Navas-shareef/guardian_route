import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_route/core/services/notification_service.dart';

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
      await Future.delayed(const Duration(milliseconds: 200));
      debugPrint("Background service stopped");
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 2), (timer) async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      debugPrint('$permission');

      if (permission == LocationPermission.denied) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      debugPrint("Latitude: ${position.latitude}");
      debugPrint("Longitude: ${position.longitude}");
      service.invoke("locationUpdated", {
        "lat": position.latitude,
        "lng": position.longitude,
        "time": DateTime.now().toIso8601String(),
      });

      await NotificationService.updateTrackingNotification(
        position.latitude,
        position.longitude,
        isFirstNotification: false,
      );
      // TODO: Save location in DB
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
