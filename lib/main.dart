import 'package:flutter/material.dart';
import 'package:guardian_route/core/theme/app_theme.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/screens/home_screen.dart';
import 'package:guardian_route/routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Guardian Route',
      theme: appTheme,
      initialRoute: AppRouter.home,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
