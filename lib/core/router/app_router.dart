import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/customer/screens/customer_home_screen.dart';
import '../../features/customer/screens/explore_screen.dart';
import '../../features/customer/screens/mess_details_screen.dart';
import '../../features/customer/screens/profile_screen.dart';
import '../../features/customer/screens/subscriptions_screen.dart';
import '../../features/customer/screens/payment_history_screen.dart';
import '../../features/leave_management/screens/leave_management_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/owner/screens/owner_dashboard_screen.dart';

enum AppRoute {
  splash('/'),
  login('/login'),
  otp('/otp'),
  register('/register'),
  home('/home'),
  explore('/explore'),
  messDetails('/explore/:messId'),
  profile('/profile'),
  subscriptions('/subscriptions'),
  paymentHistory('/payment-history'),
  leaveManagement('/leave-management'),
  notifications('/notifications'),
  ownerDashboard('/owner-dashboard');

  const AppRoute(this.path);

  final String path;

  String pathForMess(String messId) => '/explore/$messId';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // TODO: revert to AppRoute.splash.path when auth integration begins
    initialLocation: AppRoute.home.path,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.otp.path,
        name: AppRoute.otp.name,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        builder: (context, state) => const CustomerHomeScreen(),
      ),
      GoRoute(
        path: AppRoute.explore.path,
        name: AppRoute.explore.name,
        builder: (context, state) => const ExploreScreen(),
        routes: [
          GoRoute(
            path: ':messId',
            name: AppRoute.messDetails.name,
            builder: (context, state) {
              final messId = state.pathParameters['messId']!;
              return MessDetailsScreen(messId: messId);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.profile.path,
        name: AppRoute.profile.name,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoute.subscriptions.path,
        name: AppRoute.subscriptions.name,
        builder: (context, state) => const SubscriptionsScreen(),
      ),
      GoRoute(
        path: AppRoute.leaveManagement.path,
        name: AppRoute.leaveManagement.name,
        builder: (context, state) => const LeaveManagementScreen(),
      ),
      GoRoute(
        path: AppRoute.paymentHistory.path,
        name: AppRoute.paymentHistory.name,
        builder: (context, state) => const PaymentHistoryScreen(),
      ),
      GoRoute(
        path: AppRoute.notifications.path,
        name: AppRoute.notifications.name,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoute.ownerDashboard.path,
        name: AppRoute.ownerDashboard.name,
        builder: (context, state) => const OwnerDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text(state.uri.toString())),
    ),
  );
});
