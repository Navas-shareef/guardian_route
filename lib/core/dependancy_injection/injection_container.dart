import 'package:get_it/get_it.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/location_db_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/locationtracking_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/data/repositories/location_repo_imp.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/repositories/location_repository.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/check_tracking_status.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/start_tracking.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/stop_tracking.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/tracking_status_stream.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_bloc.dart';

final sl = GetIt.instance;

Future init() async {
  sl.registerFactory(
    () => LocationBloc(
      startTracking: sl(),
      stopTracking: sl(),
      checkTrackingStatus: sl(),
      trackingStatusStream: sl(),
      dataSource: sl(),
    ),
  );

  sl.registerLazySingleton(() => StartTracking(sl()));
  sl.registerLazySingleton(() => StopTracking(sl()));
  sl.registerLazySingleton(() => CheckTrackingStatus(sl()));
  sl.registerLazySingleton(() => TrackingStatusStream(sl()));

  sl.registerLazySingleton<LocationTrackingDataSource>(
    () => LocationTrackingDataSourceImpl(),
  );
  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      locationTrackingService: sl(),
      localDataSource: sl(),
    ),
  );
}
