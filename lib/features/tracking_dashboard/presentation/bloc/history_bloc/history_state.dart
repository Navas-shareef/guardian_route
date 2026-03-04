import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<LocationModel> history;

  HistoryLoaded(this.history);
}
