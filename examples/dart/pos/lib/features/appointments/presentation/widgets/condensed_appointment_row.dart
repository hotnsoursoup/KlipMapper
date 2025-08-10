// lib/features/appointments/presentation/widgets/condensed_appointment_row.dart
// Compact appointment row widget for dense appointment lists displaying essential appointment information.
// Shows customer name, time, services, and status in a horizontal layout optimized for space efficiency.
// Usage: ACTIVE - Used in compact appointment views and summary lists

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/presentation/widgets/service_pill.dart';

class CondensedAppointmentRow extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onTap;
  final VoidCallback onCheckIn;
  final bool showDensity;

  const CondensedAppointmentRow({
    super.key,
    required this.appointment,
    required this.onTap,
    required this.onCheckIn,
    this.showDensity = false,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final isToday = _isToday();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isToday ? statusColor.withValues(alpha: 0.5) : AppColors.border.withValues(alpha: 0.3),
              width: isToday ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Status indicator strip
                Container(
                  width: 4,
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
                // Main content
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(showDensity ? 12 : 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row with time and status
                        Row(
                          children: [
                            // Time
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                appointment.appointmentTime,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.primaryBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Date (if not today)
                            if (!isToday) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${appointment.appointmentDate.day}/${appointment.appointmentDate.month}',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            const Spacer(),
                            // Status chip
                            _buildStatusChip(statusColor),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Customer name
                        Text(
                          appointment.customer?.name ?? 'Customer ID: ${appointment.customerId}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        if (!showDensity) ...[
                          const SizedBox(height: 4),
                          // Services (if not in dense mode)
                          if (appointment.services?.isNotEmpty == true)
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: appointment.services!.take(3).map((service) {
                                return ServicePill(
                                  serviceName: service.name,
                                  categoryId: service.categoryId,
                                  isSmall: true,
                                );
                              }).toList(),
                            ),
                        ],
                        const SizedBox(height: 8),
                        // Bottom row with technician and actions
                        Row(
                          children: [
                            // Technician
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      appointment.assignedTechnicianId ?? 'Unassigned',
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Action buttons
                            if (appointment.status == 'confirmed') ...[
                              const SizedBox(width: 8),
                              _buildActionButton(
                                'Check In',
                                AppColors.successGreen,
                                onCheckIn,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(Color statusColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Text(
        _getStatusText(),
        style: AppTextStyles.labelSmall.copyWith(
          color: statusColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onPressed) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (appointment.status.toLowerCase()) {
      case 'confirmed':
        return AppColors.successGreen;
      case 'scheduled':
        return AppColors.warningOrange;
      case 'in-progress':
        return AppColors.primaryBlue;
      case 'completed':
        return AppColors.primaryBlue;
      case 'cancelled':
        return AppColors.errorRed;
      case 'no-show':
        return AppColors.errorRed;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText() {
    switch (appointment.status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'scheduled':
        return 'Scheduled';
      case 'in-progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'no-show':
        return 'No Show';
      default:
        return appointment.status;
    }
  }

  bool _isToday() {
    final now = DateTime.now();
    final appointmentDate = appointment.appointmentDate;
    return now.year == appointmentDate.year &&
           now.month == appointmentDate.month &&
           now.day == appointmentDate.day;
  }
}