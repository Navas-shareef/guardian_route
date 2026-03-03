import 'package:flutter/material.dart';

void showLocationErrorBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 50, color: Colors.red),
            const SizedBox(height: 15),
            const Text(
              "Location permission denied or GPS is turned off.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Open Settings"),
              ),
            ),
            const SizedBox(height: 10),

            TextButton(onPressed: () {}, child: const Text("Retry")),
          ],
        ),
      );
    },
  );
}
