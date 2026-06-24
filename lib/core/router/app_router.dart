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
import '../../features/owner/screens/join_requests_screen.dart';
import '../../features/owner/screens/customer_management_screen.dart';
import '../../features/owner/screens/customer_profile_screen.dart';
import '../../features/owner/screens/plan_management_screen.dart';
import '../../features/owner/screens/plan_form_screen.dart';
import '../../features/owner/screens/attendance_dashboard_screen.dart';
import '../../features/owner/screens/owner_notifications_screen.dart';
import '../../features/owner/screens/analytics_screen.dart';
import '../../features/admin/screens/admin_dashboard_screen.dart';
import '../../features/admin/screens/owner_verification_screen.dart';
import '../../features/admin/screens/mess_approval_screen.dart';
import '../../features/admin/screens/webhook_management_screen.dart';

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
  ownerDashboard('/owner-dashboard'),
  joinRequests('/owner-dashboard/join-requests'),
  customerManagement('/owner-dashboard/customers'),
  customerProfile('/owner-dashboard/customers/:customerId'),
  planManagement('/owner-dashboard/plans'),
  planForm('/owner-dashboard/plans/form'),
  attendanceDashboard('/owner-dashboard/attendance'),
  ownerNotifications('/owner-dashboard/notifications'),
  ownerAnalytics('/owner-dashboard/analytics'),
  adminDashboard('/admin-dashboard'),
  adminOwnerVerification('/admin-dashboard/owner-verification'),
  adminMessApproval('/admin-dashboard/mess-approval'),
  adminWebhookManagement('/admin-dashboard/webhook-management');

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
      GoRoute(
        path: AppRoute.joinRequests.path,
        name: AppRoute.joinRequests.name,
        builder: (context, state) => const JoinRequestsScreen(),
      ),
      GoRoute(
        path: AppRoute.customerManagement.path,
        name: AppRoute.customerManagement.name,
        builder: (context, state) => const CustomerManagementScreen(),
      ),
      GoRoute(
        path: AppRoute.customerProfile.path,
        name: AppRoute.customerProfile.name,
        builder: (context, state) {
          final customerId = state.pathParameters['customerId'];
          return CustomerProfileScreen(customerId: customerId);
        },
      ),
      GoRoute(
        path: AppRoute.planManagement.path,
        name: AppRoute.planManagement.name,
        builder: (context, state) => const PlanManagementScreen(),
      ),
      GoRoute(
        path: AppRoute.planForm.path,
        name: AppRoute.planForm.name,
        builder: (context, state) {
          final plan = state.extra as Plan?;
          return PlanFormScreen(initialPlan: plan);
        },
      ),
      GoRoute(
        path: AppRoute.attendanceDashboard.path,
        name: AppRoute.attendanceDashboard.name,
        builder: (context, state) => const AttendanceDashboardScreen(),
      ),
      GoRoute(
        path: AppRoute.ownerNotifications.path,
        name: AppRoute.ownerNotifications.name,
        builder: (context, state) => const OwnerNotificationsScreen(),
      ),
      GoRoute(
        path: AppRoute.ownerAnalytics.path,
        name: AppRoute.ownerAnalytics.name,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoute.adminDashboard.path,
        name: AppRoute.adminDashboard.name,
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoute.adminOwnerVerification.path,
        name: AppRoute.adminOwnerVerification.name,
        builder: (context, state) => const OwnerVerificationScreen(),
      ),
      GoRoute(
        path: AppRoute.adminMessApproval.path,
        name: AppRoute.adminMessApproval.name,
        builder: (context, state) => const MessApprovalScreen(),
      ),
      GoRoute(
        path: AppRoute.adminWebhookManagement.path,
        name: AppRoute.adminWebhookManagement.name,
        builder: (context, state) => const WebhookManagementScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(child: Text(state.uri.toString())),
    ),
  );
});
