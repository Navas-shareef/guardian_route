import 'package:flutter/material.dart';
import '../../domain/entities/location_entity.dart';

class ErrorLocationCard extends StatelessWidget {
  final LocationEntity location;

  const ErrorLocationCard({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade50,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.error_outline, color: Colors.red),
        title: Text(
          location.errorMessage ?? "Unknown error",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        subtitle: Text(location.timestamp.toString()),
      ),
    );
  }
}
