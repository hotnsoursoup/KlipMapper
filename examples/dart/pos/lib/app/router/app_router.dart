// lib/app/router/app_router.dart
// Configures go_router navigation for the POS application with route definitions, authentication guards, and navigation flow. Handles routing to dashboard, appointments, customers, services, employees, and settings screens.
// Usage: ACTIVE - Primary navigation configuration used by MaterialApp.router in app.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/tickets/presentation/screens/tickets_screen.dart';
import '../../features/employees/presentation/screens/employees_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../../features/customers/presentation/screens/customers_screen.dart';
import '../../features/appointments/presentation/screens/appointments_screen.dart';
import '../../features/appointments/presentation/screens/calendar_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../widgets/app_shell.dart';

/// Main app router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    routes: [
      // Root redirect to dashboard
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
      
      // Main app shell with navigation
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (context, state) => const DashboardScreen(), // ✅ Keep existing UI
          ),
          GoRoute(
            path: '/tickets',
            name: 'tickets',
            builder: (context, state) => const TicketsScreen(),
            routes: [
              GoRoute(
                path: ':ticketId',
                name: 'ticket-detail',
                builder: (context, state) {
                  final ticketId = state.pathParameters['ticketId']!;
                  return _buildComingSoon('Ticket #$ticketId');
                },
              ),
            ],
          ),
          GoRoute(
            path: '/appointments',
            name: 'appointments',
            builder: (context, state) => const AppointmentsScreen(),
          ),
          GoRoute(
            path: '/calendar',
            name: 'calendar',
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: '/customers',
            name: 'customers',
            builder: (context, state) => const CustomersScreen(),
          ),
          GoRoute(
            path: '/employees',
            name: 'employees',
            builder: (context, state) => const EmployeesScreen(),
          ),
          GoRoute(
            path: '/services',
            name: 'services',
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: '/checkout',
            name: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => _buildError(state.error),
  );

  // Temporary placeholder screens
  static Widget _buildComingSoon(String screenName) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '$screenName - Coming Soon',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This feature is under development',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildError(Exception? error) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'Unknown error',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
