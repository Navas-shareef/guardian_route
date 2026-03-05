import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_event.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_state.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/widgets/error_location_card.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/widgets/location_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();

    context.read<HistoryBloc>().add(LoadHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Location History")),

      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded) {
            if (state.locations.isEmpty) {
              return const Center(child: Text("No history yet"));
            }

            return ListView.builder(
              itemCount: state.locations.length,
              itemBuilder: (context, index) {
                final location = state.locations[index];

                if (location.status != "success") {
                  return ErrorLocationCard(location: location);
                }
                return LocationCard(
                  location: location,
                  onNavigate: () {
                    /// navigation logic later
                  },
                );
              },
            );
          }

          if (state is HistoryInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: Text("No history yet"));
        },
      ),
    );
  }
}
