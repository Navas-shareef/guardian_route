import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/core/db/isar_service.dart';
import 'package:guardian_route/core/services/background_service_intializer.dart';
import 'package:guardian_route/core/services/notification_service.dart';
import 'package:guardian_route/core/theme/app_theme.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/location_db_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/data/data_sources/locationtracking_datasource.dart';
import 'package:guardian_route/features/tracking_dashboard/data/repositories/location_repo_imp.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/check_tracking_status.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/start_tracking.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/stop_tracking.dart';
import 'package:guardian_route/features/tracking_dashboard/domain/usecases/tracking_status_stream.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_event.dart';
import 'package:guardian_route/routes/app_router.dart';

/// Create single instances
final dataSource = LocationTrackingDataSourceImpl();
final localDataSource = LocationLocalDataSourceImpl();
final repository = LocationRepositoryImpl(
  locationTrackingService: dataSource,
  localDataSource: localDataSource,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  await BackgroundServiceInitializer.initialize();
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LocationBloc(
            startTracking: StartTracking(repository),
            stopTracking: StopTracking(repository),
            checkTrackingStatus: CheckTrackingStatus(repository),
            trackingStatusStream: TrackingStatusStream(repository),
          )..add(CheckTrackingStatusEvent()),
        ),

        BlocProvider(create: (_) => HistoryBloc(), lazy: false),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Guardian Route',
        theme: appTheme,
        initialRoute: AppRouter.home,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
