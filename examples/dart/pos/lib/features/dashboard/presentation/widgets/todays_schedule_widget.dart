// lib/features/dashboard/presentation/widgets/todays_schedule_widget.dart
// Today's schedule widget displaying daily appointments with Riverpod state management. Features appointment list, status indicators, and dashboard UI integration for real-time schedule monitoring.
// Usage: ACTIVE - Core component of dashboard showing daily appointment schedule and status

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../appointments/providers/appointment_providers.dart';
import '../../providers/dashboard_ui_provider.dart';

/// Placeholder widget for Today's Schedule - to be implemented later
class TodaysScheduleWidget extends ConsumerWidget {
  const TodaysScheduleWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardUI = ref.watch(dashboardUIProvider);
    final isExpanded = dashboardUI.isTimelineExpanded;
    final upcomingAsync = ref.watch(upcomingAppointmentsForDashboardProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isExpanded ? 260 : 180,
      child: upcomingAsync.when(
        data: (upcoming) {
          final top = upcoming.take(5).toList();
          if (top.isEmpty) {
            return Center(
              child: Text(
                'No upcoming appointments',
                style: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            itemCount: top.length,
            separatorBuilder: (_, __) => const Divider(height: 8, thickness: 0.5),
            itemBuilder: (context, index) {
              final a = top[index];
              final time = _formatTime(a.scheduledStartTime);
              final svcNames = (a.services ?? const [])
                  .map((s) => s.name)
                  .take(3)
                  .join(', ');
              return Row(
                children: [
                  Container(
                    width: 56,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      time,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          a.customerName,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          svcNames.isEmpty ? '—' : svcNames,
                          style: TextStyle(color: Colors.grey.withValues(alpha: 0.7), fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error loading schedule',
            style: TextStyle(color: Colors.red.withValues(alpha: 0.5)),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
