import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';

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
  static void onStart(ServiceInstance service) {
    DartPluginRegistrant.ensureInitialized();
    debugPrint("Background service started");
    service.invoke("serviceReady");

    service.on("stopService").listen((event) async {
      service.invoke("serviceStopped");
      await Future.delayed(const Duration(milliseconds: 200));
      debugPrint("Background service stopped");
      service.stopSelf();
    });

    Timer.periodic(const Duration(seconds: 3), (timer) async {
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

      // TODO: Save location in DB
    });
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}
