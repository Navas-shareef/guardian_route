import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<LocationModel> locations;

  HistoryLoaded(this.locations);
}

class HistoryError extends HistoryState {
  final String message;

  HistoryError(this.message);
}
