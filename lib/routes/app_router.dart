import 'package:flutter/material.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/screens/history_screen.dart';
import 'package:guardian_route/features/tracking_dashboard/presentation/screens/home_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String history = '/history';
  static const String map = '/map';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case history:
        return MaterialPageRoute(builder: (_) => const HistoryScreen());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('No Route Found'))),
        );
    }
  }
}
