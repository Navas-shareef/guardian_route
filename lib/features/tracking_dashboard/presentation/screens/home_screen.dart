import 'package:flutter/material.dart';
import 'package:guardian_route/routes/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTracking = false; // toggle manually for UI preview

    return Scaffold(
      appBar: AppBar(title: const Text("Guardian Route"), centerTitle: true),
      body: Padding(
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
                onPressed: () {},
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
      ),
    );
  }
}
