import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';

abstract class HistoryEvent {}

class LocationReceivedEvent extends HistoryEvent {
  final LocationModel location;

  LocationReceivedEvent(this.location);
}
