import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guardian_route/core/db/isar_service.dart';
import 'package:guardian_route/core/dependancy_injection/injection_container.dart'
    as di;
import 'package:guardian_route/core/services/background_service_intializer.dart';
import 'package:guardian_route/core/services/notification_service.dart';
import 'package:guardian_route/core/theme/app_theme.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/history_bloc/history_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_bloc.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/bloc/location_tracking_bloc/location_event.dart';
import 'package:guardian_route/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await IsarService.init();
  await BackgroundServiceInitializer.initialize();
  await NotificationService.requestNotificationPermission();
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
          create: (_) => di.sl<LocationBloc>()..add(CheckTrackingStatusEvent()),
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
