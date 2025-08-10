// lib/features/dashboard/presentation/widgets/sections/dashboard_header.dart
// Dashboard header widget with navigation controls and branding. Features go_router integration, app title display, and consistent header styling across dashboard sections.
// Usage: ACTIVE - Core header component used across dashboard layouts for consistent navigation

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';

/// The main dashboard header containing primary navigation and action buttons.
/// 
/// Features:
/// * Check-in button for new customer registration
/// * Today's schedule toggle for showing/hiding appointment view
/// * Navigation buttons to other app sections
/// * Static widget design for optimal performance
/// * Consistent styling with app theme
/// * Responsive button layout
/// 
/// Usage:
/// ```dart
/// DashboardHeader(
///   onCheckIn: () => _showCheckInDialog(),
///   onToggleSchedule: () => _toggleScheduleView(),
///   showTodaysSchedule: isScheduleVisible,
/// )
/// ```
class DashboardHeader extends StatelessWidget {
  final VoidCallback onCheckIn;
  final VoidCallback onToggleSchedule;
  final bool showTodaysSchedule;

  const DashboardHeader({
    super.key,
    required this.onCheckIn,
    required this.onToggleSchedule,
    required this.showTodaysSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Check In button
          ElevatedButton.icon(
            onPressed: onCheckIn,
            icon: const Icon(Icons.person_add),
            label: const Text('Check In'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(width: 12),
          
          // Today's Schedule toggle
          OutlinedButton.icon(
            onPressed: onToggleSchedule,
            icon: Icon(
              showTodaysSchedule ? Icons.calendar_view_day : Icons.calendar_today,
            ),
            label: Text(
              showTodaysSchedule ? 'Hide Schedule' : "Today's Schedule",
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          
          const Spacer(),
          
          // Navigation buttons
          IconButton(
            onPressed: () => context.go('/customers'),
            icon: const Icon(Icons.people),
            tooltip: 'Customers',
          ),
          IconButton(
            onPressed: () => context.go('/appointments'),
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Appointments',
          ),
          IconButton(
            onPressed: () => context.go('/reports'),
            icon: const Icon(Icons.analytics),
            tooltip: 'Reports',
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
    );
  }
}