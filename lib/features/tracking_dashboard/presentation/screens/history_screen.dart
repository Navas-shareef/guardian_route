import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_state.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/widgets/location_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location History")),

      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            return ListView.builder(
              itemCount: state.history.length,
              itemBuilder: (context, index) {
                final location = state.history[index];

                return LocationCard(location: location, onNavigate: () {});
              },
            );
          }

          return const Center(child: Text("No history yet"));
        },
      ),
    );
  }
}
