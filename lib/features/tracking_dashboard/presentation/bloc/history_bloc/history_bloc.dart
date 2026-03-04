import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/location_update_stream.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_event.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final LocationUpdatesStream locationUpdatesStream;

  StreamSubscription? _locationSubscription;

  final List<LocationModel> _history = [];

  HistoryBloc(this.locationUpdatesStream) : super(HistoryInitial()) {
    _locationSubscription = locationUpdatesStream().listen((location) {
      add(LocationReceivedEvent(location));
    });

    on<LocationReceivedEvent>((event, emit) {
      _history.add(event.location);

      emit(HistoryLoaded(List.from(_history)));
    });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
