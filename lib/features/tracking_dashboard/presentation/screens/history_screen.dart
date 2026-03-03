import 'package:flutter/material.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/widgets/location_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Locations")),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return const LocationCard();
        },
      ),
    );
  }
}
