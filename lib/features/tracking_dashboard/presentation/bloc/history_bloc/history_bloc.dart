import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/core/db/isar_service.dart';
import 'package:guardian_route/features/tracking_dashboard/data/models/location_model.dart';
import 'package:isar/isar.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  StreamSubscription<List<LocationModel>>? _locationSubscription;

  final List<LocationModel> _history = [];

  HistoryBloc() : super(HistoryInitial()) {
    on<LoadHistoryEvent>(_onLoadHistory);

    on<LocationReceivedEvent>((event, emit) {
      _history
        ..clear()
        ..addAll(event.locations);

      emit(HistoryLoaded(List.from(_history)));
    });
  }

  Future<void> _onLoadHistory(
    LoadHistoryEvent event,
    Emitter<HistoryState> emit,
  ) async {
    _locationSubscription?.cancel();

    _locationSubscription = IsarService.isar.locationModels
        .where()
        .sortByTimestampDesc()
        .watch(fireImmediately: true)
        .listen((locations) {
          add(LocationReceivedEvent(locations));
        });
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
