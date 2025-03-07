import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/dashboard_screen.dart';
import 'package:kaamdekhoworker/screens/profile_screen.dart';
import '../screens/job_history_screen.dart';
import '../screens/wallet_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String jobHistory = '/job_history';
  static const String wallet = '/wallet';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      login: (context) => const LoginScreen(),
    dashboard: (context) => WorkerDashboard(),
      profile: (context) => const WorkerProfileScreen(),
      jobHistory: (context) => const JobHistoryScreen(),
      wallet: (context) => const WalletScreen(),
    };
  }
}
