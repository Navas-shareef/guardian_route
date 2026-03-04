import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/check_tracking_status.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/tracking_status_stream.dart';
import '../../../domain/usecases/start_tracking.dart';
import '../../../domain/usecases/stop_tracking.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final StartTracking startTracking;
  final StopTracking stopTracking;
  final CheckTrackingStatus checkTrackingStatus;
  final TrackingStatusStream trackingStatusStream;
  StreamSubscription? _trackingSubscription;

  LocationBloc({
    required this.startTracking,
    required this.stopTracking,
    required this.checkTrackingStatus,
    required this.trackingStatusStream,
  }) : super(LocationInitial()) {
    on<StartTrackingEvent>(_onStartTracking, transformer: droppable());
    on<StopTrackingEvent>(_onStopTracking, transformer: droppable());
    on<CheckTrackingStatusEvent>(
      _onCheckTrackingStatus,
      transformer: restartable(),
    );

    on<TrackingStartedInternally>((event, emit) {
      emit(TrackingStarted());
    });

    on<TrackingStoppedInternally>((event, emit) {
      emit(TrackingStopped());
    });

    _trackingSubscription = trackingStatusStream().listen((running) {
      if (running) {
        add(TrackingStartedInternally());
      } else {
        add(TrackingStoppedInternally());
      }
    });
  }

  Future<void> _onStartTracking(
    StartTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      await startTracking();
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onStopTracking(
    StopTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    try {
      await stopTracking();
    } catch (e) {
      emit(LocationError(e.toString()));
    }
  }

  Future<void> _onCheckTrackingStatus(
    CheckTrackingStatusEvent event,
    Emitter<LocationState> emit,
  ) async {
    bool running = await checkTrackingStatus();

    if (running) {
      emit(TrackingStarted());
    } else {
      emit(TrackingStopped());
    }
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
