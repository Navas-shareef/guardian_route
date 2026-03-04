import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class StartTrackingEvent extends LocationEvent {}

class StopTrackingEvent extends LocationEvent {}

class CheckTrackingStatusEvent extends LocationEvent {}

class TrackingStartedInternally extends LocationEvent {}

class TrackingStoppedInternally extends LocationEvent {}
