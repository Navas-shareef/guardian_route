import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:guardian_route/core/services/location_permission_service.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_event.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_state.dart';
import 'package:guardian_route/routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final LocationPermissionService _permissionService =
      LocationPermissionService();

  LocationPermissionResult? currentLocationPermission;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermission();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        [
          LocationPermissionResult.serviceDisabled,
          LocationPermissionResult.deniedForever,
          LocationPermissionResult.backgroundDenied,
        ].contains(currentLocationPermission)) {
      _checkPermissionAfterSettings();
    }
  }

  // function to check the permisstion status after opening settings
  Future<void> _checkPermissionAfterSettings() async {
    final result = await _permissionService.requestPermission();
    if (result == LocationPermissionResult.granted) {
      // if permission granted,rest of the app flow will work
      currentLocationPermission = result;
    } else if ([
      LocationPermissionResult.deniedForever,
      LocationPermissionResult.serviceDisabled,
      LocationPermissionResult.denied,
    ].contains(result)) {
      exit(0);
    }
  }

  /// function to check initial gps,and location permission
  Future<void> _requestPermission() async {
    final result = await _permissionService.requestPermission();
    switch (result) {
      case LocationPermissionResult.serviceDisabled:
        _showGpsDialog();
        break;
      case LocationPermissionResult.denied:
        exit(0);
      case LocationPermissionResult.deniedForever:
        _showLocationPermissionDialog();
        break;
      case LocationPermissionResult.backgroundDenied:
        // _showLocationPermissionDialog();
        break;
      case LocationPermissionResult.granted:
        break;
    }
  }

  void _showGpsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text("Enable GPS"),
          content: const Text(
            "Guardian Route requires GPS to track your location. Please enable GPS.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                currentLocationPermission =
                    LocationPermissionResult.serviceDisabled;
                await Geolocator.openLocationSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text(
            "Location access is permanently denied. Please enable it from app settings to use tracking.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                exit(0);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _permissionService.openSettings();
                currentLocationPermission =
                    LocationPermissionResult.deniedForever;
              },
              child: const Text("Open Settings"),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Guardian Route"), centerTitle: true),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          bool isTracking = state is TrackingStarted;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isTracking ? Icons.location_on : Icons.location_off,
                  size: 90,
                  color: isTracking ? Colors.green : Colors.red,
                ),

                const SizedBox(height: 20),

                Text(
                  isTracking ? "Tracking Active" : "Tracking Stopped",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isTracking ? Colors.green : Colors.red,
                  ),
                ),

                const SizedBox(height: 50),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isTracking) {
                        context.read<LocationBloc>().add(StopTrackingEvent());
                      } else {
                        context.read<LocationBloc>().add(StartTrackingEvent());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTracking ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isTracking ? "Stop Tracking" : "Start Tracking",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.history);
                  },
                  child: const Text("View History"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
