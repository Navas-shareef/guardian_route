import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class HistoryEvent {}

class LoadHistoryEvent extends HistoryEvent {}

class LocationReceivedEvent extends HistoryEvent {
  final List<LocationModel> locations;

  LocationReceivedEvent(this.locations);
}
