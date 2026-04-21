import 'package:flutter/material.dart';
import '../pages/auth/login_page.dart';
import '../pages/monitoring/monitoring_page.dart';
import '../pages/control/control_page.dart';
import '../pages/history/history_page.dart';
import '../pages/profile/profile_page.dart';
import '../widgets/bottom_nav.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const MainNavigation());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}