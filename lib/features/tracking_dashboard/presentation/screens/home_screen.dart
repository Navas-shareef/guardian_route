import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/core/services/location_permission_service.dart';
import 'package:guardian_route/core/services/notification_service.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_event.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_state.dart';
import 'package:guardian_route/routes/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocationPermissionService _permissionService =
      LocationPermissionService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestPermission();
    });
  }

  Future<void> _requestPermission() async {
    final result = await _permissionService.requestPermission();

    switch (result) {
      case LocationPermissionResult.granted:
        break;

      case LocationPermissionResult.serviceDisabled:
        _showMessage("Please enable GPS");
        break;

      case LocationPermissionResult.denied:
        _showMessage("Location permission denied");
        await Future.delayed(Duration(seconds: 1));
        exit(0);

      case LocationPermissionResult.deniedForever:
        _showMessage("Permission permanently denied. Open settings.");
        await Future.delayed(Duration(seconds: 1));
        exit(0);

      case LocationPermissionResult.backgroundDenied:
        break;
    }
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
