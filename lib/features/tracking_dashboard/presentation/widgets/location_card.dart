import 'package:flutter/material.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

class LocationCard extends StatelessWidget {
  final LocationModel location;
  final VoidCallback? onNavigate;

  const LocationCard({super.key, required this.location, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    final lat = location.latitude?.toStringAsFixed(5) ?? "N/A";
    final lng = location.longitude?.toStringAsFixed(5) ?? "N/A";

    final date =
        "${location.timestamp.day}-${location.timestamp.month}-${location.timestamp.year}";

    final time =
        "${location.timestamp.hour}:${location.timestamp.minute.toString().padLeft(2, '0')}";

    final bool hasLocation =
        location.latitude != null && location.longitude != null;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(
              hasLocation ? Icons.location_pin : Icons.error_outline,
              size: 35,
              color: hasLocation ? Colors.red : Colors.orange,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasLocation
                        ? "Lat: $lat, Lng: $lng"
                        : "Location unavailable",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "$date - $time",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
