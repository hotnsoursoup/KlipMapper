// lib/features/appointments/presentation/widgets/appointment_block.dart
// Reusable appointment block widget for calendar views that displays appointment details in a compact format.
// Features visual theming, status indicators, service display, and responsive layout based on appointment duration.
// Usage: ACTIVE - Used in calendar grid views and time-based appointment displays

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/calendar_appointment.dart';
import '../../data/models/calendar_theme.dart';
import '../../../shared/presentation/widgets/service_category_icon.dart';

class AppointmentBlock extends StatelessWidget {
  final CalendarAppointment appointment;
  final VoidCallback onTap;
  final bool isSelected;
  final bool isDragging;

  const AppointmentBlock({
    super.key,
    required this.appointment,
    required this.onTap,
    this.isSelected = false,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = CalendarTheme.getAppointmentDecoration(
      color: appointment.color,
      isSelected: isSelected,
      isPast: appointment.isPast,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Customer name and status
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        appointment.customer.name,
                        style: CalendarTheme.appointmentTitleStyle.copyWith(
                          color: CalendarTheme.getTextColorForBackground(appointment.color),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (appointment.status != AppointmentStatus.scheduled)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: appointment.statusColor.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          _getStatusShortText(appointment.status),
                          style: const TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: 4),
                
                // Time
                Text(
                  _formatTimeRange(appointment.startTime, appointment.endTime),
                  style: CalendarTheme.appointmentTimeStyle.copyWith(
                    color: CalendarTheme.getTextColorForBackground(appointment.color).withValues(alpha: 0.8),
                  ),
                ),
                
                // Services (if space allows)
                if (appointment.durationMinutes >= 45) ...[
                  const SizedBox(height: 4),
                  _buildServicesRow(),
                ],
                
                // Notes preview (if space allows and notes exist)
                if (appointment.durationMinutes >= 60 && appointment.notes?.isNotEmpty == true) ...[
                  const SizedBox(height: 4),
                  Text(
                    appointment.notes!,
                    style: CalendarTheme.appointmentSubtitleStyle.copyWith(
                      color: CalendarTheme.getTextColorForBackground(appointment.color).withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesRow() {
    if (appointment.services.isEmpty) {
      return const SizedBox.shrink();
    }

    // Show first service prominently, then count of additional services
    final firstService = appointment.services.first;
    final additionalCount = appointment.services.length - 1;

    return Row(
      children: [
        // Service category icon
        ServiceCategoryIcon(
          categoryId: firstService.categoryId,
          serviceName: firstService.name,
          size: 20,
          showTooltip: false,
        ),
        const SizedBox(width: 4),
        
        // Service name
        Expanded(
          child: Text(
            firstService.name,
            style: CalendarTheme.appointmentSubtitleStyle.copyWith(
              color: CalendarTheme.getTextColorForBackground(appointment.color).withValues(alpha: 0.8),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Additional services count
        if (additionalCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$additionalCount',
              style: const TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startFormatted = DateFormat.jm().format(start); // e.g., "9:00 AM"
    final endFormatted = DateFormat.jm().format(end);     // e.g., "10:30 AM"
    
    // If same period (AM/PM), we can shorten it
    if (start.hour < 12 && end.hour < 12) {
      // Both AM
      return '${DateFormat.jm().format(start).replaceAll(' AM', '')} - ${DateFormat.jm().format(end)}';
    } else if (start.hour >= 12 && end.hour >= 12) {
      // Both PM
      return '${DateFormat.jm().format(start).replaceAll(' PM', '')} - ${DateFormat.jm().format(end)}';
    } else {
      // Different periods
      return '$startFormatted - $endFormatted';
    }
  }

  String _getStatusShortText(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return 'SCH';
      case AppointmentStatus.confirmed:
        return 'CON';
      case AppointmentStatus.checkedIn:
        return 'IN';
      case AppointmentStatus.inProgress:
        return 'WRK';
      case AppointmentStatus.completed:
        return 'DONE';
      case AppointmentStatus.cancelled:
        return 'CAN';
      case AppointmentStatus.noShow:
        return 'NO';
      case AppointmentStatus.rescheduled:
        return 'RSC';
    }
  }
}