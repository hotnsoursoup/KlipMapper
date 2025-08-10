// lib/features/appointments/presentation/widgets/appointment_check_in_dialog.dart
// Dialog for viewing appointment details and managing check-in workflow with status-based action buttons.
// Displays appointment information, group booking support, and context-sensitive actions based on appointment stage.
// Usage: ACTIVE - Used for appointment check-in workflow and appointment detail viewing

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../shared/data/models/appointment_model.dart';
import '../../../shared/presentation/widgets/service_pill.dart';

class AppointmentCheckInDialog extends StatefulWidget {
  final Appointment appointment;
  final Function(Appointment updatedAppointment)? onUpdate;
  final Function()? onCheckIn;
  final Function()? onCreateAppointment;

  const AppointmentCheckInDialog({
    super.key,
    required this.appointment,
    this.onUpdate,
    this.onCheckIn,
    this.onCreateAppointment,
  });

  @override
  State<AppointmentCheckInDialog> createState() => _AppointmentCheckInDialogState();
}

class _AppointmentCheckInDialogState extends State<AppointmentCheckInDialog> {
  @override
  void initState() {
    super.initState();
  }

  String get _appointmentStage {
    if (widget.appointment.status == 'scheduled') {
      return widget.appointment.customer != null ? 'ready_to_checkin' : 'needs_customer';
    } else if (widget.appointment.status == 'confirmed') {
      return 'ready_to_checkin';
    } else if (widget.appointment.status == 'arrived') {
      return 'checked_in';
    } else {
      return 'unknown';
    }
  }

  bool get _isGroupAppointment {
    // TODO: Add group booking support to Appointment domain model
    return false; // Disabled until domain model is updated
  }

  int get _groupSize {
    return 1; // Default to single appointment
  }

  List<Widget> _buildGroupMemberChips() {
    if (!_isGroupAppointment) return [];
    
    final chips = <Widget>[];
    
    // Main customer
    if (widget.appointment.customer != null) {
      chips.add(
        Chip(
          label: Text(widget.appointment.customer!.name),
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
          labelStyle: TextStyle(color: AppColors.primaryBlue),
          side: BorderSide(color: AppColors.primaryBlue),
        ),
      );
    }
    
    // Additional group members (as "Adult")
    final additionalMembers = _groupSize - 1;
    for (int i = 0; i < additionalMembers; i++) {
      chips.add(
        Chip(
          label: Text('Adult ${i + 1}'),
          backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
          labelStyle: TextStyle(color: AppColors.textSecondary),
          side: BorderSide(color: AppColors.textSecondary),
        ),
      );
    }
    
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: 500,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Appointment Details',
                          style: AppTextStyles.headline2.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.appointment.customer?.name ?? 'Pending Customer Selection',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Appointment Time Section  
                    _buildInfoSection(
                      'Appointment Time',
                      Icons.schedule,
                      _formatAppointmentDateTime(),
                    ),
                    const SizedBox(height: 16),
                    
                    // Customer Section
                    _buildInfoSection(
                      'Customer',
                      Icons.person,
                      widget.appointment.customer?.name ?? 'No customer selected',
                      subtitle: widget.appointment.customer?.phone,
                    ),
                    const SizedBox(height: 16),
                    
                    // Group Information
                    if (_isGroupAppointment) ...[
                      Text(
                        'Group Members ($_groupSize)',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: _buildGroupMemberChips(),
                      ),
                      const SizedBox(height: 16),
                    ],
                    
                    // Services Section
                    Text(
                      'Services',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (widget.appointment.services != null && widget.appointment.services!.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.appointment.services!.map((service) => ServicePill(
                          serviceName: service.name,
                          categoryId: service.categoryId,
                          isExtraSmall: true,
                        ),).toList(),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warningOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.warningOrange.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber, color: AppColors.warningOrange, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'No services selected',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.warningOrange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    
                    // Duration Section
                    _buildInfoSection(
                      'Expected Duration',
                      Icons.timer,
                      '${widget.appointment.durationMinutes} minutes',
                    ),
                    const SizedBox(height: 16),
                    
                    // Technician Section
                    _buildInfoSection(
                      'Requested Technician',
                      Icons.person_outline,
                      widget.appointment.requestedTechnicianName ?? 'No preference',
                    ),
                    const SizedBox(height: 16),
                    
                    // Status Section
                    _buildStatusSection(),
                  ],
                ),
              ),
            ),
            // Actions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _buildActionButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, String value, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    final status = widget.appointment.status;
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (status) {
      case 'scheduled':
        statusColor = AppColors.warningOrange;
        statusIcon = Icons.schedule;
        statusText = 'Scheduled';
        break;
      case 'confirmed':
        statusColor = AppColors.primaryBlue;
        statusIcon = Icons.check_circle_outline;
        statusText = 'Confirmed';
        break;
      case 'arrived':
        statusColor = AppColors.successGreen;
        statusIcon = Icons.check_circle;
        statusText = 'Checked In';
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = Icons.help_outline;
        statusText = status.toUpperCase();
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status',
                style: AppTextStyles.labelSmall.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                statusText,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final stage = _appointmentStage;
    
    return [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Close'),
      ),
      const SizedBox(width: 12),
      
      if (stage == 'needs_customer') ...[
        ElevatedButton.icon(
          onPressed: widget.onCreateAppointment,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Create Appointment'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
        ),
      ] else if (stage == 'ready_to_checkin') ...[
        ElevatedButton.icon(
          onPressed: () {
            widget.onCheckIn?.call();
          },
          icon: const Icon(Icons.login, size: 18),
          label: const Text('Check In'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successGreen,
            foregroundColor: Colors.white,
          ),
        ),
      ] else if (stage == 'checked_in') ...[
        ElevatedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.check_circle, size: 18),
          label: const Text('Already Checked In'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.successGreen.withValues(alpha: 0.5),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    ];
  }

  String _formatAppointmentDateTime() {
    final date = widget.appointment.appointmentDate;
    final timeString = widget.appointment.appointmentTime;
    
    // Parse the time string (HH:mm format)
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final formattedDate = '${date.month}/${date.day}/${date.year}';
    
    return '$formattedDate at $displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

}