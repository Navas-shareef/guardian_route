import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  backgroundDenied,
}

class LocationPermissionService {
  /// Check if GPS is enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Request Location Permission (Foreground + Background)
  Future<LocationPermissionResult> requestPermission() async {
    // Step 1: Check GPS
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionResult.serviceDisabled;
    }

    // Step 2: Check current permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Step 3: If still denied
    if (permission == LocationPermission.denied) {
      return LocationPermissionResult.denied;
    }

    // Step 4: If permanently denied
    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.deniedForever;
    }

    // Step 5: Must be Always for background tracking
    if (permission != LocationPermission.always) {
      return LocationPermissionResult.backgroundDenied;
    }

    return LocationPermissionResult.granted;
  }

  /// Open App Settings
  Future<void> openSettings() async {
    await openAppSettings();
  }
}
